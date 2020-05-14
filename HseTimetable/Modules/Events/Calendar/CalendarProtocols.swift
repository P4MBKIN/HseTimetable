//
//  CalendarProtocols.swift
//  HseTimetable
//
//  Created by Pavel on 22.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import RxSwift
import RxCocoa
import Foundation

protocol CalendarViewProtocol: class {
    var presenter: CalendarPresenterProtocol! { get set }
}

/// VIEW -> PRESENTER
protocol CalendarPresenterInputsProtocol: class {
    var viewDidLoadTrigger: PublishSubject<Void> { get }
    var closeButtonTrigger: PublishSubject<Void> { get }
    var addButtonTrigger: PublishSubject<CalendarEventData> { get }
}

/// PRESENTER -> VIEW
protocol CalendarPresenterOutputsProtocol: class {
    var viewConfigure: PublishSubject<CalendarEventData> { get }
    var error: PublishSubject<Error> { get }
}

typealias CalendarPresenterDependencies = (
    interactor: CalendarInteractorProtocol,
    router: CalendarRouterProtocol
)

protocol CalendarPresenterProtocol: class {
    var dependencies: CalendarPresenterDependencies! { get }
    var inputs: CalendarPresenterInputsProtocol { get }
    var outputs: CalendarPresenterOutputsProtocol { get }
}

/// PRESENTER -> INTERACTOR
protocol CalendarInteractorInputsProtocol: class {
    var checkAccessTrigger: PublishSubject<Void> { get }
    var addEventTrigger: PublishSubject<CalendarEventData> { get }
}

/// INTERACTOR -> PRESENTER
protocol CalendarInteractorOutputsProtocol: class {
    var addEventResponse: PublishSubject<Void> { get }
    var errorResponse: PublishSubject<Error> { get }
}

protocol CalendarInteractorProtocol: class {
    var inputs: CalendarInteractorInputsProtocol { get }
    var outputs: CalendarInteractorOutputsProtocol { get }
}

/// PRESENTER -> ROUTER
protocol CalendarRouterInputsProtocol: class {
    var dismissTrigger: PublishSubject<Void> { get }
}

protocol CalendarRouterProtocol: class {
    var inputs: CalendarRouterInputsProtocol { get }
}

/// ANOTHER MODUL -> CONFIGURATOR
protocol CalendarConfiguratorProtocol: class {
    func configureWithPush(from: Viewable, lesson: Lesson)
    func configureWithPresent(from: Viewable, lesson: Lesson)
}
