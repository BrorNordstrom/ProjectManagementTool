//
//  DetailTableViewCell.swift
//  ProjectManagementTool
//
//  Created by Bror Andreas Nordstrom on 17/05/2019.
//  Copyright © 2019 Bror Andreas Nordstrom. All rights reserved.
//


import Foundation
import UIKit

// class for task table view cell
class DetailTableViewCell: UITableViewCell {
    
    // outlet vars for UI
    @IBOutlet var labelName: UILabel!
    @IBOutlet var labelDate: UILabel!
    @IBOutlet var labelNote: UILabel!
    @IBOutlet var labelPercent: UILabel!
    @IBOutlet var progressView: ProgressView!
    @IBOutlet weak var pieView: PieView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // we should set pie view circular
        self.pieView.layer.cornerRadius = self.pieView.frame.width / 2
        self.pieView.layer.masksToBounds = true
        
    }
    
    
    func setCellData(project: Project, task: Task) { // set cell data from parent
        
        // task name
        self.labelName.text = task.name
        
        // task note
        self.labelNote.text = task.note
        
        // set task date info
        if let startDate = task.startDate,
            let endDate = task.endDate {
            
            self.labelDate.text = startDate.toString() + " - " + endDate.toString()
            
            // calcuate length and percent for date based on timestamp
            let currentDate = Date()
            let length = endDate.timeIntervalSince1970 - startDate.timeIntervalSince1970
            let passed = currentDate.timeIntervalSince1970 - startDate.timeIntervalSince1970
            
            let percent = 100.0 * passed / length
            
            // set progress
            self.progressView.percent = CGFloat(percent)
        }
        
        // set pie view info
        self.setPiePercent(CGFloat(task.progress))
        
    }
    
    func setPiePercent(_ percent: CGFloat) {
        // set pie view data
        self.pieView.percent = percent
        // set pie view description label data
        self.labelPercent.text = "" + String(Float(percent)) + "%"
    }
    
}

