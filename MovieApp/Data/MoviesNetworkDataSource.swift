//
//  MoviesNetworkDataSource.swift
//  MovieApp
//
//  Created by Lorena Lazar on 5/24/22.
//

import Foundation


class MoviesNetworkDataSource {
    private var networkService: NetworkServiceProtocol!
    private var moviesDatabaseDataSource: MoviesDatabaseDataSource!
    
    init(networkService: NetworkServiceProtocol, moviesDatabaseDataSource: MoviesDatabaseDataSource ) {
        self.networkService = networkService
        self.moviesDatabaseDataSource = moviesDatabaseDataSource
    }

    func fetchGenreNetwork(completionHandler: @escaping ([Genre]) -> Void) {
        networkService.getGenres() { result in
            switch result {
            case .success(let value):
                DispatchQueue.main.async {
                    completionHandler(value)
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    completionHandler([])
                }
            }
        }
    }
    
    func fetchMoviesFromNetwork(urlString: String, comletionHandler: @escaping ([MyResultNetwork]) -> Void) {
        networkService.getMyResult(urlString: urlString) { result in
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    comletionHandler(movies)
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    comletionHandler([])
                }
            }
        }
    }
}
