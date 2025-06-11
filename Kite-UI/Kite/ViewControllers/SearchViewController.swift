//
//  SearchViewController.swift
//  Kite
//
//  Created by Adam on 8/20/22.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UISearchBarDelegate, ChatServiceDelegate {
    
    let searchBar = UISearchBar()
    let resultView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero,
        collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()
    let chatButton = UIView()
    let chatImage = UIImageView(image: UIImage(named: "addChat"))
    let chatLabel = UILabel()
    var chosen = Set<Int>()
    var chosenUsername = ""
    var results = [UserVO]()
    
    private var chatManager = ChatManager.shared
    
    override func viewDidLoad() {
        
        view.backgroundColor = UIColor.white
        
        resultView.delegate = self
        resultView.dataSource = self
        searchBar.delegate = self
        chatManager.chatServiceDelegate = self
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        resultView.translatesAutoresizingMaskIntoConstraints = false
        chatButton.translatesAutoresizingMaskIntoConstraints = false
        chatImage.translatesAutoresizingMaskIntoConstraints = false
        chatLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(searchBar)
        view.addSubview(resultView)
        view.addSubview(chatButton)
        chatButton.addSubview(chatImage)
        chatButton.addSubview(chatLabel)
        
        resultView.register(SearchCell.self, forCellWithReuseIdentifier: "SearchCell")
        
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchBar.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.95).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 35).isActive = true
        chatButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = .systemGray6
        
        chatImage.widthAnchor.constraint(equalToConstant: 45).isActive = true
        chatImage.heightAnchor.constraint(equalToConstant: 45).isActive = true
        chatImage.centerXAnchor.constraint(equalTo: chatButton.centerXAnchor).isActive = true
        
        chatLabel.text = "Create a Chat"
        chatLabel.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        chatLabel.centerXAnchor.constraint(equalTo: chatImage.centerXAnchor).isActive = true
        
        chatImage.bottomAnchor.constraint(equalTo: chatLabel.topAnchor, constant: 5).isActive = true
        chatButton.bottomAnchor.constraint(equalTo: chatLabel.bottomAnchor, constant: 2).isActive = true
        chatButton.topAnchor.constraint(equalTo: chatImage.topAnchor, constant: -2).isActive = true
        chatButton.leftAnchor.constraint(equalTo: chatLabel.leftAnchor, constant: -2).isActive = true
        chatButton.rightAnchor.constraint(equalTo: chatLabel.rightAnchor, constant: 2).isActive = true
        chatButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 15).isActive = true
        chatButton.isUserInteractionEnabled = true
        chatButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.pressed)))
        
        resultView.topAnchor.constraint(equalTo: chatButton.bottomAnchor, constant: 20).isActive = true
        resultView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        resultView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        resultView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
//        resultView.backgroundColor = UIColor.green
        
//        chatButton.addTarget(self, action: #selector(self.pressed), for: .touchUpInside)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        chatManager.chatServiceDelegate = nil
    }
    
    deinit {
        chatManager.chatServiceDelegate = nil
    }
    
    @objc func pressed() {
        print("chat button pressed")
        if chosen.isEmpty {
            print("is empty")
            return
        }
        
        if chosen.count > 1 {
            // creating an alert controller object
           let alertController = UIAlertController(title: "Chat Name", message: "Please enter chat name", preferredStyle: .alert)

           // adding a textField for an email address
           alertController.addTextField { textField in
           
              // configure the text field
              textField.placeholder = "Name"
               textField.keyboardType = .default
               textField.autocorrectionType = .yes
           }
           // creating OK action
           let okAction = UIAlertAction(title: "OK", style: .default) {
              action in guard let textField = alertController.textFields?.first,
              let text = textField.text else {
                 print("No value has been entered in email address")
                 return
              }
               
              print("Alert: name: \(text)")
               self.chatManager.createChat(members: self.chosen, chatName: text)
           }
           // creating a Cancel action
           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
           // adding actions to alert
           alertController.addAction(okAction)
           alertController.addAction(cancelAction)
           // showing the alert
           present(alertController, animated: true, completion: nil)
        } else {
            chatManager.createChat(members: chosen, chatName: chosenUsername)
        }
        
        
    
        
        
        
    }
    
    func updateSearch(users: Array<UserVO>) {
        results = users
        DispatchQueue.main.async {
            self.resultView.reloadData()
        }
        
        print("updateSearch reloaded table view")
    }
    
    func didErrorHappen(msg: String) {
        print("SearchViewController error: \(msg)")
    }
    
    func chatCreated() {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
        
        print("chatCreated")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = resultView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as! SearchCell
        var theName = results[indexPath.row]
        cell.username.text = theName.username
        if chosen.contains(theName.userId) {
            cell.isSelect = true
            cell.showCheck()
        } else {
            cell.isSelect = false
            cell.hideCheck()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var theOne = results[indexPath.row].userId
        print("slected user \(results[indexPath.row].username)")
        if let cell = collectionView.cellForItem(at: indexPath) as? SearchCell {
            if chosen.contains(theOne) {
                chosen.remove(theOne)
                cell.hideCheck()
                chosenUsername = ""
            } else {
                chosen.insert(results[indexPath.row].userId)
                cell.showCheck()
                chosenUsername = results[indexPath.row].username
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width / 3, height: 78.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("chaged to")
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            chatManager.searchUser(input: searchText)
        } else {
            updateSearch(users: [])
        }
        
    }
    
}
