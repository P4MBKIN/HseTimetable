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
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeButtonTouchUpInside))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTouchUpInside))
        
        self.startDatePicker.locale = Locale(identifier: "ru-RU")
        self.endDatePicker.locale = Locale(identifier: "ru-RU")
        self.alarmPickerView.dataSource = self
        self.alarmPickerView.delegate = self
        
        self.presenter.outputs.viewConfigure.asObserver()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] eventData in
                self?.titleTextField.text = eventData.title
                self?.startDatePicker.date = eventData.startDate
                self?.endDatePicker.date = eventData.endDate
                let index = self?.alarmIntervalNames.firstIndex{ $0.0 == eventData.alarmInterval } ?? 0
                self?.alarmPickerView.selectRow(index, inComponent: 0, animated: false)
            })
            .disposed(by: self.disposeBag)
        
        self.presenter.outputs.error.asObserver()
            .subscribe(onNext: { [weak self] error in
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self?.present(alert, animated: true)
            })
            .disposed(by: self.disposeBag)
        
        // First view load
        self.presenter.inputs.viewDidLoadTrigger.onNext(())
    }
    
    // MARK:- Views events
    @objc private func closeButtonTouchUpInside() {
        self.presenter.inputs.closeButtonTrigger.onNext(())
    }
    
    @objc private func addButtonTouchUpInside() {
        let dataFromView = CalendarEventData(title: self.titleTextField.text ?? "", startDate: self.startDatePicker.date, endDate: self.endDatePicker.date, alarmInterval: self.alarmIntervalNames[self.alarmPickerView.selectedRow(inComponent: 0)].0)
        self.presenter.inputs.addButtonTrigger.onNext(dataFromView)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let textViewResponder = self.view.getSelectedTextView() else { return }
        guard let positionResponder = self.view.getPositionOfSubview(subview: textViewResponder) else { return }
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
            let paddingTextView = self.view.frame.height + navigationBarHeight - (positionResponder.origin.y + positionResponder.height)
            if keyboardSize.height > paddingTextView + Size.large.indent {
                self.view.frame.origin.y -= (keyboardSize.height - paddingTextView) + Size.large.indent
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

// MARK:- Picker View Data Sourse
extension CalendarViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.alarmIntervalNames.count
    }
}

// MARK:- Picker View Delegate
extension CalendarViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.alarmIntervalNames[row].1
    }
}

// MARK:- Text Field Delegate
extension CalendarViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

// MARK:- Viewable
extension CalendarViewController: Viewable {}
