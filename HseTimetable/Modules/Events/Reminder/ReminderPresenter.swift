//
//  ReminderPresenter.swift
//  HseTimetable
//
//  Created by Pavel on 25.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import RxSwift
import RxCocoa
import Foundation

final class ReminderPresenter: ReminderPresenterProtocol, ReminderPresenterInputsProtocol, ReminderPresenterOutputsProtocol {
    
    let dependencies: ReminderPresenterDependencies!
    
    var inputs: ReminderPresenterInputsProtocol { return self }
    var outputs: ReminderPresenterOutputsProtocol { return self }
    
    /// Inputs
    let viewDidLoadTrigger = PublishSubject<Void>()
    let closeButtonTrigger = PublishSubject<Void>()
    let addButtonTrigger = PublishSubject<ReminderEventData>()
    
    /// Outputs
    let viewConfigure = PublishSubject<ReminderEventData>()
    let error = PublishSubject<Error>()
    
    private let lesson: Lesson
    private let disposeBag = DisposeBag()
    
    required init(dependencies: ReminderPresenterDependencies, lesson: Lesson) {
        self.dependencies = dependencies
        
        self.lesson = lesson
        
        /// Inputs setup
        self.viewDidLoadTrigger.asObserver()
            .withLatestFrom(Observable.just(self.lesson))
            .map{ ReminderEventData(title: $0.discipline ?? "", priority: 0, notes: "Не забыть: ", alarmDate: $0.dateStart) }
            .bind(to: self.viewConfigure)
            .disposed(by: disposeBag)
        
        self.closeButtonTrigger.asObserver()
            .bind(to: self.dependencies.router.inputs.dismissTrigger)
            .disposed(by: disposeBag)
        
        self.addButtonTrigger.asObserver()
            .bind(to: self.dependencies.interactor.inputs.addEventTrigger)
            .disposed(by: disposeBag)
        
        /// Outputs setup
        self.dependencies.interactor.outputs.addEventResponse.asObservable()
            .bind(to: self.dependencies.router.inputs.dismissTrigger)
            .disposed(by: disposeBag)
        
        self.dependencies.interactor.outputs.errorResponse.asObservable()
            .bind(to: self.error)
            .disposed(by: disposeBag)
    }
}

// MARK:- Presenterable
extension ReminderPresenter: Presenterable {}
