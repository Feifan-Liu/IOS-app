//
//  LineView.swift
//  FeifanLiu-Lab3
//
//  Created by labuser on 9/30/18.
//  Copyright © 2018 wustl. All rights reserved.
//

import UIKit

class LineView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var theLine:Line? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var lines: [Line] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    var Eraser: Eraser? {
        didSet {
            setNeedsDisplay()
        }
    }
    //use the function provided to get UIBezierPath of the line and use stroke() to draw the line
    //for the startpoint and endpoint, draw a circle to make one single touch a dot and make the line looks better
    func drawLine(_ line:Line){
        let path = Functions.createQuadPath(points: line.points)
        line.color.setStroke()
        line.color.setFill()
        let startpoint = UIBezierPath()
        let endpoint = UIBezierPath()
        startpoint.addArc(withCenter: line.startpoint, radius: line.thickness/2, startAngle: 0, endAngle: CGFloat(Float.pi * 2), clockwise: true)
        endpoint.addArc(withCenter: line.endpoint, radius: line.thickness/2, startAngle: 0, endAngle: CGFloat(Float.pi * 2), clockwise: true)
        startpoint.fill()
        endpoint.fill()
        path.lineWidth=line.thickness
        path.stroke()
    }
    //displaly the range of eraser
    func erase(_ Eraser:Eraser){
        UIColor.black.setStroke()
        let eraser = UIBezierPath()
        eraser.addArc(withCenter: Eraser.center, radius: Eraser.radius, startAngle: 0, endAngle: CGFloat(Float.pi * 2), clockwise: true)
        eraser.stroke()
    }
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    // override draw() function to drawline and eraser's range
    override func draw(_ rect: CGRect) {
        // Drawing code
        for line in lines {
            drawLine(line)
        }
        if (theLine != nil) {
            drawLine(theLine!)
        }
        if (Eraser != nil){
            erase(Eraser!)
        }
    }
    }
    


