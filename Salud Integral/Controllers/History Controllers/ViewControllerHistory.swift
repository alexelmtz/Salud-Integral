//
//  ViewControllerHistory.swift
//  Salud Integral
//
//  Created by Alex Elizondo  on 2/21/18.
//  Copyright © 2018 Alex Elizondo . All rights reserved.
//

import UIKit
import RealmSwift

class ViewControllerHistory: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    let realm = try! Realm()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var sections: Results<Section>?
    var selectedSection: Section?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadSections()
        tableView.delegate = self
        tableView.dataSource = self
        pickerView.delegate = self
        pickerView.dataSource = self
        
        self.title = "Historial"
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
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // Just the first 4 sections have history.
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sections?[row].name ?? ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSection = sections?[row]
        
        tableView.reloadData()
    }
    
    //MARK - TableView Settings
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedSection?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        cell.textLabel?.text =  selectedSection?.items[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HistorySegue" {
            let historyDatesVC = segue.destination as! HistoryDatesTableViewController
            historyDatesVC.selectedItem = selectedSection?.items[(tableView.indexPathForSelectedRow?.row)!]
        }
    }

}
