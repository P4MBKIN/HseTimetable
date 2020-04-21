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
    
    var interactor: LessonsInteractorProtocol!
    var router: LessonsRouterProtocol!
    
    var inputs: LessonsPresenterInputsProtocol { return self }
    var outputs: LessonsPresenterOutputsProtocol { return self }
    
    /// Inputs
    let viewDidLoadTrigger = PublishSubject<Void>()
    let refreshControlTrigger = PublishSubject<Void>()
    
    /// Outputs
    var opens = [Bool]()
    let lessons = BehaviorRelay<[Lesson]>(value: [])
    let error = PublishSubject<Error>()
    
    private var lessonsSearchParams: LessonsSearchParams
    private let disposeBag = DisposeBag()
    
    required init(dependencies: LessonsPresenterDependencies) {
        self.interactor = dependencies.interactor
        self.router = dependencies.router
        
        self.lessonsSearchParams = LessonsSearchParams(studentId: 203843, daysOffset: 7, dateFrom: Date.init())
        
        /// Inputs setup
        self.viewDidLoadTrigger.asObserver()
            .bind(to: self.interactor.inputs.dataBaseLessonsTrigger)
            .disposed(by: disposeBag)
        
        self.refreshControlTrigger.asObserver()
            .withLatestFrom(Observable.just(self.lessonsSearchParams))
            .bind(to: self.interactor.inputs.searchLessonsTrigger)
            .disposed(by: disposeBag)
        
        /// Outputs setup
        self.interactor.outputs.searchLessonsResponse
            .subscribe(onNext: { [weak self] list in
                self?.lessons.accept(list)
                self?.opens = Array(repeating: false, count: list.count)
            }, onError: { [weak self] e in
                self?.error.onNext(e)
            })
        .disposed(by: disposeBag)
    }
}
