//
//  TableViewControllerConfiguration.swift
//  Salud Integral
//
//  Created by Alex Elizondo  on 3/4/18.
//  Copyright © 2018 Alex Elizondo . All rights reserved.
//

import UIKit

class TableViewControllerConfiguration: UITableViewController {
    
    let sections = ["Modificar sección", "Reiniciar"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Configuración"
        configureTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sections.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConfigCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = sections[indexPath.row]
        cell.textLabel?.font = UIFont(name: (cell.textLabel?.font.fontName)!, size: 32)
        
        return cell
    }
    
    func configureTableView() {
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row == 0 {
//           // Do a popover
//        }
//    }

}