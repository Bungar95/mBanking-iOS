//
//  UIViewController + Extension.swift
//  mBanking
//
//  Created by Borna Ungar on 11.01.2022..
//

import UIKit
extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showInfoAlert(alertText : String, alertMessage : String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: handler))
        self.present(alert, animated: true, completion: nil)
    }
}
