//
//  Tasks+CoreDataProperties.swift
//  myDayApp
//
//  Created by Денис Матвеев on 02.12.2017.
//  Copyright © 2017 DenisMatveev. All rights reserved.
//
//

import Foundation
import CoreData


extension Tasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tasks> {
        return NSFetchRequest<Tasks>(entityName: "Tasks")
    }

    @NSManaged public var countOfRepeats: Int16
    @NSManaged public var dateCreateTaskOfDay: NSDate?
    @NSManaged public var endDay: NSDate?
    @NSManaged public var friday: Bool
    @NSManaged public var idToDo: Int32
    @NSManaged public var measure: Bool
    @NSManaged public var monday: Bool
    @NSManaged public var nameToDo: String?
    @NSManaged public var saturday: Bool
    @NSManaged public var startDay: NSDate?
    @NSManaged public var sunday: Bool
    @NSManaged public var thursday: Bool
    @NSManaged public var tuesday: Bool
    @NSManaged public var wednesday: Bool
    @NSManaged public var tasksOfDay: NSSet?

}

// MARK: Generated accessors for tasksOfDay
extension Tasks {

    @objc(addTasksOfDayObject:)
    @NSManaged public func addToTasksOfDay(_ value: TasksOfDay)

    @objc(removeTasksOfDayObject:)
    @NSManaged public func removeFromTasksOfDay(_ value: TasksOfDay)

    @objc(addTasksOfDay:)
    @NSManaged public func addToTasksOfDay(_ values: NSSet)

    @objc(removeTasksOfDay:)
    @NSManaged public func removeFromTasksOfDay(_ values: NSSet)

}
