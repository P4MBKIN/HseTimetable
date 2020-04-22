//
//  EventServiceProtocol.swift
//  HseTimetable
//
//  Created by Pavel on 21.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import Foundation

typealias EventData = (adress: String?, type: String?, lecturer: String?, auditorium: String?, dateStart: Date?, dateEnd: Date?, importance: Int?, discipline: String?)

protocol CalendarEventProtocol {
    func createCalendarEvent(data: EventData) -> Error?
}

protocol EventServiceProtocol: CalendarEventProtocol {
}
