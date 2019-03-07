//
//  BudgetSummaryTableViewController.swift
//  SimpleBudget
//
//  Created by Lezardvaleth on 2019/2/27.
//  Copyright © 2019 Lezardvaleth. All rights reserved.
//

import UIKit
import CoreData

class BudgetSummaryTableViewController: UITableViewController {
    private var budgets = [Budget]()
    private var datesToDispaly = [Date]()
    private let calendar = Calendar(identifier: .iso8601)
    private let context = AppDelegate.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        budgets = loadBudget()
        datesToDispaly = getUniqueDate(budgets: budgets)


    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return datesToDispaly.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BudgetSummaryDateCell", for: indexPath)
        cell.textLabel?.text = displayDateWithYearAndMonth(date: datesToDispaly[indexPath.row])
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowBudgetDetails" :
            guard let budgetDetailsTableViewController = segue.destination as? BudgetDetailsTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedCell = sender as? UITableViewCell else {
                fatalError("Unexpected sender:\(String(describing: sender))")
            }
            guard let indextPath = tableView.indexPath(for: selectedCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            budgetDetailsTableViewController.targetDate = datesToDispaly[indextPath.row]
            budgetDetailsTableViewController.navigationItem.title = displayDateWithYearAndMonth(date: datesToDispaly[indextPath.row])
        case "NewBudgetMonthAdd" :
            return
        default: fatalError("Segue identifier not found")
        }
    }
    
    //MARK: - Private Functions
    
    private func loadBudget() -> [Budget]{
        let request: NSFetchRequest<Budget> = Budget.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        //        request.predicate = NSPredicate(format: "amount > %@", "0")
        //        let context = AppDelegate.viewContext
        var returnBudgets = [Budget]()
        let result = try? context.fetch(request)
        for eachBudget in (result ?? []) {
            returnBudgets.append(eachBudget)
            
        }
        return returnBudgets
    }
    
    private func getYearAndMonth(date:Date) -> Date {
        let yearAndMonthComponent = calendar.dateComponents([.year,.month], from: date)
        return calendar.date(from: yearAndMonthComponent)!
    }
    
    private func getUniqueDate(budgets:[Budget]) -> [Date] {
        var budgetsDateConvertToFirstDayOfTheMonth = [Date]()
        var result = [Date]()
        for budget in budgets {
            budgetsDateConvertToFirstDayOfTheMonth.append(getYearAndMonth(date: budget.date!))
        }
        for date in budgetsDateConvertToFirstDayOfTheMonth {
            if !result.contains(date) {
                result.append(date)
            }
        }
        return result
    }
    
    private func displayDateWithYearAndMonth(date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "YYYY-MM"
        let dateDescription = dateFormatter.string(from: date)
        return dateDescription
    }
    
    
 
}
