//
//  CompanyController+UITableView.swift
//  CompanyInformation
//
//  Created by ashim Dahal on 12/6/17.
//  Copyright © 2017 ashim Dahal. All rights reserved.
//

import UIKit

extension CompaniesController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let employeeController = EmployeeController()
        let company = companies[indexPath.row]
        employeeController.company = company
        navigationController?.pushViewController(employeeController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deletAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexpath) in
            let company = self.companies[indexPath.row]
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
}
