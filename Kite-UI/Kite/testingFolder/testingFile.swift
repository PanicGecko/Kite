////
////  testingFile.swift
////  Kite
////
////  Created by Adam on 7/12/24.
////
//
//import Foundation
//
//
//func setURL(urls: [String]) {
//    print("ImageMessageCell: setURL photo count: \(urlList.count)")
//    urlList = urls
//    imageViewList = [:]
//    for i in 0..<urlList.count {
//        imageViewList.append(UIImageView())
//        imageViewList[i].backgroundColor = UIColor.red
//        imageViewList[i].layer.cornerRadius = 15
//        imageViewList[i].translatesAutoresizingMaskIntoConstraints = false
//        imageViewList[i].contentMode = .scaleAspectFill
//        contentView.addSubview(imageViewList[i])
//        if isSelf {
//            imageViewList[i].rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30).isActive = true
//        } else {
//            imageViewList[i].leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30).isActive = true
//        }
//        if urlList.count == 1 {
//            print("ImageMessageCell: only one message")
//            imageViewList[i].topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
//            imageViewList[i].widthAnchor.constraint(equalToConstant: contentView.frame.width / 2).isActive = true
//            imageViewList[i].heightAnchor.constraint(equalToConstant: contentView.frame.width).isActive = true
//            break
//        }
//        imageViewList[i].widthAnchor.constraint(equalToConstant: (contentView.frame.width / 2)).isActive = true
//        imageViewList[i].heightAnchor.constraint(equalToConstant: contentView.frame.width - 20).isActive = true
//        if (i % 2) == 0 {
//            imageViewList[i].rotate(degrees: CGFloat(Float.random(in: 5..<12)))
//        } else {
//            imageViewList[i].rotate(degrees: CGFloat(-Float.random(in: 5..<15)))
//        }
//        if i == 0 {
//            imageViewList[i].topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
//        } else {
//            imageViewList[i].topAnchor.constraint(equalTo: imageViewList[i - 1].bottomAnchor, constant: -20).isActive = true
//        }
//    }
//    if urlList.count > 0 {
//        contentView.bottomAnchor.constraint(equalTo: imageViewList.last!.bottomAnchor, constant: 10).isActive = true
////            imageViewList.last!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 10).isActive = true
//    }
//    getImages()
//}
