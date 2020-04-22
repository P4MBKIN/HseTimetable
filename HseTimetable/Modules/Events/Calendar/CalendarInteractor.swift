//
//  CalendarInteractor.swift
//  HseTimetable
//
//  Created by Pavel on 22.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import RxSwift
import RxCocoa
import Action
import Foundation

final class CalendarInteractor: CalendarInteractorProtocol, CalendarInteractorInputsProtocol, CalendarInteractorOutputsProtocol {
    
    var inputs: CalendarInteractorInputsProtocol { return self }
    var outputs: CalendarInteractorOutputsProtocol { return self }
    
    /// Inputs
    
    /// Outputs
    
    private let disposeBag = DisposeBag()
    
    required init() {
        
        /// Inputs setup
        
        /// Outputs setup
    }
}

//MARK:- Interactorable
extension CalendarInteractor: Interactorable {}
