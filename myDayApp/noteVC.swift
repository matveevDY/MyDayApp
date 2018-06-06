//
//  noteVC.swift
//  myDayApp
//
//  Created by Денис Матвеев on 02.01.2018.
//  Copyright © 2018 DenisMatveev. All rights reserved.
//

import UIKit
import CoreData

class noteVC: UIViewController {
    
    @IBOutlet weak var note: UITextView!
    @IBOutlet weak var saveButton: UINavigationItem!
    @IBAction func save(_ sender: Any) {
        tasksOfDay[0].note = note.text
        CoreDataManager.saveContext()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CoreDataManager.getDataTasksOfDay(predicate: NSPredicate(format: "%K == %@ AND %K == %@", "idToDo", String(taskID), "date", nowDayShow as CVarArg))
        note.text = tasksOfDay[0].note
        
        if nowDayShow != today {
            saveButton.rightBarButtonItem?.isEnabled = false
        }
    }

}
