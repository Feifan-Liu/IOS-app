//
//  ViewController.swift
//  feifanliuLab2
//
//  Created by labuser on 9/23/18.
//  Copyright © 2018 MRounds. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var Backgroundcolor: UIView!
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var Fview: DisplayView!
    @IBOutlet weak var Hview: DisplayView!
    @IBOutlet weak var Foodlevel: UILabel!
    @IBOutlet weak var Happiness: UILabel!
    //use collection to store pet status
    private var Petcollection:[pet]=[pet(type: .dog),pet(type: .cat),pet(type: .bird),pet(type: .bunny),pet(type: .fish)]
    var Pettype:pet!{
        didSet{
            updateDisplay()
        }
    }
    var timer = Timer()
    //button clicked for all 5 pets
    @IBAction func dog(_ sender: Any) {
        Pettype = Petcollection[0]
        Image.image = #imageLiteral(resourceName: "dog")
        Backgroundcolor.backgroundColor = UIColor.blue
    }
    @IBAction func cat(_ sender: Any) {
        Pettype = Petcollection[1]
        Image.image = #imageLiteral(resourceName: "cat")
        Backgroundcolor.backgroundColor = UIColor.red
    }
    @IBAction func bird(_ sender: Any) {
        Pettype = Petcollection[2]
        Image.image = #imageLiteral(resourceName: "bird")
        Backgroundcolor.backgroundColor = UIColor.yellow
    }
    @IBAction func bunny(_ sender: Any) {
        Pettype = Petcollection[3]
        Image.image = #imageLiteral(resourceName: "bunny")
        Backgroundcolor.backgroundColor = UIColor.cyan
    }
    @IBAction func fish(_ sender: Any) {
        Pettype = Petcollection[4]
        Image.image = #imageLiteral(resourceName: "fish")
        Backgroundcolor.backgroundColor = UIColor.purple
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Pettype = Petcollection[0]
        Image.image = #imageLiteral(resourceName: "dog")
        Backgroundcolor.backgroundColor = UIColor.blue
        self.timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(timeFlow), userInfo: nil, repeats: true)
    }
    //timer function
    @objc func timeFlow(){
        var Petnamecollection:[String]=[]
        var Petname:String
        for pet in Petcollection{
            switch pet.pettype{
                case .dog:Petname = "dog"
                case .cat:Petname = "cat"
                case .bird:Petname = "bird"
                case .bunny:Petname = "bunny"
                case .fish:Petname = "fish"
            }
            if(pet.foodlevel == 0){
                Petnamecollection.append(Petname)
                if(pet.happiness>0){
                    pet.happiness -= 1
                }
            }
            else{
                pet.foodlevel -= 1
            }
        }
        var message:String=""
        for name in Petnamecollection
        {
            message.append("\(name),")
        }
        if(!message.isEmpty){
            message.remove(at: message.index(before:message.endIndex))
            let alert = UIAlertController(title: "Warning!", message: "Your \(message) is hungry.", preferredStyle:.alert)
            let okaction = UIAlertAction(title: "got it", style: .default, handler: nil)
            alert.addAction(okaction)
            self.present(alert,animated: true,completion: nil)
        }
        updateDisplay()
    }
    //button play clicked
    @IBAction func play(_ sender: Any) {
        Pettype.play()
        updateDisplay()
    }
    //button feed clicked
    @IBAction func feed(_ sender: Any) {
        Pettype.feed()
        updateDisplay()
    }
    //update displayviews and labels
    func updateDisplay(){
        let Happinessviewvalue = Double(Pettype.happiness)/10
        let Foodlevelviewvalue = Double(Pettype.foodlevel)/10
        Hview.animateValue(to: CGFloat(Happinessviewvalue))
        Fview.animateValue(to: CGFloat(Foodlevelviewvalue))
        Happiness.text = String("Played:\(Pettype.timeplayed)")
        Foodlevel.text = String("Fed:\(Pettype.timefed)")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

