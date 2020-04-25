//
//  ReminderViewController.swift
//  HseTimetable
//
//  Created by Pavel on 25.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import RxSwift
import RxCocoa
import SnapKit
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
        .disposed(by: disposeBag)
        
        self.presenter.outputs.error.asObserver()
            .subscribe(onNext: { [weak self] error in
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self?.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
        
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
}

// MARK:- Viewable
extension ReminderViewController: Viewable {}
