//
//  MasterTableViewCell.swift
//  ProjectManagementTool
//
//  Created by Bror Andreas Nordstrom on 17/05/2019.
//  Copyright © 2019 Bror Andreas Nordstrom. All rights reserved.
//


import Foundation
import UIKit

// class for project table view cell
class MasterTableViewCell: UITableViewCell {
  
    // outlet vars for UI
    @IBOutlet var labelName: UILabel!
    @IBOutlet var labelEndDate: UILabel!
    @IBOutlet var labelNote: UILabel!
    @IBOutlet weak var priorityView: UIView!
    
    
    
    func setCellData(project: Project) { // set cell data from paretn
        
        // project name
        self.labelName.text = project.name
        
        // project date info
        if let startDate = project.startDate,
            let endDate = project.endDate {
            self.labelEndDate.text = startDate.toString() + " - " + endDate.toString()
        }
        
        // project note
        self.labelNote.text = project.note
        
        // project priority
        let colors: [Int32: UIColor] = [
            0: UIColor.red,
            1: UIColor.green,
            2: UIColor.blue
        ]
        
        self.priorityView.backgroundColor = colors[project.priority]
        
    }
    
}

