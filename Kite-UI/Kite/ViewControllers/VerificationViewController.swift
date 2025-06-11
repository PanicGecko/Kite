//
//  VerificationViewController.swift
//  Kite
//
//  Created by Adam on 6/28/22.
//

import UIKit

class VerificationViewController: UIViewController, UITextFieldDelegate {
    
    fileprivate let backButton = UIImageView(image: UIImage(named: "backButton"))
    
    fileprivate let verLabel = UILabel()
    
    fileprivate let verTag = UILabel()
    var emailVerInput = UILabel()
    
    fileprivate let txtFirst = UITextField()
    fileprivate let txtSecond = UITextField()
    fileprivate let txtThird = UITextField()
    fileprivate let txtFourth = UITextField()
    fileprivate let txtFith = UITextField()
    fileprivate let txtSixth = UITextField()
    fileprivate let stackView = UIStackView()
    
    fileprivate var viewWidth: CGFloat = 0
    fileprivate let boxWidth: CGFloat = 50
    fileprivate let boxHeight: CGFloat = 70
    
    fileprivate let resendLabel = UILabel()
    
    fileprivate let loginButton = LoadingButton()
    
    var signup = false
    
    var loginStatus: Bool = false
    
    private var loginManager = LoginManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor.white
        viewWidth = view.frame.width
        txtFirst.delegate = self
        txtFirst.keyboardType = .numberPad
        txtSecond.delegate = self
        txtSecond.keyboardType = .numberPad
        txtThird.delegate = self
        txtThird.keyboardType = .numberPad
        txtFourth.delegate = self
        txtFourth.keyboardType = .numberPad
        txtFith.delegate = self
        txtFith.keyboardType = .numberPad
        txtSixth.delegate = self
        txtSixth.keyboardType = .numberPad
        loginManager.delegate = self
        setupComponents()
        setupCode()
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
        stackView.translatesAutoresizingMaskIntoConstraints = false
        verTag.translatesAutoresizingMaskIntoConstraints = false
        emailVerInput.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        resendLabel.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(verLabel)
        view.addSubview(verTag)
        view.addSubview(stackView)
        view.addSubview(emailVerInput)
        view.addSubview(backButton)
        view.addSubview(resendLabel)
        view.addSubview(loginButton)
        
        backButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        backButton.contentMode = .scaleAspectFit
        backButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        backButton.isUserInteractionEnabled = true
        backButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goBack)))
        
        verLabel.textColor = UIColor.black
        verLabel.text = "Verification Code"
        verLabel.font = UIFont(name: "HelveticaNeue", size: 40)
        verLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 35).isActive = true
        verLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        verLabel.textAlignment = .center
        
        verTag.text = "Enter the verification code we sent to:"
        verTag.font = UIFont(name: "HelveticaNeue", size: 13)
        verTag.textColor = UIColor(red: 173/255, green: 166/255, blue: 166/255, alpha: 1.0)
        verTag.textAlignment = .center
        verTag.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        verTag.topAnchor.constraint(equalTo: verLabel.bottomAnchor, constant: 30).isActive = true
        
        emailVerInput.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailVerInput.topAnchor.constraint(equalTo: verTag.bottomAnchor, constant: 1).isActive = true
        emailVerInput.text = "email@email.com"
        emailVerInput.font = UIFont(name: "HelveticaNeue", size: 13)
        emailVerInput.textColor = UIColor.black
        emailVerInput.textAlignment = .center

        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        stackView.addArrangedSubview(txtFirst)
        stackView.addArrangedSubview(txtSecond)
        stackView.addArrangedSubview(txtThird)
        stackView.addArrangedSubview(txtFourth)
        stackView.addArrangedSubview(txtFith)
        stackView.addArrangedSubview(txtSixth)
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: emailVerInput.bottomAnchor, constant: 15).isActive = true
        stackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.85).isActive = true
        
    }
    
    func setupCode() {
        
        txtFirst.widthAnchor.constraint(equalToConstant: boxWidth).isActive = true
        txtFirst.heightAnchor.constraint(equalToConstant: boxHeight).isActive = true
        txtFirst.layer.borderColor = Constants.BaseColor.cgColor
        txtFirst.attributedPlaceholder = NSAttributedString(string: "-", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        txtFirst.layer.cornerRadius = 10
        txtFirst.layer.borderWidth = 1
        txtFirst.textAlignment = NSTextAlignment.center
        txtFirst.font = UIFont(name: "HelveticaNeue", size: 20)
        
        txtSecond.widthAnchor.constraint(equalToConstant: boxWidth).isActive = true
        txtSecond.heightAnchor.constraint(equalToConstant: boxHeight).isActive = true
        txtSecond.layer.borderColor = Constants.BaseColor.cgColor
        txtSecond.layer.cornerRadius = 10
        txtSecond.layer.borderWidth = 1
        txtSecond.textAlignment = NSTextAlignment.center
        txtSecond.font = UIFont(name: "HelveticaNeue", size: 20)
        txtSecond.attributedPlaceholder = NSAttributedString(string: "-", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        txtThird.widthAnchor.constraint(equalToConstant: boxWidth).isActive = true
        txtThird.heightAnchor.constraint(equalToConstant: boxHeight).isActive = true
        txtThird.layer.borderColor = Constants.BaseColor.cgColor
        txtThird.layer.cornerRadius = 10
        txtThird.layer.borderWidth = 1
        txtThird.textAlignment = NSTextAlignment.center
        txtThird.font = UIFont(name: "HelveticaNeue", size: 20)
        txtThird.attributedPlaceholder = NSAttributedString(string: "-", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        txtFourth.widthAnchor.constraint(equalToConstant: boxWidth).isActive = true
        txtFourth.heightAnchor.constraint(equalToConstant: boxHeight).isActive = true
        txtFourth.layer.borderColor = Constants.BaseColor.cgColor
        txtFourth.layer.cornerRadius = 10
        txtFourth.layer.borderWidth = 1
        txtFourth.textAlignment = NSTextAlignment.center
        txtFourth.font = UIFont(name: "HelveticaNeue", size: 20)
        txtFourth.attributedPlaceholder = NSAttributedString(string: "-", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        txtFith.widthAnchor.constraint(equalToConstant: boxWidth).isActive = true
        txtFith.heightAnchor.constraint(equalToConstant: boxHeight).isActive = true
        txtFith.layer.borderColor = Constants.BaseColor.cgColor
        txtFith.layer.cornerRadius = 10
        txtFith.layer.borderWidth = 1
        txtFith.textAlignment = NSTextAlignment.center
        txtFith.font = UIFont(name: "HelveticaNeue", size: 20)
        txtFith.attributedPlaceholder = NSAttributedString(string: "-", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        txtSixth.widthAnchor.constraint(equalToConstant: boxWidth).isActive = true
        txtSixth.heightAnchor.constraint(equalToConstant: boxHeight).isActive = true
        txtSixth.layer.borderColor = Constants.BaseColor.cgColor
        txtSixth.layer.cornerRadius = 10
        txtSixth.layer.borderWidth = 1
        txtSixth.textAlignment = NSTextAlignment.center
        txtSixth.font = UIFont(name: "HelveticaNeue", size: 20)
        txtSixth.attributedPlaceholder = NSAttributedString(string: "-", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        
        resendLabel.text = "Didn’t receive it? Click here to resend."
        resendLabel.textAlignment = .center
        resendLabel.textColor = UIColor(red: 0.679, green: 0.651, blue: 0.651, alpha: 1)
        resendLabel.font = UIFont(name: "HelveticaNeue", size: 13)
        resendLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resendLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 21).isActive = true
        
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: resendLabel.bottomAnchor, constant: 65).isActive = true
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
        self.navigationController?.popViewController(animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !(string == "") {
            textField.text = string
            if textField == txtFirst {
                txtSecond.becomeFirstResponder()
            } else if textField == txtSecond {
                txtThird.becomeFirstResponder()
            } else if textField == txtThird {
                txtFourth.becomeFirstResponder()
            } else if textField == txtFourth {
                txtFith.becomeFirstResponder()
            } else if textField == txtFith{
                txtSixth.becomeFirstResponder()
            } else {
                
                textField.resignFirstResponder()
            }
            return false
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == txtSixth {
            print("did enter didchange slection")
            DispatchQueue.main.async {
                print("in VerViewController sending vercode")
                self.loginManager.Verify(verCode: VerEmailVO(email: self.emailVerInput.text!, code: self.txtFirst.text! + self.txtSecond.text! + self.txtThird.text! + self.txtFourth.text! + self.txtFith.text! + self.txtSixth.text!), newVer: !self.loginStatus)
            }
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
extension VerificationViewController: LoginDelegate {
    func didUsernameExist(status: Bool) {
        print("VerificatoinViewController: didUsernameExists")
    }
    
    func didEmailExist(status: Bool) {
        print("VerificatoinViewController: didEmailExists")
        
        
    }
    
    func didVer(code: Int) {
        print("VerificatoinViewController: didVer")
        if code == 0 {
            print("VerificatoinViewController: didVer all goood")
            DispatchQueue.main.async {
                let homeController = HomeViewController()
                homeController.didsignup = self.signup
                self.navigationController?.setViewControllers([homeController], animated: true)
            }
            
        }
    }
    
    func didLogin(email: String) {
        print("VerificatoinViewController: didLogin")
    }
    
    func didCreateUser(code: Int) {
        print("VerificatoinViewController: didCreateUser")
        
        
    }
    
    func didErrorHappen(msg: String) {
        print("VerificatoinViewController: didErrorHappen: \(msg)")
        
        
    }
    
    
}

