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
    
    private var layout: UICollectionViewFlowLayout!
    private var layout1: UICollectionViewFlowLayout!

    var movies = Movies.all()
    
    let group = ["What's popular", "Free to Watch", "What's trending", "Top Rated", "Upcoming"]

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
    
    func set(labelIndex: Int) {
        groupLabel.text = "\(group[labelIndex])"
    }

    func buildViews() {
        groupLabel = UILabel()
        addSubview(groupLabel)
        
        layout = UICollectionViewFlowLayout()
    
        movieCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        addSubview(movieCollection)
        
        layout1 = UICollectionViewFlowLayout()
        
        filter = UICollectionView(frame: .zero, collectionViewLayout: layout1)
        addSubview(filter)
    }
    
    func styleViews(){
        groupLabel.font = .systemFont(ofSize: 24, weight: .bold)
        
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        
        layout1.minimumLineSpacing = 5
        layout1.scrollDirection = .horizontal
    }

    func addContraints() {
        groupLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
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
            let label = UILabel(frame: CGRect.zero)
            if groupLabel.text == MovieGroup.popular.title {
                label.text = "\(MovieGroup.popular.filters[indexPath.item].title)"
            } else if groupLabel.text == MovieGroup.freeToWatch.title {
                label.text = "\(MovieGroup.freeToWatch.filters[indexPath.item].title)"
            } else if groupLabel.text == MovieGroup.trending.title {
                label.text = "\(MovieGroup.trending.filters[indexPath.item].title)"
            } else if groupLabel.text == MovieGroup.topRated.title {
                label.text = "\(MovieGroup.topRated.filters[indexPath.item].title)"
            } else if groupLabel.text == MovieGroup.upcoming.title {
                label.text = "\(MovieGroup.upcoming.filters[indexPath.item].title)"
            }
            label.sizeToFit()
            return CGSize(width: label.frame.width + 18, height: 30)
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
            if groupLabel.text == MovieGroup.popular.title {
                return movies.filter { $0.group.contains(MovieGroup.popular) }.count
            } else if groupLabel.text == MovieGroup.freeToWatch.title {
                return movies.filter { $0.group.contains(MovieGroup.freeToWatch) }.count
            } else if groupLabel.text == MovieGroup.trending.title {
                return movies.filter { $0.group.contains(MovieGroup.trending) }.count
            } else if groupLabel.text == MovieGroup.topRated.title {
                return movies.filter { $0.group.contains(MovieGroup.topRated) }.count
            } else if groupLabel.text == MovieGroup.upcoming.title {
                return movies.filter { $0.group.contains(MovieGroup.upcoming) }.count
            }
            return 0
        } else {
            if groupLabel.text == MovieGroup.popular.title {
                return MovieGroup.popular.filters.count
            } else if groupLabel.text == MovieGroup.freeToWatch.title {
                return MovieGroup.freeToWatch.filters.count
            } else if groupLabel.text == MovieGroup.trending.title {
                return MovieGroup.trending.filters.count
            } else if groupLabel.text == MovieGroup.topRated.title {
                return MovieGroup.topRated.filters.count
            } else if groupLabel.text == MovieGroup.upcoming.title {
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
            if groupLabel.text == MovieGroup.popular.title {
                cell.setFilter(index: indexPath.row, group: MovieGroup.popular)
            } else if groupLabel.text == MovieGroup.freeToWatch.title {
                cell.setFilter(index: indexPath.row, group: MovieGroup.freeToWatch)
            } else if groupLabel.text == MovieGroup.trending.title {
                cell.setFilter(index: indexPath.row, group: MovieGroup.trending)
            } else if groupLabel.text == MovieGroup.topRated.title {
                cell.setFilter(index: indexPath.row, group: MovieGroup.topRated)
            } else {
                cell.setFilter(index: indexPath.row, group: MovieGroup.upcoming)
            }
            cell.delegate = self
            return cell
        }
        
        else {
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionCell.reuseIdentifier, for: indexPath) as? MovieCollectionCell
            else {
                fatalError()
            }
            if groupLabel.text == MovieGroup.popular.title {
                cell.setMovie(index: indexPath.row, caseMovie: MovieGroup.popular)
            } else if groupLabel.text == MovieGroup.freeToWatch.title {
                cell.setMovie(index: indexPath.row, caseMovie: MovieGroup.freeToWatch)
            } else if groupLabel.text == MovieGroup.trending.title {
                cell.setMovie(index: indexPath.row, caseMovie: MovieGroup.trending)
            } else if groupLabel.text == MovieGroup.topRated.title {
                cell.setMovie(index: indexPath.row, caseMovie: MovieGroup.topRated)
            } else {
                cell.setMovie(index: indexPath.row, caseMovie: MovieGroup.upcoming)
            }
            return cell
        }
    }
}

extension ListOfMoviesTableViewCell: FilterCellDelegate {
    func clickedOn(cell: FilterCell) {
        for cellAll in filter.visibleCells as! [FilterCell] {
            cellAll.isSelected = false
        }
        cell.isSelected = true
    }
}
