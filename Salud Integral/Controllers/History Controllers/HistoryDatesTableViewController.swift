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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
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
        
        cell.textLabel?.text = "Día: \(format.string(from: date))"
        cell.textLabel?.font = UIFont(name: (cell.textLabel?.font.fontName)!, size: 32)
        
        format.dateFormat = "HH:mm"
        cell.detailTextLabel?.text = "Hora: \(format.string(from: date))"
        cell.detailTextLabel?.font = UIFont(name: (cell.textLabel?.font.fontName)!, size: 24)
        
        return cell
    }
}
