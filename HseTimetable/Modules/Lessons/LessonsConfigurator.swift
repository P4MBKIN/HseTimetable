//
//  LessonsConfigurator.swift
//  HseTimetable
//
//  Created by Pavel on 21.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import Foundation

final class LessonsConfigurator: LessonsConfiguratorProtocol {
    
    func configure(with viewController: LessonsViewProtocol) {
        let router: LessonsRouterProtocol = LessonsRouter()
        let interactor: LessonsInteractorProtocol = LessonsInteractor()
        let presenter: LessonsPresenterProtocol = LessonsPresenter(dependencies: (interactor: interactor, router: router))
        viewController.presenter = presenter
    }
}
