//
//  NMBaseViewController.swift
//  NetmedsPMS
//
//  Created by Amal Mishra on 02/05/20.
//  Copyright © 2020 Amal Mishra. All rights reserved.
//

import UIKit

//This is the base view controller class, responsible for providing general functions like displaying alerts, loaders and toast messages.

class NMBaseViewController: UIViewController {
    
    var loaderOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

let loaderTag = 12313435

extension NMBaseViewController{
    
    //MARK:- UIAlert Controller handler
    
    func showAlert(message: String?) {
        showAlert(title: nmAlertTitle, message: message)
    }
    
    func showAlert(title: String?, message: String?) {
        showAlert(title: title, message: message, actionTitle: msgOk)
    }
    
    func showAlert(title: String?, message: String?, actionTitle: String?) {
        let action = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        let alert = createAlert(title: title, message: message, actions: [action])
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(message: String?, completion: (()->Void)?) {
        let action = UIAlertAction(title: msgOk, style: .default) { (alertAction) in
            if let completion = completion {
                completion()
            }
        }
        let alert = createAlert(title: nmAlertTitle, message: message, actions: [action])
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showAlertWithTwoOptions(
        message:String?,
        title: String?,
        postiveOption: String? = msgOk,
        negativeOption: String? = msgCancel,
        completion: ((_ isPositive: Bool )-> Void)?) {
        let useAction = UIAlertAction(title: postiveOption, style: .default) { (alertAction) in
            if let completion = completion {
                completion(true)
            }
        }
        let cancelAction = UIAlertAction(title: negativeOption, style: .default) { (alertAction) in
            if let completion = completion {
                completion(false)
            }
        }
        let alert = createAlert(title: title, message: message, actions: [useAction, cancelAction])
        self.present(alert, animated: true, completion: nil)
    }
    
    func createAlert(title: String?, message: String?, actions: [UIAlertAction]) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alert.addAction(action)
        }
        
        return alert
    }
    
    func showConfirmation(message:String, error:Error?){
        var message = message
        var title = msgSuccess
        if let error = error {
            title = msgError
            message = "\(msgError): \(error.localizedDescription)"
        }
        showAlert(title: title, message: message)
    }
    
    //MARK:- Toast
    
    func showToast(message: String, completion: (()->Void)?) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            alert.dismiss(animated: true, completion: {
                if let completion = completion {
                    completion()
                }
            })
        }
    }
    
    //MARK:- Loaders
    
    func showLoader(timeOut: TimeInterval = Double(kDefaultTimeOutInterval))
    {
        hideLoader()
        
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = false
            let activity = UIActivityIndicatorView(style: .large)
            activity.color = .black
            activity.tag = loaderTag
            activity.frame = CGRect(origin: self.view.center, size: CGSize(width: 0, height: 0))
            self.view.addSubview(activity)
            activity.startAnimating()
            self.loaderOn = true
            self.perform(#selector(self.hideLoader), with: nil, afterDelay: timeOut)
        }
    }
    
    @objc func hideLoader() {
        DispatchQueue.main.async {
            if let activity = self.view.viewWithTag(loaderTag) {
                self.loaderOn = false
                self.view.isUserInteractionEnabled = true
                activity.removeFromSuperview()
            }
        }
    }
}
