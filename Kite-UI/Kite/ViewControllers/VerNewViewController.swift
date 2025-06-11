//
//  VerNewViewController.swift
//  Kite
//
//  Created by Adam on 7/30/22.
//

import UIKit

class VerNewViewController: UIViewController{
    fileprivate let backButton = UIButton()
    
    fileprivate let verLabel = UILabel()
    
    fileprivate let verTag = UILabel()
    var emailVerInput = UITextField()
    
    fileprivate let firstInput = UITextField()
    fileprivate let firstLine = UIView()
    fileprivate var firstLineRight: NSLayoutConstraint?
    fileprivate let firstError = UILabel()
    
    fileprivate let lastInput = UITextField()
    fileprivate let lastLine = UIView()
    fileprivate var lastLineRight: NSLayoutConstraint?
    fileprivate let lastError = UILabel()
    
    fileprivate let emailInput = UITextField()
    fileprivate let emailLine = UIView()
    fileprivate var emailLineRight: NSLayoutConstraint?
    fileprivate let emailError = UILabel()
    
    var verVC: VerificationViewController?
    
    var loginStatus: Bool = false
    
    fileprivate let loginButton = LoadingButton()
    
    private var loginManager = LoginManager.shared
    
    var currUser: CreateUserVO?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        print("In vernew currUser: \(currUser?.username)")
        loginManager.delegate = self
        firstInput.delegate = self
        lastInput.delegate = self
        emailInput.delegate = self
        setupComponents()
//        setupCode()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        loginManager.delegate = nil
    }
    
    deinit {
        loginManager.delegate = nil
    }
    
    func setupComponents() {
        verLabel.translatesAutoresizingMaskIntoConstraints = false
        verTag.translatesAutoresizingMaskIntoConstraints = false
        emailVerInput.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        firstInput.translatesAutoresizingMaskIntoConstraints = false
        firstLine.translatesAutoresizingMaskIntoConstraints = false
        lastInput.translatesAutoresizingMaskIntoConstraints = false
        lastLine.translatesAutoresizingMaskIntoConstraints = false
        emailInput.translatesAutoresizingMaskIntoConstraints = false
        emailLine.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        firstError.translatesAutoresizingMaskIntoConstraints = false
        lastError.translatesAutoresizingMaskIntoConstraints = false
        emailError.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(verLabel)
        view.addSubview(verTag)
        view.addSubview(firstInput)
        view.addSubview(firstLine)
        view.addSubview(lastInput)
        view.addSubview(lastLine)
        view.addSubview(emailInput)
        view.addSubview(emailLine)
        view.addSubview(emailVerInput)
        view.addSubview(backButton)
        view.addSubview(loginButton)
        view.addSubview(firstError)
        view.addSubview(lastError)
        view.addSubview(emailError)
        
        backButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        backButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        backButton.backgroundColor = UIColor.cyan
        backButton.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
        
        verLabel.textColor = UIColor.black
        verLabel.text = "Finish up"
        verLabel.font = UIFont(name: "Arial-BoldMT", size: 40)
        verLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120).isActive = true
        verLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        
        setupInputs()

        
        
        
        
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 25).isActive = true
        loginButton.topAnchor.constraint(equalTo: emailLine.bottomAnchor, constant: 50).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        loginButton.backgroundColor = UIColor(red: 0/255, green: 86/255, blue: 253/255, alpha: 1.0)
        loginButton.layer.cornerRadius = 25;
        loginButton.setTitle("verify", for: .normal)
        
        loginButton.layer.shadowRadius = 3
        loginButton.layer.shadowColor = UIColor(red: 0/255, green: 86/255, blue: 253/255, alpha: 1.0).cgColor
        loginButton.layer.shadowOpacity = 0.5
        loginButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        loginButton.layer.masksToBounds = false
        
        loginButton.addTarget(self, action: #selector(self.verify), for: .touchUpInside)
        
    }
    
    @objc func verify() {
        print("LoginButton pressed")
        var flag = false
        if firstInput == nil || firstInput.text!.count == 0 {
            flag = true
            firstError.text = "cannot be empty"
        }
        if lastInput == nil || lastInput.text!.count == 0 {
            flag = true
            lastError.text = "cannot be empty"
        }
        if emailInput == nil || emailInput.text!.count == 0 {
            flag = true
            emailError.text = "cannot be empty"
        }
        if !flag {
            DispatchQueue.main.async {
                self.loginButton.showLoading()
            }
            currUser?.firstName = firstInput.text!
            currUser?.lastName = lastInput.text!
            currUser?.email = emailInput.text!
            loginManager.createUser(user: currUser!)
        }
        
        
    }
    
    func setupInputs() {
        firstInput.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        firstInput.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        firstInput.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -10).isActive = true
        firstInput.heightAnchor.constraint(equalToConstant: 60).isActive = true
        firstInput.borderStyle = .none
//        usernameInput.textColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)
//        usernameInput.backgroundColor = UIColor.blue
        firstInput.font = UIFont(name: "Arial", size: 25)
        firstInput.autocorrectionType = .no
        firstInput.attributedPlaceholder = NSAttributedString(string: "first name", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)])
        firstInput.textColor = UIColor.black
        firstInput.autocapitalizationType = .none
        firstInput.tag = 1
        
        firstLineRight = firstLine.rightAnchor.constraint(equalTo: firstInput.rightAnchor)
        firstLineRight?.isActive = true
        firstLine.leftAnchor.constraint(equalTo: firstInput.leftAnchor).isActive = true
        firstLine.topAnchor.constraint(equalTo: firstInput.bottomAnchor).isActive = true
        firstLine.heightAnchor.constraint(equalToConstant: 4).isActive = true
        firstLine.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)
        
        firstError.leftAnchor.constraint(equalTo: firstInput.leftAnchor).isActive = true
        firstError.topAnchor.constraint(equalTo: firstLine.bottomAnchor, constant: 5).isActive = true
        firstError.font = UIFont(name: "Arial", size: 15)
        firstError.textColor = UIColor.red
        firstError.text = ""
        
        
        lastInput.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 10).isActive = true
        lastInput.bottomAnchor.constraint(equalTo: firstInput.bottomAnchor).isActive = true
        lastInput.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        lastInput.heightAnchor.constraint(equalToConstant: 60).isActive = true
        lastInput.borderStyle = .none
//        usernameInput.textColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)
//        usernameInput.backgroundColor = UIColor.blue
        lastInput.font = UIFont(name: "Arial", size: 25)
        lastInput.autocorrectionType = .no
        lastInput.attributedPlaceholder = NSAttributedString(string: "last name", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)])
        lastInput.textColor = UIColor.black
        lastInput.autocapitalizationType = .none
        lastInput.tag = 2
        
        lastLineRight = lastLine.rightAnchor.constraint(equalTo: lastInput.rightAnchor)
        lastLineRight?.isActive = true
        lastLine.leftAnchor.constraint(equalTo: lastInput.leftAnchor).isActive = true
        lastLine.topAnchor.constraint(equalTo: lastInput.bottomAnchor).isActive = true
        lastLine.heightAnchor.constraint(equalToConstant: 4).isActive = true
        lastLine.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)
        
        lastError.leftAnchor.constraint(equalTo: lastInput.leftAnchor).isActive = true
        lastError.topAnchor.constraint(equalTo: lastLine.bottomAnchor, constant: 5).isActive = true
        lastError.font = UIFont(name: "Arial", size: 15)
        lastError.textColor = UIColor.red
        lastError.text = ""
        
        
        emailInput.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        emailInput.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 25).isActive = true
        emailInput.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        emailInput.heightAnchor.constraint(equalToConstant: 60).isActive = true
        emailInput.borderStyle = .none
//        usernameInput.textColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)
//        usernameInput.backgroundColor = UIColor.blue
        emailInput.font = UIFont(name: "Arial", size: 25)
        emailInput.autocorrectionType = .no
        emailInput.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)])
        emailInput.textColor = UIColor.black
        emailInput.autocapitalizationType = .none
        emailInput.tag = 3
        
        emailLineRight = emailLine.rightAnchor.constraint(equalTo: emailInput.rightAnchor)
        emailLineRight?.isActive = true
        emailLine.leftAnchor.constraint(equalTo: emailInput.leftAnchor).isActive = true
        emailLine.topAnchor.constraint(equalTo: emailInput.bottomAnchor).isActive = true
        emailLine.heightAnchor.constraint(equalToConstant: 4).isActive = true
        emailLine.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)
        
        emailError.leftAnchor.constraint(equalTo: emailInput.leftAnchor).isActive = true
        emailError.topAnchor.constraint(equalTo: emailLine.bottomAnchor, constant: 5).isActive = true
        emailError.font = UIFont(name: "Arial", size: 15)
        emailError.textColor = UIColor.red
        emailError.text = ""
        
        
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 25).isActive = true
        loginButton.topAnchor.constraint(equalTo: emailLine.bottomAnchor, constant: 50).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        loginButton.backgroundColor = UIColor(red: 0/255, green: 86/255, blue: 253/255, alpha: 1.0)
        loginButton.layer.cornerRadius = 25;
        loginButton.setTitle("verify", for: .normal)
        
        loginButton.layer.shadowRadius = 3
        loginButton.layer.shadowColor = UIColor(red: 0/255, green: 86/255, blue: 253/255, alpha: 1.0).cgColor
        loginButton.layer.shadowOpacity = 0.5
        loginButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        loginButton.layer.masksToBounds = false
        
        loginButton.addTarget(self, action: #selector(self.verify), for: .touchUpInside)
    }
    
    
    
    @objc func goBack() {
        print("VerificationViewController goBack")
//        self.navigationController?.popViewController(animated: true)
        let newRoot = HomeViewController()
//        self.navigationController?.pushViewController(newRoot, animated: false)
        self.navigationController?.setViewControllers([newRoot], animated: true)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
}

extension VerNewViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("some input didbeginediting")
        if textField.tag == 1 {
            if textField.text == "" {
                print("firstname input didbeginediting")
                firstLineRight?.isActive = false
                firstLineRight = firstLine.rightAnchor.constraint(equalTo: firstInput.leftAnchor)
                firstLineRight?.isActive = true
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                } completion: { _ in
                    self.firstLineRight?.isActive = false
                    self.firstLineRight = self.firstLine.rightAnchor.constraint(equalTo: self.firstInput.rightAnchor)
                    self.firstLineRight?.isActive = true
                    self.firstLine.backgroundColor = UIColor(red: 0/255, green: 86/255, blue: 253/255, alpha: 1.0)
                    UIView.animate(withDuration: 0.3) {
                        self.view.layoutIfNeeded()
                    }
                }
            }
        } else if textField.tag == 2 {
            if textField.text == "" {
                print("lastname input didbeginediting")
                lastLineRight?.isActive = false
                lastLineRight = lastLine.rightAnchor.constraint(equalTo: lastInput.leftAnchor)
                lastLineRight?.isActive = true
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                } completion: { _ in
                    self.lastLineRight?.isActive = false
                    self.lastLineRight = self.lastLine.rightAnchor.constraint(equalTo: self.lastInput.rightAnchor)
                    self.lastLineRight?.isActive = true
                    self.lastLine.backgroundColor = UIColor(red: 0/255, green: 86/255, blue: 253/255, alpha: 1.0)
                    UIView.animate(withDuration: 0.3) {
                        self.view.layoutIfNeeded()
                    }
                }
            }
        } else if textField.tag == 3 {
            if textField.text == "" {
                print("email input didbeginediting")
                emailLineRight?.isActive = false
                emailLineRight = emailLine.rightAnchor.constraint(equalTo: emailInput.leftAnchor)
                emailLineRight?.isActive = true
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                } completion: { _ in
                    self.emailLineRight?.isActive = false
                    self.emailLineRight = self.emailLine.rightAnchor.constraint(equalTo: self.emailInput.rightAnchor)
                    self.emailLineRight?.isActive = true
                    self.emailLine.backgroundColor = UIColor(red: 0/255, green: 86/255, blue: 253/255, alpha: 1.0)
                    UIView.animate(withDuration: 0.3) {
                        self.view.layoutIfNeeded()
                    }
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}

extension VerNewViewController: LoginDelegate {
    func didUsernameExist(status: Bool) {
        
    }
    
    func didEmailExist(status: Bool) {
        print("email esitst")
        emailError.text = "email already exists"
        DispatchQueue.main.async {
            self.loginButton.hideLoading()
        }
    }
    
    func didVer(code: Int) {
        DispatchQueue.main.async {
            if code == 0 {
                self.verVC?.dismiss(animated: true)
                let vc = HomeViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                self.verVC?.dismiss(animated: true)
                self.emailError.text = "verification code invalid"
            }
        }
        
        
    }
    
    func didLogin(email: String) {
        
    }
    
    func didCreateUser(code: Int) {
        DispatchQueue.main.async {
            self.loginButton.hideLoading()
            
            
            if code == 0 {
                self.verVC = VerificationViewController()
                self.verVC!.modalTransitionStyle = .coverVertical
                self.verVC!.modalPresentationStyle = .popover
                self.verVC?.emailVerInput.text = self.emailInput.text!
                self.present(self.verVC!, animated: true)
            } else if code == 1 { //username exists
                self.navigationController?.popViewController(animated: true)
            } else if code == 2 { // email exists
                self.emailError.text = "email already exists"
            }
        }
        
        
    }
    
    func didErrorHappen(msg: String) {
        print("didErrorHappen in VerNew")
        DispatchQueue.main.async {
            self.loginButton.hideLoading()
            self.navigationController?.popViewController(animated: true)
            
        }
    }
}
