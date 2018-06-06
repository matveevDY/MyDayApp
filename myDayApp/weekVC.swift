//
//  weekVC.swift
//  myDayApp
//
//  Created by Денис Матвеев on 08.01.2018.
//  Copyright © 2018 DenisMatveev. All rights reserved.
//

import UIKit
import CoreData

class weekVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let nameDayOfWeek: [String] = ["Воскресенье", "Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота"]

    @IBOutlet weak var weekTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let wCell = weekTableView.dequeueReusableCell(withIdentifier: "wCell") as! weekTableViewCell
        wCell.nameOfDayLabel.text = nameDayOfWeek[indexPath.row]
        wCell.weekID.text = String(indexPath.row)
        wCell.weekDaySwitcher.isOn = Bool(week[indexPath.row])!
        return wCell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }


}
