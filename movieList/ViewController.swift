//
//  ViewController.swift
//  movieList
//
//  Created by Wang Jing on 26/6/22.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UICollectionViewDataSource,  UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var movieListCV: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movieList: [Movie] = []
    var searchKeyWord: String = ""
    var totalPages = 0
    var loadedPages: Int = 0
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieListCV.delegate = self
        movieListCV.dataSource = self
    }
    
    @IBAction func searchMovie(_ sender: Any) {
        guard let keyword = searchBar.text, keyword != "" else {
            showDialog(title: "Warning", message: "Please enter keyword")
            return
        }
        searchKeyWord = keyword.replacingOccurrences(of: " ", with: "%20")
        searchMovie(name: searchKeyWord)
    }
    
    func searchMovie(name: String, page: Int = 1) {
        isLoading = true
        let searchUrl = "https://www.omdbapi.com/?apikey=b9bd48a6&s=\(name)&page=\(page)&type=movie"
        AF.request(searchUrl).responseDecodable(of: MovieData.self) { response in
            self.isLoading = false
            switch response.result {
            case .success:
                if let value = response.value {
                    self.processData(data: value)
                    self.loadedPages += 1
                    self.totalPages = Int(value.totalResults) ?? 0
                }
            case let .failure(error):
                print(error)
                self.showDialog(title: "Error", message: "No Results")
            }
        }
    }
    
    func processData(data: MovieData) {
        for movie in data.Search {
            movieList.append(movie)
        }
        DispatchQueue.main.async(execute: movieListCV.reloadData)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == movieList.count - 1 && !isLoading && loadedPages <= totalPages {
            searchMovie(name: searchKeyWord, page: loadedPages+1 )
        }
        
        let cell = movieListCV.dequeueReusableCell(withReuseIdentifier: "movieCVCell", for: indexPath) as! MovieCollectionViewCell
        
        let movie = movieList[indexPath.row]
        cell.showContent(image: movie.poster, title: movie.title)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (UIScreen.main.bounds.width - 24 * 2) / 2
        let height = width * 5 / 3
        
        return CGSize(width: width, height: height)
    }
    
    func showDialog(title: String, message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            
         })
        
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
}

