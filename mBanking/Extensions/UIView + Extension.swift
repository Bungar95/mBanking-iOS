//
//  UIView + Extension.swift
//  mBanking
//
//  Created by Borna Ungar on 11.01.2022..
//
import UIKit
extension UIView {
    
    func addSubviews(views: UIView...){
        for view in views {
            addSubview(view)
        }
    }
}
