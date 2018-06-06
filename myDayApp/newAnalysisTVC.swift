//
//  analysisTVC.swift
//  myDayApp
//
//  Created by Денис Матвеев on 03.12.2017.
//  Copyright © 2017 DenisMatveev. All rights reserved.
//

import UIKit
import CoreData

var startDay = today
var endDay = today

class analysisTVC: UITableViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var nameToDoTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    
    @objc func startDatePickerChange(sender: UIDatePicker) {
        startDateTextField.text = "\(CoreDataManager.dateFormattorToString(sender: sender.date))"
    }
    
    @objc func endDatePickerChange(sender: UIDatePicker) {
        endDateTextField.text = "\(CoreDataManager.dateFormattorToString(sender: sender.date))"
    }
    
    @objc func doneEditingDatePicker () {

        if (startDateTextField.text != "") {
            startDay = CoreDataManager.dateFormattorToDate(sender: startDateTextField.text!)
            
            if startDay > today {
                startDateTextField.text = CoreDataManager.dateFormattorToString(sender: today)
            }
            
        }
        
        if (endDateTextField.text != "") {
            endDay = CoreDataManager.dateFormattorToDate(sender: endDateTextField.text!)
            
            if startDay > endDay {
                startDateTextField.text = ""
            }
            
            if endDay > today {
                endDateTextField.text = CoreDataManager.dateFormattorToString(sender: today)
            }
            
            if (endDay <= today) && (startDay <= endDay) {
                nameToDoTextField.isEnabled = true
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
        
        if textField.placeholder != "Название задачи" {
        
        textField.inputView = datePicker
        textField.inputAccessoryView = toolbar
        datePicker.datePickerMode = .date
        
            if textField.placeholder == "Дата начала" {
                startDateTextField.text = "\(CoreDataManager.dateFormattorToString(sender: datePicker.date))"
                datePicker.addTarget(self, action: #selector (startDatePickerChange), for: UIControlEvents.valueChanged)
                nameToDoTextField.text = ""
                nameToDoTextField.isEnabled = false
                createButton.isEnabled = false
            }
            
            if endDateTextField.text != "" {
                datePicker.date = CoreDataManager.dateFormattorToDate(sender: endDateTextField.text!)
            } else {
                datePicker.date = CoreDataManager.dateFormattorToDate(sender: CoreDataManager.dateFormattorToString(sender: today))
            }
            
            if textField.placeholder == "Дата окончания"{
                endDateTextField.text = "\(CoreDataManager.dateFormattorToString(sender: datePicker.date))"
                datePicker.addTarget(self, action: #selector (endDatePickerChange), for: UIControlEvents.valueChanged)
                nameToDoTextField.text = ""
                nameToDoTextField.isEnabled = false
                createButton.isEnabled = false
            }
        } else {
            CoreDataManager.getDataTasks(predicate: NSPredicate(format: "%K >= %@ AND %K <= %@ AND %K == %@", "endDay", startDay as CVarArg, "startDay", endDay as CVarArg, "measure", true as CVarArg))
            
            if tasks.isEmpty == false {
                let pickerView = UIPickerView()
                textField.inputView = pickerView
                textField.inputAccessoryView = toolbar
                pickerView.delegate = self
                
                if nameToDoTextField.text == "" {
                    nameToDoTextField.text = String(describing: tasks[0].nameToDo!)
                    taskID = Int(tasks[0].idToDo)
                    createButton.isEnabled = true
                    
                }
            } else {
                nameToDoTextField.text = "Задачи отсутствуют"
                nameToDoTextField.isEnabled = false
            }
            
        }
        
        }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tasks.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        taskID = Int(tasks[row].idToDo)
        nameToDoTextField.text = String(describing: tasks[row].nameToDo!)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(describing: tasks[row].nameToDo!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startDateTextField.delegate = self
        endDateTextField.delegate = self
        nameToDoTextField.delegate = self
    }

}
