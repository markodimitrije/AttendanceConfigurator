//
//  LoginViewController.swift
//  navusLogin
//
//  Created by Marko Dimitrijevic on 14/04/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LoginViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var emailTxtField: UITextField!
    {
        didSet {emailTxtField.text = "nestle@mailinator.com"}
//        didSet {emailTxtField.text = ""}
    }
    @IBOutlet weak var passTxtField: UITextField!
    {
        didSet {passTxtField.text = "timm2019"}
//        didSet {passTxtField.text = ""}
    }
    @IBOutlet weak var logBtn: ActionUIButton!
    @IBOutlet weak var logStackViewYConstraint: NSLayoutConstraint!
    
    // MARK:- dependencies
    var viewModel: LoginViewModel!
    var alertErrPresenter: IAlertErrorPresenter!
    var keyboardListener: IKeyboardListener!
    lazy var loginKeyboardHandler = LoginKeyboardHandler(centerYcnstr: logStackViewYConstraint)
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToAndFromViewModel()
        manageKeyboardEvents()
    }
    
    private func bindToAndFromViewModel() {
        let input = LoginViewModelInputFactory.make(emailField: emailTxtField,
                                                    passField: passTxtField,
                                                    btn: logBtn)
        
        let output = viewModel.transform(input: input)
        
        input.userCredentials.map({_ in return ()})
            .subscribe(onNext: disableUI)
            .disposed(by: bag)
        
        output.loginSignal
            .subscribe(onNext: disableUI,
                       onError: errorCatched,
                       onCompleted: loginCompleted)
            .disposed(by: bag)
    }
    
    private func manageKeyboardEvents() {
        keyboardListener.getKeyboardEvents()
            .subscribe(onNext: { [weak self] (info) in
                self?.loginKeyboardHandler.handleKeyboardEvent(info: info)
                UIView.animate(withDuration: 0.5) {
                    self?.view.layoutIfNeeded()
                }
            }).disposed(by: bag)
    }
    
    private func disableUI() {
        print("disableUI() is called...")
        _ = [emailTxtField, passTxtField, logBtn].map {$0.isEnabled = false}
            logBtn.setLoading(true)
    }
    
    private func enableUI() {
        _ = [emailTxtField, passTxtField, logBtn].map {$0.isEnabled = true}
            logBtn.setLoading(false)
    }
    
    private func errorCatched(error: Error) {
        refreshController()
        alertErrPresenter.present(error: error)
    }
    
    private func loginCompleted() {
        refreshController()
        navigateToNext()
    }
    
    private func refreshController() {
        bindToAndFromViewModel()
        enableUI()
    }
    
    private func navigateToNext() {
        let nextVC = CampaignsViewControllerFactory.make()
//        _ = [emailTxtField, passTxtField].map {$0?.text = ""}
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

}
