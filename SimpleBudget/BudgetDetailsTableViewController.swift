//
//  BudgetDetailsTableViewController.swift
//  SimpleBudget
//
//  Created by Lezardvaleth on 2019/3/5.
//  Copyright © 2019 Lezardvaleth. All rights reserved.
//

import UIKit
import CoreData

class BudgetDetailsTableViewController: UITableViewController {
    private var categories = [Category]()
    private var budgets = [Budget]()
    private let calendar = Calendar(identifier: .iso8601)
    private let context = AppDelegate.viewContext
    var targetDate = Date()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        budgets = loadBudgets()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return budgets.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BudgetDetailCell", for: indexPath) as? BudgetDetailsTableViewCell else {
            fatalError("Cell Doesn't not exist")
        }
        cell.category.text = budgets[indexPath.row].category
        cell.amount.text = String(budgets[indexPath.row].amount)

        return cell
    }
    
    //MARK: -UITableViewDelegates

    
    
    
    //MARK: -Actions
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        saveChanges()
    }
    
    
    private func loadBudgets() -> [Budget]{
        let request: NSFetchRequest<Budget> = Budget.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
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
    
    private func queryDateCheck(selectedDate:Date, toCheckDate:Date) -> Bool {
        let yearCheck = calendar.component(Calendar.Component.year, from: selectedDate) == calendar.component(Calendar.Component.year, from: toCheckDate)
        let monthCheck = calendar.component(Calendar.Component.month, from: selectedDate) == calendar.component(Calendar.Component.month, from: toCheckDate)
        return yearCheck && monthCheck
    }
    
    private func saveChanges() {
        var row = 0
        var indexPath = IndexPath(row: row, section: 0)
        for budget in budgets {
            if let cell = tableView.cellForRow(at: indexPath) as? BudgetDetailsTableViewCell{
                budget.setValue(Double(cell.amount.text!), forKey: "amount")
                try? context.save()
            }
            row += 1
            indexPath = IndexPath(row: row, section: 0)
        }
        let alert = UIAlertController(title: "Budgets Save", message: "Amounts Saved successfully", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
        present(alert, animated: true, completion: nil)
        
    }
    
    

    

}
