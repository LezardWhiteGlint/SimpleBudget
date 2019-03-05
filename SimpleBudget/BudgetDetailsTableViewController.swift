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
    var targetDate = Date()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //budgets = loadBudgets()
        //TODO filter the correct budgets date to display, then make it changable after push save button

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return budgets.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    

    

}
