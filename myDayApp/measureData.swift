//
//  allertMeasure.swift
//  myDayApp
//
//  Created by Денис Матвеев on 03.01.2018.
//  Copyright © 2018 DenisMatveev. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class measureData{

    private init() {}
    
    static func getMeasure () {
        let measures = tasksOfDay[0].measures
        let time = tasksOfDay[0].time
        restOfRepeats = tasksOfDay[0].restOfRepeats
        count = tasksOfDay[0].countOfRepeats
        arrayMeasures.removeAll()
        arrayTime.removeAll()
        
        if measures != nil {
            let arrayMeasureAdiing = measures!.split(separator: " " )
            arrayMeasures = arrayMeasureAdiing.map{Double($0)!}
            let arrayTimeAdiing = time!.split(separator: " " )
            arrayTime = arrayTimeAdiing.map{String($0)}
        }
    }
    
    static func uploadMeasure () {
        let time = CoreDataManager.timeFormattorToString(sender: Date() as NSDate)
        var stringArrayMeasures = ""
        var stringArrayTime = ""
        var sum = 0.0
        arrayTime.append(time)
        
        for i in 0..<arrayMeasures.count {
            stringArrayMeasures.append("  \(String(arrayMeasures[i]))")
            stringArrayTime.append("  \(arrayTime[i])")
            sum += arrayMeasures[i]
        }
        
        let avg = Double((NSString(format:"%.2f", (sum / Double(arrayMeasures.count))) as String))!

        tasksOfDay[0].measures = stringArrayMeasures
        tasksOfDay[0].time = stringArrayTime
        tasksOfDay[0].avg = avg
        tasksOfDay[0].min = arrayMeasures.min()!
        tasksOfDay[0].max = arrayMeasures.max()!
        CoreDataManager.saveContext()
    }
    
}
