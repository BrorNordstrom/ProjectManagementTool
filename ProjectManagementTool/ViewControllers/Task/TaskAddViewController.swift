//
//  TaskAddViewController.swift
//  ProjectManagementTool
//
//  Created by Bror Andreas Nordstrom on 17/05/2019.
//  Copyright © 2019 Bror Andreas Nordstrom. All rights reserved.
//


import Foundation
import UIKit

// protocol for task add dialog events
protocol TaskAddViewControllerDelegate {

    // for save button
    func onSave(name: String, note: String, endDate: Date, addNotification: Bool)
}

// task add dialog
class TaskAddViewController: UIViewController {
    
    var delegate: TaskAddViewControllerDelegate? // delegate object for events
    var project: Project? // project for new task. passed from parent
    
    // outlet vars for UI
    @IBOutlet var textFieldName: UITextField!
    @IBOutlet var textFieldNotes: UITextField!
    @IBOutlet weak var datePickerEndDate: UIDatePicker!
    @IBOutlet weak var switchAddNotification: UISwitch!
    
    @IBAction func onSave(_ sender: Any) {
        
        // save button is clicked
        
        // should validate all inputs
        if (textFieldName.text ?? "") == "" {
            return
        }

        if (textFieldNotes.text ?? "") == "" {
            return
        }
        
        // all inputs are valid
        
        // close dialog
        self.dismiss(animated: true) {
            
            // after dialog is closed, emit event via delegate object
            self.delegate?.onSave(
                name: self.textFieldName.text ?? "",
                note: self.textFieldNotes.text ?? "",
                endDate: self.datePickerEndDate.date,
                addNotification: self.switchAddNotification.isOn)
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set date picker min and max value. min = today, max = project end date
        self.datePickerEndDate.minimumDate = Date()
        
        self.datePickerEndDate.maximumDate = self.project?.endDate as Date?

    }
    
    static func getInstance() -> UIViewController {

        // create instance for dialog from storybaord
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TaskAddViewController") as UIViewController
        
        return vc
    }
    
    
    
}



