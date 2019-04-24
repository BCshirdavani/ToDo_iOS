//
//  CategoryViewController.swift
//  Todoey
//
//  Created by shiMac on 4/9/19.
//  Copyright © 2019 code stuff. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryViewController: SwipeTableViewController {
    
    // use Realm data
    let realm = try! Realm()
    
    var categories: Results<Category>? // auto updating data type

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    
    // MARK: TableView data source methods
    // ---------- called by reloadData()
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // nil coalescing operator
        //      if categories !=  nil, return count
        //      else return 1
        return categories?.count ?? 1
    }
    

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        // nil coalescing operator
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
        return cell
    }
    
    
    
    
    //MARK: Datam manipulation methods
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()  // reloadData() calls all the datasource methods
    }
    
    // MARK: Delete Data from Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("error deleting category: \(error)")
            }
        }
    }
    
    
    //MARK: TableView delegation methods
    // ----------- called when we click a cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            // nil coalescing operator
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            // after user presses add button
            let newCategory = Category()
            newCategory.name = textField.text!
            self.save(category: newCategory)
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        present(alert, animated: true, completion: nil)
    }
    

}







