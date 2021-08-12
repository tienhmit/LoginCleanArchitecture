//
//  ViewController.swift
//  LoginCleanArchitecture
//
//  Created by Hoang Manh Tien on 8/9/21.
//

import UIKit
import Firebase

class LoginController: UIViewController {

    // MARK: -- IBOutLet
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    // MARK: -- IBAction
    @IBAction func loginAction(_ sender: Any) {
        
        if isValidInput(userNameTextField, isValidPasswodDigit: true) && isValidInput(passwordTextField, isValidPasswodDigit: true) {
            presenter?.checkAcount(withUsername: userNameTextField.text ?? "",
                                   password: passwordTextField.text  ?? "",
                                   alertForView: self)
        }
//        presenter?.register(withEmail: loginViewModel?.email ?? "", password: loginViewModel?.password ?? "")
    }
    
    @IBAction func registerAction(_ sender: Any) {
        
    }
    
    // MARK: -- Properties
    private var presenter: LoginPresenter?
    private var loginViewModel: LoginViewModel?
    
    // MARK: -- Lifecycle
    
    override func loadView() {
        super.loadView()
        loginViewModel = LoginViewModel()
        let useCase = LoginUserCase(loginRepository: LoginRepository(loginDataStore: LoginDataStore(loginEntity: LoginEntity())))
        presenter = LoginPresenter(loginUserCase: useCase)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configureNotificationObservers()
    }
    
    func inject(presenter: LoginPresenter, loginViewModel: LoginViewModel) {
        self.presenter = presenter
        self.loginViewModel = loginViewModel
    }
    
    // MARK: -- Action
    
    func configUI() {
        // label
        userNameTextField.backgroundColor = UIColor(white: 1, alpha: 0.1)
        userNameTextField.textColor = .white
        userNameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.7)])
        passwordTextField.backgroundColor = UIColor(white: 1, alpha: 0.1)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.7)])
        passwordTextField.isSecureTextEntry = true
        
        
        // background
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemPurple.cgColor, UIColor.systemBlue.cgColor]
        gradient.locations = [0, 1]
        gradient.zPosition = -1
        view.layer.addSublayer(gradient)
        gradient.frame = view.frame
        
        // button
        registerButton.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        registerButton.layer.cornerRadius = 5
        loginButton.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
        loginButton.layer.cornerRadius = 5
        loginButton.isEnabled = false
        
        // Navigation
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    func configureNotificationObservers() {
        userNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    @objc
    func textDidChange(sender: UITextField) {
        let check = isValidInput(sender, isValidPasswodDigit: false) &&
            (userNameTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == false)
        loginButton.isEnabled = check
        loginButton.backgroundColor = check ? #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
        loginButton.setTitleColor(check ? .white : UIColor(white: 1, alpha: 0.7), for: .normal)
    }

    // ***
    func isValidInput(_ textField: UITextField, isValidPasswodDigit valid: Bool) -> Bool {
        var check = true
        if let string = textField.text {
            if textField == userNameTextField {
                let cs = NSCharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789").inverted
                
                let usernameFilter = string.components(separatedBy: cs).joined(separator: "")
                if string != usernameFilter {
                    presenter?.showAlert(withMessage: "Username: 2-64 characters, no specific character", alertForView: self)
                    check = false
                } else {
                    if (string.count < 2 || string.count > 64 ) && valid {
                        check = false
                        presenter?.showAlert(withMessage: "Username: 2-64 characters, no specific character", alertForView: self)
                    }
                    
                }
            } else {
                let cs = NSCharacterSet(charactersIn: "0123456789").inverted
                
                let passwordFilter = string.components(separatedBy: cs).joined(separator: "")
                if string.first == "0" || string != passwordFilter{
                    presenter?.showAlert(withMessage: "Password: 6 digits, no space and first not zero", alertForView: self)
                    check = false
                } else {
                    if string.count != 6 && valid {
                        check = false
                        presenter?.showAlert(withMessage: "Password: 6 digits, no space and first not zero", alertForView: self)
                    }
                }
            }
        } else {
            check = false
        }
        return check
    }
}

