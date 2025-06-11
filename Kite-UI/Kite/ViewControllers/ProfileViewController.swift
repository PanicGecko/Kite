//
//  ProfileViewController.swift
//  Kite
//
//  Created by Adam on 12/6/23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let logoutLabel = UILabel()
    fileprivate let backButton = UIImageView(image: UIImage(named: "backButton"))
    
    var chatManager:ChatManager?
    
    override func viewDidLoad() {
        
        if chatManager == nil {
            print("ProfileViewController: viewDidLoad: no chatManager")
        }
        view.backgroundColor = UIColor.white
        logoutLabel.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutLabel)
        view.addSubview(backButton)
        
        
        backButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        backButton.contentMode = .scaleAspectFit
        backButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        backButton.isUserInteractionEnabled = true
        backButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goBack)))
        
        
        logoutLabel.text = "Logout"
        logoutLabel.font = UIFont(name: Constants.Font_Family, size: 40)
        logoutLabel.textColor = UIColor.red
        logoutLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoutLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        logoutLabel.isUserInteractionEnabled = true
        logoutLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.logout)))
        
        
        
        
    }
    
    @objc func goBack() {
        print("VerificationViewController goBack")
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func logout() {
        print("ProfileViewController logout")
        self.chatManager?.deleteAllData()
        
        //All Keychain keys: token, userId, lastLoginDate
        //Clear all keychain data
        KeychainWrapper.standard.set("", forKey: "userId")
        KeychainWrapper.standard.set("", forKey: "token")
        KeychainWrapper.standard.set("", forKey: "lastLoginDate")
        print("ProfileViewController logout going back to orginal view")
        DispatchQueue.main.async {
            self.navigationController?.viewControllers = [ViewController()]
        }
    }
    
    
}

