//
//  CalendarPresenter.swift
//  HseTimetable
//
//  Created by Pavel on 22.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import RxSwift
import RxCocoa
import Foundation

final class CalendarPresenter: CalendarPresenterProtocol, CalendarPresenterInputsProtocol, CalendarPresenterOutputsProtocol {
    
    let dependencies: CalendarPresenterDependencies!
    
    var inputs: CalendarPresenterInputsProtocol { return self }
    var outputs: CalendarPresenterOutputsProtocol { return self }
    
    /// Inputs
    
    /// Outputs
    
    private let lesson: Lesson
    private let disaposeBag = DisposeBag()
    
    required init(dependencies: CalendarPresenterDependencies, lesson: Lesson) {
        self.dependencies = dependencies
        
        self.lesson = lesson
        
        /// Inputs setup
        
        /// Outputs setup
    }
}

//MARK:- Presenterable
extension CalendarPresenter: Presenterable {}
