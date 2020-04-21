//
//  DataService.swift
//  HseTimetable
//
//  Created by Pavel on 21.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import Foundation

class DataService: DataServiceProtocol {
    
    func getLessonsData(filter: String?, sortedByKeyPath: String?, ascending: Bool?) -> ([LessonData]?, Error?) {
        let options = BaseOptions<LessonModel>()
        
        let (data, error) = options.get(filter: filter, sortedByKeyPath: sortedByKeyPath, ascending: ascending)
        if error != nil { return (nil, error!) }
        guard let list = data else { return (nil, nil) }
        let lessons = list.map{ (adress: $0.adress, type: $0.type, lecturer: $0.lecturer, auditorium: $0.auditorium, dateStart: $0.dateStart, dateEnd: $0.dateEnd, importance: $0.importance.value, discipline: $0.discipline) }
        
        return (lessons, nil)
    }
    
    func deleteLessonsData(filter: String?) -> Error? {
        let options = BaseOptions<LessonModel>()
        
        return options.delete(filter: filter)
    }
    
    func putLessonsData(listLessonsData: [LessonData]) -> Error? {
        let options = BaseOptions<LessonModel>()
        
        let data = listLessonsData.map{ LessonModel(adress: $0.adress, type: $0.type, lecturer: $0.lecturer, auditorium: $0.auditorium, dateStart: $0.dateStart, dateEnd: $0.dateEnd, importance: $0.importance, discipline: $0.discipline) }
        
        return options.put(objects: data)
    }
}
