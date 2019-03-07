//
//  SecondViewController.swift
//  SimpleBudget
//
//  Created by Lezardvaleth on 2019/2/14.
//  Copyright © 2019 Lezardvaleth. All rights reserved.
//

import UIKit
import CoreData

class SpendingAndBudgetViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITabBarControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate {

    
    
    
    
    //MARK: - Properties
    @IBOutlet weak var budgetTableView: UITableView!
    private let calendar = Calendar(identifier: .iso8601)
    private let currentDate = Date()
    private lazy var targetDate = getYearAndMonth(date: currentDate)
    private var costs = [Cost]()
    private var budgets = [Budget]()
    private var context = AppDelegate.viewContext
    
    @IBOutlet weak var yearAndMonthPicker: UIPickerView!
    private let yearCompenent = Array(2000...2050)
    private let monthCompenent = Array(1...12)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        costs = loadCost()
        budgets = loadBudget()
        self.navigationItem.title = displayDateWithYearAndMonth(date: currentDate)
        tabBarController?.delegate = self
        yearAndMonthPicker.dataSource = self
        yearAndMonthPicker.delegate = self
        setInitialPicker()
    }
    
    //MARK: - UITableView Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return budgets.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpendingBudgetCell", for: indexPath)
        if let display = cell as? SpendingAndBudgetTableViewCell {
            display.budget.text = String(budgets[indexPath.row].amount)
            display.category.text = String(budgets[indexPath.row].category!)
            display.cost.text = String(costsSum(budget: budgets[indexPath.row], costs: costs))
            display.difference.text = String(differenceCalculation(budget: budgets[indexPath.row], costsSum: costsSum(budget: budgets[indexPath.row],costs: costs)))
        }
        return cell
    }
    
    //MARK: - UITabBarControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        costs = loadCost()
        budgets = loadBudget()
        budgetTableView.reloadData()
    }
    
    //MARK: -UIPickerViewDatasource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return yearCompenent.count
        case 1:
            return monthCompenent.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return String(yearCompenent[row])
        case 1:
            return String(monthCompenent[row])
        default:
            return "No Name"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateBudgetAndSpending()
    }
    
    //MARK: -Actions
    
    //MARK: -Segue preparation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch (segue.identifier ?? "") {
        case "ShowCostDetails":
            guard let costDetailsTableController = segue.destination as? CostsDetailsTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedCell = sender as? SpendingAndBudgetTableViewCell else {
                fatalError("Unexpected sender:\(String(describing: sender))")
            }
            guard let indexPath = budgetTableView.indexPath(for: selectedCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            var payload = [Cost]()
            let targetDate = budgets[indexPath.row].date
            let targetCategory = budgets[indexPath.row].category
            for cost in costs {
                if  queryDateCheck(selectedDate: targetDate!, toCheckDate: cost.date!) && queryCategoryCheck(selectedCategory:targetCategory!, toCheckCategory:cost.category!){
                    payload.append(cost)
                }
            }
            costDetailsTableController.costs = payload
            costDetailsTableController.navigationItem.title = budgets[indexPath.row].category
        case "ShowBudgetSummary":
            return
        default: fatalError("Unexpected Segue Identifier;\(String(describing: segue.identifier))")
        }
    }
    
    
    //MARK: -Action
    
    
    
    //MARK: -Private functions
    private func queryDateCheck(selectedDate:Date, toCheckDate:Date) -> Bool {
        let yearCheck = calendar.component(Calendar.Component.year, from: selectedDate) == calendar.component(Calendar.Component.year, from: toCheckDate)
        let monthCheck = calendar.component(Calendar.Component.month, from: selectedDate) == calendar.component(Calendar.Component.month, from: toCheckDate)
        return yearCheck && monthCheck
    }
    
    private func queryCategoryCheck(selectedCategory:String, toCheckCategory:String) -> Bool {
        if selectedCategory == toCheckCategory {
            return true
        }
        return false
    }
    
    private func loadCost() -> [Cost]{
        let request: NSFetchRequest<Cost> = Cost.fetchRequest()
        //        request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
        //        request.predicate = NSPredicate(format: "amount > %@", "0")
        //        let context = AppDelegate.viewContext
        var returnCosts = [Cost]()
        let result = try? context.fetch(request)
        for eachCost in (result ?? []) {
            if queryDateCheck(selectedDate: targetDate, toCheckDate: eachCost.date!){
                returnCosts.append(eachCost)
            }
        }
        return returnCosts
    }

    
    
    private func loadBudget() -> [Budget]{
        let request: NSFetchRequest<Budget> = Budget.fetchRequest()
        //        request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
        //        request.predicate = NSPredicate(format: "amount > %@", "0")
        //        let context = AppDelegate.viewContext
        var returnBudgets = [Budget]()
        let result = try? context.fetch(request)
        for eachBudget in (result ?? []) {
            if queryDateCheck(selectedDate: targetDate, toCheckDate: eachBudget.date!){
                returnBudgets.append(eachBudget)
            }
        }
        return returnBudgets
    }
    
    
    
    private func costsSum(budget:Budget, costs:[Cost]) -> Double{
        var result = 0.0
        for cost in costs {
            if queryDateCheck(selectedDate: budget.date!, toCheckDate: cost.date!) && budget.category == cost.category{
                result += cost.amount
            }
        }
        return result
    }
    
    private func differenceCalculation(budget:Budget, costsSum:Double) -> Double{
        return budget.amount - costsSum
    }
    
    private func displayDateWithYearAndMonth(date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "YYYY-MM"
        let dateDescription = dateFormatter.string(from: date)
        return dateDescription
    }
    
    private func getYearAndMonth(date:Date) -> Date {
        let yearAndMonthComponent = calendar.dateComponents([.year,.month], from: date)
        return calendar.date(from: yearAndMonthComponent)!
    }
    
    private func setInitialPicker() {
        let currentDate = Date()
        let yearAndMonthComponent = calendar.dateComponents([.year,.month], from: currentDate)
        let year = yearAndMonthComponent.year!
        let month = yearAndMonthComponent.month!
        yearAndMonthPicker.selectRow(yearCompenent.firstIndex(of: year)!, inComponent: 0, animated: true)
        yearAndMonthPicker.selectRow(monthCompenent.firstIndex(of: month)!, inComponent: 1, animated: true)
    }
    
    private func updateBudgetAndSpending() {
        let year = yearCompenent[yearAndMonthPicker.selectedRow(inComponent: 0)]
        let month = monthCompenent[yearAndMonthPicker.selectedRow(inComponent: 1)]
        let pickerDateComponent = DateComponents(calendar: calendar, timeZone: nil, era: nil, year: year, month: month, day: nil, hour: nil, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        let pickerDate = calendar.date(from: pickerDateComponent)!
        navigationItem.title = displayDateWithYearAndMonth(date: pickerDate)
        targetDate = getYearAndMonth(date: pickerDate)
        costs = loadCost()
        budgets = loadBudget()
        budgetTableView.reloadData()
    }
    
    
}
