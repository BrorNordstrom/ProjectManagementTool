//
//  ProjectAddViewController.swift
//  ProjectManagementTool
//
//  Created by Bror Andreas Nordstrom on 15/05/2019.
//  Copyright © 2019 Bror Andreas Nordstrom. All rights reserved.
//


import Foundation
import UIKit

// protocol for project add dialog events
protocol ProjectAddViewControllerDelegate {
    // this is for save button
    func onSave(name: String, note: String, endDate: Date, priority: Int, add2Calendar: Bool)
}

// project add dialog
class ProjectAddViewController: UIViewController {
    
    var delegate: ProjectAddViewControllerDelegate? // delegate for event
    
    
    // outlet vars for UI
    @IBOutlet var textFieldProjectName: UITextField!
    @IBOutlet var textFieldNotes: UITextField!
    @IBOutlet weak var datePickerEndDate: UIDatePicker!
    @IBOutlet weak var segmentPriority: UISegmentedControl!
    @IBOutlet weak var switchAdd2Calendar: UISwitch!
    
    @IBAction func onSave(_ sender: Any) {
        
        // save button is clicked
        
        // validate inputs
        if (textFieldProjectName.text ?? "") == "" {
            return
        }

        if (textFieldNotes.text ?? "") == "" {
            return
        }
        
        // all inputs are valid
        
        // close dialog
        self.dismiss(animated: true) {
            
            // after dialog is closed, should emit event via delegate object
            self.delegate?.onSave(
                name: self.textFieldProjectName.text ?? "",
                note: self.textFieldNotes.text ?? "",
                endDate: self.datePickerEndDate.date,
                priority: self.segmentPriority.selectedSegmentIndex,
                add2Calendar: self.switchAdd2Calendar.isOn)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set minimum date. the project end date min date will be today
        self.datePickerEndDate.minimumDate = Date()
        
    }
    
    static func getInstance() -> UIViewController {
        
        // create dialog instance from storyboard
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProjectAddViewController") as UIViewController
        
        return vc
    }
    
}

