//
//  PieView.swift
//  ProjectManagementTool
//
//  Created by Bror Andreas Nordstrom on 17/05/2019.
//  Copyright © 2019 Bror Andreas Nordstrom. All rights reserved.
//


import Foundation
import UIKit

// simple pie view
class PieView: UIView {
    
    var percent: CGFloat? {
        didSet {
            
            // re-draw when percent data is set
            self.setNeedsDisplay()
        }
    }

    
    
    override func draw(_ rect: CGRect) {
        
        // draw
        
        // get context for drawing
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        guard let percent = self.percent else { return }
        
        // draw rectangle for background
        ctx.setFillColor(UIColor.darkGray.cgColor)
        ctx.fill(CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        
        // calculate pie radius
        let radius = self.frame.width / 2
        
        // get path for pie
        let path = UIBezierPath.init(circleSegmentCenter: CGPoint(x: radius, y: radius), radius: radius, startAngle: 270 - ( 360.0 * percent / 100.0 ) , endAngle: 270)

        // set fill color
        ctx.setFillColor(self.tintColor.cgColor)
        
        // fill path
        path.fill()
        
        ctx.addPath(path.cgPath)
        
        ctx.fillPath()
        
        
    }
    
    
}
