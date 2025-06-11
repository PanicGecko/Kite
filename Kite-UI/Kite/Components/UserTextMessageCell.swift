//
//  UserTextMessageCell.swift
//  Kite
//
//  Created by Adam on 9/10/23.
//

import UIKit

class UserTextMessageCell: UITableViewCell {
    
    let bubble = UIView()
    let message = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        bubble.translatesAutoresizingMaskIntoConstraints = false
        message.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(bubble)
        bubble.addSubview(message)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
