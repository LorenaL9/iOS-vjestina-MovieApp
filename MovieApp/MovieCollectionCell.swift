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

    func buildViews() {
        layer.cornerRadius = 10
        layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        layer.masksToBounds = true
    
        movieImage = UIImageView()
        movieImage.clipsToBounds = true
        addSubview(movieImage)
        
        let favoriteImageUIImage = UIImage(named: "favorite.png")
        favoriteImage = UIImageView()
        addSubview(favoriteImage)
        favoriteImage.image = favoriteImageUIImage
    }
    
    func setMovie(index: Int, caseMovie: MovieGroup) {
        let movies = Movies.all()
        
        let imageUrl = movies.filter { $0.group.contains(caseMovie) }
            .map { $0.imageUrl}
        movieImage.load(urlString: imageUrl[index])
    }

    private func styleViews(){
        movieImage.contentMode = .scaleAspectFill
    }

    func addConstraints() {
        movieImage.snp.makeConstraints{
            $0.top.bottom.equalToSuperview().inset(0)
            $0.leading.trailing.equalToSuperview().inset(0)
        }
        
        favoriteImage.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(8)
        }
    }
}
