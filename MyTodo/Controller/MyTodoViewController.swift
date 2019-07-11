//
//  ViewController.swift
//  MyTodo
//
//  Created by Adrian Layne on 7/10/19.
//  Copyright © 2019 Adrian Layne. All rights reserved.
//

import UIKit
import CoreData
class MyTodoViewController: UITableViewController
{
    
    @IBOutlet weak var searchBar: UISearchBar!
    var items = [Item]()
    var selectedCategory : ListCategory?{
        didSet{
            items = loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        definesPresentationContext = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedCategory!.items!.count
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
            items[indexPath.row].done = cell.accessoryType == .checkmark
        }
        saveData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let text = textField.text {
                let newItem = Item(context: self.context)
                newItem.title = text
                newItem.done = false
                newItem.parentCategory = self.selectedCategory!
                self.items.append(newItem)
                self.saveData()
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
    
    func saveData(){
        do{
            try context.save()
        } catch {
            print("Error saving items \(error)")
        }
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) -> [Item]{
        do{
            var searchPredicate = NSPredicate(format: "parentCategory == %@", selectedCategory!)
            if let predicate = request.predicate{
                searchPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate,searchPredicate])
            }
            request.predicate = searchPredicate
            return try context.fetch(request)
        } catch{
            print("Error loading data from context \(error)")
        }
        return []
    }

}

//Mark - Search Bar Methods
extension MyTodoViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text{
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@ ", searchText )
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            items = loadItems(with: request)
            tableView.reloadData()
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
    
    //    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    //        print("in text changed")
    //        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    //        if(trimmed.count == 0){
    //            items = loadItems()
    //            tableView.reloadData()
    //        }
    //    }
    
    
}


