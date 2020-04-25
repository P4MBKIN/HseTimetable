//
//  EventService.swift
//  HseTimetable
//
//  Created by Pavel on 21.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import EventKit
import Foundation

class EventService: EventServiceProtocol {
    
    private let eventStore = EKEventStore()
    
    private func checkEventKitAccess(for type: EKEntityType) -> Error? {
        var error: Error? = nil
        
        switch EKEventStore.authorizationStatus(for: type) {
        case .notDetermined:
            let group = DispatchGroup()
            group.enter()
            self.eventStore.requestAccess(to: type) { granted, err in
                guard err == nil else {
                    error = err
                    group.leave()
                    return
                }
                error = granted ? nil : EventServiceError.eventKitDenied
                group.leave()
            }
            group.wait()
        case .authorized: error = nil
        case .denied, .restricted: error = EventServiceError.eventKitDenied
        @unknown default: error = EventServiceError.eventKitDenied
        }
        
        return error
    }
}

extension EventService: CalendarEventProtocol {
    
    func createCalendarEvent(data: CalendarEventData) -> Error? {
        if let error = checkEventKitAccess(for: .event) { return error }
        if checkCalendarEventAlreadyExists(data: data) { return EventServiceError.eventCalendarAlreadyExists }
        let event = generateCalendarEvent(data: data)
        do {
            try self.eventStore.save(event, span: .thisEvent)
        } catch let err {
            return err
        }
        return nil
    }
    
    private func checkCalendarEventAlreadyExists(data: CalendarEventData) -> Bool {
        let predicate = self.eventStore.predicateForEvents(withStart: data.startDate, end: data.endDate, calendars: nil)
        let existingEvents = self.eventStore.events(matching: predicate)
        return existingEvents.contains { $0.title == data.title && $0.startDate == data.startDate && $0.endDate == data.endDate}
    }
    
    private func generateCalendarEvent(data: CalendarEventData) -> EKEvent {
        let event = EKEvent(eventStore: self.eventStore)
        event.calendar = self.eventStore.defaultCalendarForNewEvents
        event.title = data.title
        event.startDate = data.startDate
        event.endDate = data.endDate
        if let beforeInterval = data.alarmInterval { event.addAlarm(EKAlarm(absoluteDate: data.startDate.addingTimeInterval(beforeInterval))) }
        return event
    }
}

extension EventService: ReminderEventProtocol {
    
    func createReminderEvent(data: ReminderEventData) -> Error? {
        if let error = checkEventKitAccess(for: .reminder) { return error }
        if checkReminderEventAlreadyExists(data: data) { return EventServiceError.eventReminderAlreadyExists }
        let reminder = generateReminderEvent(data: data)
        do {
            try self.eventStore.save(reminder, commit: true)
        } catch let err {
            return err
        }
        return nil
    }
    
    private func checkReminderEventAlreadyExists(data: ReminderEventData) -> Bool {
        var isExist: Bool = false
        let predicate = self.eventStore.predicateForReminders(in: nil)
        let group = DispatchGroup()
        group.enter()
        self.eventStore.fetchReminders(matching: predicate) { reminders in
            if let reminders = reminders, reminders.contains(where: { $0.title == data.title }) { isExist = true }
            group.leave()
        }
        return isExist
    }
    
    private func generateReminderEvent(data: ReminderEventData) -> EKReminder {
        let reminder = EKReminder(eventStore: self.eventStore)
        reminder.calendar = self.eventStore.defaultCalendarForNewReminders()
        reminder.title = data.title
        reminder.priority = data.priority
        reminder.notes = data.notes
        if let alarmDate = data.alarmDate { reminder.addAlarm(EKAlarm(absoluteDate: alarmDate)) }
        return reminder
    }
}

enum EventServiceError: Error {
    case eventKitDenied
    case eventCalendarAlreadyExists
    case eventReminderAlreadyExists
}

extension EventServiceError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .eventKitDenied: return "EventServiceError - EventKit access denied!!!"
        case .eventCalendarAlreadyExists: return "EventServiceError - Calendar event already exists!!!"
        case .eventReminderAlreadyExists: return "EventServiceError - Reminder event already exists!!!"
        }
    }
}
