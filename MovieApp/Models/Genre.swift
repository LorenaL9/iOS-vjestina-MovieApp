//
//  Genre.swift
//  MovieApp
//
//  Created by Lorena Lazar on 5/6/22.
//

import Foundation

struct Genre: Codable {
    let id: Int
    let name: String
    
    init(fromModel genre: MovieGenre) {
        self.id = Int(genre.id)
        self.name = genre.name ?? ""
    }
}
