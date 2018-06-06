//
//  TasksOfDay+CoreDataProperties.swift
//  myDayApp
//
//  Created by Денис Матвеев on 02.12.2017.
//  Copyright © 2017 DenisMatveev. All rights reserved.
//
//

import Foundation
import CoreData


extension TasksOfDay {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TasksOfDay> {
        return NSFetchRequest<TasksOfDay>(entityName: "TasksOfDay")
    }

    @NSManaged public var avg: Double
    @NSManaged public var countOfRepeats: Int16
    @NSManaged public var date: NSDate?
    @NSManaged public var restOfRepeats: Int16
    @NSManaged public var idToDo: Int32
    @NSManaged public var max: Double
    @NSManaged public var measure: Bool
    @NSManaged public var measure1: Double
    @NSManaged public var measure2: Double
    @NSManaged public var measure3: Double
    @NSManaged public var measure4: Double
    @NSManaged public var measure5: Double
    @NSManaged public var min: Double
    @NSManaged public var nameToDo: String?
    @NSManaged public var tasks: Tasks?

}
