//
//  ViewController.swift
//  CompanyInformation
//
//  Created by ashim Dahal on 11/28/17.
//  Copyright © 2017 ashim Dahal. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController  {
    
    let cellID = "cellID"
    var companies = [Company]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        companies = CoreDataManager.shared.fetchCompanies()
        tableView.backgroundColor = UIColor.darkBlue
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .white
        tableView.register(CompanyCell.self, forCellReuseIdentifier: cellID)
        
        setupPlusButtonInNavBar(selector: #selector(handleAddCompany))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
        navigationItem.title = "Companies"
        setupNavigationStyle()
    }
    
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

