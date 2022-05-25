//
//  MovieListViewController.swift
//  MovieApp
//
//  Created by Lorena Lazar on 4/9/22.
//

import Foundation
import UIKit
import SnapKit
import MovieAppData
import Network


class MovieListViewController: UIViewController {

    private var searchBarView: SearchBarView!
    private var filmsGrid: UITableView!
    private var filmsList: UICollectionView!
    private var layout: UICollectionViewFlowLayout!
    private var router: AppRouterProtocol!
    private var dataService: NetworkServiceProtocol!
    private var genres: [Genre] = []
    private var searchData: [TitleDescriptionImageModel] = []
    private var data: [MovieGenresTitleModel] = []
    
    convenience init(router: AppRouterProtocol) {
            self.init()
            self.router = router
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logo = UIImage(named: "tmdb")
        let imageView = UIImageView(image: logo)
        navigationItem.titleView = imageView
        getData()
        buildViews()

    }
    
    func getData() {
        let dataService = NetworkService()

//        dataService.getGenres() { [weak self] result in
//            guard let self = self else {return}
//            switch result {
//            case .success(let value):
//                self.genres = value
//            case .failure(let error):
//                print(error)
//            }
//        }
        
        genres = MoviesRepository(networkService: dataService).fetchGenre()
        genres.sort(by: {$0.name < $1.name})
        
        MovieGroupAPI.allCases.map { group in
            dataService.getMyResult(urlString: group.url) { [weak self] result in
                guard let self = self else {return}
                switch result {
                case .success(let value):
                    let filters : [FilterCellModel] = self.genres.enumerated().map { (index, filter) in
                        let movies: [MyResult] = value.filter{ $0.genre_ids.contains(filter.id)}
                        return FilterCellModel(filters: filter, underline: index == 0, movies: movies)
                    }
                    let moviesGroup = filters.filter{ $0.underline == true}
                    let dataModel: MovieGenresTitleModel = MovieGenresTitleModel(title: group.title, genres: filters, movies: moviesGroup.first!.movies)
                    self.data.append(dataModel)
                    DispatchQueue.main.async {
                        self.filmsGrid.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        dataService.getRecommendedMovies() { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let recommendations):
                self.searchData = recommendations.map{
                    let title = $0.title
                    let description = $0.overview
                    let url = "https://image.tmdb.org/t/p/original" + $0.poster_path
                    return TitleDescriptionImageModel(title: title, description: description, imageUrl: url)
                }
                DispatchQueue.main.async {
                    self.filmsList.reloadData()
//                    self.buildViews()
                }
            case .failure(let error):
                print(error)
            }
        }

    }
    
    private func buildViews(){
        view.backgroundColor = .white
        createViews()
        styleViews()
        defineLayoutForViews()
        configureCollectionView()
        configurateTableView()
    }
    
    private func createViews(){
        searchBarView = SearchBarView()
        searchBarView.delegate = self
        view.addSubview(searchBarView)
        
        filmsGrid = UITableView()
        view.addSubview(filmsGrid)
        
        layout = UICollectionViewFlowLayout()

        filmsList = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(filmsList)
    }
    
    private func styleViews(){
        filmsList.isHidden = true
        
        filmsGrid.isHidden = false
        
        layout.minimumInteritemSpacing = 10
    }
    
    private func defineLayoutForViews(){
        searchBarView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            $0.height.equalTo(45)
        }
        filmsList.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(searchBarView.snp.bottom).offset(10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        filmsGrid.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(searchBarView.snp.bottom).offset(10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureCollectionView() {
        filmsList.register(ListOfMoviesCollectionViewCell.self, forCellWithReuseIdentifier: ListOfMoviesCollectionViewCell.reuseIdentifier)
        filmsList.dataSource = self
        filmsList.delegate = self
    }
    
    func configurateTableView() {
        filmsGrid.register(ListOfMoviesTableViewCell.self, forCellReuseIdentifier: ListOfMoviesTableViewCell.reuseIdentifier)
        filmsGrid.dataSource = self
        filmsGrid.delegate = self
    }
}

extension MovieListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: ListOfMoviesTableViewCell.reuseIdentifier,
                    for: indexPath) as? ListOfMoviesTableViewCell
        else {
            fatalError()
        }
        let data = data[indexPath.row]
        cell.selectionStyle = .none
        cell.set(data: data)
        cell.delegateController = self
        return cell
    }
}

extension MovieListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        300
    }
}

extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let collectionViewWidth = collectionView.frame.width
        return CGSize(width: collectionViewWidth - 2 * 10, height: 170)
    }
}
extension MovieListViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        searchData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListOfMoviesCollectionViewCell.reuseIdentifier, for: indexPath) as? ListOfMoviesCollectionViewCell
        else {
            fatalError()
        }
        let searchData = searchData[indexPath.row]
        cell.set(searchData: searchData)
        return cell
    }
}

extension MovieListViewController: SearchInFokusDelegate {
    
    func inFocus(bool: Bool) {
        if bool {
            filmsList.isHidden = false
            filmsGrid.isHidden = true
            
        } else {
            filmsList.isHidden = true
            filmsGrid.isHidden = false

        }
    }
}

extension MovieListViewController: ChangeControllerDelegate {
    
    func changeController(bool: Bool, string: String) {
        if bool {
            router.showMovieDetailsViewController(string: string)
        } 
    }
}
