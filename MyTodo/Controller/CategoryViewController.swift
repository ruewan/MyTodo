//
//  CategoryViewController.swift
//  MyTodo
//
//  Created by Adrian Layne on 7/11/19.
//  Copyright © 2019 Adrian Layne. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    let realm = try! Realm()
    var categories : Results<Category>?
    var selectedCategory : Category?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        categories = loadCategories()
        tableView.reloadData()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            if let text = textField.text {
                let newCategory = Category()
                newCategory.name = text
                newCategory.color = UIColor.randomFlat().hexValue()
                self.save(category: newCategory)
                self.tableView.reloadData()
            }
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Add new Category";
            
        }
        present(alert, animated: true, completion: nil)
    }
    
    func save(category : Category){
        do{
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categories?[indexPath.row]{
            cell.textLabel?.text = category.name
            cell.backgroundColor = UIColor(hexString: category.color)
            cell.textLabel?.textColor = ContrastColorOf(backgroundColor: cell.backgroundColor!, returnFlat: true)
        }else{
            cell.textLabel?.text = "No Categories added yet"
        }
        return cell
    }
    
    func loadCategories() -> Results<Category>{
        return realm.objects(Category.self)
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "goToItems"){
            let targetVC = segue.destination as! MyTodoViewController
            if let indexPath = tableView.indexPathForSelectedRow{
                targetVC.selectedCategory = categories?[indexPath.row]
            }
        }
    }
    override func destroyCell(indexPath: IndexPath) {
        if let categoryToDelete = self.categories?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(categoryToDelete)
                }
            } catch{
                print("error deleting category \(self.categories![indexPath.row])")
            }
        }
    }
}
