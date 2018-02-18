//
//  EmployeesController.swift
//  CompanyInformation
//
//  Created by ashim Dahal on 12/6/17.
//  Copyright © 2017 ashim Dahal. All rights reserved.
//

import UIKit

class  IndentedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let edgeInsect = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let customRect = UIEdgeInsetsInsetRect(rect, edgeInsect)
        super.drawText(in: customRect)
    }
}

class EmployeeController: UITableViewController, CreateEmployeeControllerDelegate {
    
   
    var company : Company?
    var employees = [Employee]()
    let employeeCellID = "employeeTableViewCellID"
  
 
    var allEmployee = [[Employee]]()
    
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
    
    var employeeTypes = [
        EmployeeType.Executive.rawValue,
        EmployeeType.SeniorManagement.rawValue,
        EmployeeType.Staff.rawValue
    ]
    
    private func fetchEmployee(){
        
        guard let companyEmployees = company?.employees?.allObjects as? [Employee] else {return}
        
       
//        let seniorManagement = companyEmployees.filter { (employee) -> Bool in
//            return employee.type == EmployeeType.SeniorManagement.rawValue
//        }
//        let staff = companyEmployees.filter { $0.type == EmployeeType.SeniorManagement.rawValue}
        
//        allEmployee = [executive,seniorManagement,staff]
        
        // this code is appending value for all employee by employee types
        
        allEmployee = []
        employeeTypes.forEach { (employeeTypes) in
            allEmployee.append(companyEmployees.filter({ (employee) -> Bool in
                return employee.type == employeeTypes
            }))
        }
      
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return allEmployee[section].count
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()
        label.backgroundColor = UIColor.lightBlue
        label.text = employeeTypes[section]
        label.textColor = .darkBlue
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allEmployee.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let employee = allEmployee[indexPath.section][indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: employeeCellID, for: indexPath)
        cell.textLabel?.text = employee.employeeName
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd , yyyy"
        
        if let birthDate = employee.employeeInformation?.birthdate {
            cell.textLabel?.text = "\(employee.employeeName ?? "")  \(dateFormatter.string(from: birthDate))"
        }
        cell.backgroundColor = .tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return cell
    }
    
    @objc private func handleAdd() {
        
        let createEmployeeController = CreateEmployeeController()
        let navController = CustomNavigationController(rootViewController: createEmployeeController)
        createEmployeeController.createEmployeeDelegate = self
        createEmployeeController.company = company
        present(navController, animated: true, completion: nil)
        
    }
    
    // remember this when we call employee
    func didAddEmployee(employee: Employee) {

        guard let employeeType = employee.type else {return}
        guard let section = employeeTypes.index(of: employeeType) else {return}
        let row = allEmployee[section].count
        allEmployee[section].append(employee)
        let insertionIndexPath = IndexPath(row: row  , section: section)
        tableView.insertRows(at: [insertionIndexPath], with: .middle)
    }
    
}
