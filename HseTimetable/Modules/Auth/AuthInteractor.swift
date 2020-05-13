//
//  AuthInteractor.swift
//  HseTimetable
//
//  Created by Pavel on 12.05.2020.
//  Copyright © 2020 Hse. All rights reserved.
//
import RxSwift
import RxCocoa
import Action
import Foundation

final class AuthInteractor: AuthInteractorProtocol, AuthInteractorInputsProtocol, AuthInteractorOutputsProtocol {
    
    var inputs: AuthInteractorInputsProtocol { return self }
    var outputs: AuthInteractorOutputsProtocol { return self }
    
    /// Inputs
    let searchStudentTrigger = PublishSubject<String>()
    let saveStudentTrigger = PublishSubject<Auth>()
    
    /// Outputs
    let searchStudentResponse = PublishSubject<Auth>()
    let saveStudentResponse = PublishSubject<Void>()
    let errorResponse = PublishSubject<Error>()
    
    private let searchStudentAction: Action<String, Auth>
    private let saveStudentAction: Action<Auth, Void>
    
    private let disposeBag = DisposeBag()
    
    static private let networkService: NetworkAuthServiceProtocol = NetworkService()
    
    required init() {
        self.searchStudentAction = Action { email in return AuthInteractor.searchStudent(email: email) }
        self.saveStudentAction = Action { student in return AuthInteractor.saveStudent(student: student) }
        
        /// Inputs setup
        self.searchStudentTrigger.asObservable()
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .compactMap{ $0 }
            .bind(to: self.searchStudentAction.inputs)
            .disposed(by: self.disposeBag)
        
        self.searchStudentAction.executing.asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .filter{ !$0 }
            .withLatestFrom(self.searchStudentTrigger)
            .distinctUntilChanged()
            .bind(to: self.searchStudentAction.inputs)
            .disposed(by: self.disposeBag)
        
        self.saveStudentTrigger.asObserver()
            .bind(to: self.saveStudentAction.inputs)
            .disposed(by: self.disposeBag)
        
        /// Outputs setup
        self.searchStudentAction.elements.asObservable()
            .bind(to: self.searchStudentResponse)
            .disposed(by: self.disposeBag)
        
        self.saveStudentAction.elements.asObservable()
            .bind(to: self.saveStudentResponse)
            .disposed(by: self.disposeBag)
        
        /// Errors setup
        self.searchStudentAction.errors.asObservable()
            .map{ $0.get() }
            .bind(to: self.errorResponse)
            .disposed(by: self.disposeBag)
    }
}

extension AuthInteractor {
    
    private static func searchStudent(email: String) -> Single<Auth> {
        return Single<Auth>.create{ observer in
            AuthInteractor.networkService.studentGet(email: email) { (auth: Auth?, responseError: ResponseError?, error) in
                guard responseError == nil else {
                    observer(.error(responseError!))
                    return
                }
                guard error == nil else {
                    observer(.error(error!))
                    return
                }
                if let auth = auth { observer(.success(auth)) }
            }
            return Disposables.create()
        }
    }
    
    private static func saveStudent(student: Auth) -> Single<Void> {
        return Single<Void>.create{ observer in
            let defaults = UserDefaults.standard
            defaults.set(student.studentId, forKey: "studentId")
            observer(.success(()))
            return Disposables.create()
        }
    }
}

// MARK: - Interactorable
extension AuthInteractor: Interactorable {}
