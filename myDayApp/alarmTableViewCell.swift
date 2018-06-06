//
//  alarmTableViewCell.swift
//  myDayApp
//
//  Created by Денис Матвеев on 08.01.2018.
//  Copyright © 2018 DenisMatveev. All rights reserved.
//

import UIKit
import CoreData

class alarmTableViewCell: UITableViewCell, UITextFieldDelegate {

    var delegate: UIViewController?
    
    @IBOutlet weak var nomberOfAlarm: UILabel!
    
    @IBOutlet weak var setTimeTextField: UITextField!
    
    @objc func doneEditingDatePicker() {
        arrayAlarm.append(self.setTimeTextField.text!)
        self.delegate?.viewDidLoad()
        self.delegate?.view.endEditing(true)
    }

    
    @objc func datePickerChange(sender: UIDatePicker) {
        setTimeTextField.text = "\(CoreDataManager.timeFormattorToString(sender: sender.date as NSDate))"
    }

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector (doneEditingDatePicker))
        toolbar.setItems([doneButton], animated: true)
        let datePicker = UIDatePicker()
        datePicker.locale = NSLocale (localeIdentifier: "ru_RU") as Locale
        textField.inputView = datePicker
        textField.inputAccessoryView = toolbar
        datePicker.datePickerMode = .time
        setTimeTextField.textColor = #colorLiteral(red: 0.2587913573, green: 0.2588421106, blue: 0.2587881684, alpha: 1)
        setTimeTextField.text = "\(CoreDataManager.timeFormattorToString(sender: datePicker.date as NSDate))"
        datePicker.addTarget(self, action: #selector (datePickerChange), for: UIControlEvents.valueChanged)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setTimeTextField.delegate = self
        // Configure the view for the selected state
    }
}
