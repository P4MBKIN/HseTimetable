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
import Foundation

final class CalendarViewController: UIViewController, CalendarViewProtocol {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var alarmPickerView: UIPickerView!
    
    var presenter: CalendarPresenterProtocol!
    
    private  let alarmIntervalNames: [(TimeInterval?, String)] = [
        (nil, "Нет"),
        (TimeInterval(0), "В момент события"),
        (TimeInterval(-5 * 60), "За 5 минут"),
        (TimeInterval(-10 * 60), "За 10 минут"),
        (TimeInterval(-15 * 60), "За 15 минут"),
        (TimeInterval(-30 * 60), "За 30 минут"),
        (TimeInterval(-1 * 60 * 60), "За 1 час"),
        (TimeInterval(-2 * 60 * 60), "За 2 часа"),
        (TimeInterval(-1 * 24 * 60 * 60), "За 1 день"),
        (TimeInterval(-2 * 24 * 60 * 60), "За 2 дня"),
        (TimeInterval(-7 * 24 * 60 * 60), "За 1 неделю")
    ]
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeButtonTouchUpInside))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTouchUpInside))
        
        self.startDatePicker.locale = Locale(identifier: "ru-RU")
        self.endDatePicker.locale = Locale(identifier: "ru-RU")
        self.alarmPickerView.dataSource = self
        self.alarmPickerView.delegate = self
        
        self.presenter.outputs.viewConfigure
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] eventData in
                self?.titleTextField.text = eventData.title
                self?.startDatePicker.date = eventData.startDate
                self?.endDatePicker.date = eventData.endDate
                let index = self?.alarmIntervalNames.firstIndex{ $0.0 == eventData.alarmInterval } ?? 0
                self?.alarmPickerView.selectRow(index, inComponent: 0, animated: false)
            })
        .disposed(by: disposeBag)
        
        // First view load
        self.presenter.inputs.viewDidLoadTrigger.onNext(())
    }
    
    @objc private func closeButtonTouchUpInside() {
        
    }
    
    @objc private func addButtonTouchUpInside() {
        
    }
}

extension CalendarViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.alarmIntervalNames.count
    }
}

extension CalendarViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.alarmIntervalNames[row].1
    }
}

// MARK:- Viewable
extension CalendarViewController: Viewable {}
