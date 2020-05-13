//
//  CalendarPresenter.swift
//  HseTimetable
//
//  Created by Pavel on 22.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import RxSwift
import RxCocoa
import Foundation

final class CalendarPresenter: CalendarPresenterProtocol, CalendarPresenterInputsProtocol, CalendarPresenterOutputsProtocol {
    
    let dependencies: CalendarPresenterDependencies!
    
    var inputs: CalendarPresenterInputsProtocol { return self }
    var outputs: CalendarPresenterOutputsProtocol { return self }
    
    /// Inputs
    let viewDidLoadTrigger = PublishSubject<Void>()
    let closeButtonTrigger = PublishSubject<Void>()
    let addButtonTrigger = PublishSubject<CalendarEventData>()
    
    /// Outputs
    let viewConfigure = PublishSubject<CalendarEventData>()
    let error = PublishSubject<Error>()
    
    private let lesson: Lesson
    private let disposeBag = DisposeBag()
    
    required init(dependencies: CalendarPresenterDependencies, lesson: Lesson) {
        self.dependencies = dependencies
        
        self.lesson = lesson
        
        /// Inputs setup
        self.viewDidLoadTrigger.asObserver()
            .withLatestFrom(Observable.just(self.lesson))
            .map{ CalendarEventData(title: $0.discipline ?? "", startDate: $0.dateStart ?? Date(), endDate: $0.dateEnd ?? Date(), alarmInterval: nil) }
            .bind(to: self.viewConfigure)
            .disposed(by: self.disposeBag)
        
        self.closeButtonTrigger.asObserver()
            .bind(to: self.dependencies.router.inputs.dismissTrigger)
            .disposed(by: self.disposeBag)
        
        self.addButtonTrigger.asObserver()
            .bind(to: self.dependencies.interactor.inputs.addEventTrigger)
            .disposed(by: self.disposeBag)
        
        /// Outputs setup
        self.dependencies.interactor.outputs.addEventResponse.asObservable()
            .bind(to: self.dependencies.router.inputs.dismissTrigger)
            .disposed(by: self.disposeBag)
        
        self.dependencies.interactor.outputs.errorResponse.asObservable()
            .bind(to: self.error)
            .disposed(by: self.disposeBag)
    }
}

// MARK:- Presenterable
extension CalendarPresenter: Presenterable {}
