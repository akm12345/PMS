//
//  Extensions.swift
//  NetmedsPMS
//
//  Created by Amal Mishra on 02/05/20.
//  Copyright © 2020 Amal Mishra. All rights reserved.
//

import UIKit

//MARK:- IBDesignables
@IBDesignable class RoundView: UIView {}
@IBDesignable class RoundButton: UIButton {}
@IBDesignable class RoundLabel: UILabel {}

//MARK:- UITableView extension
extension UIView {
    @IBInspectable
    var cornerRadiusValue: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
         set {
             guard let uiColor = newValue else { return }
             layer.borderColor = uiColor.cgColor
         }
         get {
             guard let color = layer.borderColor else { return nil }
             return UIColor(cgColor: color)
         }
     }
    
    @IBInspectable var borderWidth: CGFloat {
           set {
               layer.borderWidth = newValue
           }
           get {
               return layer.borderWidth
           }
       }
}

//MARK:- UITableView extension
extension UITableView {
    
    /// This method is used to set a custom text message letting user know that the table view is empty.
    func setEmptyTableView(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = .systemFont(ofSize: 20)
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel
    }

    /// This method removes the background view and set it to nil
    func restore() {
        self.backgroundView = nil
    }
}


