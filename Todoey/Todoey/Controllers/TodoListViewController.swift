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
    // context for sabing core data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // where is data being stoed?
        print("directory for .documentDirectory, in .userDomainMask: \n\(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))")
        
        // make search bar delegate
        //      done in GUI, with ctrl + drag to yellow view controller icon
//        searchBar.delegate = self
        
        // load the item pList data
        loadItems()
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
        
        // delete row
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        
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
    
    // load data from Core Data
    //      using "with" here, allows us to overload the function with different parameters later
    //          (external + internal parameter)
    //      default value of Item.fetchRequest() will be used if none specified
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("error fetching data from context:\n\(error)")
        }
    }

    
}


// MARK: Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {
    // search bar delegate methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        print("searching: \(searchBar.text!)")
        // search and filter data that contains the searched text in the title
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        // sort the data you get back
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        // load the items from the search
        loadItems(with: request)    // using overloaded parameters
    }
}
