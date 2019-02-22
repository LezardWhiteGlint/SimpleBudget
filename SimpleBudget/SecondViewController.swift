//
//  SecondViewController.swift
//  SimpleBudget
//
//  Created by Lezardvaleth on 2019/2/14.
//  Copyright © 2019 Lezardvaleth. All rights reserved.
//

import UIKit
import CoreData

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func test(_ sender: UIButton) {
        let request: NSFetchRequest<Cost> = Cost.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "amount", ascending: true)]
//        request.predicate = NSPredicate(format: "any")
        let context = AppDelegate.viewContext
        let toPrint = try? context.fetch(request)
        for eachCost in toPrint ?? [] {
            print(eachCost.amount)
        }
    }
    
}

