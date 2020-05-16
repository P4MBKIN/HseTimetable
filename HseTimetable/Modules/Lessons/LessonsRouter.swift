//
//  LessonsRouter.swift
//  HseTimetable
//
//  Created by Pavel on 21.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import RxSwift
import RxCocoa
import Foundation

final class LessonsRouter: LessonsRouterProtocol, LessonsRouterInputsProtocol, Routerable {
    
    private(set) weak var view: Viewable!
    
    var inputs: LessonsRouterInputsProtocol { return self }
    
    /// Inputs
    let presentLessonEvent = PublishSubject<(Lesson, EventSegueType)>()
    let pushAuthTrigger = PublishSubject<Void>()
    
    private let disposeBag = DisposeBag()
    
    required init(view: Viewable) {
        self.view = view
        
        /// Inputs setup
        self.presentLessonEvent.asObserver()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [unowned self] lesson, segue in
                switch segue {
                case .lessonsToCalendar(let type):
                    let calendarConfigurator: CalendarConfiguratorProtocol = CalendarConfigurator()
                    if type == .present { calendarConfigurator.configureWithPresent(from: self.view, lesson: lesson) }
                    else if type == .push { calendarConfigurator.configureWithPush(from: self.view, lesson: lesson) }
                case .lessonsToReminder(let type):
                    let reminderConfigurator: ReminderConfiguratorProtocol = ReminderConfigurator()
                    if type == .present { reminderConfigurator.configureWithPresent(from: self.view, lesson: lesson) }
                    else if type == .push { reminderConfigurator.configureWithPush(from: self.view, lesson: lesson) }
                }
            })
        .disposed(by: self.disposeBag)
        
        self.pushAuthTrigger.asObserver()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { _ in
                let authConfigurator: AuthConfiguratorProtocol = AuthConfigurator()
                authConfigurator.configureWithMove()
            })
            .disposed(by: self.disposeBag)
    }
}
