//
//  AuthPresenter.swift
//  HseTimetable
//
//  Created by Pavel on 12.05.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import RxSwift
import RxCocoa
import Foundation

final class AuthPresenter: AuthPresenterProtocol, AuthPresenterInputsProtocol, AuthPresenterOutputsProtocol {
    
    let dependencies: AuthPresenterDependencies!
    
    var inputs: AuthPresenterInputsProtocol { return self }
    var outputs: AuthPresenterOutputsProtocol { return self }
    
    /// Inputs
    let emailChangedTrigger = PublishSubject<String?>()
    let signInTrigger = PublishSubject<Void>()
    
    /// Outputs
    let isSuccess = PublishSubject<Bool>()
    let auth = PublishSubject<Auth>()
    
    private let disposeBag = DisposeBag()
    
    required init(dependencies: AuthPresenterDependencies) {
        self.dependencies = dependencies
        
        /// Inputs setup
        self.emailChangedTrigger.asObserver()
            .compactMap{ $0 }
            .bind(to: self.dependencies.interactor.inputs.searchStudentTrigger)
            .disposed(by: self.disposeBag)
        
        self.signInTrigger.asObserver()
            .withLatestFrom(self.auth)
            .bind(to: self.dependencies.interactor.inputs.saveStudentTrigger)
            .disposed(by: self.disposeBag)
        
        /// Outputs setup
        self.dependencies.interactor.outputs.searchStudentResponse.asObserver()
            .subscribe(onNext: { [weak self] auth in
                self?.auth.onNext(auth)
                self?.isSuccess.onNext(true)
            })
            .disposed(by: self.disposeBag)
        
        self.dependencies.interactor.outputs.errorResponse.asObserver()
            .withLatestFrom(Observable.just(false))
            .bind(to: self.isSuccess)
            .disposed(by: self.disposeBag)
        
        self.dependencies.interactor.outputs.saveStudentResponse.asObserver()
            .bind(to: self.dependencies.router.inputs.pushLessonsTrigger)
            .disposed(by: self.disposeBag)
    }
}

// MARK:- Presenterable
extension AuthPresenter: Presenterable {}
