//
//  ViewController.swift
//  CompanyInformation
//
//  Created by ashim Dahal on 11/28/17.
//  Copyright © 2017 ashim Dahal. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController, CreateCompanyControllerDelegate {
    
    let cellID = "cellID"
    var companies = [Company]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCompany()
        tableView.backgroundColor = UIColor.darkBlue
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .white
        tableView.register(CompanyCell.self, forCellReuseIdentifier: cellID)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
        
        navigationItem.title = "Companies"
        setupNavigationStyle()
    }
    private func fetchCompany(){
        // attempt to fetch data from Core Data
        let context = CoreDataManager.shared.persistancContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        
        do {
            let fetchedCompanies = try context.fetch(fetchRequest)
            
            self.companies = fetchedCompanies
            self.tableView.reloadData()
            
        } catch let fetchError {
            print("Failed to fetch result", fetchError)
        }
      
    }
    
    func didAddCompany(company: Company) {
        companies.append(company)
        // insert a new index path into table view
        let indexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    func didEditCompany(company: Company) {
        // update table view with edit
        if let row = companies.index(of: company){
         let reloadIndexPath = IndexPath(row: row, section: 0)
         tableView.reloadRows(at: [reloadIndexPath], with: .middle)
        }
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
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deletAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexpath) in
            let company = self.companies[indexPath.row]
//            print("Attempting to delet row at index path", company.name ?? "" )
            // remove the company from our table view
            self.companies.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // update the company from Core Data
            // Delet from Context from core data which was created as context
            
            let context = CoreDataManager.shared.persistancContainer.viewContext
            context.delete(company)
            
            do {
                try context.save()
            }catch let saveErr{
                print("Failed to delet company", saveErr)
            }
        }
        deletAction.backgroundColor = UIColor.lightRed
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: editHandlerFunction)
        editAction.backgroundColor = .darkBlue
        return [deletAction,editAction]
    }
    
    private func editHandlerFunction(action : UITableViewRowAction , indexPath : IndexPath){
        
        let editCompanyController = CreateCompanyController()
        let navController = CustomNavigationController(rootViewController: editCompanyController)
        editCompanyController.company = companies[indexPath.row]
        editCompanyController.createCompanyDelegate = self
        present(navController, animated: true, completion: nil)
       
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lightBlue
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No Companies Available.."
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return companies.count == 0 ? 150 : 0
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let company = companies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CompanyCell
        cell.company = company
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
