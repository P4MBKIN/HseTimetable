//
//  AuthProtocols.swift
//  HseTimetable
//
//  Created by Pavel on 12.05.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import RxSwift
import RxCocoa
import Foundation

protocol AuthViewProtocol: class {
    var presenter: AuthPresenterProtocol! { get set }
}

/// VIEW -> PRESENTER
protocol AuthPresenterInputsProtocol: class {
    var emailChangedTrigger: PublishSubject<String?> { get }
    var signInTrigger: PublishSubject<Void> { get }
}

/// PRESENTER -> VIEW
protocol AuthPresenterOutputsProtocol: class {
    var isSuccess: PublishSubject<Bool> { get }
    var auth: PublishSubject<Auth> { get }
}

typealias AuthPresenterDependencies = (
    interactor: AuthInteractorProtocol,
    router: AuthRouterProtocol
)

protocol AuthPresenterProtocol: class {
    var dependencies: AuthPresenterDependencies! { get }
    var inputs: AuthPresenterInputsProtocol { get }
    var outputs: AuthPresenterOutputsProtocol { get }
}

/// PRESENTER -> INTERACTOR
protocol AuthInteractorInputsProtocol: class {
    var searchStudentTrigger: PublishSubject<String> { get }
    var saveStudentTrigger: PublishSubject<Auth> { get }
}

/// INTERACTOR -> PRESENTER
protocol AuthInteractorOutputsProtocol: class {
    var searchStudentResponse: PublishSubject<Auth> { get }
    var saveStudentResponse: PublishSubject<Void> { get }
    var errorResponse: PublishSubject<Error> { get }
}

protocol AuthInteractorProtocol: class {
    var inputs: AuthInteractorInputsProtocol { get }
    var outputs: AuthInteractorOutputsProtocol { get }
}

/// PRESENTER -> ROUTER
protocol AuthRouterInputsProtocol: class {
    var pushLessonsTrigger: PublishSubject<Void> { get }
}

protocol AuthRouterProtocol: class {
    var inputs: AuthRouterInputsProtocol { get }
}

/// ANOTHER MODULE -> CONFIGURATOR
protocol AuthConfiguratorProtocol: class {
    func configureWithPush(from: Viewable)
    func configureWithPresent(from: Viewable)
    func configure() -> AuthViewController
}
