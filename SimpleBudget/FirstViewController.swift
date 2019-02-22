//
//  FirstViewController.swift
//  SimpleBudget
//
//  Created by Lezardvaleth on 2019/2/14.
//  Copyright © 2019 Lezardvaleth. All rights reserved.
//

import UIKit
import CoreData

class FirstViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    //MARK: Properties
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var category: UIPickerView!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var reminder: UITextField!
//    private var container = AppDelegate.persistentContainer
    private var context = AppDelegate.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: Delegations
    
    
    //MARK: Actions
    @IBAction func Done(_ sender: Any) {
        let cost = Cost(context: context)
        cost.date = date.date
        cost.category = "testCategory"
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
    
    


}

