//
//  CalendarProtocols.swift
//  HseTimetable
//
//  Created by Pavel on 22.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import Foundation

protocol CalendarViewProtocol: class {
    var presenter: CalendarPresenterProtocol! { get set }
}

/// VIEW -> PRESENTER
protocol CalendarPresenterInputsProtocol: class {
    
}

/// PRESENTER -> VIEW
protocol CalendarPresenterOutputsProtocol: class {
    
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
    
}

/// INTERACTOR -> PRESENTER
protocol CalendarInteractorOutputsProtocol: class {
    
}

protocol CalendarInteractorProtocol: class {
    var inputs: CalendarInteractorInputsProtocol { get }
    var outputs: CalendarInteractorOutputsProtocol { get }
}

/// PRESENTER -> ROUTER
protocol CalendarRouterInputsProtocol: class {
    
}

protocol CalendarRouterProtocol: class {
    var inputs: CalendarRouterInputsProtocol { get }
}

/// ANOTHER MODUL -> CONFIGURATOR
protocol CalendarConfiguratorProtocol: class {
    func configureWithPush(from: Viewable, lesson: Lesson)
    func configureWithPresent(from: Viewable, lesson: Lesson)
}
