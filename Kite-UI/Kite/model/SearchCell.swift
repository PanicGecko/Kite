//
//  SearchCell.swift
//  Kite
//
//  Created by Adam on 8/20/22.
//

import UIKit

class SearchCell: UICollectionViewCell {
    
    let username = UILabel()
    let checkBox = UIImageView(image: UIImage(named: "checkmark"))
    let profilePic = UIImageView(image: UIImage(named: "user"))
    var isSelect = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.clear
        
        username.translatesAutoresizingMaskIntoConstraints = false
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        profilePic.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(username)
        contentView.addSubview(profilePic)
        contentView.addSubview(checkBox)
        
        checkBox.isHidden = true
        checkBox.widthAnchor.constraint(equalToConstant: 15).isActive = true
        checkBox.heightAnchor.constraint(equalToConstant: 15).isActive = true
        checkBox.contentMode = .scaleAspectFit
        checkBox.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//        checkBox.backgroundColor = UIColor.red
        
        username.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        username.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        username.heightAnchor.constraint(equalToConstant: 25).isActive = true
        username.font = UIFont(name: Constants.Font_Name, size: 26)
        
        profilePic.heightAnchor.constraint(equalToConstant: 41).isActive = true
        profilePic.widthAnchor.constraint(equalToConstant: 41).isActive = true
        
        profilePic.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        profilePic.bottomAnchor.constraint(equalTo: username.topAnchor, constant: -5).isActive = true
        profilePic.topAnchor.constraint(equalTo: checkBox.centerYAnchor).isActive = true
        profilePic.contentMode = .scaleAspectFit
//        profilePic.backgroundColor = UIColor.blue
        
        checkBox.leftAnchor.constraint(equalTo: profilePic.rightAnchor).isActive = true
        print("yoooo =-- \(profilePic.bounds.height)")
        
    }
    
    func showCheck() {
        checkBox.isHidden = false
    }
    
    func hideCheck() {
        checkBox.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
