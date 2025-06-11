//
//  KiteImageView.swift
//  Kite
//
//  Created by Adam on 7/12/24.
//

import Foundation
import UIKit

class KiteImageView: UIImageView {
    
    func rotate(degrees:CGFloat){
        self.transform = CGAffineTransform(rotationAngle: degrees * CGFloat(M_PI/180))
    }
    
    private var activityIndicator: UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.black
        self.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        let centerX = NSLayoutConstraint(item: self,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: activityIndicator,
                                         attribute: .centerX,
                                         multiplier: 1,
                                         constant: 0)
        let centerY = NSLayoutConstraint(item: self,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: activityIndicator,
                                         attribute: .centerY,
                                         multiplier: 1,
                                         constant: 0)
        self.addConstraints([centerX, centerY])
        return activityIndicator
    }
    
    private var imgId: String?
    
    let chatManager = ChatManager.shared
    
    func setImageFrom(_ picId: String) {
        imgId = picId
        
        let imgData = chatManager.getImageById(imgId: self.imgId!)
        print("KiteImage - getImages name: from core data result: \(imgId)")
        
        if imgData != nil {
            print("KiteImageView - got photo from core data")
            self.image = UIImage(data: imgData!)
            self.clipsToBounds = true
            return
        }
        
        
        guard let url = URL(string: Constants.ImageURL + "/getImage/" + imgId!) else { return }
        
        
        let session = URLSession(configuration: .default)
        let activityIndicator = self.activityIndicator
        
        DispatchQueue.main.async {
            activityIndicator.startAnimating()
            
        }
        
        let downloadImageTask = session.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else { return }
            
            do {
                let incoming = try Constants.decoder.decode(DtoResponse.self, from: data)
                if incoming.errorCode == "201" {
                    print("KiteImageiew - getImage - fetched from online")
                    var picData = Data(base64Encoded: incoming.data!, options: .ignoreUnknownCharacters)!
                    DispatchQueue.main.async {[weak self] in
                                            var image = UIImage(data: picData)
                                            self?.image = nil
                                            self?.image = image
                        self?.clipsToBounds = true
                                            image = nil
                                        }
                    Task {
                        await self.chatManager.savePhoto(imgId:self.imgId!, photo: picData)
                    }
                } else {
                    print("KiteImageiew- getImages error code not good")
                }
            } catch {
                print("KiteImageiew- getImages error \(error)")
            }
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
            session.finishTasksAndInvalidate()
        }
        downloadImageTask.resume()
    }
    
}
