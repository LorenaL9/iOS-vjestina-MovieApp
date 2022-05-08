//
//  Respone.swift
//  MovieApp
//
//  Created by Lorena Lazar on 5/5/22.
//

import Foundation

struct Response: Codable {
    let page: Int
    let results: [MyResult]
    let total_pages: Int
    let total_results: Int
}
