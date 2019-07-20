//
//  ViewController.swift
//  MyTodo
//
//  Created by Adrian Layne on 7/10/19.
//  Copyright © 2019 Adrian Layne. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
class MyTodoViewController: SwipeTableViewController
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
        searchBar.delegate = self
        definesPresentationContext = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.backgroundColor = getCellColor(row: indexPath.row)
        cell.textLabel?.textColor = ContrastColorOf(backgroundColor: cell.backgroundColor!, returnFlat: true)
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
    override func destroyCell(indexPath: IndexPath) {
        do{
            try self.realm.write {
                self.realm.delete(self.items[indexPath.row])
            }
        } catch{
            print("error deleting category \(self.items[indexPath.row])")
        }
    }
}

//Mark - Search Bar Methods
extension MyTodoViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text{
            let filtered = self.selectedCategory?.items.filter(NSPredicate(format: "title CONTAINS[cd] %@ ", searchText )).sorted(byKeyPath: "dateCreated", ascending: true)
            items = converToList(results: filtered!)
            tableView.reloadData()
        }
    }
    
    func converToList(results : Results<Item>) -> List<Item>{
        return results.reduce(List<Item>()) { (list, element) -> List<Item> in
            list.append(element)
            return list
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        items = loadItems()
        tableView.reloadData()
        searchBar.text = nil
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("in text changed")
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if(trimmed.count == 0){
            items = loadItems()
            tableView.reloadData()
        }
    }
    
    func getCellColor(row: Int) -> UIColor{
        if( row == 0 ){
            return UIColor(hexString: selectedCategory!.color)
        }else{
            let percent = (0.5 / CGFloat(items.count)) * CGFloat(row + 1)
            return UIColor(hexString:selectedCategory!.color).darken(byPercentage: percent)
        }
    }

}


