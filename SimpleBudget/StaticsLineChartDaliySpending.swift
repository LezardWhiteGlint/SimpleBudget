//
//  StaticsViewController.swift
//  SimpleBudget
//
//  Created by Lezardvaleth on 2019/3/13.
//  Copyright © 2019 Lezardvaleth. All rights reserved.
//

import Foundation
import Charts
import CoreData

class StaticsLineChartRecentThirtyDaysSpending : UIViewController,ChartViewDelegate {
    @IBOutlet weak var lineChartView: LineChartView!
    let context = AppDelegate.viewContext
    var costs = [Cost]()
    var dates = [Date]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lineChartView.delegate = self
        costs = loadCost()
        dates = loadDates(costs: costs)
        let data = lineDataPreparation(dates: dates, costs: costs)
        lineChartView.data = data
        let dateFormatterXAxis = ChartDateValueFormatter()
        lineChartView.xAxis.valueFormatter = dateFormatterXAxis
        lineChartView.xAxis.labelRotationAngle = 90
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        costs = loadCost()
        dates = loadDates(costs: costs)
        let data = lineDataPreparation(dates: dates,costs: costs)
        lineChartView.data = data
        
        
    }
    
    //MYTODO: get data directly from coredata instead of load it into list
    
    private func loadCost() -> [Cost]{
        // use canlendar to get recent 30 days
        var canlendar = Calendar.current
        canlendar.timeZone = NSTimeZone.local
        let thirtyDaysBefore = canlendar.date(byAdding: .day,value: -30, to: Date())
        let request: NSFetchRequest<Cost> = Cost.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        request.predicate = NSPredicate(format: "date > %@", thirtyDaysBefore! as NSDate)
        //        let context = AppDelegate.viewContext
        var returnCosts = [Cost]()
        let result = try? context.fetch(request)
        for eachCost in (result ?? []) {
            returnCosts.append(eachCost)
        }
        return returnCosts
    }
    
    
    private func loadDates(costs:[Cost]) -> [Date] {
        var result = [Date]()
        let calendar = Calendar(identifier: .iso8601)
        for cost in costs{
            let year = calendar.component(Calendar.Component.year, from:cost.date!)
            let month = calendar.component(Calendar.Component.month, from:cost.date!)
            let day = calendar.component(Calendar.Component.day, from:cost.date!)
            let dateToAddComponents = DateComponents(calendar: calendar, timeZone: nil, era: nil, year: year, month: month, day: day, hour: nil, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
            let dateToAdd = calendar.date(from:  dateToAddComponents)!
            if !result.contains(dateToAdd){
                result.append(dateToAdd)
            }
        }
        return result
    }
    
    private func perDayCostsSum(dateToSum:Date, costs:[Cost]) -> Double{
        var result = 0.0
        for cost in costs {
            if queryDateCheck(selectedDate: dateToSum, toCheckDate: cost.date!){
                result += cost.amount
            }
        }
        return result
    }
    
    
    private func queryDateCheck(selectedDate:Date, toCheckDate:Date) -> Bool {
        let calendar = Calendar(identifier: .iso8601)
        let yearCheck = calendar.component(Calendar.Component.year, from: selectedDate) == calendar.component(Calendar.Component.year, from: toCheckDate)
        let monthCheck = calendar.component(Calendar.Component.month, from: selectedDate) == calendar.component(Calendar.Component.month, from: toCheckDate)
        let dayCheck = calendar.component(Calendar.Component.day, from: selectedDate) == calendar.component(Calendar.Component.day, from: toCheckDate)
        return yearCheck && monthCheck && dayCheck
    }
    
    private func lineDataPreparation(dates:[Date],costs:[Cost]) -> LineChartData {
        var costIntoSet = [ChartDataEntry]()
        for date in dates{
            let costYAxis = perDayCostsSum(dateToSum: date, costs: costs)
            let costDataEntry = ChartDataEntry(x: Double(date.timeIntervalSince1970), y: costYAxis)
            costIntoSet.append(costDataEntry)
        }
        let costSet = LineChartDataSet(values: costIntoSet, label: NSLocalizedString("Total Cost", comment: ""))
        costSet.setColor(.green)
        costSet.setCircleColor(.green)
        costSet.circleRadius = 3
        costSet.lineWidth = 2
        let output = LineChartData(dataSet: costSet)
        return output
    }
    
//    private func sixtyDaysDataLimitProcessor() {
//        if let last = allDates.last {
//            if let lastIndex = allDates.lastIndex(of: last) {
//                let firstIndex = lastIndex - 59
//                print(firstIndex)
//                print(lastIndex)
//                if firstIndex >= 0 {
//                    print(allCosts.count)
//                    print(allDates.count)
//                    costs = Array(allCosts[firstIndex...lastIndex])
//                    dates = Array(allDates[firstIndex...lastIndex])
//                }else{
//                    costs = allCosts
//                    dates = allDates
//                }
//            }
//        }
//    }
    
    
    
    
    
    
    
    
    
}
