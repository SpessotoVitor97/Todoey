//
//  ViewController.swift
//  Todoey
//
//  Created by Vitor Canevares Spessoto on 04/02/20.
//  Copyright © 2020 Vitor Canevari Spessoto. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    //*************************************************
    // MARK: - Public properties
    //*************************************************
    var itemsArray: [Item] = []
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    //*************************************************
    // MARK: - Private properties
    //*************************************************
    private let addNewItem = "Add new item"
    private let addItem = "Add item"
    private let createNewItem = "Create new item"
    private let todoItemCell = "TodoItemCell"
    private let emptyMessage = ""
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    //*************************************************
    // MARK: - Lifecycle
    //*************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //*************************************************
    // MARK: - TableView DataSource methods
    //*************************************************
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: todoItemCell, for: indexPath)
        let item = itemsArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    //*************************************************
    // MARK: - TableView Delegate Methods
    //*************************************************
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itemsArray[indexPath.row]
        
//        context.delete(indexPath.row)
//        itemsArray.remove(at: indexPath.row)
        
        item.done = !item.done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //*************************************************
    // MARK: - Actions
    //*************************************************
    @IBAction private func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: addNewItem, message: emptyMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: addItem, style: .default) { (action) in
            guard let newItem = textField.text else { return }
            let item = Item(context: self.context)
            
            item.title = newItem
            item.done = false
            item.parentCategory = self.selectedCategory
            
            self.itemsArray.append(item)
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = self.createNewItem
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //*************************************************
    // MARK: - Data manipulation methods
    //*************************************************
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Something went wrong while saving the context! --> \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        guard let categoryName = selectedCategory?.name else { return }
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", categoryName)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate, categoryPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemsArray = try context.fetch(request)
        } catch {
            print("Something went wrong while loading the itens! --> \(error)")
        }
        tableView.reloadData()
    }
}

//*************************************************
// MARK: - UISearchBarDelegate Delegate methods
//*************************************************
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        guard let searBarText = searchBar.text else { return }
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searBarText)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
