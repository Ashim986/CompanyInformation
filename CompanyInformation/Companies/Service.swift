//
//  Service.swift
//  CompanyInformation
//
//  Created by ashim Dahal on 2/8/18.
//  Copyright © 2018 ashim Dahal. All rights reserved.
//

import Foundation
import CoreData

struct Service {
    
//    static let shared = Service()
//
//    let urlString = "https://api.letsbuildthatapp.com/intermediate_training/companies"
//
//    func downloadCompaniesFromServer()  {
//        print("Attempting to Download Companies")
//        guard let url = URL(string: urlString) else {return}
//
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            if let err =  error {
//                print("Could not download from server ", err)
//            }
//            guard let data = data else {return}
//            let string = String(data: data, encoding: .utf8)
//
//            print(string)
//
//        }.resume()
//    }
    
    
    static let shared = Service()
    
    let urlString = "https://api.letsbuildthatapp.com/intermediate_training/companies"
    
    func downloadCompaniesFromServer(){
        print("Attempting to download Companies")
        
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Could not connect to server ", err)
                
            }
            guard let data = data else {return}
//            let string = String(data: data, encoding: .utf8)
//            print(string)
            
            let jsonDecoder = JSONDecoder()
            
            do{
                let jsonCompanies = try jsonDecoder.decode([JSONCompany].self, from: data)
                
                jsonCompanies.forEach({ (jsonCompany) in
                    
                    let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                    privateContext.parent = CoreDataManager.shared.persistancContainer.viewContext
                    
                    
                    let company = Company(context: privateContext)
                    company.companyName = jsonCompany.name
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    let foundedDate = dateFormatter.date(from: jsonCompany.founded)
                    company.founded = foundedDate
                    
                  
                   
                    jsonCompany.employees?.forEach({ (jsonEmployee) in
                        
                        let employee = Employee(context: privateContext)
                        employee.employeeName = jsonEmployee.name
                        let employeeInformation = EmployeeInformation(context: privateContext)
                        let birthdayDate = dateFormatter.date(from: jsonEmployee.birthday)
                        employeeInformation.birthdate = birthdayDate
                        employee.type = jsonEmployee.type
                        
                        employee.employeeInformation = employeeInformation
                        employee.company = company
                    })
                 
                    do {
                        try privateContext.save()
                        try privateContext.parent?.save()
                    }catch let saveErr {
                        print("Failed to save company information", saveErr)
                    }
                    
                })
                
            }catch let jsonError{
                print("failed to get json Data", jsonError)
            }
           
        }.resume()
    }
}


struct JSONCompany : Decodable {
    let name : String
    let founded : String
    var employees : [JSONEmployee]?
}

struct JSONEmployee : Decodable {
    let  name : String
    let  birthday : String
    let  type : String
}
