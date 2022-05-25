//
//  CoreDataStack.swift
//  MovieApp
//
//  Created by Lorena Lazar on 5/25/22.
//

import Foundation
import CoreData

class CoreDataStack {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MoviesDatabaase")
        container.loadPersistentStores(completionHandler: {
        (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
