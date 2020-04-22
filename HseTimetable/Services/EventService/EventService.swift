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
}

extension EventService: CalendarEventProtocol {
    
    func createCalendarEvent(data: EventData) -> Error? {
        if let error = checkEventKitAccess() { return error }
        
        let calendars = eventStore.calendars(for: .event)
        
        
        return nil
    }
    
    private func checkEventKitAccess() -> Error? {
        var error: Error? = nil
        
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized: error = nil
        case .notDetermined:
            eventStore.requestAccess(to: .event) { (granted, err) in
                guard err == nil else {
                    error = err
                    return
                }
                error = granted ? nil : EventServiceError.eventKitDenied
            }
        case .denied, .restricted: return EventServiceError.eventKitDenied
        @unknown default: return EventServiceError.eventKitDenied
        }
        
        return error
    }
}

enum EventServiceError: Error {
    case eventKitDenied
}

extension EventServiceError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .eventKitDenied: return "EventServiceError - EventKit access denied!!!"
        }
    }
}
