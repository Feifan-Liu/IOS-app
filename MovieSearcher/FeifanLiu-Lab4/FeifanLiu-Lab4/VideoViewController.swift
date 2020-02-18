//
//  VideoViewController.swift
//  FeifanLiu-Lab4
//
//  Created by labuser on 10/22/18.
//  Copyright © 2018 wustl. All rights reserved.
//

import UIKit
import WebKit
class VideoViewController: UIViewController {
    var text:String!
    var urlRequest:URLRequest!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        let webLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 50))
        if urlRequest != nil{
            webView.load(urlRequest)
            view.addSubview(webView)
            
        }
        else{
            webLabel.text = text
            webLabel.center = view.center
            webLabel.textAlignment = .center
            view.addSubview(webLabel)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
