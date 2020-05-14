//
//  EventServiceProtocol.swift
//  HseTimetable
//
//  Created by Pavel on 21.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import Foundation

protocol CalendarEventProtocol {
    func checkCalendarAccess() -> Error?
    func createCalendarEvent(data: CalendarEventData) -> Error?
}

protocol ReminderEventProtocol {
    func checkReminderAccess() -> Error?
    func createReminderEvent(data: ReminderEventData) -> Error?
}

protocol EventServiceProtocol: CalendarEventProtocol, ReminderEventProtocol {
}
