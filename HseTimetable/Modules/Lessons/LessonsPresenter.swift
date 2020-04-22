//
//  LessonsPresenter.swift
//  HseTimetable
//
//  Created by Pavel on 21.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import RxSwift
import RxCocoa
import Foundation

final class LessonsPresenter: LessonsPresenterProtocol, LessonsPresenterInputsProtocol, LessonsPresenterOutputsProtocol {
    
    let dependencies: LessonsPresenterDependencies!
    
    var inputs: LessonsPresenterInputsProtocol { return self }
    var outputs: LessonsPresenterOutputsProtocol { return self }
    
    /// Inputs
    let viewDidLoadTrigger = PublishSubject<Void>()
    let refreshControlTrigger = PublishSubject<Void>()
    let didSelectLessonTrigger = PublishSubject<(Int, EventSegueType)>()
    
    /// Outputs
    var opens = [Bool]()
    let lessons = BehaviorRelay<[Lesson]>(value: [])
    let error = PublishSubject<Error>()
    
    private var lessonsSearchParams: LessonsSearchParams
    private let disposeBag = DisposeBag()
    
    required init(dependencies: LessonsPresenterDependencies) {
        self.dependencies = dependencies
        
        self.lessonsSearchParams = LessonsSearchParams(studentId: 203843, daysOffset: 7, dateFrom: Date.init())
        
        /// Inputs setup
        self.viewDidLoadTrigger.asObserver()
            .bind(to: self.dependencies.interactor.inputs.dataBaseLessonsTrigger)
            .disposed(by: disposeBag)
        
        self.refreshControlTrigger.asObserver()
            .withLatestFrom(Observable.just(self.lessonsSearchParams))
            .bind(to: self.dependencies.interactor.inputs.searchLessonsTrigger)
            .disposed(by: disposeBag)
        
        self.didSelectLessonTrigger.asObservable()
            .map{ (self.lessons.value[$0.0], $0.1) }
            .bind(to: self.dependencies.router.inputs.presentLessonEvent)
            .disposed(by: disposeBag)
        
        /// Outputs setup
        self.dependencies.interactor.outputs.searchLessonsResponse
            .subscribe(onNext: { [weak self] list in
                self?.lessons.accept(list)
                self?.opens = Array(repeating: false, count: list.count)
            }, onError: { [weak self] e in
                self?.error.onNext(e)
            })
        .disposed(by: disposeBag)
    }
}

//MARK:- Presenterable
extension LessonsPresenter: Presenterable {}
