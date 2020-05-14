//
//  ReminderViewController.swift
//  HseTimetable
//
//  Created by Pavel on 25.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

final class ReminderViewController: UIViewController, ReminderViewProtocol {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var priorityCircleView: UIImageView!
    @IBOutlet weak var prioritySlider: UISlider!
    @IBOutlet weak var alarmDatePicker: UIDatePicker!
    
    var presenter: ReminderPresenterProtocol!
    
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
        
        self.priorityCircleView.tintColor = .green
        
        self.alarmDatePicker.locale = Locale(identifier: "ru-RU")
        
        self.notesTextView.layer.borderColor = UIColor.gray.cgColor
        self.notesTextView.layer.borderWidth = 1.0
        self.notesTextView.layer.cornerRadius = 5.0
        
        self.presenter.outputs.viewConfigure.asObserver()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] reminderData in
                self?.titleTextField.text = reminderData.title
                self?.notesTextView.text = reminderData.notes
                self?.prioritySlider.value = Float(reminderData.priority)
                self?.alarmDatePicker.date = reminderData.alarmDate ?? Date()
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
    
    @IBAction func prioritySliderValueChanged(_ sender: UISlider) {
        let color = UIColor.green.toColor(.red, percentage: CGFloat((sender.value - sender.minimumValue) * 100 / (sender.maximumValue - sender.minimumValue)))
        self.priorityCircleView.tintColor = color
    }
    
    // MARK:- Views events
    @objc private func closeButtonTouchUpInside() {
        self.presenter.inputs.closeButtonTrigger.onNext(())
    }
    
    @objc private func addButtonTouchUpInside() {
        let dataFromView = ReminderEventData(title: self.titleTextField.text ?? "", priority: Int(self.prioritySlider.value), notes: self.notesTextView.text, alarmDate: self.alarmDatePicker.date)
        self.presenter.inputs.addButtonTrigger.onNext(dataFromView)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let textViewResponder = self.view.getSelectedTextView() else { return }
        guard let positionResponder = self.view.getPositionOfView(view: textViewResponder) else { return }
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let paddingTextView = self.view.frame.height - (positionResponder.origin.y + positionResponder.height)
            if keyboardSize.height > paddingTextView + 20 {
                self.view.frame.origin.y -= (keyboardSize.height - paddingTextView) + 20
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        print(self.view.frame.origin.y)
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

// MARK: - Text Field Delegate
extension ReminderViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

// MARK: - Text View Delegate
extension ReminderViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" { textView.endEditing(true) }
        return true
    }
}

// MARK:- Viewable
extension ReminderViewController: Viewable {}
