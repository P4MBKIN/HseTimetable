//
//  LessonsViewController.swift
//  HseTimetable
//
//  Created by Pavel on 21.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import RxSwift
import RxCocoa
import IntentsUI
import SnapKit
import UIKit

final class LessonsViewController: UIViewController, LessonsViewProtocol {
    
    @IBOutlet weak var lessonsTableView: UITableView!
    var refreshControl: UIRefreshControl?
    
    var absentView: LessonsAbsentView = {
        let view = LessonsAbsentView()
        view.isHidden = true
        return view
    }()
    
    var siriButton: INUIAddVoiceShortcutButton = {
        let button = INUIAddVoiceShortcutButton(style: .whiteOutline)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var intent: HseTimetableIntent {
        let timetableIntent = HseTimetableIntent()
        timetableIntent.hseParameter = "hse timetable intent"
        timetableIntent.suggestedInvocationPhrase = "Расписание в университете"
        return timetableIntent
    }
    
    var presenter: LessonsPresenterProtocol!
    let configurator: LessonsConfiguratorProtocol = LessonsConfigurator()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configurator.configure(with: self)
        setup()
    }
    
    private func setup() {
        self.navigationController?.isNavigationBarHidden = true
        
        setAbsentView()
        
        setSiriButton()
        self.siriButton.shortcut = INShortcut(intent: self.intent )
        self.siriButton.delegate = self
        
        self.lessonsTableView.register(LessonsTableViewCell.self, forCellReuseIdentifier: LessonsTableViewCell.reuseId)
        self.lessonsTableView.register(EventsTableViewCell.self, forCellReuseIdentifier: EventsTableViewCell.reuseId)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(refreshControlValueChanged(sender:)), for: .valueChanged)
        self.lessonsTableView.refreshControl = refreshControl
        
        // News received
        self.presenter.outputs.lessons.asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] lessons in
                self?.refreshControl?.endRefreshing()
                self?.absentView.isHidden = !lessons.isEmpty
                self?.lessonsTableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        // Error received
        self.presenter.outputs.error.asObserver()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] error in
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self?.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
        
        // First view load
        self.presenter.inputs.viewDidLoadTrigger.onNext(())
    }
    
    private func setAbsentView() {
        if self.absentView.superview == nil {
            self.view.addSubview(self.absentView)
        }
        self.absentView.snp.remakeConstraints{ make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(Size.large.indent)
            make.right.equalToSuperview().inset(Size.large.indent)
        }
    }
    
    private func setSiriButton() {
        if self.siriButton.superview == nil {
            self.view.addSubview(self.siriButton)
        }
        self.siriButton.snp.remakeConstraints{ make in
            make.left.equalToSuperview().inset(25)
            make.bottom.equalToSuperview().inset(40)
        }
    }
    
    
    // MARK:- Views events
    @objc private func refreshControlValueChanged(sender: UIRefreshControl) {
        self.presenter.inputs.refreshControlTrigger.onNext(())
    }
    
    @objc private func calendarButtonTouchUpInside(sender: UIButton) {
        self.presenter.inputs.didSelectLessonTrigger.onNext((sender.tag, EventSegueType.lessonsToCalendar(.present)))
    }
    
    @objc private func noteButtonTouchUpInside(sender: UIButton) {
        //self.presenter.inputs.didSelectLessonTrigger.accept((sender.tag, .lessonsToNote))
    }
    
    @objc private func reminderButtonTouchUpInside(sender: UIButton) {
        //self.presenter.inputs.didSelectLessonTrigger.accept((sender.tag, .lessonsToReminder))
    }
    
    @objc private func alarmButtonTouchUpInside(sender: UIButton) {
        //self.presenter.inputs.didSelectLessonTrigger.accept((sender.tag, .lessonsToAlarm))
    }
}

// MARK: - Table View Data Source
extension LessonsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.presenter.outputs.opens.indices.contains(section) else { return 0 }
        return self.presenter.outputs.opens[section] ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard self.presenter.outputs.lessons.value.indices.contains(indexPath.section) else { return UITableViewCell() }
        if indexPath.row == 0 {
            let cell = self.lessonsTableView.dequeueReusableCell(withIdentifier: LessonsTableViewCell.reuseId) as? LessonsTableViewCell
            guard let lessonsCell = cell else { return UITableViewCell() }
            lessonsCell.setup(lesson: self.presenter.outputs.lessons.value[indexPath.section])
            return lessonsCell
        } else {
            let cell = self.lessonsTableView.dequeueReusableCell(withIdentifier: EventsTableViewCell.reuseId) as? EventsTableViewCell
            guard let eventsCell = cell else { return UITableViewCell() }
            eventsCell.setup(lesson: self.presenter.outputs.lessons.value[indexPath.section])
            eventsCell.calendarButton.tag = indexPath.section
            eventsCell.noteButton.tag = indexPath.section
            eventsCell.reminderButton.tag = indexPath.section
            eventsCell.alarmButton.tag = indexPath.section
            eventsCell.calendarButton.addTarget(self, action: #selector(calendarButtonTouchUpInside(sender:)), for: .touchUpInside)
            eventsCell.noteButton.addTarget(self, action: #selector(noteButtonTouchUpInside(sender:)), for: .touchUpInside)
            eventsCell.reminderButton.addTarget(self, action: #selector(reminderButtonTouchUpInside(sender:)), for: .touchUpInside)
            eventsCell.alarmButton.addTarget(self, action: #selector(alarmButtonTouchUpInside(sender:)), for: .touchUpInside)
            return eventsCell
        }
    }
}

// MARK: - Table View Delegate
extension LessonsViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.presenter.outputs.lessons.value.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard self.presenter.outputs.lessons.value.indices.contains(indexPath.section) else { return 0 }
        if indexPath.row == 0 { return LessonsTableViewCell.cellHeight }
        else { return EventsTableViewCell.cellHeight }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard self.presenter.outputs.opens.indices.contains(indexPath.section) else { return }
        if self.presenter.outputs.opens[indexPath.section] == true {
            self.presenter.outputs.opens[indexPath.section] = false
        } else {
            self.presenter.outputs.opens[indexPath.section] = true
        }
        let sections = IndexSet.init(integer: indexPath.section)
        self.lessonsTableView.reloadSections(sections, with: .none)
    }
}

// MARK:- INUIAddVoiceShortcut Button Delegate
extension LessonsViewController: INUIAddVoiceShortcutButtonDelegate {
    
    func present(_ addVoiceShortcutViewController: INUIAddVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        addVoiceShortcutViewController.delegate = self
        addVoiceShortcutViewController.modalPresentationStyle = .formSheet
        present(addVoiceShortcutViewController, animated: true, completion: nil)
    }
    
    func present(_ editVoiceShortcutViewController: INUIEditVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        editVoiceShortcutViewController.delegate = self
        editVoiceShortcutViewController.modalPresentationStyle = .formSheet
        present(editVoiceShortcutViewController, animated: true, completion: nil)
    }
}

// MARK:- INUIAddVoiceShortcut ViewController Delegate
extension LessonsViewController: INUIAddVoiceShortcutViewControllerDelegate {
    
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK:- INUIEditVoiceShortcut ViewController Delegate
extension LessonsViewController: INUIEditVoiceShortcutViewControllerDelegate {
    
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didUpdate voiceShortcut: INVoiceShortcut?, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK:- Viewable
extension LessonsViewController: Viewable {}
