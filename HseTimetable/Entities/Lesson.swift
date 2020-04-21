//
//  Lesson.swift
//  HseTimetable
//
//  Created by Pavel on 20.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import Foundation

enum ImportanceLevel: Int {
    
    case hight = 1
    case medium = 2
    case low = 3
    
    init(_ level: Int) {
        switch level {
        case 1: self = .hight
        case 2: self = .medium
        default: self = .low
        }
    }
}

struct Lesson: Decodable {
    
    let adress: String?
    let type: String?
    let lecturer: String?
    let auditorium: String?
    let dateStart: Date?
    let dateEnd: Date?
    let importance: ImportanceLevel?
    let discipline: String?
    
    enum CodingKeys: String, CodingKey {
        case building
        case type
        case lecturer
        case auditorium
        case date_start
        case date_end
        case importance_level
        case discipline
    }
    
    init(adress: String?, type: String?, lecturer: String?, auditorium: String?, dateStart: Date?, dateEnd: Date?, importance: Int?, discipline: String?) {
        self.adress = adress
        self.type = type
        self.lecturer = lecturer
        self.auditorium = auditorium
        self.dateStart = dateStart
        self.dateEnd = dateEnd
        self.importance = ImportanceLevel(importance ?? 2)
        self.discipline = discipline
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        adress = try container.decode(String?.self, forKey: .building)
        type = try container.decode(String?.self, forKey: .type)
        lecturer = try container.decode(String?.self, forKey: .lecturer)
        auditorium = try container.decode(String?.self, forKey: .auditorium)
        if let timestampStart = try container.decode(UInt64?.self, forKey: .date_start) {
            dateStart = Date(timeIntervalSince1970: TimeInterval(timestampStart/1000))
        } else {
            dateStart = nil
        }
        if let timestampEnd = try container.decode(UInt64?.self, forKey: .date_end) {
            dateEnd = Date(timeIntervalSince1970: TimeInterval(timestampEnd/1000))
        } else {
            dateEnd = nil
        }
        if let level = try container.decode(Int?.self, forKey: .importance_level) {
            importance = ImportanceLevel.init(level)
        } else {
            importance = nil
        }
        discipline = try container.decode(String?.self, forKey: .discipline)
    }
}
