//
//  SectionNamesViewController.swift
//  Salud Integral
//
//  Created by Alex Elizondo  on 4/11/18.
//  Copyright © 2018 Alex Elizondo . All rights reserved.
//

import UIKit
import RealmSwift

class SectionNamesViewController: UIViewController {
    let realm = try! Realm()
    
    var sections: Results<Section>!
    

    @IBOutlet weak var tfOne: UITextField!
    @IBOutlet weak var tfTwo: UITextField!
    @IBOutlet weak var tfThree: UITextField!
    @IBOutlet weak var tfFour: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sections = realm.objects(Section.self)
        
        tfOne.text = sections[0].name
        tfTwo.text = sections[1].name
        tfThree.text = sections[2].name
        tfFour.text = sections[3].name

        title = "Secciones"
    }
    @IBAction func savePressed(_ sender: UIButton) {
        do {
            try realm.write {
                sections[0].name = tfOne.text ?? sections[0].name
                sections[1].name = tfTwo.text ?? sections[1].name
                sections[2].name = tfThree.text ?? sections[2].name
                sections[3].name = tfFour.text ?? sections[3].name
            }
        } catch {
            print("Error saving context \(error)")
        }
        self.navigationController?.popViewController(animated: true)
    }
    
}
