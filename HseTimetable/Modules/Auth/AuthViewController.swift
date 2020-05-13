//
//  AuthViewController.swift
//  HseTimetable
//
//  Created by Pavel on 12.05.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

final class AuthViewController: UIViewController, AuthViewProtocol {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    private var leftContainerView: UIView!
    private var rightContainerView: UIView!
    
    var presenter: AuthPresenterProtocol!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        self.navigationController?.isNavigationBarHidden = true
        
        setupSignInButton()
        setupEmailTextField()
        
        self.presenter.outputs.isSuccess.asObserver()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] isSuccess in
                if isSuccess { self?.setState(state: .success) } else { self?.setState(state: .fail) }
            })
            .disposed(by: self.disposeBag)
    }
    
    private func setupSignInButton() {
        self.signInButton.layer.cornerRadius = 12.0
        setStateButton(state: .none)
    }
    
    private func setupEmailTextField() {
        /// Left setup
        self.leftContainerView = UIView()
        self.leftContainerView.frame = CGRect(x: 0, y: 0, width: self.emailTextField.frame.height * 1.5, height: self.emailTextField.frame.height)
        self.emailTextField.leftView = self.leftContainerView
        self.emailTextField.leftViewMode = .always

        let leftImage = UIImageView()
        leftImage.image = UIImage(named: "mail")
        leftImage.contentMode = .scaleAspectFit
        leftImage.tintColor = .lightGray
        leftImage.frame.size.width = self.emailTextField.frame.height * 0.8
        leftImage.frame.size.height = self.emailTextField.frame.height * 0.8
        self.leftContainerView.addSubview(leftImage)
        leftImage.center = CGPoint(x: self.leftContainerView.frame.width / 2, y: self.leftContainerView.frame.height / 2)

        /// Right setup
        self.rightContainerView = UIView()
        self.rightContainerView.frame = CGRect(x: 0, y: 0, width: self.emailTextField.frame.height * 1.5, height: self.emailTextField.frame.height)
        self.emailTextField.rightView = self.rightContainerView
        self.emailTextField.rightViewMode = .always
        setStateTextField(state: .none)
    }
    
    private func setState(state: StateAuth) {
        setStateButton(state: state)
        setStateTextField(state: state)
    }
    
    private func setStateButton(state: StateAuth) {
        switch state {
        case .none, .loading, .fail:
            self.signInButton.isEnabled = false
            self.signInButton.alpha = 0.25

        case .success:
            self.signInButton.isEnabled = true
            self.signInButton.alpha = 1.0
        }
    }
    
    private func setStateTextField(state: StateAuth) {
        var view: UIView
        switch state {
        case .none:
            let emptyView = UIView()
            view = emptyView

        case .loading:
            let indicatorView = UIActivityIndicatorView(style: .gray)
            indicatorView.startAnimating()
            view = indicatorView

        case .success:
            let imageView = UIImageView()
            imageView.image = UIImage(named: "checkmark")
            imageView.tintColor = .black
            view = imageView

        case .fail:
            let imageView = UIImageView()
            imageView.image = UIImage(named: "xmark")
            imageView.tintColor = .black
            view = imageView
        }
        view.frame.size.width = self.emailTextField.frame.height * 0.8
        view.frame.size.height = self.emailTextField.frame.height * 0.8
        self.rightContainerView.subviews.forEach { $0.removeFromSuperview() }
        self.rightContainerView.addSubview(view)
        view.center = CGPoint(x: self.rightContainerView.frame.width / 2, y: self.rightContainerView.frame.height / 2)
    }
    
    // MARK:- Views events
    @IBAction func signInButtonTouchUpInside(_ sender: UIButton) {
        setStateButton(state: .none)
        self.presenter.inputs.signInTrigger.onNext(())
    }
    
    @IBAction func emailTextFieldEditingChanged(_ sender: UITextField) {
        setState(state: .loading)
        self.presenter.inputs.emailChangedTrigger.onNext(sender.text)
    }
}

enum StateAuth {
    case none
    case loading
    case success
    case fail
}

// MARK: - Viewable
extension AuthViewController: Viewable {}
