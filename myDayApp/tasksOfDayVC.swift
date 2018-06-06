//
//  ViewController.swift
//  myDay
//
//  Created by Денис Матвеев on 09.11.2017.
//  Copyright © 2017 DenisMatveev. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

var taskID = 0
var today = CoreDataManager.dateFormattor(sender: Date() as NSDate)
var nowDayShow = today
let weekDay = Calendar.current.component(.weekday, from: nowDayShow)
var tasks = [Tasks]()
var tasksOfDay = [TasksOfDay]()
var arrayMeasures = [Double]()
var arrayTime = [String]()
var addingNumber = 0.0
var number: NSNumber = 0.0
var restOfRepeats: Int16 = 0
var count: Int16 = 0

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    @IBOutlet weak var toDoTableView: UITableView!
    
    @IBOutlet weak var nextDayButton: UIButton!
    
    
    @IBAction func nextDayAction(_ sender: Any) {
        changeDayShow(value: 1)
    }
    
    @IBAction func backDayAction(_ sender: Any) {
        changeDayShow(value: -1)
    }

    @IBAction func setTodayDay(_ sender: Any) {
        nowDayShow = today
        navigationItem.title = "Сегодня"
        nextDayButton.isEnabled = false
        CoreDataManager.getDataTasksOfDay(predicate: NSPredicate(format: "date == %@", nowDayShow as CVarArg))
        toDoTableView.reloadData()
    }
    
    func changeDayShow (value: Int) {
        nowDayShow = Calendar.current.date(byAdding: .day, value: +value, to: nowDayShow)!
        if nowDayShow == today{
            navigationItem.title = "Сегодня"
            nextDayButton.isEnabled = false
        } else {
            nextDayButton.isEnabled = true
            navigationItem.title = CoreDataManager.dateFormattorToString(sender: nowDayShow)
        }
        CoreDataManager.getDataTasksOfDay(predicate: NSPredicate(format: "date == %@", nowDayShow as CVarArg))
        toDoTableView.reloadData()
    }
    
    func createTasksOfDay () {
        CoreDataManager.getDataTasks(predicate: NSPredicate(format: "%K <= %@ AND %K >= %@", "startDay", today as CVarArg, "endDay", today as CVarArg))

        for i in 0..<tasks.count {
            let dayOfWeek = tasks[i].week
            let arrayWeekAdiing = dayOfWeek!.split(separator: " " )
            let week = arrayWeekAdiing.map{String($0)}
            
            if (tasks[i].dateCreateTaskOfDay != (today as NSDate)) && (week[weekDay - 1] == "true") {
                let tasksOfDay = TasksOfDay(context: CoreDataManager.context)
                taskID = Int(tasks[i].idToDo)
                tasksOfDay.idToDo = tasks[i].idToDo
                tasksOfDay.nameToDo = tasks[i].nameToDo
                tasksOfDay.date = today as NSDate
                tasksOfDay.measure = tasks[i].measure
                tasksOfDay.countOfRepeats = tasks[i].countOfRepeats
                tasksOfDay.restOfRepeats = tasks[i].countOfRepeats
                
                var arrayAlarm = [String]()
                count = tasks[i].countOfRepeats
                let alarm = tasks[i].alarm
                if alarm != nil {
                    let arrayAlarmAdiing = alarm!.split(separator: " " )
                    arrayAlarm = arrayAlarmAdiing.map{String($0)}
                    for j in 0..<Int(arrayAlarm.count) {
                        timedNotifications(component: CoreDataManager.timeFormattorToDateComponents(sender: arrayAlarm[j]), text: tasks[i].nameToDo!) { (success) in}
                    }
                }
                
                tasks[i].dateCreateTaskOfDay = today as NSDate
            }
        }
        CoreDataManager.saveContext()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksOfDay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let restOfRepeats = tasksOfDay[indexPath.row].restOfRepeats
        let count = tasksOfDay[indexPath.row].countOfRepeats
        var cell: TableViewCell

        if count == 1 {
            cell = toDoTableView.dequeueReusableCell(withIdentifier: "cell2") as! TableViewCell
            
        } else {
            cell = toDoTableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
            cell.countOfRepeats.text = "Осталось повторов: \(restOfRepeats) из \(count)"
        }
        
        cell.delegate = self
        cell.taskName.text = tasksOfDay[indexPath.row].nameToDo
        cell.idTask.text = String(tasksOfDay[indexPath.row].idToDo)
        cell.statusMeasure.text = String(tasksOfDay[indexPath.row].measure)
        
        
        if restOfRepeats == 0 {
            cell.checkButton.setImage(UIImage(named: "checkDone"), for: .normal)
        }
        if (restOfRepeats > 0) && (restOfRepeats < count) {
            cell.checkButton.setImage(UIImage(named: "checkOn"), for: .normal)
        }
        if restOfRepeats == count {
            cell.checkButton.setImage(UIImage(named: "checkOff"), for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
        taskID = Int(cell.idTask.text!)!
        if cell.statusMeasure.text == "true" {
            performSegue(withIdentifier: "segueToAddMeasure", sender: self)
        } else {
            performSegue(withIdentifier: "segueToNote", sender: self)
        }
    }

    
    @objc func handleSwipes (sender: UISwipeGestureRecognizer) {
        if (sender.direction == .right) {
            backDayAction((Any).self)
        }
        if (sender.direction == .left) && (navigationItem.title != "Сегодня") {
            nextDayAction((Any).self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewDidLoad()
        toDoTableView.reloadData()
    }
    
    
    func timedNotifications (component: DateComponents, text: String, complition: @escaping (_ Success: Bool) -> ()) {
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
        let content = UNMutableNotificationContent()
        content.body = text
        content.sound = UNNotificationSound.default()
        
        let request = UNNotificationRequest(identifier: text, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                complition(false)
            } else {
                complition(true)
            }
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in}
        toDoTableView.dataSource = self
        toDoTableView.delegate = self
        
        createTasksOfDay()
        CoreDataManager.getDataTasksOfDay(predicate: NSPredicate(format: "date == %@", nowDayShow as CVarArg))
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector (handleSwipes))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector (handleSwipes))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
    }


}

