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
        self.moviesDatabaseDataSource = MoviesDatabaseDataSource()
        self.moviesNetworkDataSource = MoviesNetworkDataSource(networkService: networkService, moviesDatabaseDataSource: moviesDatabaseDataSource )
    }
    
    func fetchGenre() -> [Genre] {
        var genres: [Genre] = []
        moviesNetworkDataSource.fetchGenreNetwork()
        genres = moviesDatabaseDataSource.fetchGenresFromDatabase()
//        moviesDatabaseDataSource.deleteAllGenres()
        return genres
    }
    
    func fetchSearch(text: String) -> [MyResult] {
        var search: [MyResult] = []
        search = moviesDatabaseDataSource.fetchMoviesFromDatabase(text: text)
        return search
    }
    
    func fetchMovies(group: MovieGroupAPI, genreId: Int) -> [MyResult] {
        var movies: [MyResult] = []
        moviesNetworkDataSource.fetchMoviesFromNetwork(urlString: group.url, idGroup: group.id)
        movies = moviesDatabaseDataSource.fetchMoviesFromDatabaseGroupGenre(groupId: group.id, genreId: genreId)
//        moviesDatabaseDataSource.deleteAllMovies()
        return movies
    }

    
    func fetchFavoritesFromDatabase() -> [MyResult] {
        var movies: [MyResult] = []
        movies = moviesDatabaseDataSource.fetchFavorites()
        return movies
    }
    
    func addToFavorites(movieId: Int) {
        moviesDatabaseDataSource.addToFavorites(movieId: movieId)
    }
    
    func removeFromFavorites(movieId: Int) {
        moviesDatabaseDataSource.removeFromFavorites(movieId: movieId)
    }
}
