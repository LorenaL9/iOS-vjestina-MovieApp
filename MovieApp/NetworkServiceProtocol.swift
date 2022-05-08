//
//  NetworkServiceProtocol.swift
//  MovieApp
//
//  Created by Lorena Lazar on 5/8/22.
//

import Foundation

protocol NetworkServiceProtocol{
    func getMoviesData() -> [MovieGenresTitleModel]
    func fetchTitleDescriptionImage()
    func getTitleDescriptionImage() -> [TitleDescriptionImageModel]
    func setData()
    func fetchMovieDetails(url: URL) -> MovieDetailsModel
    func getMovieDetails() -> MovieDetailsModel
}
