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
    
    var startDate: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Tarea Nueva"
        tfStartDate.addTarget(self, action: #selector(chooseDate), for: .touchDown)
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
    
    // MARK - Model Manipulation Methods

    func save() {
        do {
            try realm.write {
                let item = Item()
                item.active = true
                item.name = tfName.text!
                item.reminder = getReminder()
                item.frequency = getFrecuency()
                item.dateCreated = startDate
                selectedSection?.items.append(item)
            }
        } catch {
            print("Error saving context \(error)")
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
