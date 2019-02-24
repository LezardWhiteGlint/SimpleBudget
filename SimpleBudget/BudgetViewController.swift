//
//  SecondViewController.swift
//  SimpleBudget
//
//  Created by Lezardvaleth on 2019/2/14.
//  Copyright © 2019 Lezardvaleth. All rights reserved.
//

import UIKit
import CoreData

class BudgetViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var testData = ["1","2","3"]
    
    
    //MARK: - Properties
    @IBOutlet weak var budgetTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - UITableView Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellContent", for: indexPath)
        if let display = cell as? BudgetAndCostTableViewCell {
            display.budget.text = testData[indexPath.row]
        }
        return cell
    }


}
