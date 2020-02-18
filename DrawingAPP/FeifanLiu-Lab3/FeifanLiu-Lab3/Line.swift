//
//  Line.swift
//  FeifanLiu-Lab3
//
//  Created by labuser on 9/30/18.
//  Copyright © 2018 wustl. All rights reserved.
//

import UIKit
import Foundation
//make line stuct codable to store it in userdefaults.
struct Line: Codable{
    var points: [CGPoint] = []
    var thickness: CGFloat
    var color: UIColor
    var startpoint: CGPoint
    var endpoint:CGPoint
    
    enum CodingKeys: String, CodingKey{
        case points; case thickness; case color; case startpoint; case endpoint;
    }
    init(points:[CGPoint], thickness:CGFloat, color: UIColor, startpoint: CGPoint, endpoint: CGPoint){
        self.points=points; self.thickness=thickness; self.color=color; self.startpoint=startpoint; self.endpoint=endpoint;
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(points,forKey:.points)
        try container.encode(thickness,forKey:.thickness)
        let colorData = NSKeyedArchiver.archivedData(withRootObject: color)
        try container.encode(colorData, forKey: .color)
        try container.encode(startpoint,forKey:.startpoint)
        try container.encode(endpoint,forKey:.endpoint)
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        points = try container.decode([CGPoint].self,forKey:.points)
        thickness = try container.decode(CGFloat.self,forKey:.thickness)
        let colorData = try container.decode(Data.self, forKey: .color)
        color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor ?? UIColor.black
        startpoint = try container.decode(CGPoint.self,forKey:.startpoint)
        endpoint = try container.decode(CGPoint.self,forKey:.endpoint)
    }
}

struct Eraser{
    var center: CGPoint
    var radius: CGFloat
}
