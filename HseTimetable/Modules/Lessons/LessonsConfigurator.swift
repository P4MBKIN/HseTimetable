//
//  LessonsConfigurator.swift
//  HseTimetable
//
//  Created by Pavel on 21.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import UIKit
import Foundation

final class LessonsConfigurator: LessonsConfiguratorProtocol {
    
    func configureWithPush(from: Viewable) {
        let view = configure()
        from.push(view, animated: true)
    }
    
    func configureWithPresent(from: Viewable) {
        let view = configure()
        let nav = UINavigationController(rootViewController: view)
        from.present(nav, animated: true)
    }
    
    func configureWithMove() {
        let view = configure()
        view.move(animated: true)
    }
    
    func configure() -> LessonsViewController {
        let viewController = LessonsViewController()
        let interactor: LessonsInteractorProtocol = LessonsInteractor()
        let router: LessonsRouterProtocol = LessonsRouter(view: viewController)
        let presenter: LessonsPresenterProtocol = LessonsPresenter(dependencies: (interactor: interactor, router: router))
        viewController.presenter = presenter
        return viewController
    }
}

// MARK:- Configuratorable
extension LessonsConfigurator: Configuratorable {}
