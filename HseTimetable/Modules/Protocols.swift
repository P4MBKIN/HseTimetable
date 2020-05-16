//
//  Protocols.swift
//  HseTimetable
//
//  Created by Pavel on 22.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import UIKit
import Foundation

protocol Viewable: class {
    func push(_ vc: UIViewController, animated: Bool)
    func present(_ vc: UIViewController, animated: Bool)
    func move(animated: Bool)
    func pop(animated: Bool)
    func dismiss(animated: Bool)
    func dismiss(animated: Bool, completion:  @escaping (() -> Void))
}

protocol Presenterable: class {
    
}

protocol Interactorable: class {
    
}

protocol Routerable: class {
    var view: Viewable! { get }
    func dismiss(animated: Bool)
    func dismiss(animated: Bool, completion: @escaping (() -> Void))
    func pop(animated: Bool)
}

protocol Configuratorable: class {
    
}

extension Viewable where Self: UIViewController {
    
    func push(_ vc: UIViewController, animated: Bool) {
        self.navigationController?.pushViewController(vc, animated: animated)
    }
    func present(_ vc: UIViewController, animated: Bool) {
        self.present(vc, animated: animated, completion: nil)
    }
    func move(animated: Bool) {
        if let currentVc = UIApplication.shared.keyWindow?.rootViewController {
            currentVc.dismiss(animated: animated, completion: nil)
        }
        UIApplication.shared.keyWindow?.rootViewController = UINavigationController(rootViewController: self)
    }
    func pop(animated: Bool) {
        self.navigationController?.popViewController(animated: animated)
    }
    func dismiss(animated: Bool) {
        self.dismiss(animated: animated, completion: nil)
    }
    func dismiss(animated: Bool, completion: @escaping (() -> Void)) {
        self.dismiss(animated: animated, completion: completion)
    }
    
    var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .portrait }
    var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation { return .portrait }
}

extension Routerable {
    func dismiss(animated: Bool) { view.dismiss(animated: animated) }
    func dismiss(animated: Bool, completion: @escaping (() -> Void)) { view.dismiss(animated: animated, completion: completion) }
    func pop(animated: Bool) { view.pop(animated: animated) }
}
