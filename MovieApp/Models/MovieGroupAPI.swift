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
    
    public var url: String {
        switch self {
        case .popular:
            return "https://api.themoviedb.org/3/movie/popular?language=en-US&page=1&api_key=0c3a28c563dda18040decdb4f03a6aa5"
        case .trendingDay:
            return "https://api.themoviedb.org/3/trending/movie/day?api_key=0c3a28c563dda18040decdb4f03a6aa5&page=1"
        case .trendingWeek:
            return "https://api.themoviedb.org/3/trending/movie/week?api_key=0c3a28c563dda18040decdb4f03a6aa5&page=1"
        case .topRated:
            return "https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1&api_key=0c3a28c563dda18040decdb4f03a6aa5"
        }
    }
}
