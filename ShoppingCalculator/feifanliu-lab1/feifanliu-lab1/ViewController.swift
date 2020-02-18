//
//  ViewController.swift
//  feifanliu-lab1
//
//  Created by labuser on 9/6/18.
//  Copyright © 2018 David Kwon. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource {
    
    

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var op: UITextField!
    @IBOutlet weak var dc: UITextField!
    @IBOutlet weak var tax: UITextField!
    @IBOutlet weak var fp: UILabel!
    @IBOutlet weak var tp: UILabel!
    @IBOutlet weak var note: UITextView!
    private var data:[String] = []
    private var price:[Float] = []
    private var finalprice:Float = 0.00, totalprice:Float = 0.00
    // reset all the blank
    func reset(){
        op.text = nil
        dc.text = nil
        tax.text = nil
        name.text = nil
        displaywrong(wrong: "Please fill all the blanks with positive numbers or zero.")
    }
    // display that something is wrong
    func displaywrong(wrong:String){
        note.text = wrong
        note.alpha = 1
        finalprice = 0.00
        fp.text = "Invalid"
    }
    // calculate final price
    @IBAction func valuechanged(_ sender: Any) {
        if let originalprice = Float(op.text!),let discount = Float(dc.text!),let salestax = Float(tax.text!){
            if (originalprice < 0.00 || discount < 0.00 || salestax < 0.00){
                displaywrong(wrong: "No negative numbers.")
            }
            else if (discount >= 100){
                    displaywrong(wrong: "Discount should be less than 100%.")
                }
                else{
                    note.alpha = 0
                    finalprice = originalprice * (1 - discount / 100.00) * (1 + salestax / 100.00)
                if (finalprice >= 10000000000.00){
                    displaywrong(wrong: "Out of range.")
                }
                else{
                    fp.text=String(format:"%.2f",finalprice)
                }
                }
            }
        else {
            displaywrong(wrong: "Please fill all the blanks with positive numbers or zero.")
        }
    }
    // reset all the blank
    @IBAction func reset(_ sender: Any) {
        reset()
    }
    // add content to table
    @IBAction func addtotable(_ sender: Any) {
        if(fp.text != "Invalid"){
            data.append(name.text! + "\t$" + fp.text!)
        price.append(finalprice)
            totalprice = 0.00
            for i in price{
                totalprice += i
            }
        tableview.dataSource = self
        tableview.reloadData()
        reset()
        }
        if (totalprice >= 10000000000.00){
            tp.text = "Out of range"
        }
        else {
            tp.text = String(format:"%.2f",totalprice)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    // reuse cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "reuse") as! MyTableViewCell
        let text = data[indexPath.row]
        cell.label.text = text
        return cell
    }
    // delete table content
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            data.remove(at: indexPath.row)
            price.remove(at: indexPath.row)
            totalprice = 0.00
            for i in price{
                totalprice += i
            }
            tp.text = String(format:"%.2f",totalprice)
            tableView.reloadData()
        }
    }
}

