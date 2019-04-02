//
//  ViewController.swift
//  Todoey
//
//  Created by shiMac on 4/1/19.
//  Copyright © 2019 code stuff. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    
    // data saved to pList file
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // if Todo List array exists, load
        if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
            itemArray = items
        }
        
    }
    
    // MARK: Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    // MARK: Tableview Delegate Methods
    // when clicking on a cell, do action
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row:\t\(indexPath.row)\t\(itemArray[indexPath.row])")
        // format of highlight row
        tableView.deselectRow(at: indexPath, animated: true)
        // check mark next to selected cell
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
    
    // MARK: Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the "add item" button on the alert
            let newThing: String = textField.text ?? "empty text"
            print("about to add:\t\(newThing)")
            self.itemArray.append(newThing)
            // save to default local data
            self.defaults.setValue(self.itemArray, forKey: "ToDoListArray")
            self.tableView.reloadData()
        }
        // add text field to popup alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            print("closure triggered in add text field")
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    


}

