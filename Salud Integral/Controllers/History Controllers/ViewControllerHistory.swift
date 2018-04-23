//
//  ViewControllerHistory.swift
//  Salud Integral
//
//  Created by Alex Elizondo  on 2/21/18.
//  Copyright © 2018 Alex Elizondo . All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ViewControllerHistory: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    let realm = try! Realm()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var sections: Results<Section>?
    // Used to recognize if active or inactive tasks should be shown.
    var showActive: Bool = true
    let pickerViewSecondComponent = ["Activas", "Pasadas"]
    var selectedSection: Section?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadSections()
        
        configureView()
        
        self.title = "Historial"
    }
    
    func configureView() {
        tableView.delegate = self
        tableView.dataSource = self
        pickerView.delegate = self
        pickerView.dataSource = self
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateNavBar()
    }
    
    //MARK - Nav Bar Setup Methods
    
    func updateNavBar() {
        guard let navBar = navigationController?.navigationBar else
        {fatalError("Navigation Controller does not exist.")}
        let navBarColor = FlatSkyBlueDark()
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        let titleAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
        navBar.largeTitleTextAttributes = titleAttributes
        navBar.titleTextAttributes = titleAttributes
    }
    
    //MARK - Data Manipulation Methods
    
    func loadSections() {
        sections = realm.objects(Section.self)
        selectedSection = sections![0]

        tableView.reloadData()
        pickerView.reloadAllComponents()
    }
    
    //MARK - PickerView Settings

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // Just the first 4 sections have history.
        return component == 0 ? 4 : 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return component == 0 ? sections?[row].name : pickerViewSecondComponent[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedSection = sections?[row]
        } else {
            showActive = !showActive
        }
        tableView.reloadData()
    }
    
    //MARK - TableView Settings
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows: Int
        if showActive {
            rows =  selectedSection?.items.count ?? 0
        } else {
            rows = selectedSection?.inactiveItems.count ?? 0
        }
        return rows
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        cell.textLabel?.text = showActive ? selectedSection?.items[indexPath.row].name : selectedSection?.inactiveItems[indexPath.row].name
        
        cell.textLabel?.font = UIFont(name: (cell.textLabel?.font.fontName)!, size: 32)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HistorySegue" {
            let historyDatesVC = segue.destination as! HistoryDatesTableViewController
            if showActive {
                var item = selectedSection?.items[(tableView.indexPathForSelectedRow?.row)!]
                let index = indexForPastItem(item: item!)
                if index >= 0 {
                    item = selectedSection?.inactiveItems[index]
                }
                historyDatesVC.selectedItem = item
            } else {
                historyDatesVC.selectedItem = selectedSection?.inactiveItems[(tableView.indexPathForSelectedRow?.row)!]
            }
        }
    }
    
    // If the item was created in the past, it returns its index.
    func indexForPastItem(item: Item) -> Int {
        for i in (selectedSection?.inactiveItems)! {
            if item.name == i.name {
                return (selectedSection?.inactiveItems.index(of: i))!
            }
        }
        return -1
    }

}
