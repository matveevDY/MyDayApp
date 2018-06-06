//
//  alarmVC.swift
//  myDayApp
//
//  Created by Денис Матвеев on 08.01.2018.
//  Copyright © 2018 DenisMatveev. All rights reserved.
//

import UIKit
import CoreData

class alarmVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let alarmCell = alarmTableView.dequeueReusableCell(withIdentifier: "alarmCell") as! alarmTableViewCell
        alarmCell.delegate = self
        alarmCell.nomberOfAlarm.text = String(indexPath.row + 1)
        
        if arrayAlarm.count >= indexPath.row {
            alarmCell.setTimeTextField.isEnabled = true
            
            if arrayAlarm.count != indexPath.row {
                alarmCell.setTimeTextField.text = arrayAlarm[indexPath.row]
                alarmCell.setTimeTextField.textColor = #colorLiteral(red: 0.2587913573, green: 0.2588421106, blue: 0.2587881684, alpha: 1)
            } else {
                alarmCell.setTimeTextField.textColor = #colorLiteral(red: 0, green: 0.4793452024, blue: 0.9990863204, alpha: 1)
            }
        } else {
            alarmCell.setTimeTextField.isEnabled = false
            alarmCell.setTimeTextField.textColor = #colorLiteral(red: 0.5607210994, green: 0.5608207583, blue: 0.5607148409, alpha: 1)
        }
        
        return alarmCell
    }
    
    @objc func doneEditingDatePicker () {
        self.view.endEditing(true)
    }

    
    @IBOutlet weak var alarmTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alarmTableView.reloadData()

    }

}
