//
//  MovieModelAPI.swift
//  MovieApp
//
//  Created by Lorena Lazar on 5/6/22.
//

import Foundation
import MovieAppData

public enum MovieGroupAPI: CaseIterable {

    case popular
    case trendingDay
    case trendingWeek
    case topRated
    
    public var title: String {
        switch self {
        case .popular:
            return "What's popular"
        case .trendingDay:
            return "What's trending today"
        case .trendingWeek:
            return "What's trending this week"
        case .topRated:
            return "Top Rated"
        }
    }
}
