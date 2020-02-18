//
//  button.swift
//  FeifanLiu-Lab3
//
//  Created by labuser on 9/30/18.
//  Copyright © 2018 wustl. All rights reserved.
//

import UIKit
class button: UIButton {

    @IBInspectable var cornerRadius : CGFloat = 15.0{
        didSet{
            self.layer.cornerRadius=cornerRadius
        }

    }

    @IBInspectable var borderWidth: CGFloat = 2.0{
        didSet{
            self.layer.borderWidth=borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor=borderColor.cgColor
        }
    }

    @IBInspectable override var backgroundColor: UIColor!{
        didSet{
            self.layer.backgroundColor=backgroundColor.cgColor
        }
    }
}


