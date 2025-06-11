//
//  VerificationViewController.swift
//  Kite
//
//  Created by Adam on 6/28/22.
//

import UIKit

class EmailVerViewController: UIViewController, UITextFieldDelegate {
    
    fileprivate let backButton = UIImageView(image: UIImage(named: "backButton"))
    
    fileprivate let verLabel = UILabel()

    fileprivate let emailInput = UITextField()
    fileprivate let emailError = UILabel()
    fileprivate let emailLine = UIView()
    
    fileprivate let loginButton = LoadingButton()
    
    var emailPass = false
    
    var createUsername:String?
    var createPassword:String?
    var createFirst:String?
    var createLast:String?
    var createBirth:String?
    
    private var loginManager = LoginManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        loginManager.delegate = self
        emailInput.delegate = self
        setupComponents()
        
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
        emailInput.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        emailError.translatesAutoresizingMaskIntoConstraints = false
        emailLine.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(verLabel)
        view.addSubview(emailInput)
        view.addSubview(emailError)
        view.addSubview(emailLine)
        view.addSubview(backButton)
        view.addSubview(loginButton)
        
        backButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        backButton.contentMode = .scaleAspectFit
        backButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        backButton.isUserInteractionEnabled = true
        backButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goBack)))
        
        verLabel.textColor = UIColor.black
        verLabel.text = "Enter your email\nwith Kite"
        verLabel.numberOfLines = 2
        verLabel.font = UIFont(name: "HelveticaNeue", size: 40)
        verLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 35).isActive = true
        verLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        verLabel.textAlignment = .center
        
        emailInput.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        emailInput.topAnchor.constraint(equalTo: verLabel.bottomAnchor, constant: 60).isActive = true
        emailInput.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        emailInput.heightAnchor.constraint(equalToConstant: 25).isActive = true
        emailInput.borderStyle = .none
        emailInput.font = UIFont(name: "HelveticaNeue", size: 22)
        emailInput.tag = 1
        emailInput.autocorrectionType = .no
        emailInput.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: Constants.PlaceholderColor])
        emailInput.textColor = UIColor.black
        
        emailLine.rightAnchor.constraint(equalTo: emailInput.rightAnchor).isActive = true
        emailLine.leftAnchor.constraint(equalTo: emailInput.leftAnchor).isActive = true
        emailLine.topAnchor.constraint(equalTo: emailInput.bottomAnchor, constant: 3).isActive = true
        emailLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        emailLine.backgroundColor = UIColor.black

        emailError.leftAnchor.constraint(equalTo: emailLine.leftAnchor).isActive = true
        emailError.topAnchor.constraint(equalTo: emailLine.bottomAnchor, constant: 1).isActive = true
        emailError.font = UIFont(name: "HelveticaNeue", size: 15)
        emailError.textColor = UIColor.red
        emailError.text = ""
        
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: emailError.bottomAnchor, constant: 65).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 125).isActive = true

        loginButton.backgroundColor = Constants.BaseColor
        loginButton.layer.cornerRadius = 10;
        loginButton.setTitle("Continue", for: .normal)

        loginButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 24)

        loginButton.addTarget(self, action: #selector(self.login), for: .touchUpInside)
        
    }
    
    
    @objc func goBack() {
        print("VerificationViewController goBack")
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            print("textfield \(textField.text)")
            
            if emailInput.text == "" {
                emailError.text = "Invalid Email"
                emailError.textColor = UIColor.red
                emailPass = false
                return
            }
            
            let regex = try? NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
            if regex == nil {
                print("Email Regex is bad")
                return
            }
            if regex!.matches(in: emailInput.text!, range: NSRange(location: 0, length: emailInput.text!.utf16.count)).count == 0 {
                print("Email field invalid")
                emailError.text = "Invalid Email"
                emailError.textColor = UIColor.red
                emailPass = false
                return
            }
            emailError.text = ""
            emailError.textColor = UIColor.red
            emailPass = true
            
            DispatchQueue.main.async {
                self.loginManager.checkEmail(email: self.emailInput.text!)
            }
            
        }
    }
    
    
    @objc func login() {
        print("Submittinh signu pstuff")
        emailInput.endEditing(true)
        if emailPass {
            DispatchQueue.main.async {
                self.loginButton.showLoading()
            }
            let newUser = CreateUserVO(firstName: createFirst!, lastName: createLast!, username: createUsername!, password: createPassword!, email: emailInput.text!, birth: createBirth!)
            loginManager.createUser(user: newUser)
        }
        
        
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

extension EmailVerViewController: LoginDelegate {
    func didUsernameExist(status: Bool) {
        print("EmailVerViewController: didUsernameExists")
    }
    
    func didEmailExist(status: Bool) {
        print("EmailVerViewController: didEmailExists")
        if status { //email exists
            emailPass = false
            emailError.text = "Email already exsists"
        } else {
            emailPass = true
            emailError.text = ""
        }
        
    }
    
    func didVer(code: Int) {
        print("EmailVerViewController: didVer")
    }
    
    func didLogin(email: String) {
        print("EmailVerViewController: didLogin")
    }
    
    func didCreateUser(code: Int) {
        print("EmailVerViewController: didCreateUser")
        
        DispatchQueue.main.async {
            self.loginButton.hideLoading()
        }
        
        if code == 0 {
            print("EmailVerViewController: code = 0")
            DispatchQueue.main.async {
                let ver = VerificationViewController()
                ver.emailVerInput.text = self.emailInput.text!
                ver.loginStatus = false
                ver.signup = true
                self.navigationController?.pushViewController(ver, animated: true)
            }
            
        } else {
            print("EmailVerViewController: code = 1")
        }
        
    }
    
    func didErrorHappen(msg: String) {
        print("EmailVerViewController: didErrorHappen: \(msg)")
        
        DispatchQueue.main.async {
            self.loginButton.hideLoading()
        }
    }
    
    
}


