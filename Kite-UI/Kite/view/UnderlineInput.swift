//
//  UnderlineInput.swift
//  Kite
//
//  Created by Adam on 7/30/22.
//

import UIKit

class UnderlineInput: UITextField{
    
    fileprivate let defaultUnderlineColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)
    fileprivate let activeUnderlineColor = UIColor(red: 0/255, green: 86/255, blue: 253/255, alpha: 1.0)
    fileprivate let bottomLine = UIView()
    fileprivate var bottomLineRight: NSLayoutConstraint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        borderStyle = .none
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.backgroundColor = defaultUnderlineColor
        
        self.addSubview(bottomLine)
        bottomLine.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        bottomLine.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        bottomLineRight = bottomLine.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        bottomLineRight?.isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 4).isActive = true
        font = UIFont(name: "Arial", size: 25)
        
    }
    
    func isSelected() {
        if self.text == "" {
            bottomLineRight?.isActive = false
            bottomLineRight = bottomLine.trailingAnchor.constraint(equalTo: self.leadingAnchor)
            bottomLineRight?.isActive = true
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            } completion: { _ in
                self.bottomLineRight?.isActive = false
                self.bottomLineRight = self.bottomLine.trailingAnchor.constraint(equalTo: self.trailingAnchor)
                self.bottomLineRight?.isActive = true
                self.bottomLine.backgroundColor = self.activeUnderlineColor
                UIView.animate(withDuration: 0.3) {
                    self.layoutIfNeeded()
                }

            }

        }
    }
    
    func deSelected() {
        self.text = self.text?.trimmingCharacters(in: .whitespaces)
        if self.text == "" {
            bottomLineRight?.isActive = false
            bottomLineRight = bottomLine.trailingAnchor.constraint(equalTo: self.leadingAnchor)
            bottomLineRight?.isActive = true
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            } completion: { _ in
                self.bottomLineRight?.isActive = false
                self.bottomLineRight = self.bottomLine.trailingAnchor.constraint(equalTo: self.trailingAnchor)
                self.bottomLineRight?.isActive = true
                self.bottomLine.backgroundColor = self.defaultUnderlineColor
                UIView.animate(withDuration: 0.3) {
                    self.layoutIfNeeded()
                }
            }

        }
    }
    
    
}
