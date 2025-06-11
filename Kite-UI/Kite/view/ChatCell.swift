//
//  ChatCell.swift
//  Kite
//
//  Created by Adam on 6/28/22.
//

import UIKit

class ChatCell: UICollectionViewCell {
    
    var box = UIView()
    var chatImage = UIImageView(image: UIImage(named: "user"))
    var chatName = UILabel()
    var lastMessage = UILabel()
    var missedCircle = UIView()
    let missedCount = UILabel()
    var lastDate = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor.white
        
        box.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(box)
        
        box.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        box.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        box.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12).isActive = true
        box.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        
        print("ldksjdlkjfjfj \(contentView.frame.height)")
        chatImage.translatesAutoresizingMaskIntoConstraints = false
        chatName.translatesAutoresizingMaskIntoConstraints = false
        lastMessage.translatesAutoresizingMaskIntoConstraints = false
        missedCircle.translatesAutoresizingMaskIntoConstraints = false
        missedCount.translatesAutoresizingMaskIntoConstraints = false
        lastDate.translatesAutoresizingMaskIntoConstraints = false

        box.addSubview(chatImage)
        chatImage.backgroundColor = UIColor.clear
        
        chatImage.layer.masksToBounds = true
        chatImage.leftAnchor.constraint(equalTo: box.leftAnchor, constant: 20).isActive = true
        chatImage.centerYAnchor.constraint(equalTo: box.centerYAnchor).isActive = true
        chatImage.heightAnchor.constraint(equalToConstant: 37).isActive = true
        chatImage.widthAnchor.constraint(equalToConstant: 37).isActive = true
        chatImage.layer.cornerRadius = 37 / 2
        box.addSubview(chatName)
        box.addSubview(lastMessage)
        chatName.leftAnchor.constraint(equalTo: chatImage.rightAnchor, constant: 20).isActive = true
        chatName.bottomAnchor.constraint(equalTo: box.centerYAnchor).isActive = true
        

        lastMessage.leftAnchor.constraint(equalTo: chatName.leftAnchor).isActive = true
        lastMessage.topAnchor.constraint(equalTo: box.centerYAnchor).isActive = true

        chatName.text = "test chat"
        lastMessage.text = "ldsld"
        lastMessage.textColor = UIColor(red: 0.446, green: 0.425, blue: 0.425, alpha: 1)
        lastMessage.font = UIFont(name: "HelveticaNeue", size: 16)
        chatName.font = UIFont(name: Constants.Font_Name, size: 26)
        chatName.sizeToFit()
        lastMessage.sizeToFit()
        
        contentView.addSubview(missedCircle)

        missedCircle.centerYAnchor.constraint(equalTo: box.topAnchor).isActive = true
        missedCircle.centerXAnchor.constraint(equalTo: box.rightAnchor).isActive = true
        missedCircle.heightAnchor.constraint(equalToConstant: 24).isActive = true
        missedCircle.widthAnchor.constraint(equalToConstant: 24).isActive = true
        missedCircle.backgroundColor = UIColor(red: 255/255, green: 78/255, blue: 78/255, alpha: 1.0)
        missedCircle.layer.cornerRadius = 12

//        missedCircle.addSubview(missedCount)
//        missedCount.font = UIFont(name: "HelveticaNeue", size: 16)
//        missedCount.text = "1"
//        missedCount.textAlignment = .center
//        missedCount.textColor = UIColor.white
//        missedCount.widthAnchor.constraint(equalTo: missedCircle.widthAnchor).isActive = true
//        missedCount.heightAnchor.constraint(equalTo: missedCircle.heightAnchor).isActive = true
//        missedCount.centerXAnchor.constraint(equalTo: missedCircle.centerXAnchor).isActive = true
//        missedCount.centerYAnchor.constraint(equalTo: missedCircle.centerYAnchor).isActive = true
        
        box.addSubview(lastDate)
        lastDate.centerYAnchor.constraint(equalTo: chatName.centerYAnchor).isActive = true
        lastDate.rightAnchor.constraint(equalTo: box.rightAnchor, constant: -20).isActive = true
        lastDate.text = "18:01"
        lastDate.font = UIFont(name: "HelveticaNeue", size: 16)
        lastDate.textColor = UIColor(red: 0.446, green: 0.425, blue: 0.425, alpha: 1)
        lastDate.textAlignment = .center

        box.layer.cornerRadius = 10
        box.layer.borderColor = UIColor(red: 0.451, green: 0.769, blue: 1, alpha: 1).cgColor
        box.layer.borderWidth = 1
        backgroundConfiguration = UIBackgroundConfiguration.clear()
        
    }
    
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
