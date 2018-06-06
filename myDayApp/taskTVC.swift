//
//  TableViewController.swift
//  myDay
//
//  Created by Денис Матвеев on 09.11.2017.
//  Copyright © 2017 DenisMatveev. All rights reserved.
//

import UIKit
import CoreData

var arrayAlarm = [String]()
var week: [String] = ["true", "true", "true", "true", "true", "true", "true"]

class TableViewController: UITableViewController, UITextFieldDelegate {
    
    var weekString = ""
    var stringArrayAlarms = ""
    var taskCount = 0
    
    @IBOutlet weak var nameToDoTextField: UITextField!
    @IBOutlet weak var errorNameToDo: UILabel!
    @IBOutlet weak var measureSwitcher: UISwitch!
    @IBOutlet weak var repeatSwitcher: UISwitch!
    @IBOutlet weak var labelCountOfRepetitions: UILabel!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var errorStartDateTextField: UILabel!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var errorEndDateTextField: UILabel!
    @IBOutlet weak var errorAlarmFeed: UILabel!
    
    
    @IBOutlet weak var segmentedControlCountOfRepetitions: UISegmentedControl!
    @IBAction func segmentedControlCountOfRepetitionsAction(_ sender: Any) {
        count = Int16(segmentedControlCountOfRepetitions.selectedSegmentIndex) + 2
        removeAlarm()
    }
    @IBOutlet weak var weekSetLabel: UIButton!
    @IBAction func weekSetAction(_ sender: Any) {
        performSegue(withIdentifier: "segueToWeek", sender: self)
    }
    @IBOutlet weak var setAlarmLabel: UIButton!
    @IBAction func setAlarmAction(_ sender: Any) {
        performSegue(withIdentifier: "segueToAlarm", sender: self)
    }
    
    
    @IBAction func measureSwitcherAction(_ sender: Any) {
        measureSwitcher.isOn = !measureSwitcher.isOn
    }
    
    @IBAction func repeatSwitcherAction(_ sender: Any) {
        if repeatSwitcher.isOn == false {
            repeatSwitcher.isOn = true
            labelCountOfRepetitions.isEnabled = true
            segmentedControlCountOfRepetitions.isEnabled = true
            segmentedControlCountOfRepetitions.selectedSegmentIndex = 0
            count = Int16(segmentedControlCountOfRepetitions.selectedSegmentIndex) + 2
        } else {
            repeatSwitcher.isOn = false
            labelCountOfRepetitions.isEnabled = false
            segmentedControlCountOfRepetitions.isEnabled = false
            count = 1
            removeAlarm()
        }
        
    }
    @IBOutlet weak var alarmSwitcher: UISwitch!
    @IBAction func alarmSwitcherAction(_ sender: Any) {
        if alarmSwitcher.isOn == false {
            alarmSwitcher.isOn = true
            setAlarmLabel.isEnabled = true
        } else {
            alarmSwitcher.isOn = false
            setAlarmLabel.isEnabled = false
            errorAlarmFeed.isHidden = true
            arrayAlarm.removeAll()
        }
    }
    
    func removeAlarm() {
        if count < arrayAlarm.count {
            while count < arrayAlarm.count {
                arrayAlarm.remove(at: arrayAlarm.count - 1)
            }
        }
    }
    
    @IBOutlet weak var titleNavigationItem: UINavigationItem!
    @IBOutlet weak var createButton: UIButton!
    @IBAction func createButtonAction(_ sender: Any) {
        if nameToDoTextField.text == "" {errorNameToDo.isHidden = false} else {errorNameToDo.isHidden = true}
        nameToDoTextField.resignFirstResponder()
        
        if startDateTextField.text == "" {errorStartDateTextField.isHidden = false} else {errorStartDateTextField.isHidden = true}
        startDateTextField.resignFirstResponder()
        
        if endDateTextField.text == "" {errorEndDateTextField.isHidden = false} else {errorEndDateTextField.isHidden = true}
        endDateTextField.resignFirstResponder()
        
        var flag = true

        if (alarmSwitcher.isOn == true) && (arrayAlarm.count != count) {
            errorAlarmFeed.isHidden = false
            flag = false
        } else {
            errorAlarmFeed.isHidden = true
            flag = true
        }

        if (nameToDoTextField.text != "") && (startDateTextField.text != "") && (endDateTextField.text != "") && (flag == true){
            if changeTask == true {
                actionChangeTask()
            } else {
                actionCreateNewTask()
            }
            CoreDataManager.saveContext()
            navigationController?.popViewController(animated: true)
        }
    }
    
    func setWeekAndAlarmForUpload () {
        for i in 0..<week.count {
            weekString.append("  \(week[i])")
        }
        
        for i in 0..<arrayAlarm.count {
            stringArrayAlarms.append("  \(String(arrayAlarm[i]))")
        }
    }
    
    func actionCreateNewTask (){
        CoreDataManager.getDataTasks(predicate: NSPredicate(format: "idToDo >= %@", "0"))
        taskCount = tasks.count + 1
        setWeekAndAlarmForUpload ()
        let task = Tasks(context: CoreDataManager.context)
        task.countOfRepeats = count
        task.idToDo = Int32(taskCount)
        task.nameToDo = nameToDoTextField.text
        task.measure = measureSwitcher.isOn
        if stringArrayAlarms == "" {
            task.alarm = nil
        } else {
            task.alarm = stringArrayAlarms
        }
        task.startDay = CoreDataManager.dateFormattorToDate(sender: startDateTextField.text!) as NSDate
        task.endDay = CoreDataManager.dateFormattorToDate(sender: endDateTextField.text!) as NSDate
        task.dateCreateTaskOfDay = CoreDataManager.dateFormattorToDate(sender: "01 января 2000 г.") as NSDate
        task.week = weekString
    }
    
    func actionChangeTask() {
        setWeekAndAlarmForUpload ()
        tasks[0].nameToDo = nameToDoTextField.text
        tasks[0].measure = measureSwitcher.isOn
        tasks[0].countOfRepeats = count
        if stringArrayAlarms == "" {
            tasks[0].alarm = nil
        } else {
            tasks[0].alarm = stringArrayAlarms
        }
        tasks[0].startDay = CoreDataManager.dateFormattorToDate(sender: startDateTextField.text!) as NSDate
        tasks[0].endDay = CoreDataManager.dateFormattorToDate(sender: endDateTextField.text!) as NSDate
        tasks[0].week = weekString
    }

    func openChangeTask () {
        CoreDataManager.getDataTasks(predicate: NSPredicate(format: "idToDo == %@", String(taskID)))
        nameToDoTextField.text = tasks[0].nameToDo
        measureSwitcher.isOn = tasks[0].measure
        count = tasks[0].countOfRepeats
        if count > 1 {
            repeatSwitcher.isOn = true
            labelCountOfRepetitions.isEnabled = true
            segmentedControlCountOfRepetitions.isEnabled = true
            segmentedControlCountOfRepetitions.selectedSegmentIndex = Int(count) - 2
        }
        
        let alarm = tasks[0].alarm
        if alarm != nil {
            let arrayAlarmAdiing = alarm!.split(separator: " " )
            arrayAlarm = arrayAlarmAdiing.map{String($0)}
            setAlarmLabel.isEnabled = true
            alarmSwitcher.isOn = true
        }
        
        startDateTextField.text = CoreDataManager.dateFormattorToString(sender: tasks[0].startDay! as Date)
        endDateTextField.text = CoreDataManager.dateFormattorToString(sender: tasks[0].endDay! as Date)
        
        let startDay = CoreDataManager.dateFormattorToDate(sender: startDateTextField.text!)
        let endDay = CoreDataManager.dateFormattorToDate(sender: endDateTextField.text!)
        let testDay = Calendar.current.date(byAdding: .day, value: +7, to: startDay)!
        
        if testDay <= endDay {
            weekSetLabel.isEnabled = true
            
            let dayOfWeek = tasks[0].week
            let arrayWeekAdiing = dayOfWeek!.split(separator: " " )
            week = arrayWeekAdiing.map{String($0)}
        }
        
        nameToDoTextField.isEnabled = false
        nameToDoTextField.textColor = #colorLiteral(red: 0.5607210994, green: 0.5608207583, blue: 0.5607148409, alpha: 1)
        startDateTextField.isEnabled = false
        startDateTextField.textColor = #colorLiteral(red: 0.5607210994, green: 0.5608207583, blue: 0.5607148409, alpha: 1)
        endDateTextField.isEnabled = true
    }
    
    @objc func startDatePickerChange(sender: UIDatePicker) {
        startDateTextField.text = "\(CoreDataManager.dateFormattorToString(sender: sender.date))"
    }
    
    @objc func endDatePickerChange(sender: UIDatePicker) {
        endDateTextField.text = "\(CoreDataManager.dateFormattorToString(sender: sender.date))"
    }
    
    @objc func doneEditingDatePicker () {
        if (startDateTextField.text != "") {
            let startDay = CoreDataManager.dateFormattorToDate(sender: startDateTextField.text!)
            let today = CoreDataManager.dateFormattor(sender: Date() as NSDate)
            let testDay = Calendar.current.date(byAdding: .day, value: +7, to: startDay)!
            
            if (today > startDay) && (startDateTextField.isEnabled == true) {
                startDateTextField.text = ""
            }
            
            if (endDateTextField.text != "") {
            let endDay = CoreDataManager.dateFormattorToDate(sender: endDateTextField.text!)
                
            if startDay <= endDay {
            if testDay <= endDay {
                weekSetLabel.isEnabled = true
            } else {
                weekSetLabel.isEnabled = false
                week = ["true", "true", "true", "true", "true", "true", "true"]
            }
                
            } else {
                endDateTextField.text = ""
            }
        }
        }
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: nil, action: #selector (doneEditingDatePicker))
        toolbar.setItems([doneButton], animated: true)
        let datePicker = UIDatePicker()
        datePicker.locale = NSLocale (localeIdentifier: "ru_RU") as Locale
        
        errorNameToDo.isHidden = true
        
        if textField.placeholder != "Название задачи" {
            textField.inputView = datePicker
            textField.inputAccessoryView = toolbar
            datePicker.datePickerMode = .date
            
            if startDateTextField.text != "" {
                datePicker.date = CoreDataManager.dateFormattorToDate(sender: startDateTextField.text!)
            }
            
            if textField.placeholder == "Дата начала" {
                startDateTextField.text = "\(CoreDataManager.dateFormattorToString(sender: datePicker.date))"
                datePicker.addTarget(self, action: #selector (startDatePickerChange), for: UIControlEvents.valueChanged)
                endDateTextField.isEnabled = true
                errorStartDateTextField.isHidden = true
            }
            
            if endDateTextField.text != "" {
                datePicker.date = CoreDataManager.dateFormattorToDate(sender: endDateTextField.text!)
            } else {
                datePicker.date = CoreDataManager.dateFormattorToDate(sender: startDateTextField.text!)
            }
            
            if textField.placeholder == "Дата окончания"{
                    endDateTextField.text = "\(CoreDataManager.dateFormattorToString(sender: datePicker.date))"
                    datePicker.addTarget(self, action: #selector (endDatePickerChange), for: UIControlEvents.valueChanged)
                    errorEndDateTextField.isHidden = true
            }
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        count = 1
        nameToDoTextField.delegate = self
        startDateTextField.delegate = self
        endDateTextField.delegate = self
        if changeTask == true {
            openChangeTask()
            titleNavigationItem.title = "Настройка задачи"
            createButton.setTitle("Сохранить", for: .normal)
        }
    }

}
