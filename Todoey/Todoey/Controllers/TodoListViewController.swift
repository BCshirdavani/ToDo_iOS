//
//  ViewController.swift
//  Todoey
//
//  Created by shiMac on 4/1/19.
//  Copyright © 2019 code stuff. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    // data saved to pList file
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem1 = Item()
        newItem1.title = "Find Mike"
        itemArray.append(newItem1)
        let newItem2 = Item()
        newItem2.title = "Buy Eggos"
        itemArray.append(newItem2)
        let newItem3 = Item()
        newItem3.title = "Destroy Demagorgon"
        itemArray.append(newItem3)
        
        
        // if Todo List array exists, load
        if let items = defaults.array(forKey: "ToDoListArrayItem") as? [Item] {
            itemArray = items
        }
        
    }
    
    // MARK: Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellForRowAt called")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        // check mark next to selected cell - toggle with ternary operator
        //      value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none

        return cell
    }
    
    // MARK: Tableview Delegate Methods
    // when clicking on a cell, do action
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // toggle done check for item
        itemArray[indexPath.row].done = !(itemArray[indexPath.row].done)
        
        print("Selected row:\t\(indexPath.row)\t\(itemArray[indexPath.row].title)\t\(itemArray[indexPath.row].done)")
        // format of highlight row
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    // MARK: Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the "add item" button on the alert
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            // save to default local data
            self.defaults.setValue(self.itemArray, forKey: "ToDoListArrayItem")
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

