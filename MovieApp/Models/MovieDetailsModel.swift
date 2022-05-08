//
//  MovieDetailsModel.swift
//  MovieApp
//
//  Created by Lorena Lazar on 5/7/22.
//

import Foundation

struct MovieDetailsModel: Codable {
//    let adult: Bool
    let backdrop_path: String
    //NULL
//    let belongs_to_collection: Collection
//    let budget: Int
    let genres: [Genre]
    let homepage: String
    let id: Int
//    let imdb_id: String
    let original_language: String
    let original_title: String
    let overview: String
    let popularity: Float
    let poster_path: String
//    let production_companies: [ProductionCompanies]
//    let production_countries: [ProductionCountries]
    var release_date: String
    let revenue: Int
    let runtime: Int
//    let spoken_languages: [SpokenLanguages]
    let status: String
    let tagline: String
    let title: String
    let video: Bool
    let vote_average: Float
    let vote_count: Int
}
