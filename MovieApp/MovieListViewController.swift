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


class MovieListViewController: UIViewController{
    let movies = Movies.all()
    
    private var searchBarView: SearchBarView!
    private var popisFilmovaGrid: UITableView!
    private var popisFilmovaList: UICollectionView!
    private var layout: UICollectionViewFlowLayout!


    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 10
    }
    
    private func defineLayoutForViews(){
        searchBarView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(4)
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
        5
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
        cell.set(labelIndex: indexPath.row)
        return cell
    }
}

extension MovieListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        nil
    }

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
        movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListOfMoviesCollectionViewCell.reuseIdentifier, for: indexPath) as? ListOfMoviesCollectionViewCell
        else {
            fatalError()
        }
        cell.set(index: indexPath.row)
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

