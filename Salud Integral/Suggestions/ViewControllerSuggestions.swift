//
//  ViewControllerSuggestions.swift
//  Salud Integral
//
//  Created by Alex Elizondo  on 4/19/18.
//  Copyright © 2018 Alex Elizondo . All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ViewControllerSuggestions: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    let realm = try! Realm()
    
    var sections: Results<Section>?
    var selectedSection: Section?
    var showFirst: Bool = true
    var suggestionsFirst: [String]?
    var suggestionsSecond: [String]?

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        loadSections()
        createSuggestions()

        title = "Sugerencias"
    }
    
    func configureView() {
        tableView.delegate = self
        tableView.dataSource = self
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateNavBar()
    }
    
    //MARK - Nav Bar Setup Methods
    
    func updateNavBar() {
        guard let navBar = navigationController?.navigationBar else
        {fatalError("Navigation Controller does not exist.")}
        let navBarColor = FlatMintDark().darken(byPercentage: 0.2)!
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
    }
    
    //MARK - Defaults
    
    func createSuggestions() {
        suggestionsSecond = ["Fdsafa", "erewr"]
        suggestionsFirst = ["Fsa"]
        tableView.reloadData()
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
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sections?[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        showFirst = !showFirst
        
        tableView.reloadData()
    }
    
    //MARK - TableView Settings
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showFirst ? suggestionsFirst?.count ?? 0 : suggestionsSecond?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        cell.textLabel?.text = showFirst ? suggestionsFirst?[indexPath.row] : suggestionsSecond?[indexPath.row]
        
        cell.textLabel?.font = UIFont(name: (cell.textLabel?.font.fontName)!, size: 32)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
