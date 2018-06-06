//
//  analysisVC.swift
//  myDayApp
//
//  Created by Денис Матвеев on 03.12.2017.
//  Copyright © 2017 DenisMatveev. All rights reserved.
//

import UIKit
import CoreData

class analysisVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var minValue: UILabel!
    @IBOutlet weak var avgValue: UILabel!
    @IBOutlet weak var maxValue: UILabel!
    
    var min = 0.0
    var avg = 0.0
    var max = 0.0
    var minAvg = 0.0
    var maxAvg = 0.0

    func calculations (){
        var minArray = [Double]()
        var maxArray = [Double]()
        var avgArrayMin = [Double]()
        var avgArrayMax = [Double]()
        
        for i in 0..<tasksOfDay.count {
            minArray.append(tasksOfDay[i].min)
            maxArray.append(tasksOfDay[i].max)
        }
        min = minArray.min()!
        max = maxArray.max()!
        avg = (min + max) / 2
        
        for i in 0..<tasksOfDay.count {
            if tasksOfDay[i].min == min {
                avgArrayMin.append(tasksOfDay[i].avg)
            }
            if tasksOfDay[i].max == max {
                avgArrayMax.append(tasksOfDay[i].avg)
            }
        }
        
        minAvg = avgArrayMin.min()!
        maxAvg = avgArrayMax.max()!
    }
    
    @IBOutlet weak var analysisTableView: UITableView!
    @IBOutlet weak var analysisCell: UITableViewCell!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksOfDay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = analysisTableView.dequeueReusableCell(withIdentifier: "aCell") as! analysisTableViewCell
        
        func flag (state: Bool, color1: UIColor, color2: UIColor) {
            aCell.flag1.isHidden = state
            aCell.flag2.isHidden = state
            aCell.flag1.backgroundColor = color1
            aCell.flag2.backgroundColor = color2
        }
        
        flag(state: true, color1: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), color2: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        
        if (tasksOfDay[indexPath.row].min == min) && (tasksOfDay[indexPath.row].avg == minAvg) {
            flag(state: false, color1: #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1), color2: #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1))
        }
        if (tasksOfDay[indexPath.row].max == max) && (tasksOfDay[indexPath.row].avg == maxAvg) {
            flag(state: false, color1: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), color2: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1))
        }
        if (tasksOfDay[indexPath.row].min == min) && (tasksOfDay[indexPath.row].max == max) && (tasksOfDay[indexPath.row].avg == minAvg) && (tasksOfDay[indexPath.row].avg == maxAvg){
            flag(state: false, color1: #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1), color2: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1))
        }
        
        aCell.date.text = CoreDataManager.dateFormattorToString(sender: tasksOfDay[indexPath.row].date! as Date)
        aCell.min.text = String(tasksOfDay[indexPath.row].min)
        aCell.max.text = String(tasksOfDay[indexPath.row].max)
        aCell.avg.text = String(tasksOfDay[indexPath.row].avg)
        aCell.taskIDAnalysis.text = String(tasksOfDay[indexPath.row].idToDo)
        return aCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let aCell = analysisTableView.cellForRow(at: indexPath) as! analysisTableViewCell
        taskID = Int(aCell.taskIDAnalysis.text!)!
        nowDayShow = CoreDataManager.dateFormattorToDate(sender: aCell.date.text!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewDidLoad()
        analysisTableView.reloadData()
        nowDayShow = today
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        CoreDataManager.getDataTasksOfDay(predicate: NSPredicate(format: "%K == %@ AND %K >= %@ AND %K <= %@ AND %K != %@", "idToDo", String(taskID), "date", startDay as CVarArg, "date", endDay as CVarArg, "avg", "0.0"))
        
        if tasksOfDay.isEmpty == false {
            calculations()
            minValue.text = String(min)
            avgValue.text = String(avg)
            maxValue.text = String(max)
        } else {
            analysisCell.isHidden = true
            analysisTableView.isHidden = true
        }
        analysisTableView.dataSource = self
        analysisTableView.delegate = self
    }

}
