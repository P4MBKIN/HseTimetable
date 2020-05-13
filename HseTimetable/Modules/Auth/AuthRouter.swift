//
//  AuthRouter.swift
//  HseTimetable
//
//  Created by Pavel on 12.05.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import RxSwift
import RxCocoa
import Foundation

final class AuthRouter: AuthRouterProtocol, AuthRouterInputsProtocol, Routerable {
    
    private(set) weak var view: Viewable!
    
    var inputs: AuthRouterInputsProtocol { return self }
    
    /// Inputs
    let pushLessonsTrigger = PublishSubject<Void>()
    
    private let disposeBag = DisposeBag()
    
    required init(view: Viewable) {
        self.view = view
        
        /// Inputs setup
        self.pushLessonsTrigger.asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [unowned self] _ in
                let lessonsConfigurator: LessonsConfiguratorProtocol = LessonsConfigurator()
                lessonsConfigurator.configureWithPush(from: self.view)
            })
            .disposed(by: self.disposeBag)
    }
}
