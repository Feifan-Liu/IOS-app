//
//  ViewController.swift
//  FeifanLiu-Lab3
//
//  Created by labuser on 9/30/18.
//  Copyright © 2018 wustl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var currentLine: Line?
    var lineCanvas: LineView!
    var eraser: Eraser?
    var currentColor: UIColor = UIColor.black //current chosen color
    
    @IBOutlet weak var red: button!
    @IBOutlet weak var orange: button!
    @IBOutlet weak var yellow: button!
    @IBOutlet weak var green: button!
    @IBOutlet weak var cyan: button!
    @IBOutlet weak var blue: button!
    @IBOutlet weak var purple: button!
    @IBOutlet weak var black: button!
    @IBOutlet weak var white: button!
    @IBOutlet weak var RGBbtn: button!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var slideRed: UISlider!
    @IBOutlet weak var slideGreen: UISlider!
    @IBOutlet weak var slideBlue: UISlider!
    @IBOutlet weak var colorDisplay: UIView!
    @IBOutlet weak var RGBdisplay: UIView!
    @IBOutlet weak var colorStack: UIStackView!
    @IBOutlet weak var slide: UISlider!
    
    
    //save the Canvas by saving the lines collection to userdefaults
    @IBAction func saveCanvas(_ sender: Any) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(lineCanvas.lines), forKey:"lines")
        let alert = UIAlertController(title: "Canvas Saved", message: nil, preferredStyle:.alert)
        let okaction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okaction)
        self.present(alert,animated: true,completion: nil)
    }
    //button clicked to choose color
    @IBAction func buttonClicked(_ sender: button) {
        for btn in colorStack.subviews{
            let button = btn as! button
            button.borderColor = UIColor.white
        }
        sender.borderColor = UIColor.black
        currentColor = UIColor(cgColor: sender.layer.backgroundColor!)
        colorDisplay.backgroundColor = currentColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        lineCanvas = LineView(frame: view.frame)
        view.addSubview(lineCanvas)
        view.bringSubview(toFront: colorStack)
        view.bringSubview(toFront: secondView)
        secondView.alpha = 0.0
        colorDisplay.backgroundColor = currentColor
        RGBdisplay.backgroundColor = currentColor
        //load data from userdefaults
        if let data = UserDefaults.standard.value(forKey:"lines") as? Data {
            lineCanvas.lines = try! PropertyListDecoder().decode(Array<Line>.self, from: data)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // clear the canvas
    @IBAction func clear(_ sender: Any) {
        lineCanvas.theLine = nil
        lineCanvas.lines = []
    }
    // undo last draw
    @IBAction func undo(_ sender: Any) {
        lineCanvas.theLine = nil
        if (!lineCanvas.lines.isEmpty){
            lineCanvas.lines.removeLast()
            lineCanvas.setNeedsDisplay()
        }
    }
    // when RGB slide moved, update currentcolor
    @IBAction func slideMoved(_ sender: Any) {
        currentColor = UIColor.init(red: CGFloat(slideRed.value), green: CGFloat(slideGreen.value), blue: CGFloat(slideBlue.value), alpha: 1)
        colorDisplay.backgroundColor = currentColor
        RGBdisplay.backgroundColor = currentColor
        
    }
    // RGB button to make RGB subview visible and set current color to RGB color
    @IBAction func RGB(_ sender: Any) {
        for btn in colorStack.subviews{
            let button = btn as! button
            button.borderColor = UIColor.white
        }
        if(secondView.alpha.isEqual(to: 1.0)){
            secondView.alpha = 0.0
            RGBbtn.setImage(#imageLiteral(resourceName: "up"), for: .normal)
        }
        else if(secondView.alpha.isEqual(to: 0.0)){
            secondView.alpha = 1.0
            RGBbtn.setImage(#imageLiteral(resourceName: "down"), for: .normal)
        }
        currentColor = UIColor.init(red: CGFloat(slideRed.value), green: CGFloat(slideGreen.value), blue: CGFloat(slideBlue.value), alpha: 1)
        colorDisplay.backgroundColor = currentColor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchPoint = touches.first?.location(in: view) else { return }
        // when touches began, initalize currentLine and append first touchpoint to points[]
        currentLine = Line(points: [], thickness: CGFloat(slide.value)*100+1, color: currentColor, startpoint: touchPoint, endpoint: touchPoint )
        currentLine?.points.append(touchPoint)
        // if currentColor is white which represemts eraser, initialize eraser and display the range of eraser
        if (currentColor == UIColor.white){
            eraser = Eraser(center: touchPoint, radius: (CGFloat(slide.value)*100+1)/2)
        }
        
        lineCanvas.theLine=currentLine
        lineCanvas.Eraser = eraser
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchPoint = touches.first?.location(in: view) else { return }
        currentLine?.endpoint = touchPoint
        // when touches moved, append touchpoint to currentline's points[]
        currentLine?.points.append(touchPoint)
        // update eraser's center point
        if (currentColor == UIColor.white){
            eraser?.center = touchPoint
        }
        lineCanvas.theLine=currentLine
        lineCanvas.Eraser = eraser
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchPoint = touches.first?.location(in: view) else { return }
        currentLine?.endpoint = touchPoint
        currentLine?.points.append(touchPoint)
        // when touched ended, add the currentLine to canvas lines[]
        if let newLine = currentLine {
            lineCanvas.lines.append(newLine)
        }
        // set eraser to nil
        if (currentColor == UIColor.white){
            eraser = nil
            lineCanvas.Eraser = nil
        }
    }
}


