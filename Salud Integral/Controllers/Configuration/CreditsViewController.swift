//
//  CreditsViewController.swift
//  Salud Integral
//
//  Created by Alex Elizondo  on 4/29/18.
//  Copyright © 2018 Alex Elizondo . All rights reserved.
//

import UIKit
import ChameleonFramework

class CreditsViewController: UIViewController {

    @IBOutlet weak var lbCredits: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Créditos"
        
        lbCredits.textColor = FlatNavyBlue()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override var shouldAutorotate: Bool {
        return false
    }

}
