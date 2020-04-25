//
//  ReminderRouter.swift
//  HseTimetable
//
//  Created by Pavel on 25.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import RxSwift
import RxCocoa
import Foundation

final class ReminderRouter: ReminderRouterProtocol, ReminderRouterInputsProtocol, Routerable {
    
    private(set) weak var view: Viewable!
    
    var inputs: ReminderRouterInputsProtocol { return self }
    
    /// Inputs
    let dismissTrigger = PublishSubject<Void>()
    
    private let disposalBag = DisposeBag()
    
    required init(view: Viewable) {
        self.view = view
        
        /// Setup inputs
        self.dismissTrigger.asObserver()
            .subscribe(onNext: { [weak self] _ in
                self?.view.dismiss(animated: true)
            })
        .disposed(by: disposalBag)
    }
}
