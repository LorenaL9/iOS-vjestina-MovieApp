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
    private var search: [MyResult] = []
    private var groups: [MovieGroupAPI] = []
    private var genresUnderline: [FilterCellModel] = []
    
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
        dataService = NetworkService()
        
        genres = MoviesRepository(networkService: dataService).fetchGenre()

        search = MoviesRepository(networkService: dataService).fetchSearch(text: "")
        
        groups = MovieGroupAPI.allCases
        
        genres.sort(by: {$0.name < $1.name})

        print("GENRES: \(genres)")
        
        searchData = search.map{
                            let title = $0.title
                            let description = $0.overview
                            let url = "https://image.tmdb.org/t/p/original" + $0.poster_path
                            return TitleDescriptionImageModel(title: title, description: description, imageUrl: url)
                        }

        genresUnderline = genres.enumerated().map { (index, filter) in
                return FilterCellModel(filters: filter, underline: index == 0)
        }
     
        DispatchQueue.main.async {
            self.filmsList.reloadData()
            self.filmsGrid.reloadData()
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
        searchBarView.delegateFilter = self
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
        groups.count
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
        let data = groups[indexPath.row]
        cell.selectionStyle = .none
        cell.set(data: data, genresModel: genresUnderline)
        cell.delegateController = self
        return cell
    }
}

extension MovieListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        260
    }
}

extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let collectionViewWidth = collectionView.frame.width
        return CGSize(width: collectionViewWidth - 2 * 10, height: 150)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let string = "https://api.themoviedb.org/3/movie/\(search[indexPath.row].id)?language=en-US&page=1&api_key=0c3a28c563dda18040decdb4f03a6aa5"
        router.showMovieDetailsViewController(string: string)
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

extension MovieListViewController: SearchFilterDelegate {
    
    func filter(text: String) {
        search = MoviesRepository(networkService: dataService).fetchSearch(text: text)
        searchData = search.map{
                            let title = $0.title
                            let description = $0.overview
                            let url = "https://image.tmdb.org/t/p/original" + $0.poster_path
                            return TitleDescriptionImageModel(title: title, description: description, imageUrl: url)
                        }
        self.filmsList.reloadData()
    }
}

extension MovieListViewController: ChangeControllerDelegate {
    
    func changeController(bool: Bool, string: String) {
        if bool {
            router.showMovieDetailsViewController(string: string)
        } 
    }
}
