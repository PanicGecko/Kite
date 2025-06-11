//
//  HomeViewController.swift
//  Kite
//
//  Created by Adam on 6/28/22.
//

import UIKit
import DequeModule
import AVFoundation

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{
    
    let userDefaults = UserDefaults.standard
    
    
    fileprivate let logo = UIImageView(image: UIImage(named: "logo"))
    fileprivate let profileCircle = UIImageView()
    fileprivate let addButton = UIButton()
    fileprivate let chatCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero,
        collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()
    fileprivate let messageLabel = UILabel()
    fileprivate let createChat = UIImageView(image: UIImage(named: "addChat"))
    fileprivate let layout = UICollectionViewFlowLayout()
    
    var chatArray = ["man", "user", "woman"]
    
    private var chatManager = ChatManager.shared
    
    
    var chats: Deque<ChatRoom> = []
    var chatList = [Int]()
    let df = DateFormatter()
    let source_tz = NSTimeZone(abbreviation: "EST")
    let local_tz = NSTimeZone.system
    var didsignup = false
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let noMsg = UILabel()
    
    let notification = UIView()
    var notificationOpen = false
    var notificationBottomAnchor: NSLayoutConstraint!
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatCollectionView.delegate = self
        chatCollectionView.dataSource = self
        
        chatManager.initSocket()
        chatManager.chatDelegate = self
        chats = chatManager.getChats()
        if !didsignup {
            chatManager.getLatestChats()
        }
        
        df.dateFormat = "h:mm"
        
        view.backgroundColor = UIColor.white
        
        logo.contentMode = .scaleAspectFit
        
        
        view.addSubview(logo)
        view.addSubview(profileCircle)
        view.addSubview(messageLabel)
        view.addSubview(createChat)
        view.addSubview(addButton)
        view.addSubview(chatCollectionView)
        view.addSubview(noMsg)
        
        chatCollectionView.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        logo.translatesAutoresizingMaskIntoConstraints = false
        profileCircle.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        createChat.translatesAutoresizingMaskIntoConstraints = false
        noMsg.translatesAutoresizingMaskIntoConstraints = false
        
        logo.widthAnchor.constraint(equalToConstant: 150).isActive = true
        logo.heightAnchor.constraint(equalToConstant: 50).isActive = true
        logo.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        logo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        profileCircle.centerYAnchor.constraint(equalTo: logo.centerYAnchor).isActive = true
        profileCircle.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        profileCircle.widthAnchor.constraint(equalToConstant: 31).isActive = true
        profileCircle.heightAnchor.constraint(equalToConstant: 31).isActive = true
        
        profileCircle.image = UIImage(named: "user")
        profileCircle.contentMode = .scaleAspectFit
        profileCircle.layer.masksToBounds = true
        
        
        // TESTING DELTET LATER
        profileCircle.isUserInteractionEnabled = true
        
        profileCircle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.profilePage)))
        // TESTING ______
        
        messageLabel.text = "Messages"
        messageLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 36)
        
        messageLabel.heightAnchor.constraint(equalToConstant: 48).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: logo.leftAnchor, constant: 20).isActive = true
        messageLabel.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 20).isActive = true
        
        createChat.widthAnchor.constraint(equalToConstant: 46).isActive = true
        createChat.heightAnchor.constraint(equalToConstant: 46).isActive = true
        createChat.centerYAnchor.constraint(equalTo: messageLabel.centerYAnchor).isActive = true
        createChat.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -18).isActive = true
        createChat.contentMode = .scaleAspectFit
        
        createChat.isUserInteractionEnabled = true
        createChat.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(searchPage)))
        
        setupStuff()
        
        let per = userDefaults.bool(forKey: "AudioPermission")
        if !userDefaults.bool(forKey: "AudioPermission") {
            checkPermission()
        }
        
        
        //Setup Notification
        let notiLabel = UILabel()
        notiLabel.translatesAutoresizingMaskIntoConstraints = false
        notiLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        notiLabel.textColor = .white
        notiLabel.text = "You are offline"
        view.insertSubview(notification, at: 100)
        notification.backgroundColor = .red
        notification.translatesAutoresizingMaskIntoConstraints = false
        notification.heightAnchor.constraint(equalToConstant: 40).isActive = true
        notification.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        notificationBottomAnchor = notification.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 40)
        notificationBottomAnchor.isActive = true
        notification.addSubview(notiLabel)
        
        notiLabel.leftAnchor.constraint(equalTo: notification.leftAnchor, constant: 20).isActive = true
        notiLabel.centerYAnchor.constraint(equalTo: notification.centerYAnchor).isActive = true
        
        //Setup Refresh
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
          refreshControl.tintColor = .gray                // optional styling

          // 2️⃣ Attach it to the collection view
          if #available(iOS 10.0, *) {
            chatCollectionView.refreshControl = refreshControl
          } else {
            chatCollectionView.addSubview(refreshControl)
          }
        
    }
    
    @objc private func handleRefresh() {
      // Kick off your data reload
      chatManager.getLatestChats()
      
      // After your data’s fetched, update UI and end refreshing:
      DispatchQueue.main.async {
        self.reloadView()                  // reloads & hides “no messages”
        self.refreshControl.endRefreshing()
      }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        chatManager.chatDelegate = nil
        
        notificationBottomAnchor = nil
    }
    
    deinit {
        chatManager.chatDelegate = nil
        notificationBottomAnchor = nil
    }
    
    func checkPermission() {
        AVCaptureDevice.requestAccess(for: .audio) { audioGranted in
            if audioGranted {
                self.userDefaults.set(true, forKey: "AudioPermission")
            }
        }
    }
    
    func setupStuff() {
        chatCollectionView.leftAnchor.constraint(equalTo: messageLabel.leftAnchor).isActive = true
        chatCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -13).isActive = true
        chatCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        chatCollectionView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10).isActive = true
        
        chatCollectionView.register(ChatCell.self, forCellWithReuseIdentifier: "ChatCell")
        
        noMsg.text = "No Messages"
        noMsg.font = UIFont(name: "HelveticaNeue-Medium", size: 28)
        noMsg.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noMsg.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        noMsg.isHidden = true
        if chats.count == 0 {
            noMsg.isHidden = false
            
        }
    }
    
    @objc func profilePage() {
        print("HomeViewController profilePage")
        let profileVC = ProfileViewController()
        profileVC.chatManager = chatManager
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @objc func searchPage() {
        let searchPage = SearchViewController()
        searchPage.modalTransitionStyle = .coverVertical
        searchPage.modalPresentationStyle = .popover
//        self.navigationController?.pushViewController(searchPage, animated: true)
        self.present(searchPage, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 97) //height + 12
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        chats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 13
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 13
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatCell", for: indexPath) as! ChatCell
        let index = chats.count - 1 - indexPath.row
        print("updaing the chattableview: \(chats[indexPath.row].chatId)")
        cell.chatName.text = chats[index].chatName
        cell.lastMessage.text = chats[index].lastMessage
        cell.lastDate.text = timeConvert(date: (chats[index].lastDelivered ?? chats[index].createDate) ?? Date())
        if chats[index].lastSeen == nil {
            cell.missedCircle.isHidden = false
        } else {
            cell.missedCircle.isHidden = chats[index].lastSeen! > chats[index].lastDelivered ?? chats[index].createDate ?? Date()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.section)
        let index = chats.count - 1 - indexPath.row
        print("HomeViewController: didselectitemat select row: \(index)")
        let chatView = ChatViewController()
//        chatView.chatManager = chatManager
        chatView.chatRoom = chats[index]
//        self.navigationController?.pushViewController(chatView, animated: true)
//        chatView.modalPresentationStyle = .fullScreen
//
//        present(chatView, animated: true)
        
        ////somehting new
//        let transition = CATransition()
//        transition.duration = 0.3
//        transition.type = CATransitionType.push
//        transition.subtype = CATransitionSubtype.fromRight
//        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
//        view.window!.layer.add(transition, forKey: kCATransition)
//        present(chatView, animated: false, completion: nil)
        navigationController?.pushViewController(chatView, animated: true)
    }
    
    func timeConvert(date: Date) -> String {
        let source_offset = source_tz!.secondsFromGMT(for: date)
        let dest_offset = local_tz.secondsFromGMT(for: date)
        let time_interval: TimeInterval = Double(dest_offset - source_offset)
        return df.string(from: Date(timeInterval: time_interval, since: date))
    }
    
    func reloadView() {
        DispatchQueue.main.async {
            if self.chats.count == 0 {
                self.noMsg.isHidden = false
            } else {
                self.noMsg.isHidden = true
            }
            self.chatCollectionView.reloadData()
//            let indexPath = IndexPath(row: self.chats.count - 1, section: 0)
//            self.chatTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
}

extension HomeViewController: ChatDelegate {
    func didResolveError() {
        print("HomeViewController Error Resolved")
        if notificationOpen {
            self.notificationBottomAnchor.isActive = false
            self.notificationBottomAnchor.constant = 40
            self.notificationBottomAnchor.isActive = true
            UIView.animate(withDuration: 0.5, delay: 1.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }) { complete in
                self.notificationOpen = false
            }
        }
    }
    
    func openOldChat(chatRoom: ChatRoom) {
        
        
        guard let child = self.presentedViewController else {
            // nothing to dismiss
            return
        }
        
        // 1) Dismiss the current child without animation
        child.dismiss(animated: false) {
            // 2) Configure the new chat VC
            let chatView = ChatViewController()
//            chatView.chatManager = self.chatManager
            chatView.chatRoom    = chatRoom
            self.navigationController?.pushViewController(chatView, animated: true)
            
        }
    }
    
    
    func invalidToken() {
        print("HomeViewController: invalidToken ")
        DispatchQueue.main.async {
            self.navigationController?.setViewControllers([ViewController()], animated: true)
        }
    }
    
    func incomingMsg(chatId: Int64) {
        print("HomeViewController incomingMsg sorting")
        var firstChat:ChatRoom?
        for i in 0..<chats.count {
            if chats[i].chatId == chatId {
                firstChat = chats.remove(at: i)
                break
            }
        }
        if firstChat != nil {
            chats.append(firstChat!)
        }
        reloadView()
    }

    func didErrorHappen(msg: String) {
        
        print("Soemthing happened in HomeViewController")
        notificationBottomAnchor.isActive = false
        notificationBottomAnchor.constant = -15
        notificationBottomAnchor.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }) { (complete) in
            self.notificationOpen = true
        }
    }

    func updateChats() {
        self.chats = chatManager.getChats()
        print("HomeViewController updateChats: \(self.chats.count)")
        reloadView()
    }


    func newChat(chatId: ChatRoom) {
        
        chats.append(chatId)
        reloadView()
//        self.incomingMsg(chatId: chatId.id)
    }
    func updateSeen() {
        chats.sort { chat1, chat2 in
            if chat1.lastDelivered! < chat1.lastDelivered! {
                return true
            }
            return false
        }
        reloadView()
    }

}
