//
//  toDoListVC.swift
//  myDay
//
//  Created by Денис Матвеев on 09.11.2017.
//  Copyright © 2017 DenisMatveev. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

var changeTask = false

class toDoListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableViewToDo: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = tasks[indexPath.row].nameToDo
        cell.detailTextLabel?.text = String(tasks[indexPath.row].idToDo)
        cell.detailTextLabel?.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let startDay = CoreDataManager.dateFormattor(sender: tasks[indexPath.row].startDay!)
            let idToDo = String(tasks[indexPath.row].idToDo)
            let dateCreateTaskOfDay = CoreDataManager.dateFormattor(sender: tasks[indexPath.row].dateCreateTaskOfDay!)
            
            if startDay == today {
                let task = tasks[indexPath.row]
                CoreDataManager.context.delete(task)
            } else {
                tasks[indexPath.row].endDay = Calendar.current.date(byAdding: .day, value: -1, to: today)! as NSDate
            }
            CoreDataManager.saveContext()
            
            if dateCreateTaskOfDay == today {
                CoreDataManager.getDataTasksOfDay(predicate: NSPredicate(format: "%K == %@ AND %K == %@", "idToDo", idToDo, "date", today as CVarArg))
                
                let taskOfDay = tasksOfDay[0]
                CoreDataManager.context.delete(taskOfDay)
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [String(describing: tasksOfDay[0].nameToDo)])
                CoreDataManager.saveContext()
            }
            CoreDataManager.getDataTasks(predicate: NSPredicate(format: "%K <= %@ AND %K >= %@", "startDay", today as CVarArg, "endDay", today as CVarArg))
        }
        self.tableViewToDo.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        CoreDataManager.getDataTasks(predicate: NSPredicate(format: "%K <= %@ AND %K >= %@", "startDay", today as CVarArg, "endDay", today as CVarArg))
        self.tableViewToDo.reloadData()
        changeTask = false
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        changeTask = true
        let currentCell = tableView.cellForRow(at: indexPath) as UITableViewCell?
        taskID = Int((currentCell?.detailTextLabel?.text)!)!
        performSegue(withIdentifier: "segueToChange", sender: self)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewToDo.dataSource = self
        tableViewToDo.delegate = self
        CoreDataManager.getDataTasks(predicate: NSPredicate(format: "%K <= %@ AND %K >= %@", "startDay", today as CVarArg, "endDay", today as CVarArg))
        self.tableViewToDo.reloadData()
        changeTask = false
    }


}

