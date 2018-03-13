//
//  NewItemViewController.swift
//  Salud Integral
//
//  Created by Alex Elizondo  on 3/12/18.
//  Copyright © 2018 Alex Elizondo . All rights reserved.
//

import UIKit
import RealmSwift

class NewItemViewController: UIViewController {
    
    let realm = try! Realm()
    
    @IBOutlet weak var scFrequency: UISegmentedControl!
    @IBOutlet weak var scReminder: UISegmentedControl!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var tfStartDate: UITextField!
    
    var selectedSection: Section?
    var itemToEdit: Item?
    
    var startDate: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Tarea Nueva"
        tfStartDate.addTarget(self, action: #selector(chooseDate), for: .touchDown)
        
        load()
    }
    
    @objc func chooseDate(textField: UITextField) {
        performSegue(withIdentifier: "calendarSegue", sender: self)
    }
    
    //MARK - Segmented Control Getters
    
    func getFrecuency() -> String {
        switch scFrequency.selectedSegmentIndex {
        case 0:
            return "Lun"
        case 1:
            return "Mar"
        case 2:
            return "Mie"
        case 3:
            return "Jue"
        case 4:
            return "Vie"
        case 5:
            return "Sab"
        case 6:
            return "Dom"
        default:
            return ""
        }
    }
    
    func getFrequencyIndex(frequency: String) -> Int {
        switch frequency {
        case "Lun":
            return 0
        case "Mar":
            return 1
        case "Mie":
            return 2
        case "Jue":
            return 3
        case "Vie":
            return 4
        case "Sab":
            return 5
        case "Dom":
            return 6
        default:
            return 7
        }
        
    }
    
    func getReminder() -> Int {
        switch scReminder.selectedSegmentIndex {
        case 0:
            return 5
        case 1:
            return 10
        case 2:
            return 15
        case 3:
            return 30
        case 4:
            return 60
        default:
            return 0
        }
    }
    
    func getReminderIndex(reminder: Int) -> Int {
        switch reminder {
        case 5:
            return 0
        case 10:
            return 1
        case 15:
            return 2
        case 30:
            return 3
        case 60:
            return 4
        default:
            return 5
        }
    }
    
    // MARK - Model Manipulation Methods

    func save() {
        do {
            let item = itemToEdit ?? Item()
            try realm.write {
                item.active = true
                item.name = tfName.text!
                item.reminder = getReminder()
                item.frequency = getFrecuency()
                item.dateCreated = startDate
                if itemToEdit == nil {
                    selectedSection?.items.append(item)
                }
            }
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func load() {
        if let item = itemToEdit {
            tfName.text = item.name
            let format = DateFormatter()
            format.dateFormat = "dd-MM-YYYY"
            tfStartDate.text = format.string(from: item.dateCreated!)
            startDate = item.dateCreated
            scFrequency.selectedSegmentIndex = getFrequencyIndex(frequency: item.frequency)
            scReminder.selectedSegmentIndex = getReminderIndex(reminder: item.reminder)
        }
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "calendarSegue" {
            let checkListVC = segue.destination as! ViewControllerCheckList
            if (sender as! UIButton) == confirmButton {
                checkListVC.newItem = true
                save()
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (sender as! UIButton) == confirmButton {
            if tfName.text == "" || tfStartDate.text == "" || scReminder.selectedSegmentIndex < 0 || scFrequency.selectedSegmentIndex < 0 {
                let alerta = UIAlertController(title: "Error", message: "Los campos deben tener datos", preferredStyle: .alert)
                alerta.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                present(alerta, animated: true, completion: nil)
                return false
            }
        }
        return true
    }
    
    @IBAction func unwindCalendar(unwindSegue: UIStoryboardSegue) {
        if let date = startDate {
            let format = DateFormatter()
            format.dateFormat = "dd-MM-YYYY"
            tfStartDate.text = format.string(from: date)
        }
    }
}
