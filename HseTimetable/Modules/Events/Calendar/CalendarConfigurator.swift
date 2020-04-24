//
//  CalendarConfigurator.swift
//  HseTimetable
//
//  Created by Pavel on 22.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import UIKit
import Foundation

final class CalendarConfigurator: CalendarConfiguratorProtocol {
    
    func configureWithPush(from: Viewable, lesson: Lesson) {
        let view = configure(lesson: lesson)
        from.push(view, animated: true)
    }

    func configureWithPresent(from: Viewable, lesson: Lesson) {
        let view = configure(lesson: lesson)
        let nav = UINavigationController(rootViewController: view)
        from.present(nav, animated: true)
    }
    
    private func configure(lesson: Lesson) -> CalendarViewController {
        let viewController = CalendarViewController()
        let interactor: CalendarInteractorProtocol = CalendarInteractor()
        let router: CalendarRouterProtocol = CalendarRouter(view: viewController)
        let presenter: CalendarPresenterProtocol = CalendarPresenter(dependencies: (interactor: interactor, router: router), lesson: lesson)
        viewController.presenter = presenter
        return viewController
    }
}

// MARK:- Configuratorable
extension CalendarConfigurator: Configuratorable {}
