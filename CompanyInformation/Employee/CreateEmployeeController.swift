//
//  CreateEmployee.swift
//  CompanyInformation
//
//  Created by ashim Dahal on 12/6/17.
//  Copyright © 2017 ashim Dahal. All rights reserved.
//

import UIKit
import CoreData

class CreateEmployeeController : UIViewController{
    
    let nameLabel : UILabel = {
        let lable = UILabel()
        lable.text = "Name"
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    let nameTextField : UITextField = {
        let textFiled = UITextField()
        textFiled.placeholder = "Enter Employee Name"
        textFiled.translatesAutoresizingMaskIntoConstraints = false
        return textFiled
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkBlue
        navigationItem.title = "Create Employee"
        setupCancelButton()
        setupSaveButtonInNavBar(selector: #selector(handleSave))
        setupNavigationStyle()
        _ = setupLightBlueBackgroundView(height: 50)
        setupUI()
    }
    
    @objc private func handleSave(){
        print("Saving Employee")
        if let employeeName = nameTextField.text {
            let error = CoreDataManager.shared.createNewEmployee(employeeName: employeeName)
            if let error = error{
                
                // is where you present an error model of some kind
                // perhaps use a uialertcontroller to show your error message
                
                print(error)
            }else {
                  dismiss(animated: true, completion: nil)
            }
            
        }
    }
    func setupUI() {
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        setupViewConstraint()
    }
    func setupViewConstraint() {
        NSLayoutConstraint.activate([nameLabel.topAnchor.constraint(equalTo: view.topAnchor), nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant : 10), nameLabel.widthAnchor.constraint(equalToConstant : 60), nameLabel.heightAnchor.constraint(equalToConstant: 50)])
        
        NSLayoutConstraint.activate([nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor), nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant : -10), nameTextField.topAnchor.constraint(equalTo: view.topAnchor), nameTextField.heightAnchor.constraint(equalTo: nameLabel.heightAnchor)])
        
    }
}
