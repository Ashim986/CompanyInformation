//
//  UIViewController+Helper.swift
//  CompanyInformation
//
//  Created by ashim Dahal on 12/6/17.
//  Copyright © 2017 ashim Dahal. All rights reserved.
//

import UIKit

extension UIViewController {
    
        func  setupNavigationStyle (){
            navigationController?.navigationBar.tintColor = .white
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.barTintColor = .lightRed
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
 
    func setupLightBlueBackgroundView(height : CGFloat) -> UIView {
        let lightBlueBackgroundView = UIView()
        lightBlueBackgroundView.backgroundColor = .lightBlue
        lightBlueBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lightBlueBackgroundView)
        
        NSLayoutConstraint.activate([lightBlueBackgroundView.topAnchor.constraint(equalTo: view.topAnchor), lightBlueBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor), lightBlueBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor), lightBlueBackgroundView.heightAnchor.constraint(equalToConstant:  height)])
        return lightBlueBackgroundView
    }
    
    func setupPlusButtonInNavBar(selector : Selector){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: selector)
    }
    func setupSaveButtonInNavBar(selector : Selector){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: selector)
    }
    
    func setupCancelButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    }
    
    @objc private func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
}
