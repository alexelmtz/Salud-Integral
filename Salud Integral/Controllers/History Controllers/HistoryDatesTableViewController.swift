//
//  HistoryDatesTableViewController.swift
//  Salud Integral
//
//  Created by Alex Elizondo  on 3/26/18.
//  Copyright © 2018 Alex Elizondo . All rights reserved.
//

import UIKit

class HistoryDatesTableViewController: UITableViewController {
    
    var selectedItem: Item?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = (selectedItem?.name)!
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedItem?.datesCompleted.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        guard let date = selectedItem?.datesCompleted[indexPath.row].date else { fatalError("Item History not found")}
        
        let format = DateFormatter()
        format.dateFormat = "dd/MM/YYYY"
        
        cell.textLabel?.text = format.string(from: date)
        
        format.dateFormat = "HH:mm"
        cell.detailTextLabel?.text = format.string(from: date)
        
        return cell
    }
}
