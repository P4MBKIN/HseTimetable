//
//  LessonsPresenter.swift
//  HseTimetable
//
//  Created by Pavel on 21.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import RxSwift
import RxCocoa
import Foundation

final class LessonsPresenter: LessonsPresenterProtocol, LessonsPresenterInputsProtocol, LessonsPresenterOutputsProtocol {
    
    var interactor: LessonsInteractorProtocol!
    var router: LessonsRouterProtocol!
    
    var inputs: LessonsPresenterInputsProtocol { return self }
    var outputs: LessonsPresenterOutputsProtocol { return self }
    
    /// Inputs
    let viewDidLoadTrigger = PublishSubject<Void>()
    let refreshControlTrigger = PublishSubject<Void>()
    
    /// Outputs
    let lessons = BehaviorRelay<[Lesson]>(value: [])
    let error = PublishSubject<Error>()
    
    private var lessonsSearchParams: LessonsSearchParams
    private let disposeBag = DisposeBag()
    
    required init(dependencies: LessonsPresenterDependencies) {
        self.interactor = dependencies.interactor
        self.router = dependencies.router
        
        self.lessonsSearchParams = LessonsSearchParams(studentId: 203843, daysOffset: 2, dateFrom: Date.init())
        
        /// Inputs setup
        
        /// Outputs setup
        
    }
}
