//
//  TableViewControllerConfiguration.swift
//  Salud Integral
//
//  Created by Alex Elizondo  on 3/4/18.
//  Copyright © 2018 Alex Elizondo . All rights reserved.
//

import UIKit
import ChameleonFramework

class TableViewControllerConfiguration: UITableViewController {
    
    let sections = ["Modificar sección", "Créditos"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Configuración"
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateNavBar()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override var shouldAutorotate: Bool {
        return false
    }
    
    //MARK - Nav Bar Setup Methods
    
    func updateNavBar() {
        guard let navBar = navigationController?.navigationBar else
        {fatalError("Navigation Controller does not exist.")}
        let navBarColor = UIColor(hexString: "#f8dc9d")!
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        let titleAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
        navBar.largeTitleTextAttributes = titleAttributes
        navBar.titleTextAttributes = titleAttributes
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConfigCell", for: indexPath)

        cell.textLabel?.text = sections[indexPath.row]
        cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 32)
        cell.textLabel?.textColor = FlatNavyBlue()
        
        return cell
    }
    
    func configureTableView() {
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
           performSegue(withIdentifier: "segueSectionNames", sender: self)
        } else {
            performSegue(withIdentifier: "creditsSegue", sender: self)
        }
    }

}
