//
//  DataServiceProtocol.swift
//  HseTimetable
//
//  Created by Pavel on 21.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import Foundation

protocol DataServiceProtocol: class {
    typealias LessonData = (adress: String?, type: String?, lecturer: String?, auditorium: String?, dateStart: Date?, dateEnd: Date?, importance: Int?, discipline: String?)
    func getLessonsData(filter: String?, sortedByKeyPath: String?, ascending: Bool?) -> ([LessonData]?, Error?)
    func deleteLessonsData(filter: String?) -> Error?
    func putLessonsData(listLessonsData: [LessonData]) -> Error?
}
