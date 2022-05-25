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
//    private var url: URL!
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
        self.moviesDatabaseDataSource = MoviesDatabaseDataSource()
    }
//    func getMyResult(urlString: String, completionHandler: @escaping (Result<[MyResult], Error>) -> Void) {
//
//            guard
//                let url = URL(string: urlString)
//            else {
//                completionHandler(.failure(RequestError.clientError))
//                return
//            }
//
//            var request = URLRequest(url: url)
//            request.httpMethod = "GET"
//        NetworkService().executeUrlRequest(request) { (result: Result<Response, RequestError>) in
//                switch result {
//                case .failure:
//                    completionHandler(.failure(RequestError.serverError))
//                case .success(let value):
//                    completionHandler(.success(value.results))
//                }
//            }
//    }
    func fetchGenreNetwork() {
        networkService.getGenres() {result in
            switch result {
            case .success(let value):
                print(value)
                self.moviesDatabaseDataSource.saveGenreToDatabase(genres: value)
//                self.genres = value
//                DispatchQueue.main.async {
//                    self.fetchMovies()
//                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
//    func getRecommendedMovies(completionHandler: @escaping (Result<[MyResult], Error>) -> Void) {
//
//            guard
//                let url = URL(string: "https://api.themoviedb.org/3/movie/103/recommendations?language=en-US&page=1&api_key=0c3a28c563dda18040decdb4f03a6aa5")
//            else {
//                completionHandler(.failure(RequestError.clientError))
//                return
//            }
//
//            var request = URLRequest(url: url)
//            request.httpMethod = "GET"
//        NetworkService().executeUrlRequest(request) { (result: Result<Response, RequestError>) in
//                switch result {
//                case .failure:
//                    completionHandler(.failure(RequestError.serverError))
//                case .success(let value):
//                    completionHandler(.success(value.results))
//                }
//            }
//    }
//
//    func getMovieDetails(string: String, completionHandler: @escaping (Result<MovieDetailsModel, Error>) -> Void) {
//            guard
//                let url = URL(string: string)
//            else {
//                completionHandler(.failure(RequestError.clientError))
//                return
//            }
//            var request = URLRequest(url: url)
//            request.httpMethod = "GET"
//        NetworkService().executeUrlRequest(request) { (result: Result<MovieDetailsModel, RequestError>) in
//                switch result {
//                case .failure:
//                    completionHandler(.failure(RequestError.serverError))
//                case .success(let value):
//                    completionHandler(.success(value))
//                }
//            }
//    }
}
