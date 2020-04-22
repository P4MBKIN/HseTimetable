//
//  LessonsSeque.swift
//  HseTimetable
//
//  Created by Pavel on 21.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import Foundation

enum SegueType {
    case present
    case push
}

enum EventSegueType {
    case lessonsToCalendar(SegueType)
    case lessonsToNote(SegueType)
    case lessonsToReminder(SegueType)
    case lessonsToAlarm(SegueType)
}
