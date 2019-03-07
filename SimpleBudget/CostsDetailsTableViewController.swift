//
//  CostsDetailsTableViewController.swift
//  SimpleBudget
//
//  Created by Lezardvaleth on 2019/3/3.
//  Copyright © 2019 Lezardvaleth. All rights reserved.
//

import UIKit

class CostsDetailsTableViewController: UITableViewController {
    var costs = [Cost]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return costs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let date = costs[indexPath.row].date!
        let dateDescription = dateFormatter.string(from: date)
        let cell = tableView.dequeueReusableCell(withIdentifier: "CostsDetailsCell", for: indexPath)
        cell.textLabel?.text = dateDescription
        if costs[indexPath.row].reminder != "" {
        cell.detailTextLabel?.text = String(costs[indexPath.row].amount) + "📝"
        } else {
            cell.detailTextLabel?.text = String(costs[indexPath.row].amount)
        }
        return cell
    }
    
    //MARK: - UITableViewDelegates
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let reminder = costs[indexPath.row].reminder, reminder != "" {
            let alert = UIAlertController(title: "Reminder", message: reminder, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil ))
            present(alert, animated: true, completion: nil)
        }
    }
    



}
