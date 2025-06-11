//
//  SignUpViewController.swift
//  Kite
//
//  Created by Adam on 10/20/23.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    //Hello this is Kite label image
    fileprivate let welcomeLabel = UIImageView(image: UIImage(named: "signup"))
    fileprivate var welcomeLabelRight: NSLayoutConstraint?
    
    fileprivate let introLabel = UILabel()
    
    fileprivate let firstInput = UITextField()
    fileprivate let paddingView1 = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 25))
    fileprivate let firstLine = UIView()
    fileprivate var firstLineRight: NSLayoutConstraint?
    fileprivate let firstError = UILabel()

    fileprivate let lastInput = UITextField()
    fileprivate let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 25))
    fileprivate var lastLineRight: NSLayoutConstraint?
    fileprivate let lastLine = UIView()
    fileprivate let lastError = UILabel()
    
    fileprivate let birthdayLabel = UILabel()
    
    fileprivate let birthInput = UITextField()
    fileprivate let paddingView3 = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 25))
    fileprivate var birthLineRight: NSLayoutConstraint?
    fileprivate let birthLine = UIView()
    fileprivate let birthError = UILabel()


//    fileprivate let loginButton = UIButton()
    fileprivate let loginButton = LoadingButton()

    
    //existsing info on the user saved here
    var createUsername:String?
    var createPassword:String?
    
    var birthPass = false
    var firstPass = false
    var lastPass = false

    override func viewDidLoad() {
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        firstInput.delegate = self
        lastInput.delegate = self
        birthInput.delegate = self
        setupViews()
        view.backgroundColor = UIColor.white
    }

    func setupViews() {
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        firstInput.translatesAutoresizingMaskIntoConstraints = false
        lastInput.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        firstLine.translatesAutoresizingMaskIntoConstraints = false
        lastLine.translatesAutoresizingMaskIntoConstraints = false
        firstError.translatesAutoresizingMaskIntoConstraints = false
        lastError.translatesAutoresizingMaskIntoConstraints = false
        introLabel.translatesAutoresizingMaskIntoConstraints = false
        birthdayLabel.translatesAutoresizingMaskIntoConstraints = false
        birthInput.translatesAutoresizingMaskIntoConstraints = false
        birthLine.translatesAutoresizingMaskIntoConstraints = false
        birthError.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomeLabel)
        view.addSubview(firstInput)
        view.addSubview(lastInput)
        view.addSubview(loginButton)
        view.addSubview(firstLine)
        view.addSubview(lastLine)
        view.addSubview(firstError)
        view.addSubview(lastError)
        view.addSubview(birthdayLabel)
        view.addSubview(introLabel)
        view.addSubview(birthdayLabel)
        view.addSubview(birthLine)
        view.addSubview(birthError)
        view.addSubview(birthInput)
        
        welcomeLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        welcomeLabelRight = welcomeLabel.rightAnchor.constraint(equalTo: view.rightAnchor)
        welcomeLabelRight?.isActive = true
        welcomeLabel.contentMode = .scaleAspectFit
        
        introLabel.text = "Tell us a little about yourself!"
        introLabel.textColor = UIColor(red: 0.446, green: 0.425, blue: 0.425, alpha: 1)
        introLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        introLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        introLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 25).isActive = true
        
        firstInput.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        firstInput.topAnchor.constraint(equalTo: introLabel.bottomAnchor, constant: 15).isActive = true
        firstInput.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        firstInput.heightAnchor.constraint(equalToConstant: 25).isActive = true

        firstInput.borderStyle = .none
//        usernameInput.textColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)
//        usernameInput.backgroundColor = UIColor.blue
        firstInput.font = UIFont(name: "HelveticaNeue", size: 22)
        firstInput.tag = 1
        firstInput.autocorrectionType = .no
        firstInput.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: [NSAttributedString.Key.foregroundColor: Constants.PlaceholderColor])
        firstInput.textColor = UIColor.black
        firstInput.leftView = paddingView1
        firstInput.leftViewMode = .always
        

        firstLineRight = firstLine.rightAnchor.constraint(equalTo: firstInput.rightAnchor)
        firstLineRight?.isActive = true
        firstLine.leftAnchor.constraint(equalTo: firstInput.leftAnchor).isActive = true
        firstLine.topAnchor.constraint(equalTo: firstInput.bottomAnchor).isActive = true
        firstLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        firstLine.backgroundColor = UIColor.black

        firstError.leftAnchor.constraint(equalTo: firstLine.leftAnchor, constant: 7).isActive = true
        firstError.topAnchor.constraint(equalTo: firstLine.bottomAnchor, constant: 1).isActive = true
        firstError.font = UIFont(name: "HelveticaNeue", size: 15)
        firstError.textColor = UIColor.red
        firstError.text = ""
        


        lastInput.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        lastInput.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        lastInput.heightAnchor.constraint(equalToConstant: 25).isActive = true;
        lastInput.topAnchor.constraint(equalTo: firstError.bottomAnchor, constant: 25).isActive = true;
        lastInput.borderStyle = .none
        lastInput.textColor = UIColor.black
        lastInput.font = UIFont(name: "HelveticaNeue", size: 22)
        lastInput.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: [NSAttributedString.Key.foregroundColor: Constants.PlaceholderColor])
        lastInput.autocorrectionType = .no
        lastInput.tag = 2
        lastInput.textContentType = .oneTimeCode
        lastInput.leftView = paddingView2
        lastInput.leftViewMode = .always

        lastLineRight = lastLine.rightAnchor.constraint(equalTo: lastInput.rightAnchor)
        lastLineRight?.isActive = true
        lastLine.leftAnchor.constraint(equalTo: lastInput.leftAnchor).isActive = true
        lastLine.topAnchor.constraint(equalTo: lastInput.bottomAnchor).isActive = true
        lastLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lastLine.backgroundColor = UIColor.black

        lastError.leftAnchor.constraint(equalTo: lastLine.leftAnchor, constant: 7).isActive = true
        lastError.topAnchor.constraint(equalTo: lastLine.bottomAnchor, constant: 1).isActive = true
        lastError.font = UIFont(name: "Arial", size: 15)
        lastError.textColor = UIColor.red
        lastError.text = ""
        
        birthdayLabel.text = "Birthday"
        birthdayLabel.textColor = UIColor(red: 0.446, green: 0.425, blue: 0.425, alpha: 1)
        birthdayLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        birthdayLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        birthdayLabel.topAnchor.constraint(equalTo: lastError.bottomAnchor, constant: 35).isActive = true
        
        
        birthInput.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
//        birthInput.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        birthInput.heightAnchor.constraint(equalToConstant: 25).isActive = true;
        birthInput.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor, constant: 15).isActive = true;
        birthInput.borderStyle = .none
        birthInput.textColor = UIColor.black
        birthInput.font = UIFont(name: "HelveticaNeue", size: 22)
        birthInput.attributedPlaceholder = NSAttributedString(string: "DD / MM / YYYY ", attributes: [NSAttributedString.Key.foregroundColor: Constants.PlaceholderColor])
        birthInput.autocorrectionType = .no
        birthInput.autocapitalizationType = .none
        birthInput.tag = 3
        birthInput.keyboardType = .numberPad
        birthInput.leftView = paddingView3
        birthInput.leftViewMode = .always
        birthInput.sizeToFit()
        birthInput.widthAnchor.constraint(equalToConstant: birthInput.frame.size.width).isActive = true

        birthLineRight = birthLine.rightAnchor.constraint(equalTo: birthInput.rightAnchor)
        birthLineRight?.isActive = true
        birthLine.leftAnchor.constraint(equalTo: birthInput.leftAnchor).isActive = true
        birthLine.topAnchor.constraint(equalTo: birthInput.bottomAnchor).isActive = true
        birthLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        birthLine.backgroundColor = UIColor.black

        birthError.leftAnchor.constraint(equalTo: birthLine.leftAnchor, constant: 7).isActive = true
        birthError.topAnchor.constraint(equalTo: birthLine.bottomAnchor, constant: 1).isActive = true
        birthError.font = UIFont(name: "Arial", size: 15)
//        birthError.textColor = UIColor(red: 114/255, green: 108/255, blue: 108/255, alpha: 1.0)
        birthError.textColor = UIColor.red
        birthError.text = ""


        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: birthError.bottomAnchor, constant: 50).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 125).isActive = true

        loginButton.backgroundColor = Constants.BaseColor
        loginButton.layer.cornerRadius = 10;
        loginButton.setTitle("Continue", for: .normal)

        loginButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 24)

        loginButton.addTarget(self, action: #selector(self.login), for: .touchUpInside)
        
        
//        ----------------- test the VerificationViewCOntroller
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == birthInput {
                    if birthInput.text?.count == 2 || birthInput.text?.count == 5 {
                        //Handle backspace being pressed
                        if !(string == "") {
                            // append the text
                            birthInput.text = birthInput.text! + "/"
                        }
                    }
                    // check the condition not exceed 9 chars
                    return !(textField.text!.count > 9 && (string.count ) > range.length)
                } else {
                    return true
                }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //birthday field
        if textField.tag == 3 {
            print("did end editing for birthday field")
            let regex = try? NSRegularExpression(pattern: "[0-2][0-9]/[0-3][0-9]/[0-9][0-9]")
            if regex == nil {
                print("Regex is bad")
                return
            }
            if regex!.matches(in: birthInput.text!, range: NSRange(location: 0, length: birthInput.text!.utf16.count)).count == 0 {
                print("Birthday field invalid")
                birthError.text = "Invalid birthday"
                birthError.textColor = UIColor.red
                birthPass = false
                return
            }
            print("sdfsdfsdfsdfs")
            birthError.text = ""
            birthError.textColor = UIColor.red
            birthPass = true
        } else if textField.tag == 1 { //First name field
            if firstInput.text == nil || firstInput.text!.count < 3 || firstInput.text!.count > 20 {
                firstError.text = "Must be between 2 - 20 characters"
                firstPass = false
                return
            }
            firstError.text = ""
            firstPass = true
        }else if textField.tag == 2 { //Last name field
            if lastInput.text == nil || lastInput.text!.count < 3 || lastInput.text!.count > 20 {
                lastError.text = "Must be between 2 - 20 characters"
                lastPass = false
                return
            }
            lastError.text = ""
            lastPass = true
        }
    }
    
    @objc func login() {
        print("Signupviewcontroller: doing login birthPass: \(birthPass)")
        
        birthInput.endEditing(true)
        
        if birthPass && firstPass && lastPass {
            
            let emailVC = EmailVerViewController()
            emailVC.createUsername = createUsername
            emailVC.createPassword = createPassword
            emailVC.createFirst = firstInput.text
            emailVC.createLast = lastInput.text
            emailVC.createBirth = birthInput.text
            
            self.navigationController?.pushViewController(emailVC, animated: true)

        }
        
    }
    

}




