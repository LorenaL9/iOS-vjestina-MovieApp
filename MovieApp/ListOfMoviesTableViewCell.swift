//
//  ListOfMoviesTableViewCell.swift
//  MovieApp
//
//  Created by Lorena Lazar on 4/10/22.
//

import Foundation
import UIKit
import SnapKit
import MovieAppData

class ListOfMoviesTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: ListOfMoviesTableViewCell.self)

    private var groupLabel: UILabel!
    private var filter: UICollectionView!
    private var movieCollection: UICollectionView!
    private var movieFilterTitleData: MovieFilterTitleModel!
    
    private var filterLayout: UICollectionViewFlowLayout!
    private var movieCollectionLayout: UICollectionViewFlowLayout!

    var movies = Movies.all()
    
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
    
    func set(data: MovieFilterTitleModel) {
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
            return CGSize(width: 150, height: 200)
        } else {
            let text = "\(movieFilterTitleData.filters[indexPath.item].filters.title)"
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
            return movieFilterTitleData.movies.count
        } else {
            return movieFilterTitleData.filters.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.filter {
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCell.reuseIdentifier, for: indexPath) as? FilterCell
            else {
                fatalError()
            }
            let filters = movieFilterTitleData.filters[indexPath.row]
            cell.setFilter(filters: filters)
            return cell
        }
        
        else {
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionCell.reuseIdentifier, for: indexPath) as? MovieCollectionCell
            else {
                fatalError()
            }
            let movies = movieFilterTitleData.movies[indexPath.row]
            cell.setMovie(movies: movies)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.filter {
            let filters : [FilterCellModel] = movieFilterTitleData.filters.enumerated().map { (index, filter) in
                return FilterCellModel(filters: filter.filters, underline: index == indexPath.row)
            }
            movieFilterTitleData.filters = filters
            collectionView.reloadData()
        }
    }
}
