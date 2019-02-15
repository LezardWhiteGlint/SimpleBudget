//
//  FirstViewController.swift
//  SimpleBudget
//
//  Created by Lezardvaleth on 2019/2/14.
//  Copyright © 2019 Lezardvaleth. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var category: UIPickerView!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var reminder: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: Actions
    @IBAction func Done(_ sender: Any) {
        let storeDate: String = date.date.description
        let storeCategory: String? = "testCategory"
        let storeAmount: Double = (Double(amount.text ?? "")) ?? 0.0
        let storeReminder: String? = reminder.text
        let cost = Cost(date: storeDate, category: storeCategory, amount: storeAmount, reminder: storeReminder)
        print("The date is \(cost?.date), the category is \(cost?.category), the amount is \(cost?.amount), the reminder is \(cost?.reminder)")
    }
    
    


}

