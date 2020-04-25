//
//  ReminderInteractor.swift
//  HseTimetable
//
//  Created by Pavel on 25.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import RxSwift
import RxCocoa
import Action
import Foundation

final class ReminderInteractor: ReminderInteractorProtocol, ReminderInteractorInputsProtocol, ReminderInteractorOutputsProtocol {
    
    var inputs: ReminderInteractorInputsProtocol { return self }
    var outputs: ReminderInteractorOutputsProtocol { return self }
    
    /// Inputs
    let addEventTrigger = PublishSubject<ReminderEventData>()
    
    /// Outputs
    let addEventResponse = PublishSubject<Void>()
    let errorResponse = PublishSubject<Error>()
    
    private let addEventAction: Action<ReminderEventData, Void>
    private let disposeBag = DisposeBag()
    
    static private let reminderService: ReminderEventProtocol = EventService()
    
    required init() {
        self.addEventAction = Action { data in return ReminderInteractor.addCavendarEvent(data: data) }
        
        /// Inputs setup
        self.addEventTrigger.asObserver()
            .bind(to: self.addEventAction.inputs)
            .disposed(by: disposeBag)
        
        /// Outputs setup
        self.addEventAction.elements.asObservable()
            .bind(to: self.addEventResponse)
            .disposed(by: disposeBag)
        
        /// Errors setup
        self.addEventAction.errors.asObservable()
            .map{ $0.get() }
            .bind(to: self.errorResponse)
            .disposed(by: disposeBag)
    }
}

extension ReminderInteractor {
    
    private static func addCavendarEvent(data: ReminderEventData) -> Single<Void> {
        return Single<Void>.create{ observer in
            if let error = ReminderInteractor.reminderService.createReminderEvent(data: data) {
                observer(.error(error))
                return Disposables.create()
            }
            observer(.success(()))
            return Disposables.create()
        }
    }
}

// MARK:- Interactorable
extension ReminderInteractor: Interactorable {}
