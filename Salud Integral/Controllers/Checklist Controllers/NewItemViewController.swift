//
//  NewItemViewController.swift
//  Salud Integral
//
//  Created by Alex Elizondo  on 3/12/18.
//  Copyright © 2018 Alex Elizondo . All rights reserved.
//

import UIKit
import UserNotifications
import RealmSwift
import ChameleonFramework

class NewItemViewController: UIViewController {
    
    let realm = try! Realm()
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var scFrequency: UISegmentedControl!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var tfStartDate: UITextField!
    
    var selectedSection: Section?
    var itemToEdit: Item?
    var lastViewControllerName: String? // Could be ViewControllerCheckList or ViewControllerSuggestions.
    var itemName: String?   // This will have a value if a suggestion will be added.
    
    var startDate: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Tarea Nueva"
        tfStartDate.addTarget(self, action: #selector(chooseDate), for: .touchDown)
        
        load()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (didAllow, error) in
        }
        
        datePicker.timeZone = TimeZone.current
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func chooseDate(textField: UITextField) {
        performSegue(withIdentifier: "calendarSegue", sender: self)
    }
    
    // MARK - Notification
    
    func notificationConfiguration(title: String) {
        let answer1 = UNNotificationAction(identifier: title, title: "Completado", options: UNNotificationActionOptions.foreground)
        
        let category = UNNotificationCategory(identifier: "myCategory", actions: [answer1], intentIdentifiers: [], options:[])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        // Create notification
        let content = UNMutableNotificationContent()
        content.title = title
        content.categoryIdentifier = "myCategory"
        content.badge = 1
        
        // TODO: Make notifications repeat every certain time.
        
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let trigger = UNCalendarNotificationTrigger(dateMatching: getReminderComponents(), repeats: false)
        let request = UNNotificationRequest(identifier: "Recordatorio", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
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
    
    // Creates date based on the day of the item and the time of the reminder.
    func getReminderDate() -> Date {
        var components = getReminderComponents()
        let format = DateFormatter()
        
        format.dateFormat = "yyyy"
        components.year = Int(format.string(from: startDate))
        format.dateFormat = "MM"
        components.month = Int(format.string(from: startDate))
        format.dateFormat = "dd"
        components.day = Int(format.string(from: startDate))
        
        let calendar = Calendar.current
        
        return calendar.date(from: components)!
    }
    
    // Return components necessary to schedule notification.
    func getReminderComponents() -> DateComponents {
        var components = DateComponents()
        components.timeZone = TimeZone.current
        
        let format = DateFormatter()
        
        format.dateFormat = "HH"
        components.hour = Int(format.string(from: datePicker.date))
        format.dateFormat = "mm"
        components.minute = Int(format.string(from: datePicker.date))
//        components.weekday = scFrequency.selectedSegmentIndex + 2
        
        return components
    }

    // MARK - Model Manipulation Methods

    func save() {
        do {
            let item = itemToEdit ?? Item()
            try realm.write {
                item.name = tfName.text!
                item.reminder = getReminderDate()
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
            datePicker.setDate(item.reminder!, animated: true)
            scFrequency.selectedSegmentIndex = getFrequencyIndex(frequency: item.frequency)
        }
        else if itemName != nil {
            tfName.text = itemName
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
            if tfName.text == "" || tfStartDate.text == "" || scFrequency.selectedSegmentIndex < 0 {
                let alerta = UIAlertController(title: "Error", message: "Los campos deben tener datos", preferredStyle: .alert)
                alerta.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                present(alerta, animated: true, completion: nil)
                return false
            } else {
                notificationConfiguration(title: tfName.text!)
            }
        }
        
        if lastViewControllerName == "ViewControllerSuggestions" {
            if (sender as! UIButton) == confirmButton {
                save()
            }
            dismiss(animated: true, completion: nil)
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
