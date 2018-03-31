//
//  ViewControllerCheckList.swift
//  Salud Integral
//
//  Created by Alex Elizondo  on 2/21/18.
//  Copyright © 2018 Alex Elizondo . All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import UserNotifications

class ViewControllerCheckList: UITableViewController, SwipeTableViewCellDelegate, UNUserNotificationCenterDelegate {
    
    let realm = try! Realm()
    
    var newItem = false
    
    var todoItems: Results<Item>?
    
    var selectedSection: Section? {
        didSet {
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = selectedSection?.name
        configureTableView()
        
        UNUserNotificationCenter.current().delegate = self
    }
    
    func configureTableView() {
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120
    }
    
    // MARK -  Notification Manager
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        for item in todoItems! {
            if item.name == response.actionIdentifier {
                // Mark item as completed
                let history = History()
                history.date = Date()
                do {
                    try self.realm.write {
                        item.datesCompleted.append(history)
                        if item.frequency == "" {
                            selectedSection?.inactiveItems.append(item)
                            selectedSection?.items.remove(at: (selectedSection?.items.index(of: item))!)
                        }
                    }
                } catch {
                    print("Error deleting item, \(error)")
                }
                tableView.reloadData()
                break
            }
        }
        
        
        
        completionHandler()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseID", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.name
            cell.textLabel?.font = UIFont(name: (cell.textLabel?.font.fontName)!, size: 32)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
//        
        performSegue(withIdentifier: "editItem", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - Model Manipulation Methods
    
    func loadItems() {
        todoItems = selectedSection?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    //MARK - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "newItem", sender: self)
    }
    
    //MARK - Swipe TableView Delegate
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Eliminar") { action, indexPath in
            // handle action by updating model with deletion
            self.updateModel(at: indexPath)
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {
        if let itemToDelete = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemToDelete)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newItem" {
            let newItemVC = segue.destination as! NewItemViewController
            newItemVC.selectedSection = selectedSection
        } else if segue.identifier == "editItem" {
            let newItemVC = segue.destination as! NewItemViewController
            newItemVC.selectedSection = selectedSection
            if let item = todoItems?[tableView.indexPathForSelectedRow!.row] {
                newItemVC.itemToEdit = item
            }
            
        }
    }
    
    @IBAction func unwindNewItem(unwindSegue: UIStoryboardSegue) {
        if newItem {
            loadItems()
            newItem = false
        }
    }
}
