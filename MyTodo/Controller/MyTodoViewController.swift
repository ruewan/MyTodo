//
//  ViewController.swift
//  MyTodo
//
//  Created by Adrian Layne on 7/10/19.
//  Copyright © 2019 Adrian Layne. All rights reserved.
//

import UIKit
import RealmSwift
class MyTodoViewController: UITableViewController
{
    
    @IBOutlet weak var searchBar: UISearchBar!
    var realm = try! Realm()
    var items = List<Item>()
    var selectedCategory : Category?{
        didSet{
            items = loadItems()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        searchBar.delegate = self
        definesPresentationContext = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedCategory?.items.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTodoItemCell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            cell.accessoryType = cell.accessoryType == .checkmark ? .none : .checkmark
            do{
                try realm.write {
                   items[indexPath.row].done = cell.accessoryType == .checkmark
                }
            } catch {
                print("Error saving category \(error)")
            }
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let text = textField.text {
                let newItem = Item()
                newItem.title = text
                newItem.done = false
                self.addItem(item: newItem)
                self.tableView.reloadData()
            }
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Add new item";
            
        }
        present(alert, animated: true, completion: nil)
    }
    
    func addItem(item : Item){
        do{
            try realm.write {
                items.append(item)
            }
        } catch {
            print("Error saving category \(error)")
        }
    }
    
    func loadItems() -> List<Item>{
       return selectedCategory!.items
    }

}

////Mark - Search Bar Methods
//extension MyTodoViewController: UISearchBarDelegate{
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        if let searchText = searchBar.text{
//
//            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@ ", searchText )
//            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//            items = loadItems(with: request)
//            tableView.reloadData()
//        }
//    }
//
//
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        items = loadItems()
//        tableView.reloadData()
//        searchBar.text = nil
//        DispatchQueue.main.async {
//            searchBar.resignFirstResponder()
//        }
//    }
//
//    //    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//    //        print("in text changed")
//    //        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
//    //        if(trimmed.count == 0){
//    //            items = loadItems()
//    //            tableView.reloadData()
//    //        }
//    //    }
//
//
//}


