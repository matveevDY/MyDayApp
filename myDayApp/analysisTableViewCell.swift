//
//  analysisTableViewCell.swift
//  myDayApp
//
//  Created by Денис Матвеев on 03.12.2017.
//  Copyright © 2017 DenisMatveev. All rights reserved.
//

import UIKit
import CoreData

class analysisTableViewCell: UITableViewCell {
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var min: UILabel!
    @IBOutlet weak var max: UILabel!
    @IBOutlet weak var avg: UILabel!
    @IBOutlet weak var flag1: UILabel!
    @IBOutlet weak var flag2: UILabel!
    @IBOutlet weak var taskIDAnalysis: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
