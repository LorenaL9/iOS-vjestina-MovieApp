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

protocol ReloadFavoritesDelegate: AnyObject {
    func reload()
}

class MovieCollectionCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: MovieCollectionCell.self)

    private var movieImage: UIImageView!
    private var favoriteImage: UIImageView!
    private var movie: MyResult!
    
    weak var delegateFavorites: ReloadFavoritesDelegate?
    
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
        
        favoriteImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.addToFaavorites)))
        favoriteImage.isUserInteractionEnabled = true
    }

    private func styleViews(){
        layer.cornerRadius = 10
        layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        layer.masksToBounds = true
        
        movieImage.contentMode = .scaleAspectFill
        movieImage.clipsToBounds = true
    }

    private func addConstraints() {
        movieImage.snp.makeConstraints{
            $0.top.bottom.equalToSuperview().inset(0)
            $0.leading.trailing.equalToSuperview().inset(0)
        }
        
        favoriteImage.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(8)
            $0.width.height.equalTo(32)
        }
    }
    
    func setMovie(movies: MyResult) {
        movieImage.image = movies.image
        movie = movies
        if movies.favorite {
            let favoriteImageUIImageFull = UIImage(named: "favoriteFull.png")
            favoriteImage.image = favoriteImageUIImageFull
        } else {
            let favoriteImageUIImage = UIImage(named: "favorite.png")
            favoriteImage.image = favoriteImageUIImage
        }
    }
    
    @objc func addToFaavorites() {
        if movie.favorite {
            MoviesRepository(networkService: NetworkService()).removeFromFavorites(movieId: movie.id)
            print(movie.title)
            UIView.transition(with: favoriteImage,
                              duration: 1,
                              options: .transitionCrossDissolve,
                              animations: { self.favoriteImage.image = UIImage(named: "favorite.png")},
                              completion: { _ in
                            self.delegateFavorites?.reload()
            })
        } else {
            MoviesRepository(networkService: NetworkService()).addToFavorites(movieId: movie.id)
            print(movie.title)
            UIView.transition(with: favoriteImage,
                              duration: 0.2,
                              options: .transitionCrossDissolve,
                              animations: { self.favoriteImage.image = UIImage(named: "favoriteFill.png")},
                              completion: { _ in
                            self.delegateFavorites?.reload()
            })
        }
    }
}
