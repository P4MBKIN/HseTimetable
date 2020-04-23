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
    
    private let disposalBag = DisposeBag()
    
    required init(view: Viewable) {
        self.view = view
        
        /// Setup inputs
        self.presentLessonEvent.asObserver()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [unowned self] lesson, segue in
                switch segue {
                case .lessonsToCalendar(let type):
                    let calendarConfigurator: CalendarConfiguratorProtocol = CalendarConfigurator()
                    if type == .present { calendarConfigurator.configureWithPresent(from: self.view, lesson: lesson) }
                    else if type == .push { calendarConfigurator.configureWithPush(from: self.view, lesson: lesson) }
                case .lessonsToNote(_): return
                case .lessonsToReminder(_): return
                case .lessonsToAlarm(_): return
                }
            })
        .disposed(by: disposalBag)
    }
}
