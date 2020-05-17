//
//  AuthConfigurator.swift
//  HseTimetable
//
//  Created by Pavel on 12.05.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import UIKit
import Foundation

final class AuthConfigurator: AuthConfiguratorProtocol {
    
    func configureWithMove() {
        let view = configure()
        view.move(animated: true)
    }
    
    private func configure() -> AuthViewController {
        let viewController = AuthViewController()
        let interactor: AuthInteractorProtocol = AuthInteractor()
        let router: AuthRouterProtocol = AuthRouter(view: viewController)
        let presenter: AuthPresenterProtocol = AuthPresenter(dependencies: (interactor: interactor, router: router))
        viewController.presenter = presenter
        return viewController
    }
}

// MARK:- Configuratorable
extension AuthConfigurator: Configuratorable {}
