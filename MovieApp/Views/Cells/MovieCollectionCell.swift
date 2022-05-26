//
//  MovieCollectionCell.swift
//  MovieApp
//
//  Created by Lorena Lazar on 4/10/22.
//

import Foundation
import UIKit
import SnapKit
import MovieAppData

class MovieCollectionCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: MovieCollectionCell.self)

    private var movieImage: UIImageView!
    private var favoriteImage: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildViews()
        styleViews()
        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func buildViews() {
        movieImage = UIImageView()
        addSubview(movieImage)
        
        favoriteImage = UIImageView()
        addSubview(favoriteImage)
    }

    private func styleViews(){
        layer.cornerRadius = 10
        layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        layer.masksToBounds = true
        
        movieImage.contentMode = .scaleAspectFill
        movieImage.clipsToBounds = true
        
        let favoriteImageUIImage = UIImage(named: "favorite.png")
        favoriteImage.image = favoriteImageUIImage
        
        let favoriteImageUIImageFull = UIImage(named: "favoriteFull.png")
        favoriteImage.image = favoriteImageUIImageFull
    }

    private func addConstraints() {
        movieImage.snp.makeConstraints{
            $0.top.bottom.equalToSuperview().inset(0)
            $0.leading.trailing.equalToSuperview().inset(0)
        }
        
        favoriteImage.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(8)
        }
    }
    
    func setMovie(movies: MyResult) {
        let url = "https://image.tmdb.org/t/p/original" + movies.poster_path
        movieImage.load(urlString: url)
    }
}
