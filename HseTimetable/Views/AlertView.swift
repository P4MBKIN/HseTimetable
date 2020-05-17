//
//  AlertView.swift
//  HseTimetable
//
//  Created by Pavel on 15.05.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import UIKit
import SnapKit

protocol AlertDelegate {
    func leftButtonTapped(from alertId: AlertId)
    func rightButtonTapped(from alertId: AlertId)
}

enum AlertId: Int {
    case error = 0
    case warning = 1
    case logout = 2
}

class AlertView: UIView {
    
    // MARK:- UI Elements
    /// Container view for all other UI elements
    private let mainContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = Size.large.cornerRadius
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
        view.layer.borderWidth = 3.0
        view.layer.borderColor = UIColor.softBlue.cgColor
        return view
    }()
    
    /// Container view for content UI elements
    private let contentContainerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    /// Stack container for buttons elements
    private let stackContainerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = Size.double.indent
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = .softBlue
        label.font = .systemFont(ofSize: Size.large.font, weight: .semibold)
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: Size.common.font, weight: .regular)
        return label
    }()
    
    private let leftButton: UIButton = {
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(top: Size.common.indent, left: Size.double.indent, bottom: Size.common.indent, right: Size.double.indent)
        button.layer.cornerRadius = Size.common.cornerRadius
        button.backgroundColor = .lightGray
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(leftButtonTouchUpInside(_:)), for: .touchUpInside)
        return button
    }()
    
    private let rightButton: UIButton = {
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(top: Size.common.indent, left: Size.double.indent, bottom: Size.common.indent, right: Size.double.indent)
        button.layer.cornerRadius = Size.common.cornerRadius
        button.backgroundColor = .softBlue
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(rightButtonTouchUpInside(_:)), for: .touchUpInside)
        return button
    }()
    
    var delegate: AlertDelegate?
    
    // MARK:- Interface
    func setup(title: String, message: String, leftButtonTitle: String?, rightButtonTitle: String, alertId: AlertId = .error) {
        self.titleLabel.text = title
        self.messageLabel.text = message
        if let leftButtonTitle = leftButtonTitle {
            self.leftButton.setTitle(leftButtonTitle, for: .normal)
            self.leftButton.titleLabel?.font = .systemFont(ofSize: Size.common.font, weight: .semibold)
            self.leftButton.tag = alertId.rawValue
        } else {
            self.leftButton.isHidden = true
            self.leftButton.isEnabled = false
        }
        self.rightButton.setTitle(rightButtonTitle, for: .normal)
        self.rightButton.titleLabel?.font = .systemFont(ofSize: Size.common.font, weight: .semibold)
        self.rightButton.tag = alertId.rawValue
    }
    
    // MARK:- Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// set containers constraints
        setMainContainerViewConstraints()
        setContentContainerViewConstraints()
        setStackViewConstraints()

        /// set labels and buttons constraints
        setTitleLabelConstraints()
        setMessageLabelConstraints()
        setLeftButtonConstraints()
        setRightButtonConstraints()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        /// set containers constraints
        setMainContainerViewConstraints()
        setContentContainerViewConstraints()
        setStackViewConstraints()

        /// set labels and buttons constraints
        setTitleLabelConstraints()
        setMessageLabelConstraints()
        setLeftButtonConstraints()
        setRightButtonConstraints()
    }
    
    // MARK:- Constraints containers
    private func setMainContainerViewConstraints() {
        if self.mainContainerView.superview == nil {
            self.addSubview(self.mainContainerView)
        }
        self.mainContainerView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            if let superview = self.superview {
                make.left.equalTo(superview.snp.left).inset(Size.large.indent * 2)
                make.right.equalTo(superview.snp.right).inset(Size.large.indent * 2)
            } else {
                make.width.equalTo(300.0)
            }
        }
    }
    
    private func setContentContainerViewConstraints() {
        if self.contentContainerView.superview == nil {
            self.mainContainerView.addSubview(self.contentContainerView)
        }
        self.contentContainerView.snp.remakeConstraints{ make in
            make.top.equalToSuperview().inset(Size.double.indent)
            make.left.equalToSuperview().inset(Size.double.indent)
            make.right.equalToSuperview().inset(Size.double.indent)
        }
    }
    
    private func setStackViewConstraints() {
        if self.stackContainerView.superview == nil {
            self.mainContainerView.addSubview(self.stackContainerView)
        }
        self.stackContainerView.snp.remakeConstraints{ make in
            make.top.equalTo(self.contentContainerView.snp.bottom).offset(Size.double.indent)
            make.bottom.equalToSuperview().inset(Size.double.indent)
            make.right.equalToSuperview().inset(Size.double.indent)
        }
        self.stackContainerView.addArrangedSubview(self.leftButton)
        self.stackContainerView.addArrangedSubview(self.rightButton)
    }
    
    private func setTitleLabelConstraints() {
        if self.titleLabel.superview == nil {
            self.contentContainerView.addSubview(self.titleLabel)
        }
        self.titleLabel.snp.remakeConstraints{ make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.greaterThanOrEqualToSuperview().inset(Size.double.indent)
        }
    }
    
    private func setMessageLabelConstraints() {
        if self.messageLabel.superview == nil {
            self.contentContainerView.addSubview(self.messageLabel)
        }
        self.messageLabel.snp.remakeConstraints{ make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Size.double.indent)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func setLeftButtonConstraints() {
        if self.leftButton.superview == nil {
            self.stackContainerView.addSubview(self.self.leftButton)
        }
        self.leftButton.snp.remakeConstraints{ make in
            make.top.equalToSuperview()
        }
    }
    
    private func setRightButtonConstraints() {
        if self.rightButton.superview == nil {
            self.stackContainerView.addSubview(self.self.rightButton)
        }
        self.rightButton.snp.remakeConstraints{ make in
            make.top.equalToSuperview()
        }
    }
    
    @objc private func leftButtonTouchUpInside(_ sender: UIButton) {
        self.delegate?.leftButtonTapped(from: AlertId(rawValue: sender.tag) ?? .error)
    }
    
    @objc private func rightButtonTouchUpInside(_ sender: UIButton) {
        self.delegate?.rightButtonTapped(from: AlertId(rawValue: sender.tag) ?? .error)
    }
}

extension AlertDelegate {
    func leftButtonTapped(from alertId: AlertId) {}
}
