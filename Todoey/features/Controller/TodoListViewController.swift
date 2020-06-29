//
//  ViewController.swift
//  Todoey
//
//  Created by Vitor Canevares Spessoto on 04/02/20.
//  Copyright © 2020 Vitor Canevari Spessoto. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    //*************************************************
    // MARK: - Public properties
    //*************************************************
    var todoItems: Results<Item>?
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
    private let keyPathTitle = "title"
    private let noItemsAddedYet = "No items added yet!"
    private let emptyMessage = String()
    
    private let realm = try! Realm()

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
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: todoItemCell, for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = noItemsAddedYet
        }
        
        return cell
    }
    
    //*************************************************
    // MARK: - TableView Delegate Methods
    //*************************************************
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let item = todoItems?[indexPath.row]
        
//        context.delete(indexPath.row)
//        itemsArray.remove(at: indexPath.row)
        
//        item?.done = !item?.done
//        saveItems()
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
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let item = Item()
                        item.title = newItem
                        currentCategory.items.append(item)
                        self.realm.add(item)
                    }
                } catch  {
                    print("Something went wrong while saving the item! --> \(error)")
                }
            }
            self.tableView.reloadData()
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
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: keyPathTitle, ascending: true)
        tableView.reloadData()
    }
}

//*************************************************
// MARK: - UISearchBarDelegate Delegate methods
//*************************************************
//extension TodoListViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        guard let searBarText = searchBar.text else { return }
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searBarText)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        loadItems(with: request, predicate: predicate)
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//}
