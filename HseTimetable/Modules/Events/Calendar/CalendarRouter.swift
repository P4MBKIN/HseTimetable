//
//  CalendarRouter.swift
//  HseTimetable
//
//  Created by Pavel on 22.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import RxSwift
import RxCocoa
import Foundation

final class CalendarRouter: CalendarRouterProtocol, CalendarRouterInputsProtocol, Routerable {
    
    private(set) weak var view: Viewable!
    
    var inputs: CalendarRouterInputsProtocol { return self }
    
    /// Inputs
    
    private let disposalBag = DisposeBag()
    
    required init(view: Viewable) {
        self.view = view
        
        /// Setup inputs
    }
}
