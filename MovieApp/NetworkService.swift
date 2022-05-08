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
    private var popular: [MyResult] = []
    private var trendingWeek: [MyResult] = []
    private var trendingDay: [MyResult] = []
    private var topRated: [MyResult] = []
    private var recommendations: [MyResult] = []
    private var url: URL!
    private var genres: [Genre] = []
    private var data: [MovieGenresTitleModel] = []
    private var titleDescriotionImage: [TitleDescriptionImageModel] = []
    private var movieDetails: MovieDetailsModel!

    
    func setData() {
        let networkService = NetworkService()
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?language=en-US&page=1&api_key=0c3a28c563dda18040decdb4f03a6aa5") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        networkService.executeUrlRequest(request) { (result: Result<Response, RequestError>) in
            switch result {
                case .failure(let error):
            //      handleRequestError(error)
                    print(error)
                case .success(let value):
                print(value.results.count)
                    self.popular = value.results
            }
        }
        guard let url = URL(string: "https://api.themoviedb.org/3/trending/movie/week?api_key=0c3a28c563dda18040decdb4f03a6aa5&page=1") else { return }
        request = URLRequest(url: url)
        request.httpMethod = "GET"
        networkService.executeUrlRequest(request) { (result: Result<Response, RequestError>) in
            switch result {
                case .failure(let error):
            //      handleRequestError(error)
                    print(error)
                case .success(let value):
                print(value.results.count)
                    self.trendingWeek = value.results
            }
        }
        guard let url = URL(string: "https://api.themoviedb.org/3/trending/movie/day?api_key=0c3a28c563dda18040decdb4f03a6aa5&page=1") else { return }
        request = URLRequest(url: url)
        request.httpMethod = "GET"
        networkService.executeUrlRequest(request) { (result: Result<Response, RequestError>) in
            switch result {
                case .failure(let error):
            //      handleRequestError(error)
                    print(error)
                case .success(let value):
                print(value.results.count)
                    self.trendingDay = value.results
            }
        }
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1&api_key=0c3a28c563dda18040decdb4f03a6aa5") else { return }
        request = URLRequest(url: url)
        request.httpMethod = "GET"
        networkService.executeUrlRequest(request) { (result: Result<Response, RequestError>) in
            switch result {
                case .failure(let error):
            //      handleRequestError(error)
                    print(error)
                case .success(let value):
                print(value.results.count)
                    self.topRated = value.results
            }
        }
        guard let url = URL(string: "https://api.themoviedb.org/3/genre/movie/list?language=en-US&api_key=0c3a28c563dda18040decdb4f03a6aa5") else { return }
        request = URLRequest(url: url)
        request.httpMethod = "GET"
        networkService.executeUrlRequest(request) { (result: Result<Genres, RequestError>) in
            switch result {
                case .failure(let error):
            //      handleRequestError(error)
                    print(error)
                case .success(let value):
                print(value.genres.count)
                    self.genres = value.genres
            }
        }
        sleep(2)
        
        
        let filtersPopualr : [FilterCellModel] = genres.enumerated().map { (index, filter) in
            let movies: [MyResult] = popular.filter{ $0.genre_ids.contains(filter.id)}
            return FilterCellModel(filters: filter, underline: index == 0, movies: movies)
        }
        let moviesPopular = filtersPopualr.filter{ $0.underline == true}
        let filtersTopRated : [FilterCellModel] = genres.enumerated().map { (index, filter) in
            let movies: [MyResult] = topRated.filter{ $0.genre_ids.contains(filter.id)}
            return FilterCellModel(filters: filter, underline: index == 0, movies: movies)
        }
        let moviesTopRated = filtersTopRated.filter{ $0.underline == true}
        let filtersTrendingDay : [FilterCellModel] = genres.enumerated().map { (index, filter) in
            let movies: [MyResult] = trendingDay.filter{ $0.genre_ids.contains(filter.id)}
            return FilterCellModel(filters: filter, underline: index == 0, movies: movies)
        }
        let moviesTrendingDay = filtersTrendingDay.filter{ $0.underline == true}
        let filtersTrendingWeek : [FilterCellModel] = genres.enumerated().map { (index, filter) in
            let movies: [MyResult] = trendingWeek.filter{ $0.genre_ids.contains(filter.id)}
            return FilterCellModel(filters: filter, underline: index == 0, movies: movies)
        }
        let moviesTrendinWeek = filtersTrendingWeek.filter{ $0.underline == true}

        let data1: MovieGenresTitleModel = MovieGenresTitleModel(title: MovieGroupAPI.popular.title, genres: filtersPopualr, movies: moviesPopular.first!.movies)
        let data2: MovieGenresTitleModel = MovieGenresTitleModel(title: MovieGroupAPI.trendingDay.title, genres: filtersTrendingDay, movies: moviesTrendingDay.first!.movies)
        let data3: MovieGenresTitleModel = MovieGenresTitleModel(title: MovieGroupAPI.trendingWeek.title, genres: filtersTrendingWeek, movies: moviesTrendinWeek.first!.movies)
        let data4: MovieGenresTitleModel = MovieGenresTitleModel(title: MovieGroupAPI.topRated.title, genres: filtersTopRated, movies: moviesTopRated.first!.movies)
        data.append(data1)
        data.append(data2)
        data.append(data3)
        data.append(data4)
    }

    func getMoviesData() -> [MovieGenresTitleModel] {
        return data
    }
    
    func fetchTitleDescriptionImage() {
        let networkService = NetworkService()
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/103/recommendations?language=en-US&page=1&api_key=0c3a28c563dda18040decdb4f03a6aa5") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        networkService.executeUrlRequest(request) { (result: Result<Response, RequestError>) in
            switch result {
                case .failure(let error):
            //      handleRequestError(error)
                    print(error)
                case .success(let value):
                    print(value)
                    self.recommendations = value.results
            }
        }
    }
    
    
    func getTitleDescriptionImage() -> [TitleDescriptionImageModel] {
        let searchData: [TitleDescriptionImageModel] = recommendations.map{
            let title = $0.title
            let description = $0.overview
            let url = "https://image.tmdb.org/t/p/original" + $0.poster_path
            return TitleDescriptionImageModel(title: title, description: description, imageUrl: url)
        }
        return searchData
    }
    
    func fetchMovieDetails(url: URL) -> MovieDetailsModel {
        let networkService = NetworkService()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        networkService.executeUrlRequest(request) { (result: Result<MovieDetailsModel, RequestError>) in
            switch result {
                case .failure(let error):
    //                handleRequestError(error)
                    print(error)
                case .success(let value):
                    print(value)
                    self.movieDetails = value
            }
        }
        sleep(1)
        return movieDetails
    }
    
    func getMovieDetails() -> MovieDetailsModel {
        return movieDetails
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
