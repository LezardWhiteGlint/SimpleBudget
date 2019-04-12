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


class StaticsLineChartMonthlySpendingAndBudgetViewController : UIViewController,ChartViewDelegate {
    @IBOutlet weak var lineChartView: LineChartView!
    let context = AppDelegate.viewContext
    var costs = [Cost]()
    var budgets = [Budget]()
    var dates = [Date]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lineChartView.delegate = self
        costs = loadCost()
        budgets = loadBudget()
        dates = loadDates(budgets: budgets)
        let data = lineDataPreparation(dates: dates, budgets: budgets, costs: costs)
        lineChartView.data = data
        let dateFormatterXAxis = ChartDateValueFormatter()
        lineChartView.xAxis.valueFormatter = dateFormatterXAxis
        lineChartView.xAxis.labelRotationAngle = 90
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
        chartViewLabelCountSet()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        costs = loadCost()
        budgets = loadBudget()
        dates = loadDates(budgets: budgets)
        let data = lineDataPreparation(dates: dates, budgets: budgets, costs: costs)
        lineChartView.data = data
        chartViewLabelCountSet()
 

    }
    
    private func loadCost() -> [Cost]{
        let request: NSFetchRequest<Cost> = Cost.fetchRequest()
        //        request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
        //        request.predicate = NSPredicate(format: "amount > %@", "0")
        //        let context = AppDelegate.viewContext
        var returnCosts = [Cost]()
        let result = try? context.fetch(request)
        for eachCost in (result ?? []) {
                returnCosts.append(eachCost)
        }
        return returnCosts
    }
    
    private func loadBudget() -> [Budget]{
        let request: NSFetchRequest<Budget> = Budget.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        //        request.predicate = NSPredicate(format: "amount > %@", "0")
        //        let context = AppDelegate.viewContext
        var returnBudgets = [Budget]()
        let result = try? context.fetch(request)
        for eachBudget in (result ?? []) {
            returnBudgets.append(eachBudget)
        }
        return returnBudgets
    }
    
    private func loadDates(budgets:[Budget]) -> [Date] {
        var result = [Date]()
        for budget in budgets{
            if !result.contains(budget.date!){
                result.append(budget.date!)
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
    
    private func perMonthBudgetsSum(dateToSum:Date, budgets:[Budget]) -> Double{
        var result = 0.0
        for budget in budgets {
            if queryDateCheck(selectedDate: dateToSum, toCheckDate: budget.date!){
                result += budget.amount
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
    
    private func lineDataPreparation(dates:[Date], budgets:[Budget],costs:[Cost]) -> LineChartData {
        var costIntoSet = [ChartDataEntry]()
        var budgetIntoSet = [ChartDataEntry]()
        for date in dates{
            let costYAxis = perMonthCostsSum(dateToSum: date, costs: costs)
            let budgetYAxis = perMonthBudgetsSum(dateToSum: date, budgets: budgets)
            let costDataEntry = ChartDataEntry(x: Double(date.timeIntervalSince1970), y: costYAxis)
            let budgetDateEntry = ChartDataEntry(x: Double(date.timeIntervalSince1970), y: budgetYAxis)
            costIntoSet.append(costDataEntry)
            budgetIntoSet.append(budgetDateEntry)
        }
        let costSet = LineChartDataSet(values: costIntoSet, label: "Total Cost")
        costSet.setColor(.green)
        costSet.setCircleColor(.green)
        costSet.circleRadius = 3
        costSet.lineWidth = 2
        let budgetSet = LineChartDataSet(values: budgetIntoSet, label: "Total Budget")
        budgetSet.setColor(.red)
        budgetSet.setCircleColor(.red)
        budgetSet.circleRadius = 3
        budgetSet.lineWidth = 2
        let output = LineChartData(dataSets: [costSet,budgetSet])
        return output
    }
    
    private func chartViewLabelCountSet() {
        let dateCount = dates.count
        switch dateCount {
        case 0:
            lineChartView.xAxis.labelCount = 1
        case 1...10:
            lineChartView.xAxis.labelCount = dateCount
        default:
            lineChartView.xAxis.labelCount = 10
        }
    }
    
    
    
    
    
    
    
    
}
