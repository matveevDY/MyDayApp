//
//  TasksOfDay+CoreDataProperties.swift
//  myDayApp
//
//  Created by Денис Матвеев on 08.01.2018.
//  Copyright © 2018 DenisMatveev. All rights reserved.
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
    @NSManaged public var idToDo: Int32
    @NSManaged public var max: Double
    @NSManaged public var measure: Bool
    @NSManaged public var measures: String?
    @NSManaged public var min: Double
    @NSManaged public var nameToDo: String?
    @NSManaged public var note: String?
    @NSManaged public var restOfRepeats: Int16
    @NSManaged public var time: String?
    @NSManaged public var tasks: Tasks?

}
