//
//  CoreDataManager.swift
//  CompanyInformation
//
//  Created by ashim Dahal on 12/4/17.
//  Copyright © 2017 ashim Dahal. All rights reserved.
//

import CoreData

struct CoreDataManager {
    static let shared = CoreDataManager() // this variable will live forever as long as your application is still alive, it's properties will too be active
    
    let persistancContainer : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CompanyInformation")
        
        container.loadPersistentStores { (storeDescription, loadError) in
            
            if let err = loadError {
                fatalError("loading of store failed : \(err)")
            }
        }
        return container
    }()
    
    func createNewCompany(companyName : String , foundedDate : Date , companyImageData :Data ){
        let context =  persistancContainer.viewContext
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        
        company.setValue(companyName, forKey: "name")
        company.setValue(foundedDate, forKey: "founded")
        company.setValue(companyImageData, forKey: "imageData")
        
        
        
        // Perform The save action
        do {
            try  context.save()
            // upon success dismiss view controller
//            dismiss(animated: true, completion: {
//                self.createCompanyDelegate?.didAddCompany(company: company as! Company)
//            })
            
        } catch let err {
            print("Failed to Save company , \(err)")
        }
    }
    
    func createNewEmployee(employeeName : String, employeeType : String ,company : Company, birthdate : Date) -> (employee : Employee? , err: Error?){
        let context = persistancContainer.viewContext
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee
        
        employee.company = company
        employee.type = employeeType
        
//        let company = Company(context : context)
//        company.employees
//        employee.company
        
        employee.setValue(employeeName, forKey: "employeeName")
        let employeeInformation = NSEntityDescription.insertNewObject(forEntityName: "EmployeeInformation", into: context) as! EmployeeInformation
        employeeInformation.taxID = "456"
        employeeInformation.birthdate = birthdate
        
       employee.employeeInformation = employeeInformation
        do {
            try context.save()
            return (employee , nil)
        } catch let employeeSaveErr {
            print("Failed to create employee",employeeSaveErr)
            return (nil,employeeSaveErr)
        }
     
    }
    
    func fetchCompanies() -> [Company]{
        let context = persistancContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        do {
            let fetchedCompanies = try context.fetch(fetchRequest)
            return fetchedCompanies
            
        } catch let fetchError {
            print("Failed to fetch result", fetchError)
            return []
        }
        
    }
    
//    func fetchEmployee() -> [Employee]{
//
//        let context = persistancContainer.viewContext
//        let fetchRequest = NSFetchRequest<Employee>(entityName: "Employee")
//
//        do {
//            let fetchEmployee = try context.fetch(fetchRequest)
//            return fetchEmployee
//        } catch let fetchEmployeeError {
//            print("Failed to fetch employee", fetchEmployeeError)
//            return[]
//        }
//
//
    
//    }
    
}
