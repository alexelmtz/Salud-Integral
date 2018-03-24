//
//  TableViewControllerContacts.swift
//  Salud Integral
//
//  Created by Alex Elizondo  on 3/4/18.
//  Copyright © 2018 Alex Elizondo . All rights reserved.
//

import UIKit
import RealmSwift

class TableViewControllerContacts: UITableViewController {
    
    let realm = try! Realm()
    
    var contactList: Results<Contact>?
    
//    var contactos: [String: String] = ["Emergencias": "911", "Cruz Roja": "+52(55)5557-5757", "Bomberos": "068 o +52(55)5768-3700", "Policía": "060", "Denuncia": "089", "Protección Civil": "+52(55)5683-2222"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Contactos"
        
        load()
        
        tableView.register(UINib(nibName: "Cell", bundle: nil), forCellReuseIdentifier: "customContact")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - Model Manipulation Methods
    
    func load() {
        contactList = realm.objects(Contact.self)
        
        if contactList?.count == 0 {
            createDefaultContacts()
            contactList = realm.objects(Contact.self)
        }
        
        tableView.reloadData()
    }
    
    func createDefaultContacts() {
        do {
            let contact1 = Contact()
            contact1.name = "Emergencias"
            contact1.phoneNumber = "911"
            let contact2 = Contact()
            contact2.name = "Cruz Roja"
            contact2.phoneNumber = "+52(55)5557-5757"
            let contact3 = Contact()
            contact3.name = "Bomberos"
            contact3.phoneNumber = "068 o +52(55)5768-3700"
            let contact4 = Contact()
            contact4.name = "Policía"
            contact4.phoneNumber = "060"
            let contact5 = Contact()
            contact5.name = "Denuncia"
            contact5.phoneNumber = "089"
            let contact6 = Contact()
            contact6.name = "Protección Civil"
            contact6.phoneNumber = "+52(55)5683-2222"
            try realm.write {
                realm.add(contact1)
                realm.add(contact2)
                realm.add(contact3)
                realm.add(contact4)
                realm.add(contact5)
                realm.add(contact6)
            }
            
        } catch {
            print("Error saving context \(error)")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contactList?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customContact", for: indexPath) as! ContactTableViewCell
        
        if let contact = contactList?[indexPath.row] {
            cell.title.text = contact.name
            cell.phoneNumber.text = contact.phoneNumber
        }

        // Configure the cell...
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
