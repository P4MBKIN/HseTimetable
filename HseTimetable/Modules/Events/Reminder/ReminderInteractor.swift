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
    let checkAccessTrigger = PublishSubject<Void>()
    let addEventTrigger = PublishSubject<ReminderEventData>()
    
    /// Outputs
    let addEventResponse = PublishSubject<Void>()
    let errorResponse = PublishSubject<Error>()
    
    private let checkAccessAction: Action<Void, Void>
    private let addEventAction: Action<ReminderEventData, Void>
    
    private let disposeBag = DisposeBag()
    
    static private let reminderService: ReminderEventProtocol = EventService()
    
    required init() {
        self.checkAccessAction = Action { return ReminderInteractor.checkReminderAccess() }
        self.addEventAction = Action { data in return ReminderInteractor.addReminderEvent(data: data) }
        
        /// Inputs setup
        self.checkAccessTrigger.asObserver()
            .observeOn(MainScheduler.asyncInstance)
            .bind(to: self.checkAccessAction.inputs)
            .disposed(by: self.disposeBag)
        
        self.addEventTrigger.asObserver()
            .bind(to: self.addEventAction.inputs)
            .disposed(by: self.disposeBag)
        
        /// Outputs setup
        self.addEventAction.elements.asObservable()
            .bind(to: self.addEventResponse)
            .disposed(by: self.disposeBag)
        
        /// Errors setup
        self.checkAccessAction.errors.asObservable()
            .map{ $0.get() }
            .bind(to: self.errorResponse)
            .disposed(by: self.disposeBag)
        
        self.addEventAction.errors.asObservable()
            .map{ $0.get() }
            .bind(to: self.errorResponse)
            .disposed(by: self.disposeBag)
    }
}

extension ReminderInteractor {
    
    private static func checkReminderAccess() -> Single<Void> {
        return Single<Void>.create{ observer in
            if let error = ReminderInteractor.reminderService.checkReminderAccess() {
                observer(.error(error))
                return Disposables.create()
            }
            observer(.success(()))
            return Disposables.create()
        }
    }
    
    private static func addReminderEvent(data: ReminderEventData) -> Single<Void> {
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
