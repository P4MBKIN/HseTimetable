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
    static let cellHeight: CGFloat = 75.0
    
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
    
    /// Container view for notification UI elements
    private let notificationContainerView: UIView = {
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
    
    private let calendarButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "calendar"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.tintColor = .gray
        return button
    }()
    
    private let noteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "note"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.tintColor = .gray
        return button
    }()
    
    private let notificationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "notification"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.tintColor = .gray
        return button
    }()
    
    private let alarmButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "alarm"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.tintColor = .gray
        return button
    }()
    
    // MARK:- Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// set containers constraints
        setStackViewConstraints()
        setCalendarContainerViewConstraints()
        setNoteContainerViewConstraints()
        setNotificationContainerViewConstraints()
        setAlarmContainerViewConstraints()
        
        /// set label and images constraints
        setCalendarButtonConstraints()
        setNoteButtonConstraints()
        setNotificationButtonConstraints()
        setAlarmButtonConstraints()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        /// set containers constraints
        setStackViewConstraints()
        setCalendarContainerViewConstraints()
        setNoteContainerViewConstraints()
        setNotificationContainerViewConstraints()
        setAlarmContainerViewConstraints()
        
        /// set label and images constraints
        setCalendarButtonConstraints()
        setNoteButtonConstraints()
        setNotificationButtonConstraints()
        setAlarmButtonConstraints()
    }
    
    // MARK:- Constraints containers
    private func setStackViewConstraints() {
        if self.stackContainerView.superview == nil {
            self.contentView.addSubview(self.stackContainerView)
        }
        self.stackContainerView.snp.remakeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(Size.double.indent)
            make.bottom.equalToSuperview().inset(Size.double.indent)
            make.leading.greaterThanOrEqualToSuperview()
        }
        self.stackContainerView.addArrangedSubview(self.calendarContainerView)
        self.stackContainerView.addArrangedSubview(self.noteContainerView)
        self.stackContainerView.addArrangedSubview(self.notificationContainerView)
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
    
    private func setNotificationContainerViewConstraints() {
        if self.notificationContainerView.superview == nil {
            self.stackContainerView.addSubview(self.notificationContainerView)
        }
        self.notificationContainerView.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalTo(self.stackContainerView.snp.height)
            make.height.equalTo(self.notificationContainerView.snp.width)
        }
    }
    
    private func setAlarmContainerViewConstraints() {
        if self.alarmContainerView.superview == nil {
            self.stackContainerView.addSubview(self.alarmContainerView)
        }
        self.alarmContainerView.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalTo(self.stackContainerView.snp.height)
            make.height.equalTo(self.notificationContainerView.snp.width)
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
    
    private func setNotificationButtonConstraints() {
        if self.notificationButton.superview == nil {
            self.notificationContainerView.addSubview(self.notificationButton)
        }
        self.notificationButton.snp.remakeConstraints{ make in
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
