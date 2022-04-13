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
    var movies = Movies.all()
    
    let group = ["What's popular", "Free to Watch", "What's trending", "Top Rated", "Upcoming"]

    static let reuseIdentifier = String(describing: ListOfMoviesTableViewCell.self)

    private var groupLabel: UILabel!
    private var filter: UICollectionView!
    private var movieCollection: UICollectionView!


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        buildViews()
        addContraints()
        styleViews()
        configureCollectionView()

    }
    
    override func addSubview(_ view: UIView) {
        super.addSubview(view)
        sendSubviewToBack(contentView)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func set(labelIndex: Int) {
        
//        let imageUrl = movies.map { $0.imageUrl}
        groupLabel.text = "\(group[labelIndex])"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func buildViews() {
        
        groupLabel = UILabel()
        addSubview(groupLabel)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
    
        movieCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        addSubview(movieCollection)
        
        let layout1 = UICollectionViewFlowLayout()
        layout1.minimumLineSpacing = 5
        layout1.scrollDirection = .horizontal
        
        filter = UICollectionView(frame: .zero, collectionViewLayout: layout1)
        addSubview(filter)
    }
    func styleViews(){
        groupLabel.font = .systemFont(ofSize: 20, weight: .bold)

    }

    func addContraints() {
        groupLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.top.equalToSuperview().inset(10)
        }
        movieCollection.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(8)
            $0.trailing.equalToSuperview().inset(0)
            $0.top.equalTo(groupLabel.snp.bottom).offset(30)
            $0.bottom.equalToSuperview()
        }
        filter.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(8)
            $0.trailing.equalToSuperview().inset(0)
            $0.top.equalTo(groupLabel.snp.bottom).offset(5)
            $0.height.equalTo(45)
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
            return CGSize(width: 70, height: 40)
        }
    }
}


extension ListOfMoviesTableViewCell: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == self.filter {
            return 1
        } else {
            return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.movieCollection {
            if groupLabel.text == "What's popular" {
                return movies.filter { $0.group.contains(MovieGroup.popular) }.count
            } else if groupLabel.text == "Free to Watch" {
                return movies.filter { $0.group.contains(MovieGroup.freeToWatch) }.count
            } else if groupLabel.text == "What's trending" {
                return movies.filter { $0.group.contains(MovieGroup.trending) }.count
            } else if groupLabel.text == "Top Rated" {
                return movies.filter { $0.group.contains(MovieGroup.topRated) }.count
            } else if groupLabel.text == "Upcoming" {
                return movies.filter { $0.group.contains(MovieGroup.upcoming) }.count
            }
            return 0
        } else {
            if groupLabel.text == "What's popular" {
                return MovieGroup.popular.filters.count
            } else if groupLabel.text == "Free to Watch" {
                return MovieGroup.freeToWatch.filters.count
            } else if groupLabel.text == "What's trending" {
                return MovieGroup.trending.filters.count
            } else if groupLabel.text == "Top Rated" {
                return MovieGroup.topRated.filters.count
            } else if groupLabel.text == "Upcoming" {
                return MovieGroup.upcoming.filters.count
            }
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.filter {
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCell.reuseIdentifier, for: indexPath) as? FilterCell
            else {
                fatalError()
            }
            if groupLabel.text == "What's popular" {
                cell.setFilter(index: indexPath.row, group: MovieGroup.popular)
            } else if groupLabel.text == "Free to Watch" {
                cell.setFilter(index: indexPath.row, group: MovieGroup.freeToWatch)
            } else if groupLabel.text == "What's trending" {
                cell.setFilter(index: indexPath.row, group: MovieGroup.trending)
            } else if groupLabel.text == "Top Rated" {
                cell.setFilter(index: indexPath.row, group: MovieGroup.topRated)
            } else {
                cell.setFilter(index: indexPath.row, group: MovieGroup.upcoming)
            }
            return cell
        }
        
        else {
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionCell.reuseIdentifier, for: indexPath) as? MovieCollectionCell
            else {
                fatalError()
            }
            if groupLabel.text == "What's popular" {
                cell.setMovie(index: indexPath.row, caseMovie: MovieGroup.popular)
            } else if groupLabel.text == "Free to Watch" {
                cell.setMovie(index: indexPath.row, caseMovie: MovieGroup.freeToWatch)
            } else if groupLabel.text == "What's trending" {
                cell.setMovie(index: indexPath.row, caseMovie: MovieGroup.trending)
            } else if groupLabel.text == "Top Rated" {
                cell.setMovie(index: indexPath.row, caseMovie: MovieGroup.topRated)
            } else {
                cell.setMovie(index: indexPath.row, caseMovie: MovieGroup.upcoming)
            }
            return cell

        }
    }
}
