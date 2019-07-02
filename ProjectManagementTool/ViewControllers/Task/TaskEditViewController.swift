//
//  TaskEditViewController.swift
//  ProjectManagementTool
//
//  Created by Bror Andreas Nordstrom on 17/05/2019.
//  Copyright © 2019 Bror Andreas Nordstrom. All rights reserved.
//


import Foundation
import UIKit

// protocol for task edit dialog events
protocol TaskEditViewControllerDelegate {
    
    // for save button
    func onSave(project: Project, task: Task, name: String, note: String, endDate: Date, progress: Float)
    
    // for delete button
    func onDelete(project: Project, task: Task)
    
}

// task edit dialog
class TaskEditViewController: UIViewController {
    
    var delegate: TaskEditViewControllerDelegate? // delegate object for event
    var project: Project? // project for task. passed from parent
    var task: Task? // task to be edited. passed from parent
    
    
    // outlet vars for UI
    @IBOutlet var textFieldName: UITextField!
    @IBOutlet var textFieldNotes: UITextField!
    @IBOutlet var datePickerEndDate: UIDatePicker!
    @IBOutlet var sliderProgress: UISlider!
    
    @IBAction func onSave(_ sender: Any) {
        
        // save button clicked
        
        
        // need to validate inputs
        
        if (textFieldName.text ?? "") == "" {
            return
        }

        if (textFieldNotes.text ?? "") == "" {
            return
        }
        
        // all inputs are valid
        
        // close dialog
        self.dismiss(animated: true) {
            
            
            // after dialog is closed, we should emit event via delegate object
            self.delegate?.onSave(
                project: self.project!,
                task: self.task!,
                name: self.textFieldName.text ?? "",
                note: self.textFieldNotes.text ?? "",
                endDate: self.datePickerEndDate.date,
                progress: (self.sliderProgress.value * 10).rounded() / 10
            )
            
        }
        
    }
    
    
    @IBAction func onDelete(_ sender: Any) {
        
        // delete button is clicked

        // close dialog
        self.dismiss(animated: true) {
            
            // emit event via delegate object
            self.delegate?.onDelete(
                project: self.project!,
                task: self.task!)
        }
        
    }
    
    
    func configureView() {
        
        // show data on UI
        
        self.textFieldName.text = self.task?.name
        self.textFieldNotes.text = self.task?.note
        self.datePickerEndDate.setDate(self.task!.endDate! as Date, animated: false)
        self.sliderProgress.value = self.task?.progress ?? 0
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set date picker min and max value. min = today, max = project end date
        self.datePickerEndDate.minimumDate = Date()
        
        self.datePickerEndDate.maximumDate = self.project?.endDate as Date?
        
        // show data to UI
        self.configureView()

    }
    
    static func getInstance() -> UIViewController {
        
        // create dialog instance from storyboard
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TaskEditViewController") as UIViewController
        
        return vc
    }
    
}
