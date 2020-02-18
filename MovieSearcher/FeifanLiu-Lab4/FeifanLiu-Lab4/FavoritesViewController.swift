//
//  FavoritesViewController.swift
//  FeifanLiu-Lab4
//
//  Created by labuser on 10/16/18.
//  Copyright © 2018 wustl. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var favorites:[Movie] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "reuseCell")
        let text = favorites[indexPath.row].title
        cell.textLabel!.text = text
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            favorites.remove(at: indexPath.row)
            UserDefaults.standard.set(try? PropertyListEncoder().encode(favorites), forKey: "favorites")
            tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(1)
        let detailedVC = DetailedViewController()
        let movie = favorites[indexPath.row]
        
        detailedVC.image = getImage(movie: movie)
        detailedVC.movieAPI = favorites[indexPath.row]
        navigationController?.pushViewController(detailedVC, animated: true)
    }
    func getImage(movie:Movie) -> UIImage{
        var theImage:UIImage?
                if let path = movie.poster_path{
                    let urlString = "https://image.tmdb.org/t/p/w500\(path)"
                    let url = URL(string: urlString)
                    let data = try? Data(contentsOf: url!)
                    theImage = UIImage(data: data!)
                }
                else{
                    theImage = #imageLiteral(resourceName: "images")
                }
        return theImage!
            }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = UserDefaults.standard.value(forKey:"favorites") as? Data {
            favorites = try! PropertyListDecoder().decode(Array<Movie>.self, from: data)
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        if let data = UserDefaults.standard.value(forKey:"favorites") as? Data {
            favorites = try! PropertyListDecoder().decode(Array<Movie>.self, from: data)
        }
        tableView.reloadData()
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
