//
//  LessonsInteractor.swift
//  HseTimetable
//
//  Created by Pavel on 21.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import RxSwift
import RxCocoa
import Action
import Foundation

final class LessonsInteractor: LessonsInteractorProtocol, LessonsInteractorInputsProtocol, LessonsInteractorOutputsProtocol {
    
    var inputs: LessonsInteractorInputsProtocol { return self }
    var outputs: LessonsInteractorOutputsProtocol { return self }
    
    /// Inputs
    let dataBaseLessonsTrigger = PublishSubject<Void>()
    let searchLessonsTrigger = PublishSubject<LessonsSearchParams>()
    
    /// Outputs
    let searchLessonsResponse = PublishSubject<[Lesson]>()
    
    private let dbGetAction: Action<Void, [Lesson]>
    private let dbUpdateAction: Action<[Lesson], Void>
    private let searchLessonsAction: Action<LessonsSearchParams, [Lesson]>
    private let disposeBag = DisposeBag()
    
    static private let dataService: DataServiceProtocol = DataService()
    static private let networkService: NetworkServiceProtocol = NetworkService()
    
    init() {
        self.dbGetAction = Action { return LessonsInteractor.getLessonsFromDB() }
        self.dbUpdateAction = Action { lessons in return LessonsInteractor.updateLessonsToDB(lessons: lessons) }
        self.searchLessonsAction = Action { params in return LessonsInteractor.getLessonsFromNetwork(params: params) }
        
        /// Inputs setup
        
        /// Outputs setup
        
        /// Errors setup
        
    }
}

extension LessonsInteractor {
    
    private static func getLessonsFromDB() -> Single<[Lesson]> {
        return Single<[Lesson]>.create{  observer in
            let (data, error) = LessonsInteractor.dataService.getLessonsData(filter: nil, sortedByKeyPath: "dateStart", ascending: true)
            guard error == nil else {
                observer(.error(error!))
                return Disposables.create()
            }
            guard let list = data else {
                observer(.success([]))
                return Disposables.create()
            }
            let lessons = list.map{ Lesson(adress: $0.adress, type: $0.type, lecturer: $0.lecturer, auditorium: $0.auditorium, dateStart: $0.dateStart, dateEnd: $0.dateEnd, importance: $0.importance, discipline: $0.discipline) }
            observer(.success(lessons))
            return Disposables.create()
        }
    }
    
    private static func updateLessonsToDB(lessons: [Lesson]) -> Single<Void> {
        return Single<Void>.create{ observer in
            if let error = LessonsInteractor.dataService.deleteLessonsData(filter: nil) {
                observer(.error(error))
                return Disposables.create()
            }
            let listData = lessons.map{ (adress: $0.adress, type: $0.type, lecturer: $0.lecturer, auditorium: $0.auditorium, dateStart: $0.dateStart, dateEnd: $0.dateEnd, importance: $0.importance?.rawValue, discipline: $0.discipline) }
            if let error = LessonsInteractor.dataService.putLessonsData(listLessonsData: listData) {
                observer(.error(error))
            } else {
                observer(.success(()))
            }
            return Disposables.create()
        }
    }
    
    private static func getLessonsFromNetwork(params: LessonsSearchParams) -> Single<[Lesson]> {
        return Single<[Lesson]>.create{ observer in
            LessonsInteractor.networkService.lessonsGet(studentId: params.studentId, daysOffset: params.daysOffset, dateFrom: params.dateFrom) { (lessons: [Lesson]?, lessonsError: LessonsError?, error) in
                guard lessonsError == nil else {
                    observer(.error(lessonsError!))
                    return
                }
                guard error == nil else {
                    observer(.error(error!))
                    return
                }
                if let lessons = lessons { observer(.success(lessons)) }
            }
            return Disposables.create()
        }
    }
}
