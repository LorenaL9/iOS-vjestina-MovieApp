//
//  FavoritesViewController.swift
//  MovieApp
//
//  Created by Lorena Lazar on 5/3/22.
//

import Foundation
import UIKit
import SnapKit

class FavoritesViewController: UIViewController{
    private var favoritesLabel: UILabel!
    private var favoritesCollection: UICollectionView!
    private var layout: UICollectionViewFlowLayout!
    private var favorites: [MyResult] = []
    private var router: AppRouterProtocol!
    private var networkService: NetworkServiceProtocol!

    convenience init(router: AppRouterProtocol) {
            self.init()
            self.router = router
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logo = UIImage(named: "tmdb")
        let imageView = UIImageView(image: logo)
        navigationItem.titleView = imageView
        networkService = NetworkService()
        favorites = MoviesRepository(networkService: networkService).fetchFavoritesFromDatabase()
        buildViews()
    }
    
    private func buildViews(){
        view.backgroundColor = .white
        createViews()
        styleViews()
        defineLayoutForViews()
        configureCollectionView()
    }
    
    private func createViews() {
        favoritesLabel = UILabel()
        view.addSubview(favoritesLabel)
        
        layout = UICollectionViewFlowLayout()
        favoritesCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(favoritesCollection)
    }
    
    private func styleViews() {
        favoritesLabel.text = "Favorites"
        favoritesLabel.font = .systemFont(ofSize: 24, weight: .bold)
        
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 20
    }
    
    private func defineLayoutForViews() {
        favoritesLabel.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(18)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(18)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(18)
        }
        
        favoritesCollection.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(favoritesLabel.snp.bottom).offset(18)
        }
    }
    
    func configureCollectionView() {
        favoritesCollection.register(MovieCollectionCell.self, forCellWithReuseIdentifier: MovieCollectionCell.reuseIdentifier)
        favoritesCollection.dataSource = self
        favoritesCollection.delegate = self
    }
}

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let collectionViewWidth = collectionView.frame.width
        return CGSize(width: collectionViewWidth/3 - 2 * 3, height: 170)
    }
}

extension FavoritesViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favorites.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionCell.reuseIdentifier, for: indexPath) as? MovieCollectionCell
        else {
            fatalError()
        }
        let movies = favorites[indexPath.row]
        cell.setMovie(movies: movies)
        cell.backgroundColor = .systemGray
        cell.delegateFavorites = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let string = "https://api.themoviedb.org/3/movie/\(favorites[indexPath.row].id)?language=en-US&page=1&api_key=0c3a28c563dda18040decdb4f03a6aa5"
        router.showMovieDetailsViewControllerFavorites(string: string)
    }
}

extension FavoritesViewController: ReloadFavoritesDelegate {
    
    func reload() {
        print("Ukloni iz favorita")
        favorites = MoviesRepository(networkService: networkService).fetchFavoritesFromDatabase()
        self.favoritesCollection.reloadData()
    }
}
