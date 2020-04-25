//
//  ReminderProtocols.swift
//  HseTimetable
//
//  Created by Pavel on 25.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import RxSwift
import RxCocoa
import Foundation

protocol ReminderViewProtocol: class {
    var presenter: ReminderPresenterProtocol! { get set }
}

/// VIEW -> PRESENTER
protocol ReminderPresenterInputsProtocol: class {
    var viewDidLoadTrigger: PublishSubject<Void> { get }
    var closeButtonTrigger: PublishSubject<Void> { get }
    var addButtonTrigger: PublishSubject<ReminderEventData> { get }
}

/// PRESENTER -> VIEW
protocol ReminderPresenterOutputsProtocol: class {
    var viewConfigure: PublishSubject<ReminderEventData> { get }
    var error: PublishSubject<Error> { get }
}

typealias ReminderPresenterDependencies = (
    interactor: ReminderInteractorProtocol,
    router: ReminderRouterProtocol
)

protocol ReminderPresenterProtocol: class {
    var dependencies: ReminderPresenterDependencies! { get }
    var inputs: ReminderPresenterInputsProtocol { get }
    var outputs: ReminderPresenterOutputsProtocol { get }
}

/// PRESENTER -> INTERACTOR
protocol ReminderInteractorInputsProtocol: class {
    var addEventTrigger: PublishSubject<ReminderEventData> { get }
}

/// INTERACTOR -> PRESENTER
protocol ReminderInteractorOutputsProtocol: class {
    var addEventResponse: PublishSubject<Void> { get }
    var errorResponse: PublishSubject<Error> { get }
}

protocol ReminderInteractorProtocol: class {
    var inputs: ReminderInteractorInputsProtocol { get }
    var outputs: ReminderInteractorOutputsProtocol { get }
}

/// PRESENTER -> ROUTER
protocol ReminderRouterInputsProtocol: class {
    var dismissTrigger: PublishSubject<Void> { get }
}

protocol ReminderRouterProtocol: class {
    var inputs: ReminderRouterInputsProtocol { get }
}

/// ANOTHER MODUL -> CONFIGURATOR
protocol ReminderConfiguratorProtocol: class {
    func configureWithPush(from: Viewable, lesson: Lesson)
    func configureWithPresent(from: Viewable, lesson: Lesson)
}
