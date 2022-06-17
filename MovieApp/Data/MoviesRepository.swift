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
    
    func fetchSearch(text: String, completionHandler: @escaping ([MyResult]) -> Void){
        moviesDatabaseDataSource.fetchMoviesFromDatabase(text: text) { (result: [MyResult]) in
            completionHandler(result)
        }
    }
    
    func fetchGenre(completionHandler: @escaping ([Genre]) -> Void) {
        moviesNetworkDataSource.fetchGenreNetwork (completionHandler: { (genres: [Genre]) in
            self.moviesDatabaseDataSource.saveGenreToDatabase(genres: genres, completionHandler: {
                self.moviesDatabaseDataSource.fetchGenresFromDatabase(completionHandler: { (genresDatabase: [Genre]) in
                    guard genresDatabase.isEmpty == false else {
                        completionHandler([])
                        return
                    }
                    completionHandler(genresDatabase)
                })
            })
        })
    }
    
    func fetchMovies(group: MovieGroupAPI, genreId: Int, completionHandler: @escaping ([MyResult]) -> Void) {
        moviesNetworkDataSource.fetchMoviesFromNetwork(urlString: group.url, comletionHandler: { (movies: [MyResultNetwork]) in
            self.moviesDatabaseDataSource.saveMovieToDatabase(movies: movies, idGroup: group.id, completionHandler: {
                self.moviesDatabaseDataSource.fetchMoviesFromDatabaseGroupGenre(groupId: group.id, genreId: genreId, completionHandler: { (moviesDatabase: [MyResult]) in
                    guard moviesDatabase.isEmpty == false else {
                        completionHandler([])
                        return
                    }
                    completionHandler(moviesDatabase)
                })
            })
        })
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
