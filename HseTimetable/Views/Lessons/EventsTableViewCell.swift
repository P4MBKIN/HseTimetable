//
//  EventsTableViewCell.swift
//  HseTimetable
//
//  Created by Pavel on 20.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import UIKit
import SnapKit

class EventsTableViewCell: UITableViewCell {
    
    static let reuseId: String = "EventsTableViewCell"
    static let cellHeight: CGFloat = 50.0
    
    // MARK:- UI Elements
    /// Main stack for other UI elements
    private let stackContainerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = Size.double.indent
        return stackView
    }()
    
    /// Container view for calendar UI elements
    private let calendarContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.borderWidth = Size.common.indent
        view.layer.borderColor = UIColor.lightBlue.cgColor
        view.layer.cornerRadius = Size.common.cornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return view
    }()
    
    /// Container view for note UI elements
    private let noteContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.borderWidth = Size.common.indent
        view.layer.borderColor = UIColor.lightBlue.cgColor
        view.layer.cornerRadius = Size.common.cornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return view
    }()
    
    /// Container view for reminder UI elements
    private let reminderContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.borderWidth = Size.common.indent
        view.layer.borderColor = UIColor.lightBlue.cgColor
        view.layer.cornerRadius = Size.common.cornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return view
    }()
    
    /// Container view for alarm UI elements
    private let alarmContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.borderWidth = Size.common.indent
        view.layer.borderColor = UIColor.lightBlue.cgColor
        view.layer.cornerRadius = Size.common.cornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return view
    }()
    
    let calendarButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "calendar"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.tintColor = .gray
        return button
    }()
    
    let noteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "note"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.tintColor = .gray
        return button
    }()
    
    let reminderButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "reminder"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.tintColor = .gray
        return button
    }()
    
    let alarmButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "alarm"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.tintColor = .gray
        return button
    }()
    
    // MARK:- Interface
    func setup(lesson: Lesson) {
        self.contentView.clipsToBounds = true
        self.selectionStyle = .none
        setupColors(importance: lesson.importance)
    }
    
    // MARK:- Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// set containers constraints
        setStackViewConstraints()
        setCalendarContainerViewConstraints()
        setNoteContainerViewConstraints()
        setReminderContainerViewConstraints()
        setAlarmContainerViewConstraints()
        
        /// set label and images constraints
        setCalendarButtonConstraints()
        setNoteButtonConstraints()
        setReminderButtonConstraints()
        setAlarmButtonConstraints()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        /// set containers constraints
        setStackViewConstraints()
        setCalendarContainerViewConstraints()
        setNoteContainerViewConstraints()
        setReminderContainerViewConstraints()
        setAlarmContainerViewConstraints()
        
        /// set label and images constraints
        setCalendarButtonConstraints()
        setNoteButtonConstraints()
        setReminderButtonConstraints()
        setAlarmButtonConstraints()
    }
    
    // MARK:- Setup data
    private func setupColors(importance level: ImportanceLevel?) {
        guard let level = level else { return }
        
        var lightColor: UIColor
        
        switch level {
        case .hight:
            lightColor = .lightRed
        case .medium:
            lightColor = .lightBlue
        case .low:
            lightColor = .lightGreen
        }
        
        self.calendarContainerView.layer.borderColor = lightColor.cgColor
        self.noteContainerView.layer.borderColor = lightColor.cgColor
        self.reminderContainerView.layer.borderColor = lightColor.cgColor
        self.alarmContainerView.layer.borderColor = lightColor.cgColor
    }
    
    // MARK:- Constraints containers
    private func setStackViewConstraints() {
        if self.stackContainerView.superview == nil {
            self.contentView.addSubview(self.stackContainerView)
        }
        self.stackContainerView.snp.remakeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
        }
        self.stackContainerView.addArrangedSubview(self.calendarContainerView)
        self.stackContainerView.addArrangedSubview(self.noteContainerView)
        self.stackContainerView.addArrangedSubview(self.reminderContainerView)
        self.stackContainerView.addArrangedSubview(self.alarmContainerView)
    }
    
    
    private func setCalendarContainerViewConstraints() {
        if self.calendarContainerView.superview == nil {
            self.stackContainerView.addSubview(self.calendarContainerView)
        }
        self.calendarContainerView.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalTo(self.stackContainerView.snp.height)
            make.height.equalTo(self.calendarContainerView.snp.width)
        }
    }
    
    private func setNoteContainerViewConstraints() {
        if self.noteContainerView.superview == nil {
            self.stackContainerView.addSubview(self.noteContainerView)
        }
        self.noteContainerView.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalTo(self.stackContainerView.snp.height)
            make.height.equalTo(self.noteContainerView.snp.width)
        }
    }
    
    private func setReminderContainerViewConstraints() {
        if self.reminderContainerView.superview == nil {
            self.stackContainerView.addSubview(self.reminderContainerView)
        }
        self.reminderContainerView.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalTo(self.stackContainerView.snp.height)
            make.height.equalTo(self.reminderContainerView.snp.width)
        }
    }
    
    private func setAlarmContainerViewConstraints() {
        if self.alarmContainerView.superview == nil {
            self.stackContainerView.addSubview(self.alarmContainerView)
        }
        self.alarmContainerView.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalTo(self.stackContainerView.snp.height)
            make.height.equalTo(self.alarmContainerView.snp.width)
        }
    }
    
    private func setCalendarButtonConstraints() {
        if self.calendarButton.superview == nil {
            self.calendarContainerView.addSubview(self.calendarButton)
        }
        self.calendarButton.snp.remakeConstraints{ make in
            make.edges.equalToSuperview().inset(Size.double.indent)
        }
    }
    
    private func setNoteButtonConstraints() {
        if self.noteButton.superview == nil {
            self.noteContainerView.addSubview(self.noteButton)
        }
        self.noteButton.snp.remakeConstraints{ make in
            make.edges.equalToSuperview().inset(Size.double.indent)
        }
    }
    
    private func setReminderButtonConstraints() {
        if self.reminderButton.superview == nil {
            self.reminderContainerView.addSubview(self.reminderButton)
        }
        self.reminderButton.snp.remakeConstraints{ make in
            make.edges.equalToSuperview().inset(Size.double.indent)
        }
    }
    
    private func setAlarmButtonConstraints() {
        if self.alarmButton.superview == nil {
            self.alarmContainerView.addSubview(self.alarmButton)
        }
        self.alarmButton.snp.remakeConstraints{ make in
            make.edges.equalToSuperview().inset(Size.double.indent)
        }
    }
}
