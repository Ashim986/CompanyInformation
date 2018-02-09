//
//  ViewController.swift
//  CompanyInformation
//
//  Created by ashim Dahal on 11/28/17.
//  Copyright © 2017 ashim Dahal. All rights reserved.
//

import UIKit
import CoreData
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
class CompaniesController : UITableViewController {

    let cellID = "cellID"
    var companies = [Company]()
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
        companies = CoreDataManager.shared.fetchCompanies()
        tableView.backgroundColor = UIColor.darkBlue
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .white
        tableView.register(CompanyCell.self, forCellReuseIdentifier: cellID)
        
        setupPlusButtonInNavBar(selector: #selector(handleAddCompany))
        
        navigationItem.leftBarButtonItems = [UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset)), UIBarButtonItem(title: "Nested Updates", style: .plain, target: self, action: #selector(doNestedUpdates)) ]
        navigationItem.title = "Companies"
        setupNavigationStyle()
        
    }
    
    @objc private func doNestedUpdates() {
        print("trying to perform nested updates now...")
        DispatchQueue.global(qos: .background).async {
            // we'll try to perfor our updates
            
            // we'll first construct a custom MOC ( managed object context)
            
            let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateContext.parent = CoreDataManager.shared.persistancContainer.viewContext
            
            // execute updates on privateContext now
            
            let request: NSFetchRequest<Company> = Company.fetchRequest()
            request.fetchLimit = 1
            do {
                let companies = try privateContext.fetch(request)
                
                companies.forEach({ (company) in
                    print(company.companyName ?? "")
                    company.companyName = "D : \(company.companyName ?? "")"
                })
                do {
                    try  privateContext.save()
                    
                    // after save succeded reload table view.
                    DispatchQueue.main.async {
                        do {
                            let context = CoreDataManager.shared.persistancContainer.viewContext
                            if context.hasChanges {
                                try context.save()
                            }
                            
                        }catch let finalSaveErr {
                            print("failed to save in main context", finalSaveErr)
                        }
                        self.tableView.reloadData()
                    }
                    
                }catch let saveErr {
                    print("failed to save on private context", saveErr)
                }
               
                
            }catch let fetchErr{
                print("Failed to fetch on private context:", fetchErr)
            }
            
            
        }
    }
    
    @objc private func doUpdates(){
        print("trying to update companies on a background context")
        CoreDataManager.shared.persistancContainer.performBackgroundTask { (backgroundContext) in
            let request : NSFetchRequest<Company> = Company.fetchRequest()
            
            do {
                let companies = try backgroundContext.fetch(request)
                companies.forEach({ (company) in
                    print(company.companyName ?? "")
                    company.companyName = "C : \(company.companyName ?? "")"
                })
                do{
                    try  backgroundContext.save()
                    
                    // lets try to update the UI after a save
                    DispatchQueue.main.async {
                         // reset will forget all of the objects you've fetch before
                        CoreDataManager.shared.persistancContainer.viewContext.reset()
                        
                       // you don't want to refetch everythin if you're just simply update one or two companies
                        self.companies = CoreDataManager.shared.fetchCompanies()
                        
                        // is there a way to just merge the changes that you made onto the main view context?
                        
                        self.tableView.reloadData()
                    }
                }catch let saveErr {
                    print("Failed to save on background :", saveErr)
                }
               
            }catch let error{
                print("failed to fetch companies on background : ", error)
            }
            
        }
    }
    
//    @objc private func doWork() {
//        print("do somework")
//            CoreDataManager.shared.persistancContainer.performBackgroundTask({ (backgroundContext) in
//                (0...5).forEach { (value) in
//                    print(value)
//                    let company = Company(context: backgroundContext)
//                    company.companyName = String(value)
//                }
//                do {
//                    try backgroundContext.save()
//                    DispatchQueue.main.async {
//                        self.companies = CoreDataManager.shared.fetchCompanies()
//                        self.tableView.reloadData()
//                    }
//
//                }catch let err{
//                    print("Failed to save : ", err)
//                }
//            })
//    }
    
    @objc private func handleReset(){
        
        let context = CoreDataManager.shared.persistancContainer.viewContext
        let batchDeletRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        do {
            try  context.execute(batchDeletRequest)
            var indexPathToRemove = [IndexPath]()
            for index in companies.indices {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathToRemove.append(indexPath)
            }
            companies.removeAll()
            tableView.deleteRows(at: indexPathToRemove, with: .left)
        } catch let delErr {
            print("Failed to delet object form Core Data:", delErr)
        }
    }
    
    @objc private func handleAddCompany() {
        let createCompanyController = CreateCompanyController()
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        createCompanyController.createCompanyDelegate = self
        present(navController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

