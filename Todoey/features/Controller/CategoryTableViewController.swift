//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Vitor Spessoto on 5/27/20.
//  Copyright © 2020 Vitor Canevari Spessoto. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    
    //*************************************************
    // MARK: - Public properties
    //*************************************************
    var categoriesArray: Results<Category>?
    
    //*************************************************
    // MARK: - Private properties
    //*************************************************
    private let addNewCategory = "Add new category"
    private let addCategory = "Add category"
    private let createNewCategory = "Create new category"
    private let categoryCell = "CategoryCell"
    private let goToItems = "goToItems"
    private let noCategoriesAddedYet = "No Categories added yet!"
    private let emptyMessage = String()
    
    private let realm = try! Realm()
    
    //*************************************************
    // MARK: - Lifecycle
    //*************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    //*************************************************
    // MARK: - Actions
    //*************************************************
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: addNewCategory, message: emptyMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: addCategory, style: .default) { (action) in
            
            guard let newCategory = textField.text else { return }
            let category = Category()
            category.name = newCategory
            
            self.save(category: category)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = self.createNewCategory
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //*************************************************
    // MARK: - TableView DataSource methods
    //*************************************************
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: categoryCell, for: indexPath)
        let category = categoriesArray?[indexPath.row]
        
        cell.textLabel?.text = category?.name ?? noCategoriesAddedYet
        return cell
    }
    
    //*************************************************
    // MARK: - TableView Delegate methods
    //*************************************************
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: goToItems, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoriesArray?[indexPath.row]
        }
    }
    
    //*************************************************
    // MARK: - Data manipulation methods
    //*************************************************
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Something went wrong while saving the category! --> \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories() {
        categoriesArray = realm.objects(Category.self)
        tableView.reloadData()
   }
}
