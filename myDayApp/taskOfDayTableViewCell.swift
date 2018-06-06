//
//  TableViewCell.swift
//  myDayApp
//
//  Created by Денис Матвеев on 02.12.2017.
//  Copyright © 2017 DenisMatveev. All rights reserved.
//

import UIKit
import CoreData

class TableViewCell: UITableViewCell {

    var delegate: UIViewController?
    
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var countOfRepeats: UILabel!
    @IBOutlet weak var idTask: UILabel!
    @IBOutlet weak var statusMeasure: UILabel!
    
    @IBOutlet weak var checkButton: UIButton!
    @IBAction func checkButtonAction(_ sender: Any) {
        if nowDayShow == today {
        taskID = Int(idTask.text!)!
        CoreDataManager.getDataTasksOfDay(predicate: NSPredicate(format: "%K == %@ AND %K == %@", "idToDo", String(taskID), "date", nowDayShow as CVarArg))
        restOfRepeats = tasksOfDay[0].restOfRepeats
        count = tasksOfDay[0].countOfRepeats
        let measure = tasksOfDay[0].measure
        if (measure == true) && (restOfRepeats != 0) {
            self.alert()
        } else {
            self.setCheck()
        }
        }
    }
    
    
    func alert () {
        let alert = UIAlertController(title: "Новое измерение", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.keyboardType = .decimalPad
        }
        
        let action = UIAlertAction(title: "Добавить", style: .default) { (_) in
            if (alert.textFields!.first!.text!) != "" {
                measureData.getMeasure()
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                formatter.locale = NSLocale (localeIdentifier: "ru_RU") as Locale
                let stringNumber = String(alert.textFields!.first!.text!)
                number = formatter.number(from: stringNumber)!
                addingNumber = Double(truncating: number)
                arrayMeasures.append(addingNumber)
                measureData.uploadMeasure()
                self.setCheck()
            }
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .cancel) { (_) in }
        
        alert.addAction(action)
        alert.addAction(cancel)
        delegate?.present(alert, animated: true, completion: nil)
    }
    
    func setCheck() {
        if restOfRepeats != 0 {
            restOfRepeats -= 1
            tasksOfDay[0].restOfRepeats = restOfRepeats
            
        CoreDataManager.saveContext()

        if count > 1 {
            countOfRepeats.text = "Осталось повторов: \(restOfRepeats) из \(count)"
            }
        
        if (restOfRepeats == 0) {
            checkButton.setImage(UIImage(named: "checkDone"), for: .normal)
        }
        if (restOfRepeats > 0) {
            checkButton.setImage(UIImage(named: "checkOn"), for: .normal)
        }
        if (restOfRepeats == count) {
            checkButton.setImage(UIImage(named: "checkOff"), for: .normal)
        }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
