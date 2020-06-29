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
    var categoriesArray: [Category] = []
    
    //*************************************************
    // MARK: - Private properties
    //*************************************************
    private let addNewCategory = "Add new category"
    private let addCategory = "Add category"
    private let createNewCategory = "Create new category"
    private let categoryCell = "CategoryCell"
    private let emptyMessage = ""
    private let goToItems = "goToItems"
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let realm = try! Realm()
    
    //*************************************************
    // MARK: - Lifecycle
    //*************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
//        loadCategories()
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
            
            self.categoriesArray.append(category)
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
        return categoriesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: categoryCell, for: indexPath)
        let category = categoriesArray[indexPath.row]
        
        cell.textLabel?.text = category.name
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
            destinationVC.selectedCategory = categoriesArray[indexPath.row]
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
            print("Something went wrong while saving the context! --> \(error)")
        }
        self.tableView.reloadData()
    }
    
//    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
//        do {
//            categoriesArray = try context.fetch(request)
//        } catch {
//            print("Something went wrong while fetching the categories! --> \(error)")
//        }
//        tableView.reloadData()
//   }
}
