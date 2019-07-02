//
//  ProjectEditViewController.swift
//  ProjectManagementTool
//
//  Created by Bror Andreas Nordstrom on 15/05/2019.
//  Copyright © 2019 Bror Andreas Nordstrom. All rights reserved.
//


import Foundation
import UIKit

// protocol for project edit dialog events
protocol ProjectEditViewControllerDelegate {
    
    // for save button
    func onSave(project: Project, name: String, note: String, endDate: Date, priority: Int)
    
    // for delete button
    func onDelete(project: Project)
}

// projecte deit dialog
class ProjectEditViewController: UIViewController {
    
    var delegate: ProjectEditViewControllerDelegate? // delegate for event
    
    var project: Project? // selected project. passed from parent
    
    // outlet vars for UI
    @IBOutlet var textFieldProjectName: UITextField!
    @IBOutlet var textFieldNotes: UITextField!
    @IBOutlet weak var datePickerEndDate: UIDatePicker!
    @IBOutlet weak var segmentPriority: UISegmentedControl!
    
    @IBAction func onSave(_ sender: Any) {
        
        // save button clicked
        
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
            
            // after dialog is closed, emit event via delegate object
            self.delegate?.onSave(
                project: self.project!,
                name: self.textFieldProjectName.text ?? "",
                note: self.textFieldNotes.text ?? "",
                endDate: self.datePickerEndDate.date,
                priority: self.segmentPriority.selectedSegmentIndex)
        }
        
    }
    
    @IBAction func onDelete(_ sender: Any) {
        
        // delete button cliekced
        
        // close dialog
        self.dismiss(animated: true) {
            
            // after dialog is closed, emit event via delegate object
            self.delegate?.onDelete(project: self.project!)
        }
        
        
    }
    
    // show project data to dialog
    func configureView() {
        
        // check if project is not nil
        guard let project = project else { return }
        
        
        // show data to UI
        self.textFieldProjectName.text = project.name
        self.textFieldNotes.text = project.note
        self.datePickerEndDate.setDate(project.endDate! as Date, animated: false)
        self.segmentPriority.selectedSegmentIndex = Int(project.priority)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // project end date min value will be today
        self.datePickerEndDate.minimumDate = Date()
        
        // show data to UI
        self.configureView()
        
    }
    
    static func getInstance() -> UIViewController {

        // create instance for dialog from storyboard
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProjectEditViewController") as UIViewController
        
        return vc
    }
    
}

