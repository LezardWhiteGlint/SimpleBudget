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
    @IBOutlet weak var doneButton: UIButton!
    
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
                category.order = Int32(orderToRemember)
                do {
                    try context.save()
                } catch {
                    print("Initial categories save failed")
                }
                orderToRemember += 1
            }
        }
        amount.delegate = self
        reminder.delegate = self
        
        //change doneButton shape
        doneButton.clipsToBounds = true
        doneButton.layer.cornerRadius = doneButton.frame.size.width / 4
        
        //Add keyboard observer
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        if !(amount.text?.isEmpty)! {
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
    
    // sroll up when keyboard show
    var activeField: UITextField?
    var lastOffset: CGPoint!
    var keyboardHeight: CGFloat!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    

}


extension BookKeepingViewController {
    // MARK: UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        lastOffset = self.scrollView.contentOffset
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeField?.resignFirstResponder()
        activeField = nil
        return true
    }
    
    // MARK: Keyboard Handling
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if keyboardHeight != nil {
            return
        }
        if (activeField != amount) && (activeField != reminder) {
            return
        }
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            
            // so increase contentView's height by keyboard height
            UIView.animate(withDuration: 0.3, animations: {
                self.constraintContentHeight.constant += self.keyboardHeight
            })
            
            let collapseSpace = keyboardHeight + 0.1
            
            // set new offset for scroll view
            UIView.animate(withDuration: 0.3, animations: {
                // scroll to the position above keyboard 10 points
                self.scrollView.contentOffset = CGPoint(x: self.lastOffset.x, y: collapseSpace + 10)
            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if (activeField == amount) || (activeField == reminder) {
            UIView.animate(withDuration: 0.3) {
                self.constraintContentHeight.constant -= self.keyboardHeight
                self.scrollView.contentOffset = self.lastOffset
            }
            
        }
        
        keyboardHeight = nil
    }
    
    
}

