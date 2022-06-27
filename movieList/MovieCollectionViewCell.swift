//
//  MovieCollectionViewCell.swift
//  movieList
//
//  Created by Wang Jing on 27/6/22.
//

import UIKit
import SDWebImage

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    
    func showContent(image: String, title: String) {
        moviePoster.sd_setImage(with: URL(string:image))
        movieTitle.text = title
        movieTitle.numberOfLines = 0
    }
}
