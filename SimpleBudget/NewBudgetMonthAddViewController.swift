//
//  NewBudgetMonthAddViewController.swift
//  SimpleBudget
//
//  Created by Lezardvaleth on 2019/3/6.
//  Copyright © 2019 Lezardvaleth. All rights reserved.
//

import UIKit
import CoreData

class NewBudgetMonthAddViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    @IBOutlet weak var yearAndMonthPicker: UIPickerView!
    private let yearCompenent = Array(2000...2050)
    private let monthCompenent = Array(1...12)
    private var categories = [Category]()
    private var budgets = [Budget]()
    private let calendar = Calendar(identifier: .iso8601)
    private let context = AppDelegate.viewContext
    
    @IBAction func test(_ sender: UIBarButtonItem) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yearAndMonthPicker.dataSource = self
        yearAndMonthPicker.delegate = self
    }
    
    
    //MARK: -UIPikcerViewDataSource
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let budgetDetailsTableViewController = segue.destination as? BudgetDetailsTableViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        let dateToDisplay = addNewBudget()!
        budgetDetailsTableViewController.targetDate = dateToDisplay
        budgetDetailsTableViewController.navigationItem.title = displayDateWithYearAndMonth(date: dateToDisplay)
    }
    
    
    private func addNewBudget() -> Date?{
        //Construct the date
        let year = yearCompenent[yearAndMonthPicker.selectedRow(inComponent: 0)]
        let month = monthCompenent[yearAndMonthPicker.selectedRow(inComponent: 1)]
        let dateCommponentToAdd = DateComponents(calendar: calendar, timeZone: nil, era: nil, year: year, month: month, day: nil, hour: nil, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        let dateToAdd = calendar.date(from:dateCommponentToAdd)
        //Add the date
        categories = loadCategory()
        for eachCategory in categories {
            let budget = Budget(context: context)
            budget.amount = 0.0
            budget.date = dateToAdd
            budget.category = eachCategory.name
        }
        return dateToAdd
    }
    
    private func loadCategory() -> [Category]{
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
        //        request.predicate = NSPredicate(format: "amount > %@", "0")
        //        let context = AppDelegate.viewContext
        var returnCategories = [Category]()
        let result = try? context.fetch(request)
        for eachCategory in (result ?? []) {
            returnCategories.append(eachCategory)
        }
        return returnCategories
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
