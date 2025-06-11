//
//  EditChatViewController.swift
//  Kite
//
//  Created by Adam on 10/1/23.
//

import UIKit

class EditChatViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    let editLabel = UILabel()
    let backButton = UIImageView(image: UIImage(named: "backButton"))
    let chatName = UILabel()
    let editChatLabel = UILabel()
    let peopleLabel = UILabel()
    let memberCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero,
        collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()
    let addLabel = UILabel()
    var members = [UserVO]()
    
    override func viewDidLoad() {
        memberCollectionView.register(SearchCell.self, forCellWithReuseIdentifier: "SearchCell")
        view.backgroundColor = UIColor.white
        editLabel.translatesAutoresizingMaskIntoConstraints = false
        chatName.translatesAutoresizingMaskIntoConstraints = false
        editChatLabel.translatesAutoresizingMaskIntoConstraints = false
        peopleLabel.translatesAutoresizingMaskIntoConstraints = false
        memberCollectionView.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        addLabel.translatesAutoresizingMaskIntoConstraints = false
        
        members.append(UserVO(userId: 0, username: "Bob"))
        
        view.addSubview(editLabel)
        view.addSubview(chatName)
        view.addSubview(editChatLabel)
        view.addSubview(peopleLabel)
        view.addSubview(memberCollectionView)
        view.addSubview(backButton)
        view.addSubview(addLabel)
        
        editLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        editLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        editLabel.text = "EDIT"
        editLabel.font = UIFont(name: Constants.Font_Name, size: 20)
        editLabel.textAlignment = .center
        
        chatName.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        chatName.topAnchor.constraint(equalTo: editLabel.bottomAnchor, constant: 2).isActive = true
        chatName.text = "Bob"
        chatName.textAlignment = .center
        chatName.font = UIFont(name: Constants.Font_Name, size: 50)
        
        backButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        backButton.contentMode = .scaleAspectFit
        backButton.centerYAnchor.constraint(equalTo: editLabel.bottomAnchor).isActive = true
        backButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        
        editChatLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
        editChatLabel.textColor = Constants.BaseColor
        editChatLabel.attributedText = NSAttributedString(string: "Change Chat Title", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: Constants.BaseColor])
        editChatLabel.topAnchor.constraint(equalTo: chatName.bottomAnchor, constant: 2).isActive = true
        editChatLabel.centerXAnchor.constraint(equalTo: chatName.centerXAnchor).isActive = true
        
        peopleLabel.text = "People"
        peopleLabel.textAlignment = .left
        peopleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
        peopleLabel.textColor = UIColor.black
        peopleLabel.leftAnchor.constraint(equalTo: backButton.leftAnchor).isActive = true
        peopleLabel.topAnchor.constraint(equalTo: editChatLabel.bottomAnchor, constant: 25).isActive = true
        
        memberCollectionView.topAnchor.constraint(equalTo: peopleLabel.bottomAnchor, constant: 5).isActive = true
        memberCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        memberCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        memberCollectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 78).isActive = true
//        memberCollectionView.heightAnchor.constraint(equalToConstant: memberCollectionView.collectionViewLayout.collectionViewContentSize.height).isActive = true
        
        addLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        addLabel.topAnchor.constraint(equalTo: memberCollectionView.bottomAnchor, constant: 15).isActive = true
        addLabel.leftAnchor.constraint(equalTo: peopleLabel.leftAnchor).isActive = true
        addLabel.text = "Add People..."
        addLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
        addLabel.textAlignment = .left
        
        memberCollectionView.backgroundColor = UIColor.green
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return members.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = memberCollectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as! SearchCell
        var theName = members[indexPath.row]
        cell.username.text = theName.username
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width / 4, height: 78.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
