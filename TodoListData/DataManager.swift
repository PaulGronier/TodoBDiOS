//
//  DataManager.swift
//  TodoListData
//
//  Created by Paul Gronier on 30/03/2018.
//  Copyright © 2018 Paul Gronier. All rights reserved.
//

import Foundation
import CoreData

class DataManager {
    
    static let shared = DataManager()
    
    //let items = ["BIERE", "Pizza", "Vinyle", "Poulet"]
    
    
    var cachedItems = [Item]()
    let fetchedRequest = NSFetchRequest<Item>(entityName: "Item")
    let sort = NSSortDescriptor(key: "name", ascending: true)
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    
    
    private init () {
        loadData()
        //createItems()
    }
    
    func createItems() {
        for item in cachedItems {
            let newElement = Item(context: persistentContainer.viewContext)
            newElement.name = item.name
            cachedItems.append(newElement)
        }
    }
    
    func loadData() {
//        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
    
        do {
            cachedItems = try context.fetch(fetchedRequest)
        } catch {
            debugPrint("Could not load items from CoreData")
        }
    }
    
    func triage() {
        fetchedRequest.sortDescriptors = [sort]
        saveData()
    }
    
    func removeItem(at index: Int) {
        let item = cachedItems.remove(at: index)
        persistentContainer.viewContext.delete(item)
        saveData()
    }
    
    func removeItem(_ item: Item) {
        cachedItems.remove(at: cachedItems.index(of: item)!)
        persistentContainer.viewContext.delete(item)
        saveData()
    }
    
    func insertItem(item: Item, at index: Int) {
        cachedItems.insert(item, at: index)
        persistentContainer.viewContext.insert(item)
        saveData()
    }
    
    
    func saveData() {
        saveContext()
    }
    
    func getDocumentsDirectory() -> URL {
        var documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        documentsDirectory.appendPathComponent("items.json", isDirectory: false)
        print(documentsDirectory)
        return documentsDirectory
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "TodoListData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
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
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
