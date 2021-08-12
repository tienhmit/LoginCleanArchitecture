//
//  LoginPresenter.swift
//  LoginCleanArchitecture
//
//  Created by Hoang Manh Tien on 8/10/21.
//

import UIKit

protocol LoginPresenterInterface {
    func checkAcount(withUsername username: String, password: String, alertForView loginView: LoginController?)
}

class LoginPresenter: LoginPresenterInterface {
    
    private let loginUsercase: LoginUserCaseInterface

    required init(loginUserCase: LoginUserCase) {
        self.loginUsercase = loginUserCase
        
    }
    
    //MARK: -- public Func
    
    func checkAcount(withUsername username: String, password: String, alertForView loginView: LoginController?) {
        let message = loginUsercase.checkAcount(withUsername: username, password: password)
        showAlert(withMessage: message, alertForView: loginView)
        
//        loginUsercase.loginUserIn(withEmail: email, password: password, completion: { result, error in
//            if let error = error {
//                self.showAlert(withMessage: error.localizedDescription)
//                return
//            }
//            self.showAlert(withMessage: "Success")
//        })
    }
    
    func showAlert(withMessage message: String, alertForView loginView: LoginController?) {
        let alert = UIAlertController(title: "Warning!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        print("The \"OK\" alert occured.")
        }))
        loginView?.present(alert, animated: true, completion: nil)
    }
}
