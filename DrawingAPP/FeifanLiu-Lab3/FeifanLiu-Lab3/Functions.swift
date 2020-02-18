//
//  Functions.swift
//  FeifanLiu-Lab3
//
//  Created by labuser on 9/30/18.
//  Copyright © 2018 wustl. All rights reserved.
//

import UIKit
import Foundation

class Functions {
    private static func midpoint(first: CGPoint, second: CGPoint) -> CGPoint {
        // return two CGPoint's midpoint's coordinate
        return CGPoint(x: (first.x+second.x)/2, y: (first.y+second.y)/2)
    }
    static func createQuadPath(points: [CGPoint]) -> UIBezierPath {
        let path = UIBezierPath()
        if points.count < 2 { return path }
        let firstPoint = points[0]
        let secondPoint = points[1]
        let firstMidpoint = midpoint(first: firstPoint, second: secondPoint)
        path.move(to: firstPoint)
        path.addLine(to: firstMidpoint)
        for index in 1 ..< points.count-1 {
            let currentPoint = points[index]
            let nextPoint = points[index + 1]
            let midPoint = midpoint(first: currentPoint, second: nextPoint)
            path.addQuadCurve(to: midPoint, controlPoint: currentPoint)
        }
        guard let lastLocation = points.last else { return path }
        path.addLine(to: lastLocation)
        return path
    }
}
