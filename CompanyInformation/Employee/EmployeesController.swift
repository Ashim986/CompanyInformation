//
//  EmployeesController.swift
//  CompanyInformation
//
//  Created by ashim Dahal on 12/6/17.
//  Copyright © 2017 ashim Dahal. All rights reserved.
//

import UIKit

class EmployeeController: UITableViewController {
    
    var company : Company?
    var employees = [Employee]()
    let employeeCellID = "employeeTableViewCellID"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = company?.companyName
        fetchEmployee()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .darkBlue
        setupPlusButtonInNavBar(selector: #selector(handleAdd))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: employeeCellID)
    }
    
    private func fetchEmployee(){
        print("Trying to fetch employee")
        let fetchEmpolyees = CoreDataManager.shared.fetchEmployee()
        self.employees = fetchEmpolyees
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let employee = employees[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: employeeCellID, for: indexPath)
        cell.textLabel?.text = employee.employeeName
        cell.backgroundColor = .tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return cell
    }
    
    @objc private func handleAdd() {
        
        let createEmployeeCompany = CreateEmployeeController()
        let navController = CustomNavigationController(rootViewController: createEmployeeCompany)
        present(navController, animated: true, completion: nil)
        print("Trying to add an employee ")
    }
}
