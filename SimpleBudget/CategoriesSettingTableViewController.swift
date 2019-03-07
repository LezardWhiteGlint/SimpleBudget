//
//  CategoriesSettingTableViewController.swift
//  SimpleBudget
//
//  Created by Lezardvaleth on 2019/2/24.
//  Copyright © 2019 Lezardvaleth. All rights reserved.
//

import UIKit
import CoreData

class CategoriesSettingTableViewController: UITableViewController {
    private var categories = [Category]()
    
    private var context = AppDelegate.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        categories = loadCategories()
        tableView.isEditing = true
        for category in categories {
            print(category.order)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoriesCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    //MARK: - Actions
    @IBAction func addCategories(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "test", message: "message test", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in self.addCategory(name: alert.textFields![0].text!) } ))
        present(alert, animated: true, completion: nil)
    }
    

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let category = categories[indexPath.row]
            // Delete from datasource
            context.delete(category)
            // Delete from category
            categories.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            try? context.save()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let switchCategories = loadCategories()
        let temp = switchCategories[fromIndexPath.row].order
        switchCategories[fromIndexPath.row].order = switchCategories[to.row].order
        switchCategories[to.row].order = temp
        try? context.save()
    }
    

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    private func addCategory(name:String) {
        if name != "" {
            let category = Category(context: context)
            category.name = name
            //remember order
            let lastOrder = loadCategories().last?.order
            category.order = Int32(lastOrder ?? 20) + 1
            do
            {try context.save()
            } catch {
                print("addCategory content saving failed")
            }
            categories += [category]
            tableView.reloadData()
        }
    }
    
    private func loadCategories() -> [Category]{
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
//        request.predicate = NSPredicate(format: "amount > %@", "0")
//        let context = AppDelegate.viewContext
        var returnCategories = [Category]()
        let result = try? context.fetch(request)
        for category in (result ?? []) {
            returnCategories.append(category)
        }
        return returnCategories
    }
    

}
