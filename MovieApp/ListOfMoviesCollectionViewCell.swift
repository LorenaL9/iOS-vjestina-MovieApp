//
//  ListOfMoviesCollectionView.swift
//  MovieApp
//
//  Created by Lorena Lazar on 4/9/22.
//

import Foundation
import UIKit
import SnapKit
import MovieAppData

class ListOfMoviesCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: ListOfMoviesCollectionViewCell.self)

    private var movieTitle: UILabel!
    private var movieImage: UIImageView!
    private var movieDescription: UILabel!
    
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
        
        movieImage = UIImageView()
        addSubview(movieImage)
        
        movieTitle = UILabel()
        addSubview(movieTitle)
    
        movieDescription = UILabel()
        addSubview(movieDescription)
    }
    func set(index: Int) {
        let movies = Movies.all()
        let title = movies
            .map { $0.title }
        let description = movies
            .map { $0.description}
        let imageUrl = movies
            .map { $0.imageUrl}
        
        movieTitle.text = "\(title[index])"
        movieDescription.text = "\(description[index])"
        movieImage.load(urlString: imageUrl[index])
    }
    
    
    private func styleViews(){
        layer.cornerRadius = 10
        layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        layer.masksToBounds = false
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.7
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 5, height: 5)
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 10)
        layer.shadowPath = shadowPath.cgPath
        
        movieImage.contentMode = .scaleAspectFill
        movieImage.clipsToBounds = true
        
        movieTitle.font = .systemFont(ofSize: 16, weight: .bold)
        movieDescription.textColor = .gray
        movieDescription.numberOfLines = 5
    }

    func addConstraints() {
        movieImage.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview().inset(0)
            $0.width.equalTo(120)
        }
        movieTitle.snp.makeConstraints{
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalTo(movieImage.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(10)
        }
        movieDescription.snp.makeConstraints{
            $0.top.equalTo(movieTitle.snp.bottom).offset(10)
            $0.leading.equalTo(movieImage.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(10)
        }
    }
}

extension UIImageView {
    func load(urlString: String) {
        let url = URL(string: urlString)
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
