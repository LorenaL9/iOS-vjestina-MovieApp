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


class MovieListViewController: UIViewController {
    private var popular: [MyResult] = []
    private var searchBarView: SearchBarView!
    private var popisFilmovaGrid: UITableView!
    private var popisFilmovaList: UICollectionView!
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
        let dataService = NetworkService()
        let queue = DispatchQueue.global()
        queue.sync {
            dataService.fetchTitleDescriptionImage()
        }
        queue.sync {
            dataService.setData()
        }
        queue.sync {
            searchData = dataService.getTitleDescriptionImage()
        }
        queue.sync {
            data = dataService.getMoviesData()
        }
        
        buildViews()

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
        
        popisFilmovaGrid = UITableView()
        view.addSubview(popisFilmovaGrid)
        
        layout = UICollectionViewFlowLayout()

        popisFilmovaList = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(popisFilmovaList)
    }
    
    private func styleViews(){
        popisFilmovaList.isHidden = true
        
        popisFilmovaGrid.isHidden = false
        
        layout.minimumInteritemSpacing = 10
    }
    
    private func defineLayoutForViews(){
        searchBarView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            $0.height.equalTo(45)
        }
        popisFilmovaList.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(searchBarView.snp.bottom).offset(10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        popisFilmovaGrid.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(searchBarView.snp.bottom).offset(10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureCollectionView() {
        popisFilmovaList.register(ListOfMoviesCollectionViewCell.self, forCellWithReuseIdentifier: ListOfMoviesCollectionViewCell.reuseIdentifier)
        popisFilmovaList.dataSource = self
        popisFilmovaList.delegate = self
    }
    
    func configurateTableView() {
        popisFilmovaGrid.register(ListOfMoviesTableViewCell.self, forCellReuseIdentifier: ListOfMoviesTableViewCell.reuseIdentifier)
        popisFilmovaGrid.dataSource = self
        popisFilmovaGrid.delegate = self
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
            popisFilmovaList.isHidden = false
            popisFilmovaGrid.isHidden = true
            
        } else {
            popisFilmovaList.isHidden = true
            popisFilmovaGrid.isHidden = false

        }
    }
}

extension MovieListViewController: ChangeControllerDelegate {
    
    func changeController(bool: Bool, url: URL) {
        if bool {
            router.showMovieDetailsViewController(url: url)
        } 
    }
}
