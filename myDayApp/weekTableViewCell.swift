//
//  weekTableViewCell.swift
//  myDayApp
//
//  Created by Денис Матвеев on 08.01.2018.
//  Copyright © 2018 DenisMatveev. All rights reserved.
//

import UIKit
import CoreData

class weekTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameOfDayLabel: UILabel!
    @IBOutlet weak var weekID: UILabel!
    @IBOutlet weak var weekDaySwitcher: UISwitch!
    @IBAction func weekDaySwitcherAction(_ sender: Any) {
        week[Int(weekID.text!)!] = String(weekDaySwitcher.isOn)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
