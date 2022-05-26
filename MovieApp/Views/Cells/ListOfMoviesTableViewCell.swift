//
//  ListOfMoviesTableViewCell.swift
//  MovieApp
//
//  Created by Lorena Lazar on 4/10/22.
//

import Foundation
import UIKit
import SnapKit

protocol ChangeControllerDelegate: AnyObject {
    func changeController(bool: Bool, string: String)
}

class ListOfMoviesTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: ListOfMoviesTableViewCell.self)

    private var groupLabel: UILabel!
    private var filter: UICollectionView!
    private var movieCollection: UICollectionView!
    private var movieFilterTitleData: MovieGenresTitleModel!
    private var filterLayout: UICollectionViewFlowLayout!
    private var movieCollectionLayout: UICollectionViewFlowLayout!
    
    weak var delegateController: ChangeControllerDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildViews()
        addContraints()
        styleViews()
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addSubview(_ view: UIView) {
        super.addSubview(view)
        sendSubviewToBack(contentView)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func set(data: MovieGenresTitleModel) {
        groupLabel.text = "\(data.title)"
        movieFilterTitleData = data
    }

    func buildViews() {
        groupLabel = UILabel()
        addSubview(groupLabel)
        
        movieCollectionLayout = UICollectionViewFlowLayout()
    
        movieCollection = UICollectionView(frame: .zero, collectionViewLayout: movieCollectionLayout)
        addSubview(movieCollection)
        
        filterLayout = UICollectionViewFlowLayout()
        
        filter = UICollectionView(frame: .zero, collectionViewLayout: filterLayout)
        addSubview(filter)
    }
    
    func styleViews(){
        groupLabel.font = .systemFont(ofSize: 24, weight: .bold)
        
        movieCollectionLayout.minimumLineSpacing = 10
        movieCollectionLayout.scrollDirection = .horizontal
        
        filterLayout.minimumLineSpacing = 5
        filterLayout.scrollDirection = .horizontal
    }

    func addContraints() {
        groupLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.top.equalToSuperview().inset(10)
        }
        movieCollection.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(8)
            $0.trailing.equalToSuperview().inset(0)
            $0.top.equalTo(filter.snp.bottom).offset(0)
            $0.bottom.equalToSuperview()
        }
        filter.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(8)
            $0.trailing.equalToSuperview().inset(0)
            $0.top.equalTo(groupLabel.snp.bottom).offset(0)
            $0.height.equalTo(40)
        }
    }
    
    func configureCollectionView() {
        movieCollection.register(MovieCollectionCell.self, forCellWithReuseIdentifier: MovieCollectionCell.reuseIdentifier)
        movieCollection.dataSource = self
        movieCollection.delegate = self
        
        filter.register(FilterCell.self, forCellWithReuseIdentifier: FilterCell.reuseIdentifier)
        filter.dataSource = self
        filter.delegate = self
    }
}

extension ListOfMoviesTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if collectionView == self.movieCollection {
            return CGSize(width: 120, height: 170)
        } else {
            let text = "\(movieFilterTitleData.genres[indexPath.item].filters.name)"
            let textWidth = text.widthOfString(usingFont: UIFont.systemFont(ofSize: 18))
            return CGSize(width: textWidth + 18, height: 30)
        }
    }
}
extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}
extension ListOfMoviesTableViewCell: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.movieCollection {
            let moviesPopular = movieFilterTitleData.genres.filter{ $0.underline == true}
            return moviesPopular.first!.movies.count
        } else {
            return movieFilterTitleData.genres.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.filter {
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCell.reuseIdentifier, for: indexPath) as? FilterCell
            else {
                fatalError()
            }
            let filters = movieFilterTitleData.genres[indexPath.row]
            cell.setFilter(filters: filters)
            return cell
        }
        
        else {
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionCell.reuseIdentifier, for: indexPath) as? MovieCollectionCell
            else {
                fatalError()
            }
            let moviesCategory = movieFilterTitleData.genres.filter{ $0.underline == true}
            let movies = moviesCategory.first!.movies[indexPath.row]
            cell.setMovie(movies: movies)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.filter {
            let filters : [FilterCellModel] = movieFilterTitleData.genres.enumerated().map { (index, filter) in
                return FilterCellModel(filters: filter.filters, underline: index == indexPath.row, movies: filter.movies)
            }
            movieFilterTitleData.genres = filters
            collectionView.reloadData()
            let coll = self.movieCollection
            coll!.reloadData()
            
        } else {
            let moviesPopular = movieFilterTitleData.genres.filter{ $0.underline == true}
            let string = "https://api.themoviedb.org/3/movie/\(moviesPopular.first!.movies[indexPath.row].id)?language=en-US&page=1&api_key=0c3a28c563dda18040decdb4f03a6aa5"
            delegateController?.changeController(bool: true, string: string)
        }
    }
}
