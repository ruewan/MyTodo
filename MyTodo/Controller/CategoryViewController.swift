//
//  CategoryViewController.swift
//  MyTodo
//
//  Created by Adrian Layne on 7/11/19.
//  Copyright © 2019 Adrian Layne. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    let realm = try! Realm()
    var categories : Results<Category>?
    var selectedCategory : Category?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categories?[indexPath.row]
        cell.textLabel?.text = category?.name ?? "No Categories added yet"
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
}
