//
//  LessonsViewController.swift
//  HseTimetable
//
//  Created by Pavel on 21.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

final class LessonsViewController: UIViewController, LessonsViewProtocol {
    
    var presenter: LessonsPresenterProtocol!
    let configurator: LessonsConfiguratorProtocol = LessonsConfigurator()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configurator.configure(with: self)
        setup()
    }
    
    private func setup() {
        
    }
}
