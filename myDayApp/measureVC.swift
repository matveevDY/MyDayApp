//
//  measureVC.swift
//  myDayApp
//
//  Created by Денис Матвеев on 05.01.2018.
//  Copyright © 2018 DenisMatveev. All rights reserved.
//

import UIKit

class measureVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var measureTableView: UITableView!
    @IBOutlet weak var measureCell: UITableViewCell!
    @IBOutlet weak var addMeasureButton: UIBarButtonItem!
    @IBOutlet weak var min: UILabel!
    @IBOutlet weak var avg: UILabel!
    @IBOutlet weak var max: UILabel!
    var change = false
    var id = 0
    @IBAction func addMeasureAction(_ sender: Any) {
        change = false
        alert(title: "Новое измерение", buttonTitle: "Добавить")
    }
    
    func alert (title: String, buttonTitle: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.keyboardType = .decimalPad
        }
        
        let action = UIAlertAction(title: buttonTitle, style: .default) { (_) in
            if (alert.textFields!.first!.text!) != "" {
                measureData.getMeasure()
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                formatter.locale = NSLocale (localeIdentifier: "ru_RU") as Locale
                let stringNumber = String(alert.textFields!.first!.text!)
                number = formatter.number(from: stringNumber)!
                addingNumber = Double(truncating: number)
                
                if self.change == false {
                    arrayMeasures.append(addingNumber)
                    restOfRepeats -= 1
                    tasksOfDay[0].restOfRepeats = restOfRepeats
                } else {
                    arrayMeasures[self.id - 1] = addingNumber
                }
                measureData.uploadMeasure()
                self.viewDidLoad()
                self.measureTableView.reloadData()
            }
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .cancel) { (_) in }
        
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMeasures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mCell = measureTableView.dequeueReusableCell(withIdentifier: "mCell") as! measureTableViewCell
        
        mCell.timeLabel.text = arrayTime[indexPath.row]
        mCell.idMeasure.text = String(indexPath.row + 1)
        mCell.measureLabel.text = String(describing: arrayMeasures[indexPath.row])

        return mCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if today == nowDayShow {
            let mCell = tableView.cellForRow(at: indexPath) as! measureTableViewCell
            id = Int(mCell.idMeasure.text!)!
            change = true
            alert(title: "Новое значение для: Измерение \(id)", buttonTitle: "Изменить")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        CoreDataManager.getDataTasksOfDay(predicate: NSPredicate(format: "%K == %@ AND %K == %@", "idToDo", String(taskID), "date", nowDayShow as CVarArg))
        measureData.getMeasure()
        min.text = String(tasksOfDay[0].min)
        max.text = String(tasksOfDay[0].max)
        avg.text = String(tasksOfDay[0].avg)

        if (restOfRepeats == 0) || (nowDayShow != today) {
            addMeasureButton.isEnabled = false
        }
        
        if restOfRepeats == count {
            measureTableView.isHidden = true
            measureCell.isHidden = true
        } else {
            measureTableView.isHidden = false
            measureCell.isHidden = false
        }
    }

}
