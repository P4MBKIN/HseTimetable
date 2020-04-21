//
//  LessonsTableViewCell.swift
//  HseTimetable
//
//  Created by Pavel on 19.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import UIKit
import SnapKit

class LessonsTableViewCell: UITableViewCell {
    
    static let reuseId: String = "LessonsTableViewCell"
    static let cellHeight: CGFloat = 175.0
    
    // MARK:- UI Elements
    /// Container view for all other UI elements
    private let mainContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightBlue
        view.clipsToBounds = true
        view.layer.cornerRadius = Size.common.cornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return view
    }()
    
    /// Container view for date UI elements
    private let dateContainerView: UIView = {
        let view  = UIView()
        view.backgroundColor = .lightGray
        view.clipsToBounds = true
        view.layer.cornerRadius = Size.common.cornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    /// Container view for lesson UI elements
    private let lessonContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = Size.common.cornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return view
    }()
    
    /// Container view for time UI elements
    private let timeContainerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: Size.small.font, weight: .bold)
        return label
    }()
    
    private let timeStartLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: Size.large.font, weight: .regular)
        return label
    }()
    
    private let timeEndLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: Size.large.font, weight: .regular)
        return label
    }()
    
    private let typeLessonLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = .sortBlue
        label.font = UIFont.systemFont(ofSize: Size.common.font, weight: .bold)
        return label
    }()
    
    private let auditoriumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pin")
        imageView.tintColor = .sortBlue
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let auditoriumLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: Size.common.font, weight: .regular)
        return label
    }()
    
    private let disciplineLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 3
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: Size.common.font, weight: .bold)
        return label
    }()
    
    private let adressImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mappin.and.ellipse")
        imageView.tintColor = .sortBlue
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let adressLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: Size.small.font, weight: .regular)
        return label
    }()
    
    private let lecturerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: Size.small.font, weight: .regular)
        return label
    }()
    
    private let lecturerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "person")
        imageView.tintColor = .sortBlue
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK:- Interface
    func set() {
        self.contentView.clipsToBounds = true
        self.dateLabel.text = "понедельник, 20 апреля 2020".uppercased()
        self.timeStartLabel.text = "09:30"
        self.timeEndLabel.text = "10:50"
        self.typeLessonLabel.text = "Лекция"
        self.auditoriumLabel.text = "R405"
        self.disciplineLabel.text = "Основы информационных процессов, систем и сетей (рус)"
        self.adressLabel.text = "Шаболовка ул., д. 26-28"
        self.lecturerLabel.text = "проф. Климов Борис Анатольевич"
    }
    
    // MARK:- Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// set containers constraints
        setMainContainerViewConstraints()
        setDateContainerViewConstraints()
        setTimeContainerViewConstraints()
        setLessonContainerViewConstraints()
        
        /// set label and images constraints
        setDateLabelConstraints()
        setTimeStartLabelConstraints()
        setTimeEndLabelConstraints()
        setTypeLessonLabelConstraints()
        setAuditoriumImageViewConstraints()
        setAuditoriumLabelConstraints()
        setDisciplineLabelConstraints()
        setAdressImageViewConstraints()
        setAdressLabelConstraints()
        setLecturerImageViewConstraints()
        setLecturerLabelConstraints()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        /// set containers constraints
        setMainContainerViewConstraints()
        setDateContainerViewConstraints()
        setTimeContainerViewConstraints()
        setLessonContainerViewConstraints()
        
        /// set label and images constraints
        setDateLabelConstraints()
        setTimeStartLabelConstraints()
        setTimeEndLabelConstraints()
        setTypeLessonLabelConstraints()
        setAuditoriumImageViewConstraints()
        setAuditoriumLabelConstraints()
        setDisciplineLabelConstraints()
        setAdressImageViewConstraints()
        setAdressLabelConstraints()
        setLecturerImageViewConstraints()
        setLecturerLabelConstraints()
    }
    
    // MARK:- Constraints containers
    private func setMainContainerViewConstraints() {
        if self.mainContainerView.superview == nil {
            self.contentView.addSubview(self.mainContainerView)
        }
        self.mainContainerView.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.edges.equalToSuperview().inset(
                UIEdgeInsets(top: Size.double.indent, left: Size.large.indent, bottom: Size.common.indent, right: Size.large.indent)
            )
        }
    }
    
    private func setDateContainerViewConstraints() {
        if self.dateContainerView.superview == nil {
            self.mainContainerView.addSubview(self.dateContainerView)
        }
        self.dateContainerView.snp.remakeConstraints{ make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(20)
        }
    }
    
    private func setTimeContainerViewConstraints() {
        if self.timeContainerView.superview == nil {
            self.mainContainerView.addSubview(self.timeContainerView)
        }
        self.timeContainerView.snp.remakeConstraints{ make in
            make.top.equalTo(self.dateContainerView.snp.bottom).offset(Size.common.indent)
            make.bottom.equalToSuperview().inset(Size.common.indent)
            make.left.equalToSuperview().inset(Size.common.indent)
            make.width.equalTo(80)
        }
    }
    
    private func setLessonContainerViewConstraints() {
        if self.lessonContainerView.superview == nil {
            self.mainContainerView.addSubview(self.lessonContainerView)
        }
        self.lessonContainerView.snp.remakeConstraints{ make in
            make.top.equalTo(self.dateContainerView.snp.bottom).offset(Size.common.indent)
            make.bottom.equalToSuperview().inset(Size.common.indent)
            make.right.equalToSuperview().inset(Size.common.indent)
            make.left.equalTo(self.timeContainerView.snp.right).offset(Size.common.indent)
        }
    }
    
    // MARK:- Constraints labels and images
    private func setDateLabelConstraints() {
        if self.dateLabel.superview == nil {
            self.dateContainerView.addSubview(self.dateLabel)
        }
        self.dateLabel.snp.remakeConstraints{ make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(Size.double.indent)
            make.right.equalToSuperview()
        }
    }
    
    private func setTimeStartLabelConstraints() {
        if self.timeStartLabel.superview == nil {
            self.timeContainerView.addSubview(self.timeStartLabel)
        }
        self.timeStartLabel.snp.remakeConstraints{ make in
            make.top.equalToSuperview().inset(Size.common.indent)
            make.left.equalToSuperview().inset(Size.common.indent)
            make.right.equalToSuperview().inset(Size.common.indent)
        }
    }
    
    private func setTimeEndLabelConstraints() {
        if self.timeEndLabel.superview == nil {
            self.timeContainerView.addSubview(self.timeEndLabel)
        }
        self.timeEndLabel.snp.remakeConstraints{ make in
            make.left.equalToSuperview().inset(Size.common.indent)
            make.right.equalToSuperview().inset(Size.common.indent)
            make.bottom.equalToSuperview().inset(Size.common.indent)
        }
    }
    
    private func setTypeLessonLabelConstraints() {
        if self.typeLessonLabel.superview == nil {
            self.lessonContainerView.addSubview(self.typeLessonLabel)
        }
        self.typeLessonLabel.snp.remakeConstraints{ make in
            make.top.equalToSuperview().inset(Size.common.indent)
            make.left.equalToSuperview().inset(Size.double.indent)
        }
    }
    
    private func setAuditoriumImageViewConstraints() {
        if self.auditoriumImageView.superview == nil {
            self.lessonContainerView.addSubview(self.auditoriumImageView)
        }
        self.auditoriumImageView.snp.remakeConstraints{ make in
            make.top.equalToSuperview().inset(Size.common.indent)
            make.left.equalTo(self.typeLessonLabel.snp.right).offset(Size.common.indent)
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
    }
    
    private func setAuditoriumLabelConstraints() {
        if self.auditoriumLabel.superview == nil {
            self.lessonContainerView.addSubview(self.auditoriumLabel)
        }
        self.auditoriumLabel.snp.remakeConstraints{ make in
            make.centerY.equalTo(self.auditoriumImageView)
            make.left.equalTo(self.auditoriumImageView.snp.right).offset(Size.common.indent)
            make.right.equalToSuperview().inset(Size.double.indent)
        }
    }
    
    private func setDisciplineLabelConstraints() {
        if self.disciplineLabel.superview == nil {
            self.lessonContainerView.addSubview(self.disciplineLabel)
        }
        self.disciplineLabel.snp.remakeConstraints{ make in
            make.top.equalTo(self.typeLessonLabel.snp.bottom).offset(Size.common.indent)
            make.left.equalTo(self.typeLessonLabel.snp.left)
            make.right.equalToSuperview().inset(Size.double.indent)
        }
    }
    
    private func setAdressImageViewConstraints() {
        if self.adressImageView.superview == nil {
            self.lessonContainerView.addSubview(self.adressImageView)
        }
        self.adressImageView.snp.remakeConstraints{ make in
            make.left.equalTo(self.typeLessonLabel.snp.left)
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
    }
    
    private func setAdressLabelConstraints() {
        if self.adressLabel.superview == nil {
            self.lessonContainerView.addSubview(self.adressLabel)
        }
        self.adressLabel.snp.remakeConstraints{ make in
            make.centerY.equalTo(self.adressImageView)
            make.left.equalTo(self.adressImageView.snp.right).offset(Size.common.indent)
            make.right.equalToSuperview().inset(Size.double.indent)
        }
    }
    
    private func setLecturerImageViewConstraints() {
        if self.lecturerImageView.superview == nil {
            self.lessonContainerView.addSubview(self.lecturerImageView)
        }
        self.lecturerImageView.snp.remakeConstraints{ make in
            make.left.equalTo(self.typeLessonLabel.snp.left)
            make.top.equalTo(self.adressImageView.snp.bottom).offset(Size.common.indent)
            make.bottom.equalToSuperview().inset(Size.common.indent)
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
    }
    
    private func setLecturerLabelConstraints() {
        if self.lecturerLabel.superview == nil {
            self.lessonContainerView.addSubview(self.lecturerLabel)
        }
        self.lecturerLabel.snp.remakeConstraints{ make in
            make.centerY.equalTo(self.lecturerImageView)
            make.left.equalTo(self.lecturerImageView.snp.right).offset(Size.common.indent)
            make.right.equalToSuperview().inset(Size.double.indent)
        }
    }
}
