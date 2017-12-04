//
//  ViewController.swift
//  CompanyInformation
//
//  Created by ashim Dahal on 11/28/17.
//  Copyright © 2017 ashim Dahal. All rights reserved.
//

import UIKit

class CompaniesController: UITableViewController, CreateCompanyControllerDelegate {
    let cellID = "cellID"
    var companies = [
        Company(name: "Apple", founded: Date()),
        Company(name: "Google", founded: Date()),
        Company(name: "Facebook", founded: Date())
        
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        tableView.backgroundColor = UIColor.darkBlue
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))
        
        navigationItem.title = "Companies"
        setupNavigationStyle()
    }
    func addCompany(company: Company) {
        companies.append(company)
        // insert a new index path into table view
        let indexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    @objc func handleAddCompany() {
        
        let createCompanyController = CreateCompanyController()
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        createCompanyController.createCompanyDelegate = self
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let company = companies[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        cell.backgroundColor = .tealColor
        cell.textLabel?.text = company.name
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        cell.textLabel?.textColor = .white
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

