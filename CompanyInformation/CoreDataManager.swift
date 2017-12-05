//
//  CoreDataManager.swift
//  CompanyInformation
//
//  Created by ashim Dahal on 12/4/17.
//  Copyright © 2017 ashim Dahal. All rights reserved.
//

import CoreData

struct CoreDataManager {
    static let shared = CoreDataManager() // this variable will live forever as long as your application is still alive, it's properties will too be active
    
    let persistancContainer : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CompanyInformation")
        
        container.loadPersistentStores { (storeDescription, loadError) in
            
            if let err = loadError {
                fatalError("loading of store failed : \(err)")
            }
        }
        return container
    }()
    
    
}
