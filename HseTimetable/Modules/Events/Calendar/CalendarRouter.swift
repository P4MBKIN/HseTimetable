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
    let dismissTrigger = PublishSubject<Void>()
    
    private let disposeBag = DisposeBag()
    
    required init(view: Viewable) {
        self.view = view
        
        /// Inputs setup
        self.dismissTrigger.asObserver()
            .subscribe(onNext: { [weak self] _ in
                self?.view.dismiss(animated: true)
            })
        .disposed(by: self.disposeBag)
    }
}
