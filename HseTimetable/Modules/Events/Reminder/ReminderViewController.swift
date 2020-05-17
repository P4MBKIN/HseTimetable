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
    
    lazy var alertView: AlertView = {
        let view = AlertView()
        view.delegate = self
        return view
    }()
    
    var visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] error in
                self?.alertView.setup(
                    title: "Внимание!",
                    message: error.localizedDescription,
                    leftButtonTitle: nil,
                    rightButtonTitle: "Skip",
                    alertId: .error
                )
                self?.animateInAlert()
            })
            .disposed(by: self.disposeBag)
        
        // First view load
        self.presenter.inputs.viewDidLoadTrigger.onNext(())
    }
    
    private func setVisualEffect() {
        self.navigationController?.view.addSubview(self.visualEffectView)
        self.visualEffectView.snp.remakeConstraints{ make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setAlert() {
        self.navigationController?.view.addSubview(self.alertView)
        self.alertView.snp.remakeConstraints{ make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK:- Animations
    private func animateInAlert() {
        setVisualEffect()
        self.visualEffectView.alpha = 0.0
        
        setAlert()
        self.alertView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.alertView.alpha = 0.0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.alpha = 1.0
            self.alertView.alpha = 1.0
            self.alertView.transform = CGAffineTransform.identity
        }
    }
    
    private func animateOutAlert(completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.4, animations: {
            self.visualEffectView.alpha = 0.0
            self.alertView.alpha = 0.0
            self.alertView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { _ in
            self.visualEffectView.removeFromSuperview()
            self.alertView.removeFromSuperview()
            completion?()
        }
    }
    
    // MARK:- Views events
    @IBAction func prioritySliderValueChanged(_ sender: UISlider) {
        let color = UIColor.green.toColor(.red, percentage: CGFloat((sender.value - sender.minimumValue) * 100 / (sender.maximumValue - sender.minimumValue)))
        self.priorityCircleView.tintColor = color
    }
    
    @objc private func closeButtonTouchUpInside() {
        self.presenter.inputs.closeButtonTrigger.onNext(())
    }
    
    @objc private func addButtonTouchUpInside() {
        let dataFromView = ReminderEventData(title: self.titleTextField.text ?? "", priority: Int(self.prioritySlider.value), notes: self.notesTextView.text, alarmDate: self.alarmDatePicker.date)
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

// MARK:- Text Field Delegate
extension ReminderViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

// MARK:- Text View Delegate
extension ReminderViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" { textView.endEditing(true) }
        return true
    }
}

// MARK:- Alert Delegate
extension ReminderViewController: AlertDelegate {
    
    func rightButtonTapped(from alertId: AlertId) {
        switch alertId {
        case .error:
            animateOutAlert(completion: nil)
        default: break
        }
    }
}

// MARK:- Viewable
extension ReminderViewController: Viewable {}
