//
//  AdvancedSearchViewController.swift
//  FeifanLiu-Lab4
//
//  Created by labuser on 10/22/18.
//  Copyright © 2018 wustl. All rights reserved.
//

import UIKit

class AdvancedSearchViewController: UIViewController {

    
    @IBOutlet weak var Region: UITextField!
    @IBOutlet weak var Language: UITextField!
    @IBOutlet weak var Year: UITextField!
    @IBOutlet weak var IncludeAdult: UISwitch!
    @IBOutlet weak var AdvancedSwitch: UISwitch!
    var VC:ViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        AdvancedSwitch.isOn = UserDefaults.standard.bool(forKey: "advance")
        IncludeAdult.isOn = UserDefaults.standard.bool(forKey: "adult")
        Year.text = UserDefaults.standard.string(forKey: "year")
        Language.text = UserDefaults.standard.string(forKey: "language")
        Region.text = UserDefaults.standard.string(forKey: "region")
    }
    override func viewWillDisappear(_ animated: Bool) {
        if AdvancedSwitch.isOn{
            var urlString = "https://api.themoviedb.org/3/search/movie?api_key=cb1a830ef99603b8b3785bc8d2c141ce"
            if IncludeAdult.isOn{
                urlString.append("&include_adult=true")
            }
            else{
                urlString.append("&include_adult=false")
            }
            if Year.text != ""{
                urlString.append("&year=\(Year.text!)")
            }
            if Language.text != ""{
                urlString.append("&language=\(Language.text!)")
            }
            if Region.text != ""{
                urlString.append("&region=\(Region.text!)")
            }
            UserDefaults.standard.set(urlString, forKey: "url")
        }
        else{
            UserDefaults.standard.removeObject(forKey: "url")
        }
        UserDefaults.standard.set(AdvancedSwitch.isOn, forKey: "advance")
        UserDefaults.standard.set(IncludeAdult.isOn, forKey: "adult")
        UserDefaults.standard.set(Year.text, forKey: "year")
        UserDefaults.standard.set(Language.text, forKey: "language")
        UserDefaults.standard.set(Region.text, forKey: "region")
    }
    
    @IBAction func searchUpcoming(_ sender: Any) {
        let urlString = "https://api.themoviedb.org/3/movie/upcoming?api_key=cb1a830ef99603b8b3785bc8d2c141ce"
        setUrl(string: urlString)
    }
    @IBAction func searchRating(_ sender: Any) {
        let urlString = "https://api.themoviedb.org/3/discover/movie?api_key=cb1a830ef99603b8b3785bc8d2c141ce&sort_by=vote_average.desc"
        setUrl(string: urlString)
    }
    @IBAction func searchPopular(_ sender: Any) {
        let urlString = "https://api.themoviedb.org/3/discover/movie?api_key=cb1a830ef99603b8b3785bc8d2c141ce&sort_by=popularity.desc"
        setUrl(string: urlString)
    }
    func setUrl(string:String){
        var urlString = string
        if AdvancedSwitch.isOn{
            if IncludeAdult.isOn{
                urlString.append("&include_adult=true")
            }
            else{
                urlString.append("&include_adult=false")
            }
            if Year.text != ""{
                urlString.append("&year=\(Year.text!)")
            }
            if Language.text != ""{
                urlString.append("&language=\(Language.text!)")
            }
            if Region.text != ""{
                urlString.append("&region=\(Region.text!)")
            }
        }
        VC?.searchBar.text = nil
        VC?.search = urlString
        VC?.pages = 1
        navigationController?.popToViewController(VC!, animated: true)
    }

}
