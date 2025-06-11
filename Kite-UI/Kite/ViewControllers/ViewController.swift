//
//  ViewController.swift
//  Kite
//
//  Created by Adam on 6/23/22.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    //Hello this is Kite label image
    fileprivate let welcomeLabel = UIImageView(image: UIImage(named: "signup"))
    fileprivate var welcomeLabelRight: NSLayoutConstraint?
    
    //Welcome back image
    fileprivate let welcomeBackLabel = UIImageView(image: UIImage(named: "signin"))
    fileprivate var welcomeBackLabelLeft: NSLayoutConstraint?
    
    fileprivate let backgroundView = UIView()
    fileprivate var backgroundViewCenter: NSLayoutConstraint?
    
    fileprivate let signup = UILabel()
    fileprivate let signin = UILabel()
    
    fileprivate let accountLabel = UILabel()
    
    fileprivate let usernameInput = UITextField()
    fileprivate let paddingView1 = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 25))
    fileprivate let usernameLine = UIView()
    fileprivate var userLineRight: NSLayoutConstraint?
    fileprivate let usernameError = UILabel()
    
    fileprivate let passwordInput = UITextField()
    fileprivate let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 25))
    fileprivate var passLineRight: NSLayoutConstraint?
    fileprivate let passwordLine = UIView()
    fileprivate let passwordError = UILabel()
    
    fileprivate let forgotLabel = UILabel()
    fileprivate var forgotLabelLeft: NSLayoutConstraint?
    
    fileprivate let loginButton = LoadingButton()
    fileprivate var loginStat = false
    
    fileprivate var usernamePass = false
    fileprivate var passwordPass = false
    
    private var loginManager = LoginManager.shared
    
    override func viewDidLoad() {
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        usernameInput.delegate = self
        passwordInput.delegate = self
        loginManager.delegate = self
        setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        loginManager.delegate = nil
    }
    
    deinit {
        loginManager.delegate = nil
    }
    
    func setupViews() {
        view.backgroundColor = UIColor.white
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameInput.translatesAutoresizingMaskIntoConstraints = false
        passwordInput.translatesAutoresizingMaskIntoConstraints = false
        forgotLabel.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        usernameLine.translatesAutoresizingMaskIntoConstraints = false
        passwordLine.translatesAutoresizingMaskIntoConstraints = false
        welcomeBackLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        signup.translatesAutoresizingMaskIntoConstraints = false
        signin.translatesAutoresizingMaskIntoConstraints = false
        usernameError.translatesAutoresizingMaskIntoConstraints = false
        passwordError.translatesAutoresizingMaskIntoConstraints = false
        accountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomeLabel)
        view.addSubview(usernameInput)
        view.addSubview(passwordInput)
        view.addSubview(forgotLabel)
        view.addSubview(loginButton)
        view.addSubview(usernameLine)
        view.addSubview(passwordLine)
        view.addSubview(welcomeBackLabel)
        view.addSubview(backgroundView)
        view.addSubview(signin)
        view.addSubview(signup)
        view.addSubview(usernameError)
        view.addSubview(passwordError)
        view.addSubview(accountLabel)
        
        welcomeLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        welcomeLabelRight = welcomeLabel.rightAnchor.constraint(equalTo: view.rightAnchor)
        welcomeLabelRight?.isActive = true
        welcomeLabel.contentMode = .scaleAspectFit
        
        welcomeBackLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        welcomeBackLabel.centerYAnchor.constraint(equalTo: welcomeLabel.centerYAnchor).isActive = true
        welcomeBackLabelLeft = welcomeBackLabel.leftAnchor.constraint(equalTo: view.rightAnchor)
        welcomeBackLabelLeft?.isActive = true
        welcomeBackLabel.contentMode = .scaleAspectFit
        
        backgroundView.backgroundColor = Constants.BaseColor
        backgroundView.layer.cornerRadius = 10
        backgroundView.widthAnchor.constraint(equalToConstant: 115).isActive = true
        backgroundView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        signup.font = loginStat ? UIFont(name: "HelveticaNeue", size: 24) : UIFont(name: "HelveticaNeue-Bold", size: 24)
        signup.text = "Sign-Up"
        signup.textColor = loginStat ? Constants.BaseColor : UIColor.white
        signup.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -(view.frame.width / 4) + 10).isActive = true
        signup.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 35).isActive = true
        signup.isUserInteractionEnabled = true
        signup.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signupTap)))
        
        
        signin.font = loginStat ? UIFont(name: "HelveticaNeue-Bold", size: 24) : UIFont(name: "HelveticaNeue", size: 24)
        signin.text = "Sign-In"
        signin.textColor = loginStat ? UIColor.white : Constants.BaseColor
        signin.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: (view.frame.width / 4) - 10).isActive = true
        signin.topAnchor.constraint(equalTo: signup.topAnchor).isActive = true
        signin.isUserInteractionEnabled = true
        signin.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signinTap)))
        
        backgroundView.centerYAnchor.constraint(equalTo: signup.centerYAnchor).isActive = true
        backgroundViewCenter = backgroundView.centerXAnchor.constraint(equalTo: signup.centerXAnchor)
        backgroundViewCenter?.isActive = true
        
        accountLabel.text = loginStat ? "Sign into your account" : "Create your account"
        accountLabel.textColor = UIColor(red: 0.446, green: 0.425, blue: 0.425, alpha: 1)
        accountLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        accountLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        accountLabel.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 30).isActive = true
        
        
        usernameInput.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        usernameInput.topAnchor.constraint(equalTo: accountLabel.bottomAnchor, constant: 25).isActive = true
        usernameInput.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        usernameInput.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        usernameInput.borderStyle = .none
        //        usernameInput.textColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)
        //        usernameInput.backgroundColor = UIColor.blue
        usernameInput.font = UIFont(name: "HelveticaNeue", size: 22)
        usernameInput.tag = 1
        usernameInput.autocorrectionType = .no
        usernameInput.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: Constants.PlaceholderColor])
        usernameInput.textColor = UIColor.black
        usernameInput.autocapitalizationType = .none
        
        
        userLineRight = usernameLine.rightAnchor.constraint(equalTo: usernameInput.rightAnchor)
        userLineRight?.isActive = true
        usernameLine.leftAnchor.constraint(equalTo: usernameInput.leftAnchor).isActive = true
        usernameLine.topAnchor.constraint(equalTo: usernameInput.bottomAnchor).isActive = true
        usernameLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        usernameLine.backgroundColor = UIColor.black
        
        usernameError.leftAnchor.constraint(equalTo: usernameLine.leftAnchor, constant: 7).isActive = true
        usernameError.topAnchor.constraint(equalTo: usernameLine.bottomAnchor, constant: 1).isActive = true
        usernameError.font = UIFont(name: "HelveticaNeue", size: 15)
        usernameError.textColor = UIColor.red
        usernameError.text = ""
        
        
        
        passwordInput.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        passwordInput.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        passwordInput.heightAnchor.constraint(equalToConstant: 25).isActive = true;
        passwordInput.topAnchor.constraint(equalTo: usernameError.bottomAnchor, constant: 30).isActive = true;
        passwordInput.borderStyle = .none
        passwordInput.textColor = UIColor.black
        passwordInput.font = UIFont(name: "HelveticaNeue", size: 22)
        passwordInput.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: Constants.PlaceholderColor])
        passwordInput.autocorrectionType = .no
        passwordInput.autocapitalizationType = .none
        passwordInput.isSecureTextEntry = true
        passwordInput.tag = 2
        passwordInput.textContentType = .oneTimeCode
        
        passLineRight = passwordLine.rightAnchor.constraint(equalTo: passwordInput.rightAnchor)
        passLineRight?.isActive = true
        passwordLine.leftAnchor.constraint(equalTo: passwordInput.leftAnchor).isActive = true
        passwordLine.topAnchor.constraint(equalTo: passwordInput.bottomAnchor).isActive = true
        passwordLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        passwordLine.backgroundColor = UIColor.black
        
        passwordError.leftAnchor.constraint(equalTo: passwordLine.leftAnchor, constant: 7).isActive = true
        passwordError.topAnchor.constraint(equalTo: passwordLine.bottomAnchor, constant: 1).isActive = true
        passwordError.font = UIFont(name: "Arial", size: 15)
        passwordError.textColor = UIColor(red: 114/255, green: 108/255, blue: 108/255, alpha: 1.0)
        passwordError.text = "forgot password?"
        
        //        forgotLabel.text = "forgot password?"
        //        forgotLabel.textColor = UIColor(red: 0/255, green: 86/255, blue: 253/255, alpha: 1.0)
        //        forgotLabel.font = UIFont(name: "Arial", size: 18)
        //
        //        forgotLabel.topAnchor.constraint(equalTo: passwordLine.bottomAnchor, constant: 10).isActive = true
        //        forgotLabelLeft = loginStat ? forgotLabel.rightAnchor.constraint(equalTo: passwordInput.rightAnchor) : forgotLabel.leftAnchor.constraint(equalTo: view.rightAnchor)
        //        forgotLabelLeft?.isActive = true
        
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: passwordError.bottomAnchor, constant: 50).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 125).isActive = true
        
//        loginButton.backgroundColor = Constants.BaseColor
        loginButton.backgroundColor = UIColor.gray
        loginButton.layer.cornerRadius = 10;
        loginButton.setTitle("Continue", for: .normal)
        
        loginButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 24)
        
        loginButton.addTarget(self, action: #selector(self.buttonPressed), for: .touchUpInside)
        
        
        //        ----------------- test the VerificationViewCOntroller
        
    }
    
    @objc func signupTap() {
        print("signupTap pressed")
        if !loginStat {
            return
        }
        backgroundViewCenter?.isActive = false
        backgroundViewCenter = backgroundView.centerXAnchor.constraint(equalTo: signup.centerXAnchor)
        backgroundViewCenter?.isActive = true
        
        
        signup.font = UIFont(name: "HelveticaNeue-Bold", size: 24)
        signup.textColor = UIColor.white
        signin.font = UIFont(name: "HelveticaNeue", size: 24)
        signin.textColor = Constants.BaseColor
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3, animations: {
            self.view.layoutIfNeeded()
        }) { _ in
            self.loginStat = false
        }
        
        welcomeLabelRight?.isActive = false
        welcomeLabelRight = welcomeLabel.rightAnchor.constraint(equalTo: view.rightAnchor)
        welcomeLabelRight?.isActive = true
        
        welcomeBackLabelLeft?.isActive = false
        welcomeBackLabelLeft = welcomeBackLabel.leftAnchor.constraint(equalTo: view.rightAnchor)
        welcomeBackLabelLeft?.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 3, options: .curveEaseOut) {
            self.accountLabel.text = "Create your account"
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func signinTap() {
        print("signinTap pressed")
        if loginStat {
            return
        }
        backgroundViewCenter?.isActive = false
        backgroundViewCenter = backgroundView.centerXAnchor.constraint(equalTo: signin.centerXAnchor)
        backgroundViewCenter?.isActive = true
        
        
        
        signup.font = UIFont(name: "HelveticaNeue", size: 24)
        signup.textColor = Constants.BaseColor
        signin.font = UIFont(name: "HelveticaNeue-Bold", size: 24)
        signin.textColor = UIColor.white
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3, animations: {
            self.view.layoutIfNeeded()
        }) { _ in
            self.loginStat = true
        }
        
        welcomeLabelRight?.isActive = false
        welcomeLabelRight = welcomeLabel.rightAnchor.constraint(equalTo: view.leftAnchor)
        welcomeLabelRight?.isActive = true
        
        welcomeBackLabelLeft?.isActive = false
        welcomeBackLabelLeft = welcomeBackLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        welcomeBackLabelLeft?.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 3, options: .curveEaseOut) {
            self.accountLabel.text = "Sign into your account"
            self.view.layoutIfNeeded()
        }
        
    }
    
    //Determines if signUp or signIn
    @objc func buttonPressed() {
        //Sign In mode
        if loginStat {
            login()
        } else { //Sign Up mode
            createMode()
        }
        
    }
    
    func createMode() {
        print("Sign up")
        var flag = false
        if !usernamePass {
            flag = true
            usernameError.text = "Username already exists"
            usernameError.textColor = UIColor.red
        }
        
        if usernameInput.text == nil || usernameInput.text!.count < 8 || usernameInput.text!.count > 20 {
            flag = true
            usernameError.textColor = UIColor.red
            usernameError.text = "Username must have 8 - 20 characters"
        }
        
        if passwordInput.text == nil || passwordInput.text!.count < 6 || passwordInput.text!.count > 20 {
            flag = true
            passwordError.textColor = UIColor.red
            passwordError.text = "Password must have 6 - 20 characters"
        }
        
        if !flag {
            //move to the signup viewcontroller
            let nextView = SignUpViewController()
            nextView.createUsername = usernameInput.text!
            nextView.createPassword = passwordInput.text!
            self.navigationController?.pushViewController(nextView, animated: true)
        }
    }
    
    func login() {
        print("doing login")
        
        var flag = false
        
        if usernameInput.text == nil || usernameInput.text!.count < 8 || usernameInput.text!.count > 20 {
            flag = true
            usernameError.textColor = UIColor.red
            usernameError.text = "Username must have 8 - 20 characters"
        }
        
        
        if passwordInput.text == nil || passwordInput.text!.count < 6 || passwordInput.text!.count > 20 {
            flag = true
            passwordError.textColor = UIColor.red
            passwordError.text = "Password must have 6 - 20 characters"
        }
        
        if !flag {
            
            DispatchQueue.main.async {
                self.loginButton.showLoading()
            }
            //left off here
            self.loginManager.doLogin(user: LoginUserVO(username: self.usernameInput.text!, password: self.passwordInput.text!))
            
        }

//        let homeView = HomeViewController()
//        verView.loginStatus = loginStat
//        self.navigationController?.pushViewController(homeView, animated: true)
        
    }
    
    //    @objc func changeSign() {
    //        print("Change pressed")
    ////        let verView = VerNewViewController()
    ////        verView.loginStatus = loginStat
    ////        verView.currUser = CreateUserVO(firstName: "", lastName: "", username: "testUsername", password: "", email: "", age: 0)
    ////        self.navigationController?.pushViewController(verView, animated: true)
    //        loginStat.toggle()
    //        if loginStat {
    //            changeLabel.text = "sign up"
    //            loginButton.setTitle("sign in", for: .normal)
    //
    //            forgotLabelLeft?.isActive = false
    //            forgotLabelLeft = forgotLabel.rightAnchor.constraint(equalTo: passwordInput.rightAnchor)
    //            forgotLabelLeft?.isActive = true
    //
    //
    //            welcomeLabelLeft?.isActive = false
    //            welcomeLabelLeft = welcomeLabel.rightAnchor.constraint(equalTo: view.leftAnchor)
    //            welcomeLabelLeft?.isActive = true
    //            UIView.animate(withDuration: 0.5) {
    //                self.view.layoutIfNeeded()
    //            }
    //
    //            welLabelLeft?.isActive = false
    //            welLabelLeft = welLabel.rightAnchor.constraint(equalTo: view.leftAnchor)
    //            welLabelLeft?.isActive = true
    //            UIView.animate(withDuration: 0.5, delay: 0.1) {
    //                self.view.layoutIfNeeded()
    //            }
    //
    //            welcomeBackLabelLeft?.isActive = false
    //            welcomeBackLabelLeft = welcomeBackLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25)
    //            welcomeBackLabelLeft?.isActive = true
    ////            UIView.animate(withDuration: 0.5) {
    ////                self.view.layoutIfNeeded()
    ////            }
    //            UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseOut) {
    //                self.view.layoutIfNeeded()
    //            } completion: { _ in
    //
    //            }
    
    
    
    //        } else {
    //            changeLabel.text = "sign in"
    //            loginButton.setTitle("sign up", for: .normal)
    //
    //            forgotLabelLeft?.isActive = false
    //            forgotLabelLeft = forgotLabel.leftAnchor.constraint(equalTo: view.rightAnchor)
    //            forgotLabelLeft?.isActive = true
    //
    //            welcomeBackLabelLeft?.isActive = false
    //            welcomeBackLabelLeft = welcomeBackLabel.leftAnchor.constraint(equalTo: view.rightAnchor)
    //            welcomeBackLabelLeft?.isActive = true
    //            UIView.animate(withDuration: 0.5) {
    //                self.view.layoutIfNeeded()
    //            }
    //
    //            welcomeLabelLeft?.isActive = false
    //            welcomeLabelLeft = welcomeLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25)
    //            welcomeLabelLeft?.isActive = true
    ////            UIView.animate(withDuration: 0.5) {
    ////                self.view.layoutIfNeeded()
    ////            }
    //            UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseOut) {
    //                self.view.layoutIfNeeded()
    //            } completion: { _ in
    //
    //            }
    //
    //            welLabelLeft?.isActive = false
    //            welLabelLeft = welLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25)
    //            welLabelLeft?.isActive = true
    ////            UIView.animate(withDuration: 0.5, delay: 0.1) {
    ////                self.view.layoutIfNeeded()
    ////            }
    //            UIView.animate(withDuration: 0.7, delay: 0.2, options: .curveEaseOut) {
    //                self.view.layoutIfNeeded()
    //            } completion: { _ in
    //
    //            }
    //
    //
    //        }
    //    }
    
    //    func textFieldDidBeginEditing(_ textField: UITextField) {
    //        print("some input didbeginediting")
    //        if textField.tag == 1 {
    //            if textField.text == "" {
    //                print("username input didbeginediting")
    //                userLineRight?.isActive = false
    //                userLineRight = usernameLine.rightAnchor.constraint(equalTo: usernameInput.leftAnchor)
    //                userLineRight?.isActive = true
    //                UIView.animate(withDuration: 0.3) {
    //                    self.view.layoutIfNeeded()
    //                } completion: { _ in
    //                    self.userLineRight?.isActive = false
    //                    self.userLineRight = self.usernameLine.rightAnchor.constraint(equalTo: self.usernameInput.rightAnchor)
    //                    self.userLineRight?.isActive = true
    //                    self.usernameLine.backgroundColor = UIColor(red: 0/255, green: 86/255, blue: 253/255, alpha: 1.0)
    //                    UIView.animate(withDuration: 0.3) {
    //                        self.view.layoutIfNeeded()
    //                    }
    //                }
    //            }
    //        } else if textField.tag == 2 {
    //            if textField.text == "" {
    //                print("username input didbeginediting")
    //                passLineRight?.isActive = false
    //                passLineRight = passwordLine.rightAnchor.constraint(equalTo: passwordInput.leftAnchor)
    //                passLineRight?.isActive = true
    //                UIView.animate(withDuration: 0.3) {
    //                    self.view.layoutIfNeeded()
    //                } completion: { _ in
    //                    self.passLineRight?.isActive = false
    //                    self.passLineRight = self.passwordLine.rightAnchor.constraint(equalTo: self.passwordInput.rightAnchor)
    //                    self.passLineRight?.isActive = true
    //                    self.passwordLine.backgroundColor = UIColor(red: 0/255, green: 86/255, blue: 253/255, alpha: 1.0)
    //                    UIView.animate(withDuration: 0.3) {
    //                        self.view.layoutIfNeeded()
    //                    }
    //                }
    //            }
    //        }
    //    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            if usernamePass == false {
                return
            }
            usernamePass = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("some input didendEditing")
        if textField.tag == 1 {
            print(textField.text)
            print("username input didendEditing")
            if usernameInput.text == "" {
                
                //input field animation
                //                userLineRight?.isActive = false
                //                userLineRight = usernameLine.rightAnchor.constraint(equalTo: usernameInput.leftAnchor)
                //                userLineRight?.isActive = true
                //                UIView.animate(withDuration: 0.3) {
                //                    self.view.layoutIfNeeded()
                //                } completion: { _ in
                //                    self.userLineRight?.isActive = false
                //                    self.userLineRight = self.usernameLine.rightAnchor.constraint(equalTo: self.usernameInput.rightAnchor)
                //                    self.userLineRight?.isActive = true
                //                    self.usernameLine.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)
                //                    UIView.animate(withDuration: 0.3) {
                //                        self.view.layoutIfNeeded()
                //                    }
                //                }
                
            } else {
                if !loginStat {
                    if usernameInput.text!.count < 8 || usernameInput.text!.count > 20 {
                        return
                    }
                    print("ViewController: textFielddidendediting about to check username")
                    DispatchQueue.main.async {
                        self.loginManager.checkUsername(username: self.usernameInput.text!)
                    }
                }
                
            }
        }
        //        else if textField.tag == 2 {
        //            print(textField.text)
        //            print("password input didendEditing")
        //            if passwordInput.text == "" {
        //                return
        //input field animation
        //                passLineRight?.isActive = false
        //                passLineRight = passwordLine.rightAnchor.constraint(equalTo: passwordInput.leftAnchor)
        //                passLineRight?.isActive = true
        //                UIView.animate(withDuration: 0.3) {
        //                    self.view.layoutIfNeeded()
        //                } completion: { _ in
        //                    self.passLineRight?.isActive = false
        //                    self.passLineRight = self.passwordLine.rightAnchor.constraint(equalTo: self.passwordInput.rightAnchor)
        //                    self.passLineRight?.isActive = true
        //                    self.passwordLine.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)
        //                    UIView.animate(withDuration: 0.3) {
        //                        self.view.layoutIfNeeded()
        //                    }
        //                }
        
    }
    
    //    }
    //
    //    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    //        self.view.endEditing(true)
    //        return false
    //    }
    //
    //}
    
    //extension String {
    //    func trim() -> String {
    //        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    //    }
    //}
    //
}
    extension ViewController: LoginDelegate {
        
        //All Good
        func didUsernameExist(status: Bool) {
            print("didUsernameExist result: \(status)")
            if status { //if true = username already exists
                DispatchQueue.main.async {
                    self.usernameError.text = "username already exists"
                    self.usernameError.textColor = UIColor.red
                    self.usernamePass = false
                }
                
            } else {
                DispatchQueue.main.async {
                    self.usernameError.text = ""
                    self.usernamePass = true
                }
                
                
                //            DispatchQueue.main.async {
                //                let verView = VerNewViewController()
                //                verView.loginStatus = self.loginStat
                //                verView.currUser = CreateUserVO(firstName: "", lastName: "", username: self.usernameInput.text!, password: self.passwordInput.text!, email: "", age: 0)
                //                self.navigationController?.pushViewController(verView, animated: true)
                //            }
                
            }
        }
        
        func didEmailExist(status: Bool) {
            //        print("didEmailExist result: \(status)")
        }
        
        func didVer(code: Int) {
            print("didVer")
            DispatchQueue.main.async {
                let vc = HomeViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        func didLogin(email: String) {
            print("in do lOing email: \(email)")
            DispatchQueue.main.async {
                self.loginButton.hideLoading()
            
            
                let verView = VerificationViewController()
                verView.loginStatus = true
                verView.emailVerInput.text = email
                verView.modalTransitionStyle = .coverVertical
                verView.modalPresentationStyle = .popover
                self.navigationController?.pushViewController(verView, animated: true)
            }
            
            
            
            print("didLogin email: \(email)")
        }
        
        func didCreateUser(code: Int) {
            //        print("didCreateUser")
            //        DispatchQueue.main.async {
            //            self.loginButton.hideLoading()
            //        }
            //
            //        let verView = VerNewViewController()
            //        verView.currUser = CreateUserVO(firstName: "", lastName: "", username: usernameInput.text!, password: passwordInput.text!,email: "", age: 0)
            //        self.navigationController?.pushViewController(verView, animated: true)
        }
        
        func didErrorHappen(msg: String) {
            print("didErrorHappen is activated")
            if loginStat == true {
                
            }
            DispatchQueue.main.async {
                self.loginButton.hideLoading()
                if self.loginStat == true {
                    self.usernameError.text = "username may be incorrect"
                    self.usernameError.textColor = UIColor.red
                    self.passwordError.text = "password may be incorrect"
                    self.passwordError.textColor = UIColor.red
                }
            }
            print(msg)
            
        }
        
        @objc func keyboardWillShow(notification: NSNotification) {
            //        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            //            if self.view.frame.origin.y == 0 {
            //                self.view.frame.origin.y -= keyboardSize.height
            //            }
            //        }
        }
        
        @objc func keyboardWillHide(notification: NSNotification) {
            //        if self.view.frame.origin.y != 0 {
            //            self.view.frame.origin.y = 0
            //        }
        }
        
    }
    
