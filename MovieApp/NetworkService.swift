//
//  NetworkService.swift
//  MovieApp
//
//  Created by Lorena Lazar on 5/5/22.
//

import Foundation

enum RequestError: Error {
    case clientError
    case serverError
    case noDataError
    case dataDecodingError
}

enum Result<Success, Failure> where Failure : Error {
    /// A success, storing a `Success` value.
    case success(Success)
    /// A failure, storing a `Failure` value.
    case failure(Failure)
}

class NetworkService: NetworkServiceProtocol{
    private var url: URL!

    func getMyResult(urlString: String, completionHandler: @escaping (Result<[MyResult], Error>) -> Void) {

            guard
                let url = URL(string: urlString)
            else {
                completionHandler(.failure(RequestError.clientError))
                return
            }
        
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            executeUrlRequest(request) { (result: Result<Response, RequestError>) in
                switch result {
                case .failure:
                    completionHandler(.failure(RequestError.serverError))
                case .success(let value):
                    completionHandler(.success(value.results))
                }
            }
    }
    
    func getGenres(completionHandler: @escaping (Result<[Genre], Error>) -> Void) {

            guard
                let url = URL(string: "https://api.themoviedb.org/3/genre/movie/list?language=en-US&api_key=0c3a28c563dda18040decdb4f03a6aa5")
            else {
                completionHandler(.failure(RequestError.clientError))
                return
            }
        
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            executeUrlRequest(request) { (result: Result<Genres, RequestError>) in
                switch result {
                case .failure:
                    completionHandler(.failure(RequestError.serverError))
                case .success(let value):
                    completionHandler(.success(value.genres))
                }
            }
    }
    
    func getRecommendedMovies(completionHandler: @escaping (Result<[MyResult], Error>) -> Void) {

            guard
                let url = URL(string: "https://api.themoviedb.org/3/movie/103/recommendations?language=en-US&page=1&api_key=0c3a28c563dda18040decdb4f03a6aa5")
            else {
                completionHandler(.failure(RequestError.clientError))
                return
            }
        
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            executeUrlRequest(request) { (result: Result<Response, RequestError>) in
                switch result {
                case .failure:
                    completionHandler(.failure(RequestError.serverError))
                case .success(let value):
                    completionHandler(.success(value.results))
                }
            }
    }
    
    func getMovieDetails(string: String, completionHandler: @escaping (Result<MovieDetailsModel, Error>) -> Void) {
            guard
                let url = URL(string: string)
            else {
                completionHandler(.failure(RequestError.clientError))
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            executeUrlRequest(request) { (result: Result<MovieDetailsModel, RequestError>) in
                switch result {
                case .failure:
                    completionHandler(.failure(RequestError.serverError))
                case .success(let value):
                    completionHandler(.success(value))
                }
            }
    }
    
    func executeUrlRequest<T: Decodable>(_ request: URLRequest, completionHandler:
    @escaping (Result<T, RequestError>) -> Void) {
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, err in
                guard err == nil else {
                    completionHandler(.failure(.clientError))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                              (200...299).contains(httpResponse.statusCode) else {
                            completionHandler(.failure(.serverError))
                return
                }
                        guard let data = data else {
                            completionHandler(.failure(.noDataError))
                            return
                }
                        guard let value = try? JSONDecoder().decode(T.self, from: data) else {
                            completionHandler(.failure(.dataDecodingError))
                            return
                }
                        completionHandler(.success(value))
                    }
                    dataTask.resume()
                }
}
