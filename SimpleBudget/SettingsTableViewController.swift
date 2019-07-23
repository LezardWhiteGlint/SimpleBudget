//
//  SettingsTableViewController.swift
//  SimpleBudget
//
//  Created by Lezardvaleth on 2019/2/24.
//  Copyright © 2019 Lezardvaleth. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
//    @IBAction func addBudgetSample(_ sender: UIBarButtonItem) {
//        addSampleBudgetData()
//    }
//    @IBAction func costMockDataInput(_ sender: Any) {
//        testAddSampleCostData(costCount: 180)
//    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
//    private func testAddSampleCostData(costCount:Int) {
//        let context = AppDelegate.viewContext
//        for count in 0...costCount {
//            let cost = Cost(context: context)
//            cost.amount = Double.random(in: 100...10000)
//            cost.date = Date().addingTimeInterval(-86400*Double(count))
//            cost.category = "testOnly"
//            try? context.save()
//        }
//        
//    }

//    private func addSampleBudgetData() {
//        let context = AppDelegate.viewContext
//        let budget = Budget(context: context)
//        budget.amount = Double.random(in: 1000...10000)
//        budget.date = Date().addingTimeInterval(Double.random(in: 100000...100000000))
//        budget.category = String("qwertyuiopasdfghjklzxcvbnm1234567890".randomElement()!)
//        try? context.save()
//
//    }

}
