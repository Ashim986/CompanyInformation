//
//  CompaniesController+CreateCompany.swift
//  CompanyInformation
//
//  Created by ashim Dahal on 12/6/17.
//  Copyright © 2017 ashim Dahal. All rights reserved.
//

import UIKit

extension CompaniesController : CreateCompanyControllerDelegate {
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
}
