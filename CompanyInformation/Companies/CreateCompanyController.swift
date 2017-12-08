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

class CreateCompanyController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    var company : Company? {
        didSet {
            nameTextField.text = company?.companyName
            if let imageData = company?.imageData {
               companyImageView.image = UIImage(data: imageData)
            }
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
    
    
    lazy var companyImageView : UIImageView = {
       let imageView = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
        imageView.layer.cornerRadius = 45
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.darkBlue.cgColor
        imageView.layer.borderWidth = 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        setupCancelButton()
        setupSaveButtonInNavBar(selector: #selector(handleSave))
        setupNavigationStyle()
        setupUI()
    }
    private func setupUI(){
        
        let lightBlueBackGroundView = setupLightBlueBackgroundView(height: 350)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(datePicker)
        view.addSubview(companyImageView)
        addViewConstraint(lightBlueBackgroundView: lightBlueBackGroundView)
    }
    private func addViewConstraint(lightBlueBackgroundView : UIView) {

        NSLayoutConstraint.activate([companyImageView.topAnchor.constraint(equalTo: view.topAnchor , constant : 10), companyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor), companyImageView.widthAnchor.constraint(equalToConstant: 90),companyImageView.heightAnchor.constraint(equalToConstant: 90)])
        
        NSLayoutConstraint.activate([nameLabel.topAnchor.constraint(equalTo: companyImageView.bottomAnchor), nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant : 10), nameLabel.widthAnchor.constraint(equalToConstant : 60), nameLabel.heightAnchor.constraint(equalToConstant: 50)])
        
        NSLayoutConstraint.activate([nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor), nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant : -10), nameTextField.topAnchor.constraint(equalTo: companyImageView.bottomAnchor), nameTextField.heightAnchor.constraint(equalTo: nameLabel.heightAnchor)])
        
        NSLayoutConstraint.activate([datePicker.topAnchor.constraint(equalTo: nameLabel.bottomAnchor), datePicker.leftAnchor.constraint(equalTo: view.leftAnchor), datePicker.rightAnchor.constraint(equalTo: view.rightAnchor), datePicker.bottomAnchor.constraint(equalTo:lightBlueBackgroundView.bottomAnchor)])
    }
    @objc func handleSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            companyImageView.image = editedImage
        }
        else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            companyImageView.image = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func handleSave() {
        
        if company == nil {
            // save new company
            createNewCompany()
            } else {
            //update company
            saveEditedCompany()
        }
    }
    private func saveEditedCompany(){
        let context = CoreDataManager.shared.persistancContainer.viewContext
        
        company?.companyName = nameTextField.text
        company?.founded = datePicker.date
        
        if let companyImage = companyImageView.image {
            company?.imageData = UIImageJPEGRepresentation(companyImage, 1)
        }
        
        
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
        company.setValue(nameTextField.text, forKey: "companyName")
        company.setValue(datePicker.date, forKey: "founded")

        if let companyImage = companyImageView.image{
            let imageData = UIImageJPEGRepresentation(companyImage, 0.2)
            company.setValue(imageData, forKey: "imageData")
        }

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

