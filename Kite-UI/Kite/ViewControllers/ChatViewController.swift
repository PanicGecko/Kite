//
//  ChatViewController.swift
//  chat01
//
//  Created by Adam Chao on 8/14/20.
//  Copyright © 2020 Adam Chao. All rights reserved.
//

import UIKit
import AVFoundation
import PhotosUI

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, AVAudioRecorderDelegate, UIGestureRecognizerDelegate {
    let userDefaults = UserDefaults.standard
    var messages: [Message] = []
    var chatId: Int?
    
    let chatsView = UITableView()
    
    private var chatManager = ChatManager.shared
    
    var chatRoom: ChatRoom? {
        didSet {
            
            if chatManager == nil {
                print("ChatViewController chatManager is missing")
                return
            }
            if chatRoom == nil {
                print("ChatViewController chatRoom is missing")
                return
            }
            print("ChatViewController chatRoom didset: \(chatRoom?.chatId)")
            
        }
    }
    
    var insertIndex = 0
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let textView = UIView()
    let textBox = UITextView(frame: CGRect.zero)
    let sendButton = UIButton()
    let cameraButton = UIView()
    let cameraImage = UIImageView(image: UIImage(named: "camera"))
    let micButton = UIView()
    let micImage = UIImageView(image: UIImage(named: "microphone"))

    let maxHeight: CGFloat = 100
    
    var chatViewTopAnchor: NSLayoutConstraint?
    var chatTitleTopAnchor: NSLayoutConstraint?
    var textBoxBottomAnchor: NSLayoutConstraint?
    
    let chatTitle = UILabel()
    let backButton = UIImageView(image: UIImage(named: "backButton"))
    let editButton = UILabel()
    
    //recording view
    let voiceButton = UIView()
    let recordingView = UIView()
    
    fileprivate let firstOne = UIView()
    fileprivate let secondOne = UIView()
    fileprivate let thirdOne = UIView()
    fileprivate let fourthOne = UIView()
    fileprivate let fithOne = UIView()
    
    var firstHt: NSLayoutConstraint?
    var secHt: NSLayoutConstraint?
    var thirdHt: NSLayoutConstraint?
    var fourHt: NSLayoutConstraint?
    var fithHt: NSLayoutConstraint?
    
    var voiceWidth: NSLayoutConstraint?
    var voiceHeight: NSLayoutConstraint?
    var bWdith: NSLayoutConstraint?
    var bHeight: NSLayoutConstraint?
    
    fileprivate lazy var views: [UIView] = [
        firstOne,
        secondOne,
        thirdOne,
        fourthOne,
        fithOne
    ]
    
    
    let theWid: CGFloat = 26
    let theSpace: CGFloat = 10
    
    
    let userId = Int64(KeychainWrapper.standard.integer(forKey: "userId")!)
    
    //Audio Setup
    var audioRecorder: AVAudioRecorder?
    var audioSession: AVAudioSession?
    var isRecording = false
    var isPlaying = false
    var playingRow = -1
    var displayLink: CADisplayLink?
    
    var widthConstraint: NSLayoutConstraint!
    var heightConstraint: NSLayoutConstraint!
    
    var animating = false {
        didSet {
            displayLink?.isPaused = !animating
        }
    }
    
    let warningView = UIView()
    let warningLabel = UILabel()
    
    //Image Picker
    var photoConfig: PHPickerConfiguration = {
       var config = PHPickerConfiguration()
        config.selectionLimit = 5
        config.filter = .any(of: [.images])
        return config
    }()
    var picker: PHPickerViewController?
    
    //Notification
    let notification = UIView()
    var notificationOpen = false
    var notificationBottomAnchor: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        chatsView.delegate = self
        chatsView.dataSource = self
        textBox.delegate = self
        chatManager.messageDelegate = self
        chatManager.messageDelegate = self
        chatManager.getDelMessagesByChatRoom(chatRoom: chatRoom!)
        view.backgroundColor = UIColor.white
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        chatsView.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textBox.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        chatTitle.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        micButton.translatesAutoresizingMaskIntoConstraints = false
        cameraImage.translatesAutoresizingMaskIntoConstraints = false
        micImage.translatesAutoresizingMaskIntoConstraints = false
        
//        view.addSubview(textView)
        view.addSubview(backButton)
        view.addSubview(chatTitle)
        view.addSubview(editButton)
        view.addSubview(textView)
        view.addSubview(chatsView)
        
        chatTitle.textAlignment = .center
        chatTitle.text = chatRoom?.chatName
        chatTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        chatTitleTopAnchor = chatTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5)
        chatTitleTopAnchor?.isActive = true
        chatTitle.font = UIFont(name: Constants.Font_Name, size: 50)
        
        backButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        backButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        backButton.topAnchor.constraint(equalTo: chatTitle.topAnchor).isActive = true
        backButton.isUserInteractionEnabled = true
        backButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goBack)))
        
        editButton.text = "EDIT"
        editButton.font = UIFont(name: Constants.Font_Name, size: 20)
        editButton.textAlignment = .center
        editButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        editButton.topAnchor.constraint(equalTo: chatTitle.topAnchor).isActive = true
        
        textView.addSubview(textBox)
        textView.addSubview(sendButton)
        textView.addSubview(cameraButton)
        textView.addSubview(micButton)
        micButton.addSubview(micImage)
        cameraButton.addSubview(cameraImage)
        
//        textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        
        
        
        sendButton.rightAnchor.constraint(equalTo: textView.rightAnchor, constant: -12).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 55).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: textBox.bottomAnchor).isActive = true
        sendButton.layer.cornerRadius = 10
        sendButton.setTitle("Send", for: .normal)
//        sendButton.titleLabel?.text = "Send"
        sendButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        sendButton.backgroundColor = Constants.BaseColor
        sendButton.titleLabel?.textAlignment = .center
        sendButton.titleLabel?.textColor = UIColor.white
        sendButton.addTarget(self, action: #selector(self.sendPressed), for: .touchUpInside)
        
        textView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        textView.backgroundColor = UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 0.61)
        textView.layer.cornerRadius = 20
        textView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        textView.topAnchor.constraint(equalTo: textBox.topAnchor, constant: -8).isActive = true
        
        cameraButton.bottomAnchor.constraint(equalTo: textBox.bottomAnchor).isActive = true
        cameraButton.leftAnchor.constraint(equalTo: textView.leftAnchor, constant: 12).isActive = true
        cameraButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cameraButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        cameraButton.layer.cornerRadius = 10
        cameraButton.backgroundColor = UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1)
        cameraButton.isUserInteractionEnabled = true
        cameraButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageButton)))

        micButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        micButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        micButton.bottomAnchor.constraint(equalTo: textBox.bottomAnchor).isActive = true
        micButton.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -8).isActive = true
        micButton.layer.cornerRadius = 10
        micButton.backgroundColor = UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1)
        
        cameraImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        cameraImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        cameraImage.centerYAnchor.constraint(equalTo: cameraButton.centerYAnchor).isActive = true
        cameraImage.centerXAnchor.constraint(equalTo: cameraButton.centerXAnchor).isActive = true
        cameraImage.contentMode = .scaleAspectFit
        
        micImage.centerYAnchor.constraint(equalTo: micButton.centerYAnchor).isActive = true
        micImage.centerXAnchor.constraint(equalTo: micButton.centerXAnchor).isActive = true
        micImage.heightAnchor.constraint(equalToConstant: 22).isActive = true
        micImage.contentMode = .scaleAspectFit
        
//
//        textBox.font = UIFont(name: "Arial", size: 20)
//        textBox.clipsToBounds = true
//
        textBox.heightAnchor.constraint(equalToConstant: 40).isActive = true
        textBox.leftAnchor.constraint(equalTo: cameraButton.rightAnchor, constant: 8).isActive = true
        textBox.rightAnchor.constraint(equalTo: micButton.leftAnchor, constant: -8).isActive = true
        textBoxBottomAnchor = textBox.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        textBoxBottomAnchor?.isActive = true
        textBox.layer.cornerRadius = 10
        textBox.backgroundColor = UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1)
        textBox.text = "message..."
        textBox.textColor = UIColor.lightGray
        textBox.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        
//        textBox.contentInset = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)
        
        textBox.sizeToFit()
//        textBox.isScrollEnabled = true
        
        
    
//        textBox.backgroundColor = UIColor.black
        
//        view.addSubview(chatsView)
        chatsView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        chatsView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        chatsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        chatViewTopAnchor = chatsView.topAnchor.constraint(equalTo: chatTitle.bottomAnchor)
        chatViewTopAnchor?.isActive = true

        chatsView.bottomAnchor.constraint(equalTo: textView.topAnchor).isActive = true
        
        chatsView.register(UserMessageCell.self, forCellReuseIdentifier: "UserCell")
        chatsView.register(OtherMessageCell.self, forCellReuseIdentifier: "OtherCell")
        chatsView.register(UserAudioMessageCell.self, forCellReuseIdentifier: "UserAudioCell")
        chatsView.register(ImageMessageCell.self, forCellReuseIdentifier: "ImageCell")
        chatsView.rowHeight = UITableView.automaticDimension
        chatsView.separatorStyle = .none
        chatsView.backgroundColor = UIColor.clear
        chatsView.keyboardDismissMode = .interactive


        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handleGlobalPan(_:)))
        pan.delegate = self
        chatsView.addGestureRecognizer(pan)
        
        
        //Recording stuff
        textView.addSubview(voiceButton)
        voiceButton.translatesAutoresizingMaskIntoConstraints = false
        voiceButton.centerXAnchor.constraint(equalTo: micButton.centerXAnchor).isActive = true
        voiceButton.centerYAnchor.constraint(equalTo: micButton.centerYAnchor).isActive = true
        voiceWidth = voiceButton.widthAnchor.constraint(equalToConstant: 0)
        voiceHeight = voiceButton.heightAnchor.constraint(equalToConstant: 0)
        voiceWidth?.isActive = true
        voiceHeight?.isActive = true
        
        textView.bringSubviewToFront(micButton)
        
        view.addSubview(recordingView)
        recordingView.translatesAutoresizingMaskIntoConstraints = false
        recordingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        recordingView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        bWdith = recordingView.widthAnchor.constraint(equalToConstant: 0)
        bHeight = recordingView.heightAnchor.constraint(equalToConstant: 0)
        bWdith?.isActive = true
        bHeight?.isActive = true
        recordingView.layer.cornerRadius = 15
        recordingView.backgroundColor = Constants.BaseColor
        
        views.forEach { i in
            recordingView.addSubview(i)
            i.translatesAutoresizingMaskIntoConstraints = false
            i.widthAnchor.constraint(equalToConstant: CGFloat(theWid)).isActive = true
            i.centerYAnchor.constraint(equalTo: recordingView.centerYAnchor).isActive = true
            i.layer.cornerRadius = 13
            i.backgroundColor = UIColor.white
            i.isHidden = true
        }
        thirdOne.centerXAnchor.constraint(equalTo: recordingView.centerXAnchor).isActive = true
        secondOne.rightAnchor.constraint(equalTo: thirdOne.leftAnchor, constant: -theSpace).isActive = true
        firstOne.rightAnchor.constraint(equalTo: secondOne.leftAnchor, constant: -theSpace).isActive = true
        fourthOne.leftAnchor.constraint(equalTo: thirdOne.rightAnchor, constant: theSpace).isActive = true
        fithOne.leftAnchor.constraint(equalTo: fourthOne.rightAnchor, constant: theSpace).isActive = true
        
        firstHt = firstOne.heightAnchor.constraint(equalToConstant: theWid)
        firstHt?.isActive = true
        
        secHt = secondOne.heightAnchor.constraint(equalToConstant: theWid)
        secHt?.isActive = true
        
        thirdHt = thirdOne.heightAnchor.constraint(equalToConstant: theWid)
        thirdHt?.isActive = true
        
        fourHt = fourthOne.heightAnchor.constraint(equalToConstant: theWid)
        fourHt?.isActive = true
        
        fithHt = fithOne.heightAnchor.constraint(equalToConstant: theWid)
        fithHt?.isActive = true
        
        
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
        
        
        
        //Audio Setup
        if userDefaults.bool(forKey: "AudioPermission") {
            setupBubbleView()
        }

        //Image setup
        picker = PHPickerViewController(configuration: photoConfig)
        picker?.delegate = self
        
    }

    func gestureRecognizer(_ g: UIGestureRecognizer,
                             shouldRecognizeSimultaneouslyWith other: UIGestureRecognizer)
                             -> Bool {
        return true
      }
    
    @objc private func handleGlobalPan(_ g: UIPanGestureRecognizer) {
        let translationX = g.translation(in: view).x
          // we only care about left-swipes → positive offset
          let offset = max(0, -translationX)

          switch g.state {
          case .changed:
            // apply the same offset to every visible TimestampRevealable cell
              for case let cell as TimestampRevealable in chatsView.visibleCells {
              cell.revealTimestamp(by: offset)
            }

          case .ended, .cancelled:
            // spring them all back
              for case let cell as TimestampRevealable in chatsView.visibleCells {
              cell.resetTimestamp()
            }

          default: break
          }
      }
    
    

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if chatRoom != nil {
            chatManager.setChatLastSeen(chatroom: chatRoom!)
        }
        print("ChatViewController CLOSED")
        displayLink?.invalidate()
        displayLink = nil
        chatManager.messageDelegate = nil
        audioRecorder?.delegate = nil
        picker?.delegate = nil
        NotificationCenter.default.removeObserver(self)
        notificationBottomAnchor = nil
    }
    
    deinit {
        displayLink?.invalidate()
        displayLink = nil
        chatManager.messageDelegate = nil
        audioRecorder?.delegate = nil
        picker?.delegate = nil
        NotificationCenter.default.removeObserver(self)
        notificationBottomAnchor = nil
        print("🔥 ChatViewController deinit")
    }
    
    
    func setupBubbleView() {
        warningView.translatesAutoresizingMaskIntoConstraints = false
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(warningView)
        warningView.addSubview(warningLabel)
        warningView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        warningView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        warningLabel.centerXAnchor.constraint(equalTo: warningView.centerXAnchor).isActive = true
        warningLabel.centerYAnchor.constraint(equalTo: warningView.centerYAnchor).isActive = true
        warningLabel.font = UIFont(name: Constants.Font_Family, size: 20)
        warningLabel.text = "Hold to record"
        warningView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        warningView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        warningView.isHidden = true
        
        micButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(micTapped)))
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleMic))
        longPress.minimumPressDuration = 0.5
        micButton.addGestureRecognizer(longPress)
        
       
//        widthConstraint.isActive = true
//        heightConstraint.isActive = true
        
        setupDisplayLink()
        setupRecorder()
        
    }
    
    func setupRecorder() {
        do {
            audioSession = AVAudioSession.sharedInstance()
            try audioSession?.setCategory(.playAndRecord)
//            try audioSession?.setActive(true)
            audioRecorder = try AVAudioRecorder.init(url: Constants.RecordFileURL!, settings: [AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC as UInt32),
                                                                                             AVSampleRateKey: 44100.0,
                                                                                             AVNumberOfChannelsKey: 2 ])
            
        } catch {
            print("ChatViewController: setupRecorder: something wrong: \(error)")
            return
        }
        audioRecorder!.delegate = self
        audioRecorder!.isMeteringEnabled = true
        audioRecorder!.prepareToRecord()
    }
    
    @objc func micTapped() {
        print("ChatViewControlller: micTapped")
        
        if !userDefaults.bool(forKey: "AudioPermission") {
            if !checkPermission() {
                return
            }
        }
        
        UIView.transition(with: warningView, duration: 1, options: .transitionCrossDissolve) {
            self.warningView.isHidden = false
        } completion: { com in
            UIView.animate(withDuration: 1) {
                self.warningView.alpha = 0
            } completion: { comp in
                self.warningView.isHidden = true
            }

        }
        
    }
    
    func setupDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateWaveForm))
        displayLink?.add(to: .main, forMode: .common)
        animating = false
    }
    
    
    
    @objc func updateWaveForm() {
        audioRecorder?.updateMeters()
        print("ChatViewController: amplitude: \(audioRecorder?.averagePower(forChannel: 0) ?? 0)")
        let newValue = (audioRecorder?.averagePower(forChannel: 0) ?? 0) + 180
        let newSize:CGFloat = CGFloat(min(newValue / 40, 8))
        
        print("ChatViewController: newSize value: \(newSize)")
        UIView.animate(withDuration: 0.1) {
            self.firstHt?.isActive = false
            self.secHt?.isActive = false
            self.thirdHt?.isActive = false
            self.fourHt?.isActive = false
            self.fithHt?.isActive = false

            self.firstHt = self.firstOne.heightAnchor.constraint(equalToConstant: max(self.theWid, (newSize * 0.35)))
            self.secHt = self.secondOne.heightAnchor.constraint(equalToConstant: max(self.theWid, (newSize * 0.65)))
            self.thirdHt = self.thirdOne.heightAnchor.constraint(equalToConstant: max(self.theWid, newSize))
            self.fourHt = self.fourthOne.heightAnchor.constraint(equalToConstant: max(self.theWid, (newSize * 0.65)))
            self.fithHt = self.fithOne.heightAnchor.constraint(equalToConstant: max(self.theWid, (newSize * 0.35)))

            self.firstHt?.isActive = true
            self.secHt?.isActive = true
            self.thirdHt?.isActive = true
            self.fourHt?.isActive = true
            self.fithHt?.isActive = true

            self.view.layoutIfNeeded()

        }
    }
    
    @objc func handleMic(gesture: UILongPressGestureRecognizer) {
        print("ChatViewControlller: longpressed::::")
        
        if !userDefaults.bool(forKey: "AudioPermission") {
            if !checkPermission() {
                return
            }
        }
        
        switch gesture.state {
        case .began:
            
            voiceWidth?.isActive = false
            voiceHeight?.isActive = false
            
            bWdith?.isActive = false
            bHeight?.isActive = false
            
            view.bringSubviewToFront(voiceButton)
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.0) {
                self.voiceWidth = self.voiceButton.widthAnchor.constraint(equalToConstant: 40)
                self.voiceHeight = self.voiceButton.heightAnchor.constraint(equalToConstant: 40)
                
                self.bWdith = self.recordingView.widthAnchor.constraint(equalToConstant: 200)
                self.bHeight = self.recordingView.heightAnchor.constraint(equalToConstant: 150)
                
//                self.widthConstraint!.isActive = true
//                self.heightConstraint!.isActive = true
                self.bWdith?.isActive = true
                self.bHeight?.isActive = true
                
                self.views.forEach { i in
                    i.isHidden = false
                }
                
                self.view.layoutIfNeeded()
            }
            
            print("ChatViewController: handleMic gesture state began")
            startRecording()
            break
        case .ended:
            voiceWidth?.isActive = false
            voiceHeight?.isActive = false
            
            bWdith?.isActive = false
            bHeight?.isActive = false
            
            view.bringSubviewToFront(voiceButton)
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.0) {
                self.voiceWidth = self.voiceButton.widthAnchor.constraint(equalToConstant: 0)
                self.voiceHeight = self.voiceButton.heightAnchor.constraint(equalToConstant: 0)
                
                self.bWdith = self.recordingView.widthAnchor.constraint(equalToConstant: 0)
                self.bHeight = self.recordingView.heightAnchor.constraint(equalToConstant: 0)
                
//                self.widthConstraint!.isActive = true
//                self.heightConstraint!.isActive = true
                self.bWdith?.isActive = true
                self.bHeight?.isActive = true
                
                self.views.forEach { i in
                    i.isHidden = true
                }
                
                self.view.layoutIfNeeded()
            }
            print("ChatViewController: handleMic gesture state ended")
            stopRecording()
            break
        default:
            break
        }
    }
    
    func startRecording() {
        if audioRecorder == nil {
            return
        }
        if isPlaying {
            let cell = chatsView.cellForRow(at: IndexPath(index: playingRow)) as! UserAudioMessageCell
            cell.stopPlaying()
        }
        if !audioRecorder!.isRecording {
            do {
                try audioSession?.setActive(true)
            } catch {
                print("ChatViewController: startRecording audiosession wrong: \(error)")
            }
            audioRecorder?.record()
            animating = true
        }
    }
    
    
    
    func stopRecording() {
        if let recorder = audioRecorder {
            if recorder.isRecording {
                audioRecorder?.stop()
                animating = false
                do {
                    try audioSession?.setActive(false)
                } catch {
                    print("ChatViewController: stopRecording audiosession wrong: \(error)")
                }
            }
            do {
                let data = try Data(contentsOf: Constants.RecordFileURL!)
//                chatManager?.sendMessage(msg: "", chatId: Int(chatRoom!.chatId), msgType: 1, audio: data)
                chatManager.sendVoice(voice: data, chatId: Int(chatRoom!.chatId), voiceName: UUID().uuidString)
                try Data().write(to: Constants.RecordFileURL!)
            } catch {
                print("ChatViewController: stopRecording getting data wrong: \(error)")
            }
        }
    }
    
    func checkPermission() -> Bool {
        var flag = false
        AVCaptureDevice.requestAccess(for: .audio) { [weak self] audioGranted in guard let self = self else { return }
            if audioGranted {
                self.userDefaults.set(true, forKey: "AudioPermission")
                self.setupBubbleView()
                flag = true
            }
            flag = false
        }
        return flag
    }
    
    var viewTranslation = CGPoint(x: 0, y: 0)
    
    
//    @objc func handleDismiss(sender: UIPanGestureRecognizer) {
//        switch sender.state {
//        case .changed:
//            viewTranslation = sender.translation(in: view)
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
//                self.view.transform = CGAffineTransform(translationX: self.viewTranslation.x, y: 0)
//            }
//        case .ended:
//            if viewTranslation.x < 150 {
//                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1,options: .curveEaseOut) {
//                    self.view.transform = .identity
//                }
//            } else {
//                self.dismiss(animated: false)
//            }
//        default:
//            break
//        }
//    }
    
    @objc func imageButton() {
        print("ChatViewController: imageButtion hit")
        present(picker!, animated: true)
    }

    
    @objc func goBack() {
        chatManager.updateLastSeen(chatRoom: chatRoom!)
        self.navigationController?.popViewController(animated: true)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
//        let size = CGSize(width: textView.frame.size.width, height: .infinity)
//        let estimatedSize = textView.sizeThatFits(size)
//        guard textView.contentSize.height < 100.0 else {
//            textView.isScrollEnabled = true
//            return
//        }
//        textView.isScrollEnabled = false
//        textView.constraints.forEach { (constraint) in
//            if constraint.firstAttribute == .height {
//                constraint.constant = estimatedSize.height
//            }
//        }
    
        print("textviewchangeselection")
    }
    
    
    
    
//    func textViewDidChange(_ textView: UITextView) {
//        if textView.contentSize.height >= maxHeight {
//            isOversized = true
//        }
//    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "message..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        print("line heaight \(textBox.lineheight())")
        let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
        if textView.contentSize.height >= maxHeight {
            textBox.isScrollEnabled = true
        } else {
            textBox.isScrollEnabled = false
            textBox.setNeedsUpdateConstraints()
//            chatsView.setContentOffset(CGPoint(x: 0, y: chatsView.contentSize.height - chatsView.bounds.size.height), animated: false)
//            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
//            self.chatsView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
//    var currentLines = 1
//    func textViewDidChange(_ textView: UITextView) {
//        print("in textviewdidchange  \(textView.numberOfLines())")
//        if textView.numberOfLines() > currentLines {
//            currentLines = textView.numberOfLines()
//            if currentLines >= 8 {
//                textBox.isScrollEnabled = true
//            }
//            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
//            self.chatsView.scrollToRow(at: indexPath, at: .bottom, animated: true)
//        } else {
//            currentLines = textView.numberOfLines()
//        }
//    }
    
    @objc func sendPressed(sender: UIButton) {
        print("sendPressed")
        if textBox.text != "" {
            chatManager.sendMessage(msg: textBox.text, chatId: Int(chatRoom!.chatId))
            textBox.text = ""
            
            DispatchQueue.main.async {
                    print("ChatViewController sendPressed")
                    self.chatsView.reloadData()
                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                    self.chatsView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                        }
        }
    }
    
    
    
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(false)
//        self.chatsView.reloadData()
//        DispatchQueue.main.async {
//                        print("dispat dlsk")
//
//                        let indexPath = IndexPath(row: self.messages!.count - 1, section: 0)
//                        self.chatsView.scrollToRow(at: indexPath, at: .bottom, animated: true)
//                    }
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("number of rows")
        return messages.count
    }
    
    func formattedRelativeDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.locale   = .current
        formatter.timeZone = .current

        // Time-only for today/yesterday
        formatter.dateFormat = "h:mm a"

        if calendar.isDateInToday(date) {
            return "Today " + formatter.string(from: date)
        }
        else if calendar.isDateInYesterday(date) {
            return "Yesterday " + formatter.string(from: date)
        }
        else {
            // Full date+time for anything older
            formatter.dateFormat = "MMMM d h:mm a"   // e.g. “June 7 3:14 PM”
            return formatter.string(from: date)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let msg = messages[indexPath.row]
        print("cell for row at \(indexPath.row)")
//        if messages[indexPath.row].from == KeychainWrapper.standard.integer(forKey: "userId")!{
//            let cell = chatsView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserMessageCell
//            cell.message.text = messages[indexPath.row].message
//            return cell
//        } else {
//            let cell = chatsView.dequeueReusableCell(withIdentifier: "OtherCell", for: indexPath) as! OtherMessageCell
//            cell.message.text = messages[indexPath.row].message
//
//            return cell
//        }
        //test
        if msg.msgType == 1 {
            if messages[indexPath.row].from == userId{
                let cell = chatsView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserMessageCell
                cell.message.text = messages[indexPath.row].message
                cell.setNotLast()
                if messages[indexPath.row].delivered == false {
                    cell.setTimestamp(time: "Not Deliverd")
                } else {
                    cell.setTimestamp(time: formattedRelativeDate(messages[indexPath.row].deliveredTime!))
                }
                
                return cell
            } else {
                let cell = chatsView.dequeueReusableCell(withIdentifier: "OtherCell", for: indexPath) as! OtherMessageCell
                cell.message.text = messages[indexPath.row].message
                if messages[indexPath.row].delivered == false {
                    cell.setTimestamp(time: "Not Deliverd")
                } else {
                    cell.setTimestamp(time: formattedRelativeDate(messages[indexPath.row].deliveredTime!))
                }
                return cell
            }
        } else if msg.msgType == 2 {
            print("ChatViewController: tableview is in audio cell")
            if messages[indexPath.row].from == userId{
                let cell = chatsView.dequeueReusableCell(withIdentifier: "UserAudioCell", for: indexPath) as! UserAudioMessageCell
                cell.setAudio(audioId: msg.message!)
                return cell
            } else {
                let cell = chatsView.dequeueReusableCell(withIdentifier: "UserAudioCell", for: indexPath) as! OtherAudioMessageCell
                cell.setAudio(audioId: msg.message!)
                return cell
            }
        } else {
            print("ChatViewController: tableview is in image cell")
            let cell = chatsView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageMessageCell
            
            let msg = messages[indexPath.row].message
            if msg == nil || msg == "" {
                print("chatViewController: tableview for image cell message is null")
            }
            if messages[indexPath.row].from == userId {
                cell.isSelf = true
            } else {
                cell.isSelf = false
            }
            if messages[indexPath.row].delivered == false {
                cell.timestampLabel.text = "Not Delivered Yet"
            } else {
                cell.timestampLabel.text = formattedRelativeDate(messages[indexPath.row].deliveredTime!)
            }
            cell.setURL(urls: messages[indexPath.row].message!.components(separatedBy: ","))
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("height for row at")
        return UITableView.automaticDimension
    }
    
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
//                self.view.frame.origin.y -= keyboardSize.height
                self.chatTitleTopAnchor?.isActive = false
                self.chatTitleTopAnchor = self.chatTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: keyboardSize.height + 5)
                self.chatTitleTopAnchor?.isActive = true
                self.textBoxBottomAnchor?.isActive = false
                self.textBoxBottomAnchor = textBox.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
                self.textBoxBottomAnchor?.isActive = true
                UIView.animate(withDuration: 0.4) {
                    self.view.frame.origin.y -= keyboardSize.height
                    self.view.layoutIfNeeded()
                }
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.chatTitleTopAnchor?.isActive = false
            self.chatTitleTopAnchor = self.chatTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5)
            self.chatTitleTopAnchor?.isActive = true
            self.textBoxBottomAnchor?.isActive = false
            self.textBoxBottomAnchor = textBox.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            self.textBoxBottomAnchor?.isActive = true
            UIView.animate(withDuration: 0.4) {
                self.view.frame.origin.y = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func reloadView() {
        DispatchQueue.main.async {
            self.chatsView.reloadData()
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.chatsView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
}

extension UITextView {
    func numberOfLines() -> Int {
        if let fontUnwrapped = self.font {
            return Int(self.contentSize.height / fontUnwrapped.lineHeight)
        }
        return 0
    }
    func lineheight() -> CGFloat {
        return self.font?.lineHeight ?? 0
    }
}

extension ChatViewController: MessageDelegate{
    
    func updateMsg(msg: Message) {
        print("ChatViewController udpateMsg")
        if messages.count == insertIndex {
            print("Something went wrong but insert anyways")
            messages.append(msg)
            insertIndex += 1
        } else {
            var index = -1
            for i in stride(from: messages.count - 1, through: 0, by: -1) {
                if messages[i].id == msg.id {
                    index = i
                    print("ChatViewController updateMSG found the element at: \(index) and i: \(i)")
                    break
                }
            }
            if index == -1 {
                print("ChatViewController messages does not have message to change to delivered")
            } else {
                messages.remove(at: index)
                messages.insert(msg, at: insertIndex)
                insertIndex += 1
            }
        }
        reloadView()
        
    }
    
    func newMessage(msg: Message, del: Bool) {
        
        if del { //incoming msg so we know its delivered
            if messages.count == insertIndex {
                messages.append(msg)
                insertIndex += 1
            } else {
                messages.insert(msg, at: insertIndex)
                insertIndex += 1
            }
        } else { //user sent message but not delivered
            messages.append(msg)
        }
        reloadView()
    }
    
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
    
    func didErrorHappen(msg: String) {
        print("ChatViewController didErrorHappen: \(msg)")
        notificationBottomAnchor.isActive = false
        notificationBottomAnchor.constant = -15
        notificationBottomAnchor.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }) { (complete) in
            self.notificationOpen = true
        }
    }
    
    func initMessages(del: [Message], undel: [Message]) {
        print("ChatViewController initMessages del: \(del.count), undel: \(undel.count)")
        insertIndex = del.count
        messages = del
        messages.append(contentsOf: undel)
        print("initMessages count: \(messages.count)")
        if messages.count > 0 {
            reloadView()
        }
        
    }
    
    
    
    
}
extension AVAudioPCMBuffer {
    func toData() -> Data {
        let channelCount = format.channelCount
        let channels = UnsafeBufferPointer(start: floatChannelData, count: Int(channelCount))
        let frameLength = AVAudioFrameCount(self.frameLength)
        
        let data = Data(bytes: channels.map { Data(bytes: $0, count: Int(frameLength) * MemoryLayout<Float>.size) }.joined())
        

        return data
    }
}

extension ChatViewController: PHPickerViewControllerDelegate {
    
    
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        if results.count < 1 {
            print("ChatViewController - picker no images selected")
            return
        }
        var photoData:[Data] = []
        for i in results.indices {
            let provider = results[i].itemProvider
            if provider.canLoadObject(ofClass: UIImage.self) {
                print("ChatViewController - picker - picked an image")
                provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in guard let self = self, let ui = image as? UIImage else { return }
                        if error != nil {
                            print("picker: error: \(error)")
                            return
                        }
                        if let theImage = image as? UIImage{
                            let imageData = theImage.jpegData(compressionQuality: 0.7) ??
                            nil
                            if imageData == nil {
                                print("ChatViewController - picker - getting image data gone wrong")
                                return
                            }
                            photoData.append(imageData!)
                            print("picker: photo appended: count: \(photoData.count)")
                            if i == results.count - 1 {
                                print("picker: last photo: count: \(photoData.count)")
                                self.chatManager.sendPhotos(photos: photoData, chatId: Int(self.chatRoom!.chatId))
                            }
                        } else {
                            print("picker: something gone wrong with photo data")
                        }
                    }
                
                
            }
        }
    }
}


