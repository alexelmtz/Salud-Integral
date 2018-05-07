//
//  CalendarViewController.swift
//  Salud Integral
//
//  Created by Alex Elizondo  on 3/12/18.
//  Copyright © 2018 Alex Elizondo . All rights reserved.
//

import UIKit
import JBDatePicker
import ChameleonFramework

class CalendarViewController: UIViewController, JBDatePickerViewDelegate {

    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var datePicker: JBDatePickerView!
    @IBOutlet weak var confirmButton: UIButton!
    
    ///Color of any label text that is selected
    var colorForSelelectedDayLabel: UIColor { return FlatWhite() }
    ///Color of the selection circle for dates that aren't today
    var colorForSelectionCircleForOtherDate: UIColor { return FlatMint() }
    ///Color of the selection circle for today
    var colorForSelectionCircleForToday: UIColor { return FlatRed() }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker.delegate = self
    }
    
    func didSelectDay(_ dayView: JBDatePickerDayView) {
        // Needed to comply with protocol
    }
    
    func didPresentOtherMonth(_ monthView: JBDatePickerMonthView) {
        lbDate.text = monthView.monthDescription
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override var shouldAutorotate: Bool {
        return false
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewNewItem = segue.destination as! NewItemViewController
        if (sender as! UIButton) == confirmButton {
            viewNewItem.startDate = datePicker.selectedDateView.date
        }
    }
}
