//
//  CategoryViewController.swift
//  MyTodo
//
//  Created by Adrian Layne on 7/11/19.
//  Copyright © 2019 Adrian Layne. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    var categories : [ListCategory] = []
    var selectedCategory : ListCategory?
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
                let newCategory = ListCategory(context: self.context)
                newCategory.name = text
                self.categories.append(newCategory)
                self.saveData()
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
    
    func saveData(){
        do{
            try context.save()
        } catch {
            print("Error saving items \(error)")
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    
    func loadCategories(with request: NSFetchRequest<ListCategory> = ListCategory.fetchRequest()) -> [ListCategory]{
        do{
            return try context.fetch(request)
        } catch{
            print("Error loading data from context \(error)")
        }
        return []
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "goToItems"){
            let targetVC = segue.destination as! MyTodoViewController
            if let indexPath = tableView.indexPathForSelectedRow{
                targetVC.selectedCategory = categories[indexPath.row]
            }
        }
    }
}
