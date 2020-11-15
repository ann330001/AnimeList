//
//  CoreDataManager.swift
//  AnimeList
//
//  Created by Ann on 2020/11/14.
//  Copyright © 2020 AnnChen.com. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    static let instance = CoreDataManager()
    var favoriteItems = [FavoriteItem]()
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
       let container = NSPersistentContainer(name: "AnimeList")
       container.loadPersistentStores(completionHandler: { (storeDescription, error) in
           if let error = error as NSError? {
            print("Unresolved error \(error), \(error.userInfo)")
           }
       })
       return container
    }()
    
    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func addNewItem(topItem: Top) -> Bool {
        let managedContext = persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<FavoriteItem> = FavoriteItem.fetchRequest()
        
        do {
            let searchResults = try managedContext.fetch(fetchRequest)
            if searchResults.count > 0 {
                for item in searchResults as [NSManagedObject] {
                    let itemID = item.value(forKey: "mal_id") as! Int32
                    if itemID == topItem.mal_id {
                        return true
                    }
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        
        
        let item = FavoriteItem(context: managedContext)
        
        // Set attributes
        item.setValue(topItem.mal_id, forKey: "mal_id")
        item.setValue(topItem.rank, forKey: "rank")
        item.setValue(topItem.title, forKey: "title")
        item.setValue(topItem.url, forKey: "url")
        item.setValue(topItem.image_url, forKey: "image_url")
        item.setValue(topItem.type, forKey: "type")
        item.setValue(topItem.start_date, forKey: "start_date")
        item.setValue(topItem.end_date, forKey: "end_date")
        
        // commit changes and save to disk
        do {
            try managedContext.save()
            return true
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
    
    func fetchItem() {
        let managedContext = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteItem> = FavoriteItem.fetchRequest()
        
        do {
            favoriteItems = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func deleteItem(id: Int32) {
        let managedContext = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteItem> = FavoriteItem.fetchRequest()
        
        do {
            let searchResults = try managedContext.fetch(fetchRequest)
            if searchResults.count > 0 {
                for item in searchResults as [NSManagedObject] {
                    let itemID = item.value(forKey: "mal_id") as! Int32
                    if itemID == id {
                        managedContext.delete(item)
                    }
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        // save changes
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save changes. \(error), \(error.userInfo)")
        }
    }

}
