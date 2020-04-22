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
    
    /// Outputs
    let viewConfigure: Observable<CalendarEventData>
    
    private let lesson: Lesson
    private let disposeBag = DisposeBag()
    
    required init(dependencies: CalendarPresenterDependencies, lesson: Lesson) {
        self.dependencies = dependencies
        
        self.lesson = lesson
        
        let _viewConfigure = PublishRelay<CalendarEventData>()
        
        /// Inputs setup
        self.viewDidLoadTrigger.asObserver()
            .withLatestFrom(Observable.just(lesson))
            .map{ CalendarEventData(title: $0.discipline ?? "", startDate: $0.dateStart ?? Date(), endDate: $0.dateEnd ?? Date(), alarmInterval: nil) }
            .bind(to: _viewConfigure)
            .disposed(by: disposeBag)
        
        /// Outputs setup
        self.viewConfigure = _viewConfigure.asObservable().take(1)
    }
}

//MARK:- Presenterable
extension CalendarPresenter: Presenterable {}
