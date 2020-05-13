//
//  CalendarInteractor.swift
//  HseTimetable
//
//  Created by Pavel on 22.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import RxSwift
import RxCocoa
import Action
import Foundation

final class CalendarInteractor: CalendarInteractorProtocol, CalendarInteractorInputsProtocol, CalendarInteractorOutputsProtocol {
    
    var inputs: CalendarInteractorInputsProtocol { return self }
    var outputs: CalendarInteractorOutputsProtocol { return self }
    
    /// Inputs
    let addEventTrigger = PublishSubject<CalendarEventData>()
    
    /// Outputs
    let addEventResponse = PublishSubject<Void>()
    let errorResponse = PublishSubject<Error>()
    
    private let addEventAction: Action<CalendarEventData, Void>
    private let disposeBag = DisposeBag()
    
    static private let calendarService: CalendarEventProtocol = EventService()
    
    required init() {
        self.addEventAction = Action { data in return CalendarInteractor.addCavendarEvent(data: data) }
        
        /// Inputs setup
        self.addEventTrigger.asObserver()
            .bind(to: self.addEventAction.inputs)
            .disposed(by: self.disposeBag)
        
        /// Outputs setup
        self.addEventAction.elements.asObservable()
            .bind(to: self.addEventResponse)
            .disposed(by: self.disposeBag)
        
        /// Errors setup
        self.addEventAction.errors.asObservable()
            .map{ $0.get() }
            .bind(to: self.errorResponse)
            .disposed(by: self.disposeBag)
    }
}

extension CalendarInteractor {
    
    private static func addCavendarEvent(data: CalendarEventData) -> Single<Void> {
        return Single<Void>.create{ observer in
            if let error = CalendarInteractor.calendarService.createCalendarEvent(data: data) {
                observer(.error(error))
                return Disposables.create()
            }
            observer(.success(()))
            return Disposables.create()
        }
    }
}

// MARK:- Interactorable
extension CalendarInteractor: Interactorable {}
