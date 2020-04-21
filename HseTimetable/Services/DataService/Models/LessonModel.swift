//
//  LessonModel.swift
//  HseTimetable
//
//  Created by Pavel on 21.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import RealmSwift
import Foundation

class LessonModel: Object {
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var adress: String?
    @objc dynamic var type: String?
    @objc dynamic var lecturer: String?
    @objc dynamic var auditorium: String?
    @objc dynamic var dateStart: Date?
    @objc dynamic var dateEnd: Date?
    var importance = RealmOptional<Int>()
    @objc dynamic var discipline: String?
    
    convenience init(adress: String?, type: String?, lecturer: String?, auditorium: String?, dateStart: Date?, dateEnd: Date?, importance: Int?, discipline: String?) {
        self.init()
        self.adress = adress
        self.type = type
        self.lecturer = lecturer
        self.auditorium = auditorium
        self.dateStart = dateStart
        self.dateEnd = dateEnd
        self.importance = RealmOptional<Int>(importance)
        self.discipline = discipline
    }
    
    override class func primaryKey() -> String? { return "id" }
}
