//
//  StaticsBarChartViewTotalSpendingController.swift
//  SimpleBudget
//
//  Created by Lezardvaleth on 2019/3/17.
//  Copyright © 2019 Lezardvaleth. All rights reserved.
//

import Foundation
import Charts
import CoreData

class StaticsBarChartViewTotalSpendingController: UIViewController,ChartViewDelegate{
    @IBOutlet weak var barChartView: BarChartView!
    let context = AppDelegate.viewContext
    var costs = [Cost]()
    var dates = [Date]()
    //MYTODO: fix the barcharts setting
    override func viewDidLoad() {
        super.viewDidLoad()
        barChartView.delegate = self
        costs = loadCost()
        dates = loadDates(costs: costs)
        let data = barDataPreparation(dates: dates, costs: costs)
        barChartView.data = data
        let dateFormatterXAxis = ChartDateValueFormatter()
        barChartView.xAxis.valueFormatter = dateFormatterXAxis
        barChartView.xAxis.labelRotationAngle = 90
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawGridLinesEnabled = false
        chartViewLabelCountSet()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        costs = loadCost()
        dates = loadDates(costs: costs)
        let data = barDataPreparation(dates: dates,costs: costs)
        barChartView.data = data
        chartViewLabelCountSet()
        
        
    }
    
    private func loadCost() -> [Cost]{
        let request: NSFetchRequest<Cost> = Cost.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        //        request.predicate = NSPredicate(format: "amount > %@", "0")
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
        for cost in costs{
            if !result.contains(cost.date!){
                result.append(cost.date!)
            }
        }
        return result
    }
    
    private func perMonthCostsSum(dateToSum:Date, costs:[Cost]) -> Double{
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
        return yearCheck && monthCheck
    }
    
    private func barDataPreparation(dates:[Date],costs:[Cost]) -> BarChartData {
        var costIntoSet = [ChartDataEntry]()
        for date in dates{
            let costYAxis = perMonthCostsSum(dateToSum: date, costs: costs)
            let costDataEntry = ChartDataEntry(x: Double(date.timeIntervalSince1970), y: costYAxis)
            costIntoSet.append(costDataEntry)
        }
        let costSet = BarChartDataSet(values: costIntoSet, label: "Total Cost")
        costSet.setColor(.green)
        let output = BarChartData(dataSets: [costSet])
        return output
    }
    
    private func chartViewLabelCountSet() {
        let dateCount = dates.count
        switch dateCount {
        case 0:
            barChartView.xAxis.labelCount = 1
        case 1...10:
            barChartView.xAxis.labelCount = dateCount
        default:
            barChartView.xAxis.labelCount = 10
        }
    }
}
