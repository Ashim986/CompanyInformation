//
//  CreateCompanyController.swift
//  CompanyInformation
//
//  Created by ashim Dahal on 12/1/17.
//  Copyright © 2017 ashim Dahal. All rights reserved.
//

import UIKit

// custom delegateMethod for adding company to access specific method

protocol CreateCompanyControllerDelegate {
    func addCompany(company : Company)
}

class CreateCompanyController: UIViewController {
   
    var createCompanyDelegate : CreateCompanyControllerDelegate?
    
    let nameLabel : UILabel = {
       let lable = UILabel()
        lable.text = "Name"
        lable.translatesAutoresizingMaskIntoConstraints = false
       return lable
    }()
    
    let lightBlueBackgroundView : UIView = {
        let view = UIView()
        view.backgroundColor = .lightBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameTextField : UITextField = {
        let textFiled = UITextField()
        textFiled.placeholder = "Enter Company Name"
        textFiled.translatesAutoresizingMaskIntoConstraints = false
        return textFiled
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkBlue
        
        navigationItem.title = "Create Company"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        setupNavigationStyle()
        setupUI()
        
    }
    
    private func setupUI(){
        view.addSubview(lightBlueBackgroundView)
        lightBlueBackgroundView.addSubview(nameLabel)
        lightBlueBackgroundView.addSubview(nameTextField)
        addViewConstraint()
    }
    private func addViewConstraint() {
    NSLayoutConstraint.activate([lightBlueBackgroundView.topAnchor.constraint(equalTo: view.topAnchor), lightBlueBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor), lightBlueBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor), lightBlueBackgroundView.heightAnchor.constraint(equalToConstant:  50)])
        
    
        NSLayoutConstraint.activate([nameLabel.topAnchor.constraint(equalTo: lightBlueBackgroundView.topAnchor), nameLabel.leftAnchor.constraint(equalTo: lightBlueBackgroundView.leftAnchor, constant : 10), nameLabel.widthAnchor.constraint(equalToConstant : 60), nameLabel.heightAnchor.constraint(equalTo : lightBlueBackgroundView.heightAnchor)])
        
        NSLayoutConstraint.activate([nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor), nameTextField.rightAnchor.constraint(equalTo: lightBlueBackgroundView.rightAnchor, constant : -10), nameTextField.topAnchor.constraint(equalTo: lightBlueBackgroundView.topAnchor), nameTextField.heightAnchor.constraint(equalTo: lightBlueBackgroundView.heightAnchor)])
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSave() {
        print("trying to save company")
        dismiss(animated: true, completion: nil)
        guard let name = nameTextField.text else {return}
        let company = Company(name: name, founded: Date())
        createCompanyDelegate?.addCompany(company: company)
    }
}

