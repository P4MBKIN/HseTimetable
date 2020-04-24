//
//  LessonsConfigurator.swift
//  HseTimetable
//
//  Created by Pavel on 21.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import Foundation

final class LessonsConfigurator: LessonsConfiguratorProtocol {
    
    func configure(with viewController: LessonsViewController) {
        let interactor: LessonsInteractorProtocol = LessonsInteractor()
        let router: LessonsRouterProtocol = LessonsRouter(view: viewController)
        let presenter: LessonsPresenterProtocol = LessonsPresenter(dependencies: (interactor: interactor, router: router))
        viewController.presenter = presenter
    }
}

// MARK:- Configuratorable
extension LessonsConfigurator: Configuratorable {}
