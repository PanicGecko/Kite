//
//  ImageMessageCell.swift
//  Kite
//
//  Created by Adam on 1/14/24.
//

import UIKit

class ImageMessageCell: UITableViewCell, TimestampRevealable {
    
    
    
    let chatManager = ChatManager.shared
    let decoder = JSONDecoder()
    var isSelf = false
    var imageViewList: [KiteImageView] = []
    var urlList: [String] = []
    let timestampLabel = UILabel()
    
    private var baseTransforms: [CGAffineTransform] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    
    func setURL(urls: [String]) {
        if !imageViewList.isEmpty {
            return
        }
        baseTransforms = []
        print("IMAGE CELL COUNT: \(urls.count)")
        urlList = urls
        for i in 0..<urlList.count {
            imageViewList.append(KiteImageView())
            contentView.addSubview(imageViewList[i])
            imageViewList[i].setImageFrom(urlList[i])
            imageViewList[i].layer.borderWidth = 1
            imageViewList[i].layer.borderColor = UIColor.black.cgColor
            imageViewList[i].layer.cornerRadius = 15
            imageViewList[i].translatesAutoresizingMaskIntoConstraints = false
            imageViewList[i].contentMode = .scaleAspectFill
            if isSelf {
                imageViewList[i].rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30).isActive = true
            } else {
                imageViewList[i].leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30).isActive = true
            }
            if i == 0 {
                imageViewList[i].topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
            } else {
                imageViewList[i].topAnchor.constraint(equalTo: imageViewList[i - 1].bottomAnchor, constant: -20).isActive = true
            }
            if urlList.count < 2 {
                print("ImageMessageCell: only one message")
//                imageViewList[i].topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
                imageViewList[i].widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5).isActive = true
                imageViewList[i].heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.75).isActive = true
            } else {
                imageViewList[i].widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5, constant: -20).isActive = true
                imageViewList[i].heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.75, constant: -20).isActive = true
                
//                imageViewList[i].heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9).isActive = true
                if (i % 2) == 0 {
                    imageViewList[i].rotate(degrees: CGFloat(Float.random(in: 5..<12)))
                } else {
                    imageViewList[i].rotate(degrees: CGFloat(-Float.random(in: 5..<15)))
                }
               
            }
            baseTransforms.append(imageViewList[i].transform)
            
        }
        if urlList.count > 0 {
            contentView.bottomAnchor.constraint(equalTo: imageViewList.last!.bottomAnchor, constant: 10).isActive = true

        }
        
        //Setup timestamp
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false
        timestampLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 12)
        timestampLabel.textColor = .black
        timestampLabel.textAlignment = .center
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
        if isSelf {
                    for (idx, iv) in imageViewList.enumerated() {
                        let base = baseTransforms[idx]
                        let translation = CGAffineTransform(translationX: -x, y: 0)
                        iv.transform = base.concatenating(translation)
                    }
                }
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
            if self.isSelf {
                            for (idx, iv) in self.imageViewList.enumerated() {
                                iv.transform = self.baseTransforms[idx]
                            }
                        }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        for i in imageViewList {
            i.removeFromSuperview()
            i.image = nil
        }
        imageViewList.removeAll()
        isSelf = false
        urlList.removeAll()
        baseTransforms.removeAll()
    }
    
}

extension UIImageView {

    
}
