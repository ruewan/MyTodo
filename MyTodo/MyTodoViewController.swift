//
//  ViewController.swift
//  MyTodo
//
//  Created by Adrian Layne on 7/10/19.
//  Copyright © 2019 Adrian Layne. All rights reserved.
//

import UIKit

class MyTodoViewController: UITableViewController {
    let items = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    override func viewDidLoad() {
        super.viewDidLoad()
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

}

