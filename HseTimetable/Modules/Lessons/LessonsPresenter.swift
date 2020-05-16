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
    let logoutTrigger = PublishSubject<Void>()
    
    /// Outputs
    var opens = [Bool]()
    let lessons = BehaviorRelay<[Lesson]>(value: [])
    let error = PublishSubject<Error>()
    
    private var daysOffset: Int
    
    private let disposeBag = DisposeBag()
    
    required init(dependencies: LessonsPresenterDependencies) {
        self.dependencies = dependencies
        
        self.daysOffset = 7
        
        /// Inputs setup
        self.viewDidLoadTrigger.asObserver()
            .bind(to: self.dependencies.interactor.inputs.dataBaseLessonsTrigger)
            .disposed(by: self.disposeBag)
        
        self.refreshControlTrigger.asObserver()
            .withLatestFrom(Observable.just(self.daysOffset))
            .bind(to: self.dependencies.interactor.inputs.searchLessonsTrigger)
            .disposed(by: self.disposeBag)
        
        self.didSelectLessonTrigger.asObservable()
            .map{ (self.lessons.value[$0.0], $0.1) }
            .bind(to: self.dependencies.router.inputs.presentLessonEvent)
            .disposed(by: self.disposeBag)
        
        self.logoutTrigger.asObserver()
            .bind(to: self.dependencies.interactor.inputs.removeStudentTrigger)
            .disposed(by: self.disposeBag)
        
        /// Outputs setup
        self.dependencies.interactor.outputs.searchLessonsResponse.asObservable()
            .subscribe(onNext: { [weak self] list in
                self?.opens = Array(repeating: false, count: list.count)
                self?.lessons.accept(list)
            })
            .disposed(by: self.disposeBag)
        
        self.dependencies.interactor.outputs.errorResponse.asObservable()
            .bind(to: self.error)
            .disposed(by: self.disposeBag)
        
        self.dependencies.interactor.outputs.removeStudentResponse.asObserver()
            .bind(to: self.dependencies.router.inputs.pushAuthTrigger)
            .disposed(by: self.disposeBag)
        
    }
}

// MARK:- Presenterable
extension LessonsPresenter: Presenterable {}
