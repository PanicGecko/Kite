//
//  VerificationViewController.swift
//  Kite
//
//  Created by Adam on 6/28/22.
//

import UIKit

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {
    
    fileprivate let backButton = UIImageView(image: UIImage(named: "backButton"))
    
    fileprivate let verLabel = UILabel()

    fileprivate let passInput = UITextField()
    fileprivate let passError = UILabel()
    fileprivate let passLine = UIView()
    
    fileprivate let confirmInput = UITextField()
    fileprivate let confirmError = UILabel()
    fileprivate let confirmLine = UIView()
    
    fileprivate let loginButton = LoadingButton()
    
    private var loginManager = LoginManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        loginManager.delegate = self
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
        passInput.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        passError.translatesAutoresizingMaskIntoConstraints = false
        passLine.translatesAutoresizingMaskIntoConstraints = false
        confirmLine.translatesAutoresizingMaskIntoConstraints = false
        confirmError.translatesAutoresizingMaskIntoConstraints = false
        confirmInput.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(verLabel)
        view.addSubview(passInput)
        view.addSubview(passError)
        view.addSubview(passLine)
        view.addSubview(confirmInput)
        view.addSubview(confirmError)
        view.addSubview(confirmLine)
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
        verLabel.text = "Change Password"
        verLabel.font = UIFont(name: "HelveticaNeue", size: 40)
        verLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 35).isActive = true
        verLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        verLabel.textAlignment = .center
        
        passInput.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        passInput.topAnchor.constraint(equalTo: verLabel.bottomAnchor, constant: 60).isActive = true
        passInput.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        passInput.heightAnchor.constraint(equalToConstant: 25).isActive = true
        passInput.borderStyle = .none
        passInput.font = UIFont(name: "HelveticaNeue", size: 22)
        passInput.tag = 1
        passInput.autocorrectionType = .no
        passInput.attributedPlaceholder = NSAttributedString(string: "New Password", attributes: [NSAttributedString.Key.foregroundColor: Constants.PlaceholderColor])
        passInput.textColor = UIColor.black
        
        passLine.rightAnchor.constraint(equalTo: passInput.rightAnchor).isActive = true
        passLine.leftAnchor.constraint(equalTo: passInput.leftAnchor).isActive = true
        passLine.topAnchor.constraint(equalTo: passInput.bottomAnchor, constant: 3).isActive = true
        passLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        passLine.backgroundColor = UIColor.black

        passError.leftAnchor.constraint(equalTo: passLine.leftAnchor).isActive = true
        passError.topAnchor.constraint(equalTo: passLine.bottomAnchor, constant: 1).isActive = true
        passError.font = UIFont(name: "HelveticaNeue", size: 15)
        passError.textColor = UIColor.red
        passError.text = "This email is already registered"
        
        confirmInput.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        confirmInput.topAnchor.constraint(equalTo: passError.bottomAnchor, constant: 60).isActive = true
        confirmInput.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        confirmInput.heightAnchor.constraint(equalToConstant: 25).isActive = true
        confirmInput.borderStyle = .none
        confirmInput.font = UIFont(name: "HelveticaNeue", size: 22)
        confirmInput.tag = 1
        confirmInput.autocorrectionType = .no
        confirmInput.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedString.Key.foregroundColor: Constants.PlaceholderColor])
        confirmInput.textColor = UIColor.black
        
        confirmLine.rightAnchor.constraint(equalTo: confirmInput.rightAnchor).isActive = true
        confirmLine.leftAnchor.constraint(equalTo: confirmInput.leftAnchor).isActive = true
        confirmLine.topAnchor.constraint(equalTo: confirmInput.bottomAnchor, constant: 3).isActive = true
        confirmLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        confirmLine.backgroundColor = UIColor.black

        confirmError.leftAnchor.constraint(equalTo: confirmLine.leftAnchor).isActive = true
        confirmError.topAnchor.constraint(equalTo: confirmLine.bottomAnchor, constant: 1).isActive = true
        confirmError.font = UIFont(name: "HelveticaNeue", size: 15)
        confirmError.textColor = UIColor.red
        confirmError.text = "This email is already registered"
        
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: confirmError.bottomAnchor, constant: 65).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 125).isActive = true

        loginButton.backgroundColor = Constants.BaseColor
        loginButton.layer.cornerRadius = 10;
        loginButton.setTitle("Continue", for: .normal)

        loginButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 24)

//        loginButton.addTarget(self, action: #selector(self.login), for: .touchUpInside)
        
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

extension ChangePasswordViewController: LoginDelegate {
    func didUsernameExist(status: Bool) {
        
    }
    
    func didEmailExist(status: Bool) {
        
    }
    
    func didVer(code: Int) {
        
    }
    
    func didLogin(email: String) {
        
    }
    
    func didCreateUser(code: Int) {
        
    }
    
    func didErrorHappen(msg: String) {
        
    }
    
    
}

