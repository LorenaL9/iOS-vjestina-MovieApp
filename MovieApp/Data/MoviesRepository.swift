//
//  MoviesRepository.swift
//  MovieApp
//
//  Created by Lorena Lazar on 5/24/22.
//

import Foundation
import CoreData

class MoviesRepository {
    private var moviesDatabaseDataSource: MoviesDatabaseDataSource!
    private var moviesNetworkDataSource: MoviesNetworkDataSource!
    
    init(networkService: NetworkServiceProtocol) {
        self.moviesNetworkDataSource = MoviesNetworkDataSource(networkService: networkService)
        self.moviesDatabaseDataSource = MoviesDatabaseDataSource()
    }
    
    
    func fetchGenre() -> [Genre] {
        var genres: [Genre] = []
//        moviesNetworkDataSource.fetchGenreNetwork()
        genres = moviesDatabaseDataSource.fetchGenresFromDatabase()
        return genres
    }
}
