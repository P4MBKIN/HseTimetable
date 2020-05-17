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
    
    var logoutImage: UIImage? = {
        var image = UIImage(named: "logout")
        image = image?.withRenderingMode(.alwaysOriginal)
        image = image?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: -Size.double.indent, right: 0))
        return image
    }()
    
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
    
    lazy var siriButton: INUIAddVoiceShortcutButton = {
        let button = INUIAddVoiceShortcutButton(style: .whiteOutline)
        button.shortcut = INShortcut(intent: self.intent)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.delegate = self
        return button
    }()
    
    var intent: HseTimetableIntent {
        let timetableIntent = HseTimetableIntent()
        timetableIntent.hseParameter = "hse timetable intent"
        timetableIntent.suggestedInvocationPhrase = "Расписание в университете"
        return timetableIntent
    }
    
    var presenter: LessonsPresenterProtocol!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        self.navigationController?.isNavigationBarHidden = false
        
        let logoutBarButtonItem = UIBarButtonItem(image: self.logoutImage, style: .plain, target: self, action: #selector(logoutTouchUpInside(sender:)))
        self.navigationItem.rightBarButtonItem = logoutBarButtonItem
        
        setAbsentView()
        
        setSiriButton()
        
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
            .disposed(by: self.disposeBag)
        
        // Error received
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
        
        self.presenter.outputs.warningConnection.asObserver()
        .observeOn(MainScheduler.asyncInstance)
        .subscribe(onNext: { [weak self] _ in
            self?.alertView.setup(
                title: "Внимание!",
                message: "Отсутствует сетевое подключение!\nПроверьте возможность доступа в интернет",
                leftButtonTitle: nil,
                rightButtonTitle: "OK",
                alertId: .warning
            )
            self?.animateInAlert()
        })
        .disposed(by: self.disposeBag)
        
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
    @objc private func refreshControlValueChanged(sender: UIRefreshControl) {
        self.presenter.inputs.refreshControlTrigger.onNext(())
    }
    
    @objc private func calendarButtonTouchUpInside(sender: UIButton) {
        self.presenter.inputs.didSelectLessonTrigger.onNext((sender.tag, EventSegueType.lessonsToCalendar(.present)))
    }
    
    @objc private func reminderButtonTouchUpInside(sender: UIButton) {
        self.presenter.inputs.didSelectLessonTrigger.onNext((sender.tag, EventSegueType.lessonsToReminder(.present)))
    }
    
    @objc private func logoutTouchUpInside(sender: UIBarButtonItem) {
        self.alertView.setup(
            title: "Внимание!",
            message: "Если Вы выйдете из аккаунта, все данные о расписании будут удалены с этого девайса.\nВы действительно хотите выйти из аккаунта?",
            leftButtonTitle: "Отменить",
            rightButtonTitle: "Да",
            alertId: .logout
        )
        animateInAlert()
    }
}

// MARK:- Table View Data Source
extension LessonsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard self.presenter.outputs.lessons.value.indices.contains(indexPath.section) else { return UITableViewCell() }
        if indexPath.row == 0 {
            /// show lesson cell
            let cell = self.lessonsTableView.dequeueReusableCell(withIdentifier: LessonsTableViewCell.reuseId) as? LessonsTableViewCell
            guard let lessonsCell = cell else { return UITableViewCell() }
            lessonsCell.setup(lesson: self.presenter.outputs.lessons.value[indexPath.section])
            return lessonsCell
        } else if indexPath.row == 1 && self.presenter.outputs.opens[indexPath.section] {
            /// show event cell if open
            let cell = self.lessonsTableView.dequeueReusableCell(withIdentifier: EventsTableViewCell.reuseId) as? EventsTableViewCell
            guard let eventsCell = cell else { return UITableViewCell() }
            eventsCell.setup(lesson: self.presenter.outputs.lessons.value[indexPath.section])
            eventsCell.calendarButton.tag = indexPath.section
            eventsCell.reminderButton.tag = indexPath.section
            eventsCell.calendarButton.addTarget(self, action: #selector(calendarButtonTouchUpInside(sender:)), for: .touchUpInside)
            eventsCell.reminderButton.addTarget(self, action: #selector(reminderButtonTouchUpInside(sender:)), for: .touchUpInside)
            return eventsCell
        }
        return UITableViewCell()
    }
}

// MARK:- Table View Delegate
extension LessonsViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.presenter.outputs.lessons.value.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard self.presenter.outputs.lessons.value.indices.contains(indexPath.section) else { return 0 }
        if indexPath.row == 0 { return LessonsTableViewCell.cellHeight }
        else if indexPath.row == 1 && self.presenter.outputs.opens[indexPath.section] { return EventsTableViewCell.cellHeight }
        else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard self.presenter.outputs.opens.indices.contains(indexPath.section) else { return }
        
        /// close opened sections
        var indexes = self.presenter.outputs.opens.indexes(of: true).filter{ $0 != indexPath.section }
        indexes.forEach { index in
            self.presenter.outputs.opens[index] = false
        }
        
        /// open / close selected section
        if self.presenter.outputs.opens[indexPath.section] == true {
            self.presenter.outputs.opens[indexPath.section] = false
        } else {
            self.presenter.outputs.opens[indexPath.section] = true
        }
        indexes.append(indexPath.section)
        
        /// reload table rows
        let paths = indexes.map{ IndexPath(row: 1, section: $0) }
        self.lessonsTableView.reloadRows(at: paths, with: .none)
    }
}

// MARK:- Alert Delegate
extension LessonsViewController: AlertDelegate {
    
    func leftButtonTapped(from alertId: AlertId) {
        switch alertId {
        case .logout:
            animateOutAlert(completion: nil)
        default: break
        }
    }
    
    func rightButtonTapped(from alertId: AlertId) {
        switch alertId {
        case .error:
            animateOutAlert(completion: nil)
        case .warning:
            animateOutAlert(completion: nil)
        case .logout:
            animateOutAlert(completion: { self.presenter.inputs.logoutTrigger.onNext(()) })
        }
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
