//
//  ViewController.swift
//  MyTodo
//
//  Created by Adrian Layne on 7/10/19.
//  Copyright © 2019 Adrian Layne. All rights reserved.
//

import UIKit

class MyTodoViewController: UITableViewController {
    let ITEM_KEY = "items"
    var items : [String] = []
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let storedItems = defaults.array(forKey: ITEM_KEY) as? [String]{
            items = storedItems
        }
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTodoItemCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("selected \(items[indexPath.row])")
        if let cell = tableView.cellForRow(at: indexPath){
            cell.accessoryType = cell.accessoryType == .checkmark ? .none : .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let text = textField.text {
                self.items.append(text)
                self.defaults.set(self.items, forKey: self.ITEM_KEY)
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
}

