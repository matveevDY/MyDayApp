//
//  measureTableViewCell.swift
//  myDayApp
//
//  Created by Денис Матвеев on 05.01.2018.
//  Copyright © 2018 DenisMatveev. All rights reserved.
//

import UIKit
import CoreData

class measureTableViewCell: UITableViewCell {


    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameMeasure: UILabel!
    @IBOutlet weak var idMeasure: UILabel!
    @IBOutlet weak var measureLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
