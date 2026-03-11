//
//  UIViewController + Extension.swift
//  TODO
//
//  Created by Алеся Афанасенкова on 11.03.2026.
//

import UIKit
import JGProgressHUD

extension UIViewController {
    static let hud = JGProgressHUD(style: .dark)
    
    func showLoading(_ show: Bool) {
        view.endEditing(true)
        
        if show {
            UIViewController.hud.show(in: view)
        } else {
            UIViewController.hud.dismiss()
        }
    }
}
