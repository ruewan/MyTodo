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
    let DATA_FILE_PATH = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    var items : [Item] = []
    let encoder = PropertyListEncoder()
    let decoder = PropertyListDecoder()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
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
                self.items.append(Item(title : text,done : false))
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
            let data = try encoder.encode(items)
            try data.write(to: DATA_FILE_PATH!)
        } catch {
            print("Error encoding items \(error)")
        }
    }
    func loadItems(){
        if let data = try? Data(contentsOf: DATA_FILE_PATH!){
            do {
                items = try decoder.decode([Item].self, from: data)
            } catch {
                print("error decoding items \(error)")
            }
        }
    }
}

