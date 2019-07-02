//
//  ProgressView.swift
//  ProjectManagementTool
//
//  Created by Bror Andreas Nordstrom on 17/05/2019.
//  Copyright © 2019 Bror Andreas Nordstrom. All rights reserved.
//


import Foundation
import UIKit

// simple progress view
class ProgressView: UIView {
    
    var percent: CGFloat? {
        didSet {
            // re-draw view when percent data is set
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {

        // draw
        
        // get context
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        guard let percent = self.percent else { return }
        
        let width = self.frame.width * percent / 100.0
        
        // draw two rectangles
        
        // background rectangle
        ctx.setFillColor(UIColor.darkGray.cgColor)
        ctx.fill(CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        
        // percent rectangle
        ctx.setFillColor(self.tintColor.cgColor)
        ctx.fill(CGRect(x: 0, y: 0, width: width, height: self.frame.height))
    }
    
}
