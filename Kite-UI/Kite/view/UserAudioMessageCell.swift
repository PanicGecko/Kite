//
//  MessageCell.swift
//  chat01
//
//  Created by Adam Chao on 8/14/20.
//  Copyright © 2020 Adam Chao. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftUI
import Combine



class UserAudioMessageCell: UITableViewCell, AVAudioPlayerDelegate, TimestampRevealable {

    let bubble = UIView()
    let button = UIView()
    let buttonImg = UIImageView()
    let playImage = UIImage(systemName: "play.fill")?.withTintColor(UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1), renderingMode: .alwaysOriginal)
    let pauseImage = UIImage(systemName: "pause.fill")?.withTintColor(UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1), renderingMode: .alwaysOriginal)
    let timeLabel = UILabel()
    var isPlaying = false
    var audio: Data?
    var audioPlayer: AVAudioPlayer?
    var contentURL: URL?
    var voiceId = ""
    
    let decoder = JSONDecoder()
    
    let timestampLabel = UILabel()
    
    private var dataTask: URLSessionDataTask?
    
    var audioDuration: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        return formatter
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        bubble.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        print("user message cell")
        contentView.addSubview(bubble)
        print("width: \(contentView.frame.width)")
        
        //backgroundColor = UIColor.orange
        selectionStyle = .none
        bubble.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        bubble.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        bubble.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
//        bubble.widthAnchor.constraint(lessThanOrEqualToConstant: contentView.frame.width * 0.75).isActive = true
        bubble.heightAnchor.constraint(equalToConstant: 65).isActive = true
        bubble.clipsToBounds = true
        bubble.layer.cornerRadius = 20
        bubble.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner]
        bubble.backgroundColor = Constants.BaseColor
        bubble.addSubview(button)
        bubble.addSubview(timeLabel)
        bubble.backgroundColor = Constants.BaseColor
        
        button.centerYAnchor.constraint(equalTo: bubble.centerYAnchor).isActive = true
//        button.leftAnchor.constraint(equalTo: bubble.leftAnchor, constant: 15).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.layer.cornerRadius = 20
        button.backgroundColor = UIColor.white
        
        
        timeLabel.centerYAnchor.constraint(equalTo: bubble.centerYAnchor).isActive = true
        timeLabel.rightAnchor.constraint(equalTo: bubble.rightAnchor, constant: -15).isActive = true
        timeLabel.textAlignment = .center
        timeLabel.numberOfLines = 0
        timeLabel.textColor = UIColor.white
        
        button.rightAnchor.constraint(equalTo: timeLabel.leftAnchor, constant: -15).isActive = true
        
        buttonImg.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(buttonImg)
        buttonImg.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        buttonImg.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        buttonImg.heightAnchor.constraint(equalToConstant: 21).isActive = true
        buttonImg.widthAnchor.constraint(equalToConstant: 21).isActive = true
        buttonImg.contentMode = .scaleAspectFit
        buttonImg.image = playImage
        
        button.isUserInteractionEnabled = true
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonTapped)))
        bubble.leftAnchor.constraint(equalTo: button.leftAnchor, constant: -15).isActive = true
        
        contentView.backgroundColor = UIColor.clear
        backgroundConfiguration = UIBackgroundConfiguration.clear()
        
    }
    
    func setTimestamp(time: String) {
        //Setup timestamp
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false
        timestampLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 12)
        timestampLabel.textColor = .black
        timestampLabel.textAlignment = .center
        timestampLabel.text = time
        contentView.insertSubview(timestampLabel, at: 0)

        // 2) Pin its leading edge to the cell’s trailing edge
        timestampLabel.leadingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        // 3) Center it on the same y-axis as your bubble
        timestampLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        // 4) Let its intrinsic content size drive its width
        timestampLabel.widthAnchor.constraint(equalToConstant: timestampLabel.intrinsicContentSize.width).isActive = true
    }
    
    func revealTimestamp(by offset: CGFloat) {
        let maxOffset = timestampLabel.bounds.width + 10
        let x = min(offset, maxOffset)
        timestampLabel.transform = CGAffineTransform(translationX: -x, y: 0)
        bubble.transform = CGAffineTransform(translationX: -x, y: 0)
    }
    
    func resetTimestamp() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 1,
            options: .curveEaseOut
        ) {
            self.timestampLabel.transform = .identity
            self.bubble.transform = .identity
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dataTask?.cancel()
        dataTask = nil
        audioPlayer?.stop()
        audioPlayer?.delegate = nil
        audioPlayer = nil
        isPlaying = false
        buttonImg.image = playImage
        timeLabel.text = nil
    }
    
    
    
    func setAudio(audioId: String) {
        dataTask?.cancel()
        self.voiceId = audioId
        let audioFile = Constants.VoiceDir.appendingPathComponent(self.voiceId + ".m4a")
        if !FileManager.default.fileExists(atPath: audioFile.path) {
            if let url = URL(string: Constants.ImageURL + "/getVoice/" + self.voiceId) {
                
                dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                    guard let self = self, let data = data, error == nil else { return }
                    
                    do {
                        let incoming = try self.decoder.decode(DtoImage.self, from: data)
                        if incoming.errorCode == "201" && incoming.data != nil {
                            print("UserAudioMessageCell - setAudio - got audio from server all good")
                            try incoming.data!.write(to: audioFile)
                            self.readyAudio(contentFile: audioFile)
                        } else {
                            print("UserAudioMessageCell- getImages error code not good")
                        }
                    } catch {
                        print("UserAudioMessageCell- getImages error \(error)")
                    }
                    
                    
                    
                    
                }
                
                dataTask?.resume()
            }
        } else {
            readyAudio(contentFile: audioFile)
        }
       
    }
    
    func readyAudio(contentFile: URL) {
        
        print("UserAudioMessageCell - readyAudio - start")
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            try audioPlayer = AVAudioPlayer(contentsOf: contentFile)
            audioPlayer?.prepareToPlay()
            audioPlayer?.delegate = self
        } catch {
            print("UserAudioMessageCell: AudioPlayer did not setup \(error.localizedDescription)")
            return
        }
        timeLabel.text = audioDuration.string(from: audioPlayer!.duration)
    }
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        buttonImg.image = playImage
    }
    
    @objc func buttonTapped() {
        print("UserAudioMeesageCell: buttonTapped")
        if audioPlayer == nil {
            print("UserAudioMessageCell: buttontapped audioplayer is not good")
            return
        }
        if isPlaying {
            isPlaying = false
            audioPlayer!.pause()
            buttonImg.image = playImage
        } else {
            isPlaying = true
            audioPlayer!.play()
            buttonImg.image = pauseImage
            
        }
    }
    
    func stopPlaying() {
        if audioPlayer == nil {
            print("UserAudioMessageCell: stopPlaying audioplayer is not good")
            return
        }
        isPlaying = false
        audioPlayer?.pause()
        buttonImg.image = playImage
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

