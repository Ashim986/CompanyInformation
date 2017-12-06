//
//  NavigationSupportingContent.swift
//  CompanyInformation
//
//  Created by ashim Dahal on 11/28/17.
//  Copyright © 2017 ashim Dahal. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}

extension UIViewController {
    
        func  setupNavigationStyle (){
            navigationController?.navigationBar.tintColor = .white
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.barTintColor = .lightRed
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        }
    
}
