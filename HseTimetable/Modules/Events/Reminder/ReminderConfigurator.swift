//
//  ReminderConfigurator.swift
//  HseTimetable
//
//  Created by Pavel on 25.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import UIKit
import Foundation

final class ReminderConfigurator: ReminderConfiguratorProtocol {
    
    func configureWithPush(from: Viewable, lesson: Lesson) {
        let view = configure(lesson: lesson)
        from.push(view, animated: true)
    }

    func configureWithPresent(from: Viewable, lesson: Lesson) {
        let view = configure(lesson: lesson)
        let nav = UINavigationController(rootViewController: view)
        from.present(nav, animated: true)
    }
    
    private func configure(lesson: Lesson) -> ReminderViewController {
        let viewController = ReminderViewController()
        let interactor: ReminderInteractorProtocol = ReminderInteractor()
        let router: ReminderRouterProtocol = ReminderRouter(view: viewController)
        let presenter: ReminderPresenterProtocol = ReminderPresenter(dependencies: (interactor: interactor, router: router), lesson: lesson)
        viewController.presenter = presenter
        return viewController
    }
}

// MARK:- Configuratorable
extension ReminderConfigurator: Configuratorable {}
