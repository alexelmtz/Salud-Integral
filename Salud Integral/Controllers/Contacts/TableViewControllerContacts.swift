//
//  TableViewControllerContacts.swift
//  Salud Integral
//
//  Created by Alex Elizondo  on 3/4/18.
//  Copyright © 2018 Alex Elizondo . All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TableViewControllerContacts: UITableViewController {
    
    let realm = try! Realm()
    
    var contactList: Results<Contact>?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Contactos"
        
        load()
        
        tableView.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: "customContact")
        
        tableView.rowHeight = 120
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateNavBar()
    }
    
    //MARK - Nav Bar Setup Methods
    
    func updateNavBar() {
        guard let navBar = navigationController?.navigationBar else
        {fatalError("Navigation Controller does not exist.")}
        let navBarColor = FlatOrangeDark().lighten(byPercentage: 0.05)!
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        let titleAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
        navBar.largeTitleTextAttributes = titleAttributes
        navBar.titleTextAttributes = titleAttributes
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
            contact3.phoneNumber = "068"
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactList?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customContact", for: indexPath) as! ContactTableViewCell
        
        if let contact = contactList?[indexPath.row] {
            cell.title.text = contact.name
            cell.title.textColor = FlatNavyBlueDark()
            
            cell.phoneNumber.text = contact.phoneNumber
            cell.phoneNumber.textColor = FlatNavyBlue()
        }

        return cell
    }

}
