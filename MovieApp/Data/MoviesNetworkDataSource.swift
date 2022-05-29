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

    func fetchGenreNetwork() {
        networkService.getGenres() {result in
            switch result {
            case .success(let value):
                print("FETCH GENRES FROM NETWORK: \(value)")
                DispatchQueue.main.async {
                    self.moviesDatabaseDataSource.saveGenreToDatabase(genres: value)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchMoviesFromNetwork(urlString: String, idGroup: Int) {
        networkService.getMyResult(urlString: urlString) { result in
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
//                    print("FETCH MOVIES FROM NETWORK: \(movies)")
                    self.moviesDatabaseDataSource.saveMovieToDatabase(movies: movies, idGroup: idGroup)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
