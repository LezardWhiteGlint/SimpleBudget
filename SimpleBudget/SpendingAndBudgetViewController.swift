//
//  SecondViewController.swift
//  SimpleBudget
//
//  Created by Lezardvaleth on 2019/2/14.
//  Copyright © 2019 Lezardvaleth. All rights reserved.
//

import UIKit
import CoreData

class SpendingAndBudgetViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITabBarControllerDelegate {
    
    
    
    //MARK: - Properties
    @IBOutlet weak var budgetTableView: UITableView!
    private let calendar = Calendar(identifier: .iso8601)
    private let currentDate = Date()
    private lazy var targetDate = getYearAndMonth(date: currentDate)
    private var costs = [Cost]()
    private var budgets = [Budget]()
    private var context = AppDelegate.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        costs = loadCost()
        budgets = loadBudget()
        self.navigationItem.title = displayDateWithYearAndMonth(date: currentDate)
        tabBarController?.delegate = self
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
    
    //MARK: -Actions
    
    //MARK: -Segue preparation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch (segue.identifier ?? "") {
        case "ShowCostDetails":
            guard let costDetailsTableController = segue.destination as? CostsDetailsTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedCell = sender as? UITableViewCell else {
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
    
    
}
