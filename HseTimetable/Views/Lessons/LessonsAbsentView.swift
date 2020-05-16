//
//  LessonsAbsentView.swift
//  HseTimetable
//
//  Created by Pavel on 24.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import SnapKit
import UIKit

class LessonsAbsentView: UIView {
    
    // MARK:- UI Elements
    /// Container view for all other UI elements
    private let mainContainerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    private let absentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 3
        label.textColor = .black
        label.font = .systemFont(ofSize: Size.large.font, weight: .bold)
        label.text = "У вас нет занятий".uppercased()
        return label
    }()
    
    private let pullLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 3
        label.textColor = .gray
        label.font = .systemFont(ofSize: Size.common.font, weight: .medium)
        label.text = "Потяните чтобы обновить".uppercased()
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "chevron")
        return imageView
    }()
    
        // MARK:- Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// set containers constraints
        setMainViewConstraints()
        
        /// set label and images constraints
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        /// set containers constraints
        setMainViewConstraints()
        
        /// set label and images constraints
        setAbsentLabelConstraints()
        setPullLabelConstraints()
        setChevronImageViewConstraints()
    }
    
    // MARK:- Constraints containers
    private func setMainViewConstraints() {
        if self.mainContainerView.superview == nil {
            self.addSubview(self.mainContainerView)
        }
        self.mainContainerView.snp.remakeConstraints{ make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setAbsentLabelConstraints() {
        if self.absentLabel.superview == nil {
            self.mainContainerView.addSubview(self.absentLabel)
        }
        self.absentLabel.snp.remakeConstraints{ make in
            make.top.equalToSuperview().inset(Size.common.indent)
            make.left.equalToSuperview().inset(Size.common.indent)
            make.right.equalToSuperview().inset(Size.common.indent)
        }
    }
    
    private func setPullLabelConstraints() {
        if self.pullLabel.superview == nil {
            self.mainContainerView.addSubview(self.pullLabel)
        }
        self.pullLabel.snp.remakeConstraints{ make in
            make.top.equalTo(self.absentLabel.snp.bottom).offset(Size.double.indent)
            make.left.equalToSuperview().inset(Size.common.indent)
            make.right.equalToSuperview().inset(Size.common.indent)
        }
    }
    
    private func setChevronImageViewConstraints() {
        if self.chevronImageView.superview == nil {
            self.mainContainerView.addSubview(self.chevronImageView)
        }
        self.chevronImageView.snp.remakeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.pullLabel.snp.bottom).offset(Size.large.indent)
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().inset(Size.common.indent)
        }
    }
}
