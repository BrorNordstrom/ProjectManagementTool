//
//  Extensions.swift
//  ProjectManagementTool
//
//  Created by Bror Andreas Nordstrom on 17/05/2019.
//  Copyright © 2019 Bror Andreas Nordstrom. All rights reserved.
//


import Foundation
import UIKit

// extension for NSDate
extension NSDate {
    
    // returns string represents date
    func toString(_ format: String = "yyyy/MM/dd") -> String {
        /*
         yyyy.MM.dd
         yyyy-MM-dd HH:mm:ss
         yyyy/MM/dd
         */
        // use date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self as Date)
    }
    
}

// extension for CGFlaot
extension CGFloat {
    // returns radians value from angle value
    func radians() -> CGFloat {
        let b = CGFloat(Double.pi) * (self/180)
        return b
    }
}

// extension for UIBezierPath
extension UIBezierPath {
    
    // create constructor for generating path from pie data
    convenience init(circleSegmentCenter center:CGPoint, radius:CGFloat, startAngle:CGFloat, endAngle:CGFloat)
    {
        self.init()
        
        // move to center
        self.move(to: CGPoint.init(x: center.x, y: center.y))
        
        // draw arc for pie
        self.addArc(withCenter: center, radius: radius, startAngle: startAngle.radians(), endAngle: endAngle.radians(), clockwise:true)

        // close path
        self.close()
    }
}

