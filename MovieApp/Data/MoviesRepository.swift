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
    
    func fetchSearch(text: String) -> [MyResult] {
        var search: [MyResult] = []
//        moviesNetworkDataSource.fetchRecommendedNetwork()
        search = moviesDatabaseDataSource.fetchMoviesFromDatabase(text: text)
        return search
    }
//    
//    func fetchMovies(urlString: String) -> [MyResult] {
//        var movies: [MyResult] = []
//        moviesNetworkDataSource.fetchMovies(urlString: urlString)
//        movies = moviesDatabaseDataSource.fetchMoviesFromDatabaseGroup(group: "popular")
//        return movies
//    }
}
