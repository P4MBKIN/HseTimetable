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
    
    func configureWithMove() {
        let view = configure()
        view.move(animated: true)
    }
    
    private func configure() -> LessonsViewController {
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
