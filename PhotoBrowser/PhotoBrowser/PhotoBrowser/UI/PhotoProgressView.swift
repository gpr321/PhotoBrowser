//
//  PhotoProgressView.swift
//  MyWeiBo
//
//  Created by mac on 15/3/9.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

import UIKit

class PhotoProgressView: UIView {
    static let RADIUS: CGFloat = 50
    static let LINE_WIDTH: CGFloat = 10
    // 0 - 1
    var progress: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let angel = CGFloat(M_PI) * 2 * progress
        let out = UIBezierPath(arcCenter: self.center, radius: PhotoProgressView.RADIUS, startAngle: 0, endAngle: angel, clockwise: true)
        out.lineWidth = PhotoProgressView.LINE_WIDTH
        out.stroke()
        var p = Int(progress * 10000)
        var pp = CGFloat(p) / 100
        let progressString = "\(pp)%"
        let size = progressString.sizeWithAttributes(nil)
        let x = self.center.x - size.width * 0.5
        let y = self.center.y - size.height * 0.5
        let point = CGPointMake(x, y)
        progressString.drawAtPoint(point, withAttributes: nil)
    }

}
