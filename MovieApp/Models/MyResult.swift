//
//  codableStruct.swift
//  MovieApp
//
//  Created by Lorena Lazar on 5/5/22.
//

import Foundation
import UIKit

struct MyResult {
    let adult: Bool
    let backdrop_path: String
    let genre_ids: [Int]
    let id: Int
    let original_language: String
    let original_title: String
    let overview: String
    let popularity: Float
    let poster_path: String
    let release_date: String
    let title: String
    let video: Bool
    let vote_average: Float
    let vote_count: Int
    let favorite: Bool
    var image: UIImage?
    
    init(fromModel movie: Movie) {
        self.adult  = movie.adult
        self.backdrop_path = movie.backdrop_path ?? ""
        self.id = Int(movie.id)
        self.original_language =  movie.original_language ?? ""
        self.original_title = movie.original_title ?? ""
        self.overview = movie.overview ?? ""
        self.popularity = movie.popularity
        self.poster_path = movie.poster_path ?? ""
        self.release_date = movie.release_date ?? ""
        self.title = movie.title ?? ""
        self.video = movie.video
        self.vote_average = movie.vote_average
        self.vote_count = Int(movie.vote_count)
        self.genre_ids = []
        self.favorite = movie.favorite
        if let imageData = movie.image as Data? {
            self.image = UIImage(data: imageData)
        }
    }
}
