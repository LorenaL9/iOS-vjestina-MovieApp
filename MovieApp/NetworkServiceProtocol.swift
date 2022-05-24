//
//  NetworkServiceProtocol.swift
//  MovieApp
//
//  Created by Lorena Lazar on 5/8/22.
//

import Foundation

protocol NetworkServiceProtocol{
    
    func getRecommendedMovies(completionHandler: @escaping (Result<[MyResult], Error>) -> Void)
    func getGenres(completionHandler: @escaping (Result<[Genre], Error>) -> Void)
    func getMovieDetails(string: String, completionHandler: @escaping (Result<MovieDetailsModel, Error>) -> Void)
    func getMyResult(urlString: String, completionHandler: @escaping (Result<[MyResult], Error>) -> Void) 

}
