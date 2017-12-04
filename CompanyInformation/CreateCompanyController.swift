//
//  CreateCompanyController.swift
//  CompanyInformation
//
//  Created by ashim Dahal on 12/1/17.
//  Copyright © 2017 ashim Dahal. All rights reserved.
//

import UIKit

class CreateCompanyController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        
        navigationItem.title = "Create Company"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        setupNavigationStyle()
    }
    
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}

