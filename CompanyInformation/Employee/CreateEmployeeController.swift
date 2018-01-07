//
//  CreateEmployee.swift
//  CompanyInformation
//
//  Created by ashim Dahal on 12/6/17.
//  Copyright © 2017 ashim Dahal. All rights reserved.
//

import UIKit
import CoreData

protocol CreateEmployeeControllerDelegate {
    func didAddEmployee(employee : Employee)
}

class CreateEmployeeController : UIViewController{
  
    var  createEmployeeDelegate : CreateEmployeeControllerDelegate?
    var company : Company?
    
    let nameLabel : UILabel = {
        let lable = UILabel()
        lable.text = "Name"
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    let birthDate : UILabel = {
        let lable = UILabel()
        lable.text = "Birth Date"
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    let nameTextField : UITextField = {
        let textFiled = UITextField()
        textFiled.placeholder = "Enter Employee Name"
        textFiled.translatesAutoresizingMaskIntoConstraints = false
        return textFiled
    }()
    
    let birthDateTextField : UITextField = {
        let textFiled = UITextField()
        textFiled.placeholder = "MM/DD/YYYY"
        textFiled.translatesAutoresizingMaskIntoConstraints = false
        return textFiled
    }()
    
    let employeeTypeSegmentedControl : UISegmentedControl = {
        let types = [
            EmployeeType.Executive.rawValue,
            EmployeeType.SeniorManagement.rawValue,
            EmployeeType.Staff.rawValue
        ]
       let segmentedControl = UISegmentedControl(items: types)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = UIColor.darkBlue
       segmentedControl.translatesAutoresizingMaskIntoConstraints = false
       return segmentedControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkBlue
        navigationItem.title = "Create Employee"
        setupCancelButton()
        setupSaveButtonInNavBar(selector: #selector(handleSave))
        setupNavigationStyle()
        setupUI()
    }
    
    @objc private func handleSave(){
        
        guard let company = company else {return}
        guard  let employeeName = nameTextField.text else { return }
        // turn birthdate object to date object
        
        guard let birthDateText = birthDateTextField.text else {return}
        // start form validation
        if birthDateText.isEmpty {
            showError(title: "Empty Birth Date field ", message: "you have not entered a birth Date")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        guard let birthdate = dateFormatter.date(from: birthDateText) else {
            showError(title: "Birth date not valid", message: "you have entered invalid birth Date")
            return
            
        }
        guard let employeeType = employeeTypeSegmentedControl.titleForSegment(at: employeeTypeSegmentedControl.selectedSegmentIndex) else {return}
        
        let touple = CoreDataManager.shared.createNewEmployee(employeeName: employeeName, employeeType: employeeType, company: company, birthdate: birthdate)
            
            if let error = touple.err {
                
                // is where you present an error model of some kind
                // perhaps use a uialertcontroller to show your error message
                
                print(error)
            }else {
                // creation success
                  dismiss(animated: true, completion: nil)
                // we'll call delegate somehow
                self.createEmployeeDelegate?.didAddEmployee(employee: touple.employee!)
            }
        
    }
    
    private func showError(title : String , message : String){
        let dateAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        dateAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(dateAlertController, animated: true, completion: nil)
    }
        
    func setupUI() {
         _ = setupLightBlueBackgroundView(height: 140)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(birthDate)
        view.addSubview(birthDateTextField)
        view.addSubview(employeeTypeSegmentedControl)
        setupViewConstraint()
    }
    func setupViewConstraint() {
        NSLayoutConstraint.activate([nameLabel.topAnchor.constraint(equalTo: view.topAnchor), nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant : 10), nameLabel.widthAnchor.constraint(equalToConstant : 100), nameLabel.heightAnchor.constraint(equalToConstant: 40)])
        
        NSLayoutConstraint.activate([nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor), nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant : -10), nameTextField.topAnchor.constraint(equalTo: view.topAnchor), nameTextField.heightAnchor.constraint(equalTo: nameLabel.heightAnchor)])
        
        NSLayoutConstraint.activate([birthDate.topAnchor.constraint(equalTo: nameLabel.bottomAnchor), birthDate.leftAnchor.constraint(equalTo: view.leftAnchor, constant : 10), birthDate.widthAnchor.constraint(equalToConstant : 100), birthDate.heightAnchor.constraint(equalToConstant: 40)])
        
        NSLayoutConstraint.activate([birthDateTextField.leftAnchor.constraint(equalTo: birthDate.rightAnchor), birthDateTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant : -10), birthDateTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor), birthDateTextField.heightAnchor.constraint(equalTo: nameTextField.heightAnchor)])
        
        NSLayoutConstraint.activate([employeeTypeSegmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant : 10), employeeTypeSegmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant : -10), employeeTypeSegmentedControl.topAnchor.constraint(equalTo: birthDate.bottomAnchor, constant : 8), employeeTypeSegmentedControl.heightAnchor.constraint(equalToConstant: 34)])
        
    }
}
