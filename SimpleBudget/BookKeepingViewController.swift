//
//  FirstViewController.swift
//  SimpleBudget
//
//  Created by Lezardvaleth on 2019/2/14.
//  Copyright © 2019 Lezardvaleth. All rights reserved.
//

import UIKit
import CoreData

class BookKeepingViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource{

    
    //MARK: Properties
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var category: UIPickerView!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var reminder: UITextField!
    //Category contents
    private var categoryPickerDataSource = [String]()
    
//    private var container = AppDelegate.persistentContainer
    private var context = AppDelegate.viewContext
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        category.dataSource = self
        category.delegate = self
        categoryPickerDataSource = loadCategories()
        //Set initial categories
        if categoryPickerDataSource == [] {
            categoryPickerDataSource = ["Housing","Food","Shopping","Other"]
            var orderToRemember = 1
            for eachCategory in categoryPickerDataSource {
                let category = Category(context: context)
                category.name = eachCategory
                category.order = Int16(orderToRemember)
                do {
                    try context.save()
                } catch {
                    print("Initial categories save failed")
                }
                orderToRemember += 1
            }
        }
    }
    
    //MARK: Delegations

    //MARK: - UIPickerView Delegates
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryPickerDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryPickerDataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateCategory()
    }
    
    //MARK: Actions
    @IBAction func Done(_ sender: Any) {
        let cost = Cost(context: context)
        cost.date = date.date
        cost.category = categoryPickerDataSource[category.selectedRow(inComponent: 0)]
        cost.amount = (Double(amount.text ?? "")) ?? 0.0
        cost.reminder = reminder.text
        amount.text = ""
        reminder.text = ""
        do {
            try context.save()
        }catch {
            fatalError("Context save failed")
        }
    }
    @IBAction func doneEditing(_ sender: UITapGestureRecognizer) {
        amount.resignFirstResponder()
        reminder.resignFirstResponder()
    }
    
    func updateCategory() {
        categoryPickerDataSource = loadCategories()
        category.reloadAllComponents()
    }

    private func loadCategories() -> [String]{
        var categories = [String]()
        let request: NSFetchRequest<Category> = Category.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
        //        request.predicate = NSPredicate(format: "amount > %@", "0")
        //        let context = AppDelegate.viewContext
        let result = try? context.fetch(request)
        for category in (result ?? []) {
            categories.append(category.name ?? "")
        }
        return categories
    }


}

