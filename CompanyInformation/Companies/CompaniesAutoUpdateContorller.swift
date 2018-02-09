//
//  CompaniesAutoUpdateContorller.swift
//  CompanyInformation
//
//  Created by ashim Dahal on 2/1/18.
//  Copyright © 2018 ashim Dahal. All rights reserved.
//

import UIKit
import CoreData

class CompaniesAutoUpdateController :  UITableViewController , NSFetchedResultsControllerDelegate{
    
    let companyName = "companyName"
    
    lazy var fetchResultController : NSFetchedResultsController <Company> = {
        
        let context = CoreDataManager.shared.persistancContainer.viewContext
        let request : NSFetchRequest<Company> = Company.fetchRequest()
        
        request.sortDescriptors = [
            NSSortDescriptor(key: companyName, ascending: true)
        ]
        
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: companyName, cacheName: nil)
        frc.delegate = self
        
        do {
            try frc.performFetch()
        }catch let err{
            print(err)
        }
        
        return frc
    }()
    
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        <#code#>
//    }
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        <#code#>
//    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .middle)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .middle)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .middle)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    let cellID = "cellID"
    
    override func viewDidLoad() {
         super .viewDidLoad()
        tableView.backgroundColor = UIColor.darkBlue
        navigationItem.title = "Company Auto Updates"
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAdd)),
            UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(handleDelete))
        ]
     
        
        tableView.register(CompanyCell.self, forCellReuseIdentifier: cellID)
        setupNavigationStyle()
        
        Service.shared.downloadCompaniesFromServer()
        
    }
    
    @objc private func handleDelete() {
        let request: NSFetchRequest<Company> = Company.fetchRequest()
        
//        request.predicate = NSPredicate(format: "\(companyName) contains %@", "A")
        
        let context = CoreDataManager.shared.persistancContainer.viewContext
      
        let companyWithB = try? context.fetch(request)
        
        companyWithB?.forEach({ (company) in
            context.delete(company)
        })
        
        try? context.save()
    }
    
     @objc private func handleAdd(){
        
        print("lets add a company called BMW")
        
        let context = CoreDataManager.shared.persistancContainer.viewContext
        let company = Company(context: context)
        company.companyName = "Apple"
        
        try? context.save()
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchResultController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultController.sections![section].numberOfObjects
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = IndentedLabel()
        label.text = fetchResultController.sectionIndexTitles[section]
        label.backgroundColor = UIColor.lightBlue
        
        return label
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID , for: indexPath) as! CompanyCell
        
        let company = fetchResultController.object(at: indexPath)
        cell.company = company
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let employeesListController = EmployeeController()
        employeesListController.company = fetchResultController.object(at: indexPath)
        navigationController?.pushViewController(employeesListController, animated: true)
    }
}


