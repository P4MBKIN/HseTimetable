//
//  CalendarViewController.swift
//  HseTimetable
//
//  Created by Pavel on 22.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

final class CalendarViewController: UIViewController, CalendarViewProtocol {
    
    var presenter: CalendarPresenterProtocol!
    
    private let disaposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        
    }
}

// MARK:- Viewable
extension CalendarViewController: Viewable {}
