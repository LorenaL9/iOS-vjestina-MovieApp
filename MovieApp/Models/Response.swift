//
//  Respone.swift
//  MovieApp
//
//  Created by Lorena Lazar on 5/5/22.
//

import Foundation

struct Response: Codable {
    let page: Int
    let results: [MyResultNetwork]
    let total_pages: Int
    let total_results: Int
}
