//
//  LessonsProtocols.swift
//  HseTimetable
//
//  Created by Pavel on 20.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import RxSwift
import RxCocoa
import Foundation

protocol LessonsViewProtocol: class {
    var presenter: LessonsPresenterProtocol! { get set }
}

/// VIEW -> PRESENTER
protocol LessonsPresenterInputsProtocol: class {
    var viewDidLoadTrigger: PublishSubject<Void> { get }
    var refreshControlTrigger: PublishSubject<Void> { get }
    var didSelectLessonTrigger: PublishSubject<(Int, EventSegueType)> { get }
}

/// PRESENTER -> VIEW
protocol LessonsPresenterOutputsProtocol: class {
    var opens: [Bool] { get set }
    var lessons: BehaviorRelay<[Lesson]> { get }
    var error: PublishSubject<Error> { get }
}

typealias LessonsPresenterDependencies = (
    interactor: LessonsInteractorProtocol,
    router: LessonsRouterProtocol
)

protocol LessonsPresenterProtocol: class {
    var dependencies: LessonsPresenterDependencies! { get }
    var inputs: LessonsPresenterInputsProtocol { get }
    var outputs: LessonsPresenterOutputsProtocol { get }
}

/// PRESENTER -> INTERACTOR
protocol LessonsInteractorInputsProtocol: class {
    var dataBaseLessonsTrigger: PublishSubject<Void> { get }
    var searchLessonsTrigger: PublishSubject<LessonsSearchParams> { get }
}

/// INTERACTOR -> PRESENTER
protocol LessonsInteractorOutputsProtocol: class {
    var searchLessonsResponse: PublishSubject<[Lesson]> { get }
}

protocol LessonsInteractorProtocol: class {
    var inputs: LessonsInteractorInputsProtocol { get }
    var outputs: LessonsInteractorOutputsProtocol { get }
}

/// PRESENTER -> ROUTER
protocol LessonsRouterInputsProtocol: class {
    var presentLessonEvent: PublishSubject<(Lesson, EventSegueType)> { get }
}

protocol LessonsRouterProtocol: class {
    var inputs: LessonsRouterInputsProtocol { get }
}

protocol LessonsConfiguratorProtocol: class {
    func configure(with viewController: LessonsViewController)
}
