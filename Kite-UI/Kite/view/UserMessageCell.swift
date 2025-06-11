//
//  MessageCell.swift
//  chat01
//
//  Created by Adam Chao on 8/14/20.
//  Copyright © 2020 Adam Chao. All rights reserved.
//

import UIKit

class UserMessageCell: UITableViewCell, TimestampRevealable {

    
    let bubble = UIView()
    let message = UILabel()
    let timestampLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        bubble.translatesAutoresizingMaskIntoConstraints = false
        message.translatesAutoresizingMaskIntoConstraints = false
        print("user message cell")
        contentView.addSubview(bubble)
        print("width: \(contentView.frame.width)")
        
        //backgroundColor = UIColor.orange
        selectionStyle = .none
        bubble.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        bubble.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        bubble.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        bubble.widthAnchor.constraint(lessThanOrEqualToConstant: contentView.frame.width * 0.75).isActive = true
        bubble.clipsToBounds = true
        bubble.layer.cornerRadius = 20
        bubble.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner]
        bubble.backgroundColor = Constants.BaseColor
        bubble.addSubview(message)
        
        message.leftAnchor.constraint(equalTo: bubble.leftAnchor, constant: 15).isActive = true
        message.rightAnchor.constraint(equalTo: bubble.rightAnchor, constant: -15).isActive = true
        message.topAnchor.constraint(equalTo: bubble.topAnchor, constant: 10).isActive = true
        message.bottomAnchor.constraint(equalTo: bubble.bottomAnchor, constant: -10).isActive = true
        
        message.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        message.text = "sld"
        message.textColor = UIColor.white
        message.numberOfLines = 0
        bubble.contentMode = .scaleToFill
        message.textAlignment = .left
        
        
        
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
        contentView.insertSubview(timestampLabel, belowSubview: bubble)

        // 2) Pin its leading edge to the cell’s trailing edge
        timestampLabel.leadingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        // 3) Center it on the same y-axis as your bubble
        timestampLabel.centerYAnchor.constraint(equalTo: bubble.centerYAnchor).isActive = true
        // 4) Let its intrinsic content size drive its width
        timestampLabel.widthAnchor.constraint(equalToConstant: timestampLabel.intrinsicContentSize.width).isActive = true
    }
    
    
    func revealTimestamp(by offset: CGFloat) {
        
        let maxOffset = timestampLabel.bounds.width + 10
        let x = min(offset, maxOffset)
        bubble.transform = CGAffineTransform(translationX: -x, y: 0)
        timestampLabel.transform = CGAffineTransform(translationX: -x, y: 0)
    }
    
    func resetTimestamp() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 1,
            options: .curveEaseOut
        ) {
            self.bubble.transform = .identity
            self.timestampLabel.transform = .identity
        }
    }
    
    func setNotLast() {
        bubble.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
