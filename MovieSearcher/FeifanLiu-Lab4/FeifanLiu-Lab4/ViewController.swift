//
//  ViewController.swift
//  FeifanLiu-Lab4
//
//  Created by labuser on 10/15/18.
//  Copyright © 2018 wustl. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UISearchBarDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    var movies:[Movie] = []
    var theData:APIResults?
    var theImage:[UIImage] = []
    var fetchingMore = false
    var pages = 1
    var urlString:String?
    var string:String?
    var search:String?
    var lastUrl = URL(string: "")
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchBar()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.layer.backgroundColor = UIColor(white: 0.0, alpha: 0.8).cgColor
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50);
        activityIndicator.center = self.view.center
        activityIndicator.color = UIColor.white
        view.addSubview(activityIndicator)
        view.bringSubview(toFront: activityIndicator)
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
        string = UserDefaults.standard.string(forKey: "url")
        if search != nil{
            searchMovie(newSearch: false)
        }
        if string != nil{
            urlString = string
        }
        else{
            urlString = nil
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private func setUpSearchBar(){
        searchBar.delegate = self
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        search = nil
        searchMovie(newSearch: true)
    }
    func searchMovie(newSearch: Bool){
        if newSearch{
            self.movies = []
            self.pages = 1
            self.theImage = []
        }
        var url:URL!
        if var urlString = search{
            urlString.append("&page=\(pages)")
            print(urlString)
            url = URL(string: urlString)
        }
        else if searchBar.text != ""{
            if urlString != nil{
                urlString = string
                let searchBarText = self.searchBar.text!.replacingOccurrences(of: " ",with: "%20")
                urlString?.append("&page=\(pages)&query=\(searchBarText)")
                url = URL(string: urlString!)
            }
            else{
                let searchBarText = self.searchBar.text!.replacingOccurrences(of: " ",with: "%20")
                url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=cb1a830ef99603b8b3785bc8d2c141ce&page=\(pages)&query=\(searchBarText)")
                }
        }
        else if searchBar.text == ""{
            return
        }
        if url == lastUrl{
            return
        }
            self.activityIndicator.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async {
                let data = try! Data(contentsOf: url!)
                self.theData = try! JSONDecoder().decode(APIResults.self, from: data)
                if !self.fetchingMore{
                    self.movies = []
                    self.theImage = []
                    self.pages = 1
                }
                for movie in self.theData!.results{
                    self.movies.append(movie)
                }
                self.getImage()
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.lastUrl = url
                    self.collectionView.reloadData()
                }
            if self.fetchingMore{
                self.fetchingMore = false
            }
        }
    }
    func getImage(){
        if theData!.total_results > 0{
            for movie in theData!.results{
                if let path = movie.poster_path{
                    let urlString = "https://image.tmdb.org/t/p/w500\(path)"
                    let url = URL(string: urlString)
                    let data = try? Data(contentsOf: url!)
                    let image = UIImage(data: data!)
                    theImage.append(image!)
                }
                else{
                    theImage.append(#imageLiteral(resourceName: "images"))
                }
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! AdvancedSearchViewController
        destination.VC = self
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return movies.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseIdentifier",
                                                      for: indexPath) as! CollectionView
        
        cell.image.image = theImage[indexPath.row]
        cell.label.text = movies[indexPath.row].title
        cell.titleView.superview?.bringSubview(toFront: cell.titleView)
        // Configure the cell
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        return CGSize(width: width/3.5, height: width/2.5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5.0, left: 10.0, bottom: 5.0, right: 10.0)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailedVC = DetailedViewController()
        detailedVC.image = theImage[indexPath.row]
        detailedVC.movieAPI = movies[indexPath.row]
        navigationController?.pushViewController(detailedVC, animated: true)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.height{
            if !fetchingMore{
                beginFetch()
            }
        }
    }
    func beginFetch(){
        fetchingMore = true
        pages += 1
            if pages <= theData!.total_pages{
                searchMovie(newSearch: false)
        }
            else{
                fetchingMore = false
                pages -= 1
        }
    }
}


