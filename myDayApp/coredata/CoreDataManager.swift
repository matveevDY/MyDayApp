//
//  File.swift
//  myDay
//
//  Created by Денис Матвеев on 13.11.2017.
//  Copyright © 2017 DenisMatveev. All rights reserved.
//

import CoreData
import Foundation

class CoreDataManager {
    
    private init() {}
    
    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Date formattors
    
    static func timeFormattorToString (sender: NSDate) -> String {
        let formatter = DateFormatter()
        formatter.locale = NSLocale (localeIdentifier: "ru_RU") as Locale
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        let timeOfString = formatter.string(from: sender as Date)
        return timeOfString
    }
    
    static func timeFormattorToDateComponents (sender: String) -> DateComponents {
        let formatter = DateFormatter()
        formatter.locale = NSLocale (localeIdentifier: "ru_RU") as Locale
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        let timeOfDateTime = formatter.date(from: sender)
        let calendar = Calendar(identifier: .gregorian)
        let component = calendar.dateComponents([.hour, .minute], from: timeOfDateTime!)
        return component
    }
    
    static func dateFormattorToString (sender: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = NSLocale (localeIdentifier: "ru_RU") as Locale
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        let dateOfString = formatter.string(from: sender)
        return dateOfString
    }
    
    static func dateFormattorToDate (sender: String) -> Date {
        let formatter = DateFormatter()
        formatter.locale = NSLocale (localeIdentifier: "ru_RU") as Locale
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        let dateOfDate = formatter.date(from: sender)
        return dateOfDate!
    }
    static func dateFormattor (sender: NSDate) -> Date {
        let formatter = DateFormatter()
        formatter.locale = NSLocale (localeIdentifier: "ru_RU") as Locale
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        let stringDate = formatter.string(from: sender as Date)
        let date = formatter.date(from: stringDate)
        return date!
    }
    
    // Get Data from CoreData
    
    static func getDataTasks (predicate: NSPredicate) {
        tasks.removeAll()
        let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        fetchRequest.predicate = predicate
        do {
            let task = try CoreDataManager.context.fetch(fetchRequest)
            tasks = task
        } catch {}
    }
    
    static func getDataTasksOfDay (predicate: NSPredicate) {
        tasksOfDay.removeAll()
        let fetchRequest: NSFetchRequest<TasksOfDay> = TasksOfDay.fetchRequest()
        fetchRequest.predicate = predicate
        do {
            let task = try CoreDataManager.context.fetch(fetchRequest)
            tasksOfDay = task
        } catch {}
    }
    
    // MARK: - Core Data stack
    
    static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "myDay")
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
    
    static func saveContext () {
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
