//
//  LoginViewController.swift
//  EventContact
//
//  Created by Princess Sampson on 9/30/16.
//  Copyright © 2016 Princess Sampson. All rights reserved.
//

import UIKit

class LoginViewController: ViewController {
    
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    fileprivate let store = UserStore()
    
}

extension LoginViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loginButton.isEnabled = false
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == passwordTextField {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        let emailFieldIsNotEmpty = !(emailTextfield.text?.isEmpty)!
        let passwordFieldIsNotEmpty = !(passwordTextField.text?.isEmpty)!
        
        if emailFieldIsNotEmpty && passwordFieldIsNotEmpty {
            loginButton.isEnabled = true
        }
        
        return true
    }
    
}

extension LoginViewController {
    @IBAction func attemptLogin(_ sender: AnyObject) {
        
        let email = emailTextfield.text!
        let password = passwordTextField.text!
        
        let loginRequest = LoginRequest(email: email, password: password)
        
        store.loginUser(requestBody: loginRequest) { (result) in
            switch result {
            case let .Success(user):
                let tabController = EventContactTabBarController()
                tabController.user = user
                self.show(tabController, sender: nil)
            case let .Failure(_, message):
                print("\n\n\n\nERROR MESSAGE: \n\(message)")
                self.alertUser(title: "Couldn't login", message: message, action: "Try again")
                print(message)
            }
        }
        
    }
    
}

extension LoginViewController {
    func alertUser(title: String, message: String, action: String) {
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: action, style: .default, handler: nil)
        ac.addAction(alertAction)
        
        present(ac, animated: true) {
            self.clearFieldsAndDisableLoginButton()
        }
    }
    
    fileprivate func clearFieldsAndDisableLoginButton() {
        
        emailTextfield.text = ""
        passwordTextField.text = ""
        loginButton.isEnabled = false
        
    }
}
