//
//  ViewController.swift
//  Salud Integral
//
//  Created by Alex Elizondo  on 2/21/18.
//  Copyright © 2018 Alex Elizondo . All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Inicio"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "checkListSegue", sender: sender)
    }
    
    //MARK - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let btn = (sender as! UIButton)
        // It's one of the buttons with checklist.
        if btn.tag < 4 {
            let checkListView = segue.destination as! ViewControllerCheckList
            checkListView.checklistTitle = (btn.titleLabel?.text!)!
        } else if btn.tag  == 5 { // It's the history button
//            let checkListView = segue.destination as! ViewControllerCheckList
//            checkListView.title = (sender as! UIButton).titleLabel?.text
        } else {    // It's the configuration button
            
        }
    }
    
}

