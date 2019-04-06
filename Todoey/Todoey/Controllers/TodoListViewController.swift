//
//  ViewController.swift
//  Todoey
//
//  Created by shiMac on 4/1/19.
//  Copyright © 2019 code stuff. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    // context for sabing core data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // data saved to pList file
//    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // where is data being stoed?
        print("directory for .documentDirectory, in .userDomainMask: \n\(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))")
        
        // load the item pList data
//        loadItems()
        
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
        saveItems()
        
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
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            // save to default local data
            // make encoder
            self.saveItems()
            
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
    
    // MARK: model manipulation methods
    func saveItems(){
        do {
            try context.save()
        } catch {
            print("error saving context:\n\(error)")
        }
    }
    
    // load data from pList, and decode the data
//    func loadItems() {
//        if let data = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//            do {
//                itemArray = try decoder.decode([Item].self, from: data)
//            } catch {
//                print("Error decoding: \(error)")
//            }
//        }
//    }
    


}

