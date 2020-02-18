//
//  DetailedViewController.swift
//  FeifanLiu-Lab4
//
//  Created by labuser on 10/16/18.
//  Copyright © 2018 wustl. All rights reserved.
//

import UIKit
import WebKit
class DetailedViewController: UIViewController {
    var movieAPI: Movie!
    var image:UIImage!
    var favorites:[Movie] = []
    var button:UIButton!
    var playButton:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = UserDefaults.standard.value(forKey:"favorites") as? Data {
            favorites = try! PropertyListDecoder().decode(Array<Movie>.self, from: data)
        }
        view.backgroundColor = UIColor.white
        navigationItem.title = movieAPI.title
        let backgroundFrame = CGRect(x: 0, y: self.navigationController!.navigationBar.bounds.midY + self.navigationController!.navigationBar.frame.height, width: view.bounds.width, height: view.bounds.height/3)
        let backgroudView = UIView(frame: backgroundFrame)
        let imageFrame = CGRect(x: backgroudView.bounds.width/4, y: 0, width: backgroudView.bounds.width/2, height: backgroudView.bounds.height)
        let imageView = UIImageView(frame: imageFrame)
        backgroudView.backgroundColor = UIColor.black
        imageView.image = image
        view.addSubview(backgroudView)
        backgroudView.addSubview(imageView)
        let overviewFrame = CGRect(x: 10, y: backgroundFrame.maxY + 10, width: view.bounds.width-20, height: 150)
        let overView = UITextView(frame: overviewFrame)
        overView.text = "  Overview: " + movieAPI.overview
        
        overView.textAlignment = .left
        overView.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(overView)
        let textFrame = CGRect(x: 0, y: overviewFrame.maxY + 10, width: view.bounds.width, height: 70)
        let textLabel = UILabel(frame: textFrame)
        textLabel.text = "Released Date: \(movieAPI.release_date)\n\nScore: \(movieAPI.vote_average)"
        textLabel.textAlignment = .center
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.numberOfLines = 3
        view.addSubview(textLabel)
        button = UIButton(frame: CGRect(x: 0, y: textFrame.maxY + 10, width: 200, height: 30))
        button.center.x = view.center.x
        button.backgroundColor = UIColor.blue
        button.setTitle("Add to Favorites", for: .normal)
        button.addTarget(self, action: #selector(addToFavorites), for: .touchUpInside)
        playButton = UIButton(frame: CGRect(x: 0, y: button.frame.maxY + 10, width: 100, height: 30))
        playButton.center.x = view.center.x
        playButton.backgroundColor = UIColor.blue
        playButton.setTitle("Preview", for: .normal)
        playButton.addTarget(self, action: #selector(playVideos), for: .touchUpInside)
        for movie in favorites{
            if movie.id == movieAPI.id{
                button.isEnabled = false
                button.backgroundColor = UIColor.white
                button.setTitle("Already in Favorites", for: .normal)
                button.setTitleColor(UIColor.gray, for: .normal)
            }
        }
        view.addSubview(playButton)
        view.addSubview(button)
        view.bringSubview(toFront: button)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if let data = UserDefaults.standard.value(forKey:"favorites") as? Data {
            favorites = try! PropertyListDecoder().decode(Array<Movie>.self, from: data)
        }
        var added = false
        for movie in favorites{
            if movie.id == movieAPI.id{
                added = true
            }
        }
            if added{
                button.isEnabled = false
                button.backgroundColor = UIColor.white
                button.setTitle("Already in Favorites", for: .normal)
                button.setTitleColor(UIColor.gray, for: .normal)
            }
            else{
                button.isEnabled = true
                button.backgroundColor = UIColor.blue
                button.setTitle("Add to Favorites", for: .normal)
                button.setTitleColor(UIColor.white, for: .normal)
            }
    }
    @objc func playVideos(sender: UIButton!){
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieAPI.id!)/videos?api_key=cb1a830ef99603b8b3785bc8d2c141ce")

        DispatchQueue.global(qos: .userInitiated).async {
            let data = try! Data(contentsOf: url!)
            let videoData = try! JSONDecoder().decode(VideoAPI.self, from: data)
            if videoData.results.isEmpty||videoData.results[0].site != "YouTube" {
                DispatchQueue.main.async {
                    let VideoVC = VideoViewController()
                    VideoVC.text = "Sorry, there is no video for this movie."
                    VideoVC.urlRequest = nil
                    self.navigationController?.pushViewController(VideoVC, animated: true)
                }
            }
            else{
                let video = videoData.results[0]
                var videoUrl:URL?
                if let key = video.key{
                    videoUrl = URL(string: "https://www.youtube.com/embed/\(key)")
                }
                let urlRequest = URLRequest(url: videoUrl!)
                DispatchQueue.main.async {
                    let VideoVC = VideoViewController()
                    VideoVC.urlRequest = urlRequest
                    VideoVC.text = "Sorry, there is no video for this movie."
                    self.navigationController?.pushViewController(VideoVC, animated: true)
                }
            }
        }
    }
    @objc func addToFavorites(sender: UIButton!){
        var favorites:[Movie] = []
        if let data = UserDefaults.standard.value(forKey:"favorites") as? Data {
            favorites = try! PropertyListDecoder().decode(Array<Movie>.self, from: data)
        }
        favorites.append(movieAPI)
        UserDefaults.standard.set(try? PropertyListEncoder().encode(favorites), forKey: "favorites")
        button.isEnabled = false
        button.backgroundColor = UIColor.white
        button.setTitle("Already in Favorites", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
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
