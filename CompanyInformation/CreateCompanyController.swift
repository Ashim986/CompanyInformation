//
//  CreateCompanyController.swift
//  CompanyInformation
//
//  Created by ashim Dahal on 12/1/17.
//  Copyright © 2017 ashim Dahal. All rights reserved.
//

import UIKit
import CoreData

// custom delegateMethod for adding company to access specific method

protocol CreateCompanyControllerDelegate {
    func didAddCompany(company : Company)
    func didEditCompany(company : Company)
}

class CreateCompanyController: UIViewController {
    
    var company : Company? {
        didSet {
            nameTextField.text = company?.name
            guard let founded = company?.founded else {return}
            datePicker.date = founded
        }
    }
   
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
    
    let datePicker : UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
       return datePicker
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company == nil ? "Create Company" : "Editing Company"
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkBlue
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        setupNavigationStyle()
        setupUI()
        
    }
    
    private func setupUI(){
        view.addSubview(lightBlueBackgroundView)
        lightBlueBackgroundView.addSubview(nameLabel)
        lightBlueBackgroundView.addSubview(nameTextField)
        lightBlueBackgroundView.addSubview(datePicker)
        addViewConstraint()
    }
    private func addViewConstraint() {
    NSLayoutConstraint.activate([lightBlueBackgroundView.topAnchor.constraint(equalTo: view.topAnchor), lightBlueBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor), lightBlueBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor), lightBlueBackgroundView.heightAnchor.constraint(equalToConstant:  250)])
        
    
        NSLayoutConstraint.activate([nameLabel.topAnchor.constraint(equalTo: lightBlueBackgroundView.topAnchor), nameLabel.leftAnchor.constraint(equalTo: lightBlueBackgroundView.leftAnchor, constant : 10), nameLabel.widthAnchor.constraint(equalToConstant : 60), nameLabel.heightAnchor.constraint(equalToConstant: 50)])
        
        NSLayoutConstraint.activate([nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor), nameTextField.rightAnchor.constraint(equalTo: lightBlueBackgroundView.rightAnchor, constant : -10), nameTextField.topAnchor.constraint(equalTo: lightBlueBackgroundView.topAnchor), nameTextField.heightAnchor.constraint(equalTo: nameLabel.heightAnchor)])
        
        NSLayoutConstraint.activate([datePicker.topAnchor.constraint(equalTo: nameLabel.bottomAnchor), datePicker.leftAnchor.constraint(equalTo: lightBlueBackgroundView.leftAnchor), datePicker.rightAnchor.constraint(equalTo: lightBlueBackgroundView.rightAnchor), datePicker.bottomAnchor.constraint(equalTo: lightBlueBackgroundView.bottomAnchor)])
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSave() {
        
        if company == nil {
            // save new company
            createNewCompany()
        }else {
            //update company
            saveEditedCompany()
        }

    }
    private func saveEditedCompany(){
        let context = CoreDataManager.shared.persistancContainer.viewContext
        
        company?.name = nameTextField.text
        company?.founded = datePicker.date
        do {
            try context.save()
            dismiss(animated: true, completion: {
                self.createCompanyDelegate?.didEditCompany(company: self.company!)
            })
            
        }catch let saveErr {
            print("failed to save company changes :", saveErr)
        }
        
    }
    private func createNewCompany(){
        let context =  CoreDataManager.shared.persistancContainer.viewContext
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        company.setValue(nameTextField.text, forKey: "name")
        company.setValue(datePicker.date, forKey: "founded")
        // Perform The save action
        do {
            try  context.save()
            
            // upon success dismiss view controller
            dismiss(animated: true, completion: {
                self.createCompanyDelegate?.didAddCompany(company: company as! Company)
            })
            
        } catch let err {
            print("Failed to Save company , \(err)")
        }
    }
}

