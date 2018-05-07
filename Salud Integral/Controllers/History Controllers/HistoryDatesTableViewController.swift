//
//  HistoryDatesTableViewController.swift
//  Salud Integral
//
//  Created by Alex Elizondo  on 3/26/18.
//  Copyright © 2018 Alex Elizondo . All rights reserved.
//

import UIKit
import ChameleonFramework

class HistoryDatesTableViewController: UITableViewController {
    
    var selectedItem: Item?
    var datesCompleted: [History]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = (selectedItem?.name)!
        if let dates = selectedItem?.datesCompleted {
            datesCompleted = Array(dates).reversed()
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let size = datesCompleted?.count ?? 0
        return size > 0 ? size : 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if datesCompleted?.count == 0 {
            cell.textLabel?.text = "No se ha realizado"
            cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 32)
            cell.textLabel?.textColor = FlatNavyBlue()
            cell.detailTextLabel?.text = ""

            return cell
        }
        
        guard let date = datesCompleted?[indexPath.row].date else { fatalError("Item History not found")}
        
        let format = DateFormatter()
        format.dateFormat = "dd/MM/YYYY"
        
        cell.textLabel?.text = "Día: \(format.string(from: date))"
        cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 32)
        cell.textLabel?.textColor = FlatNavyBlue()
        format.dateFormat = "hh:mm a"
        cell.detailTextLabel?.text = "Hora: \(format.string(from: date))"
        cell.detailTextLabel?.font = UIFont(name: "HelveticaNeue", size: 24)
        cell.detailTextLabel?.textColor = FlatNavyBlue()
        return cell
    }
}
