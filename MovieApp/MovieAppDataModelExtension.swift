//
//  MovieAppDataModelExstension.swift
//  MovieApp
//
//  Created by Lorena Lazar on 4/14/22.
//

import Foundation
import MovieAppData

extension MovieFilter{
    
    public var title: String {
        switch self {
        case .streaming:
            return "Streaming"
        case .onTv:
            return "On TV"
        case .forRent:
            return "For Rent"
        case .inTheaters:
            return "In Theaters"

        // genre
        case .thriller:
            return "Thriller"
        case .horror:
            return "Horror"
        case .comedy:
            return "Comedy"
        case .romanticComedy:
            return "Romantic Comedy"
        case .sport:
            return "Sport"
        case .action:
            return "Action"
        case .sciFi:
            return "Sci Fi"
        case .war:
            return "War"
        case .drama:
            return "Drama"

        // time filters
        case .day:
            return "Day"
        case .week:
            return "Week"
        case .month:
            return "Month"
        case .allTime:
            return "All Time"
        }
    }
}

extension MovieGroup{
    public var title: String {
        switch self {
        case .popular:
            return "What's popular"
        case .freeToWatch:
            return "Free to Watch"
        case .trending:
            return "What's trending"
        case .topRated:
            return "Top Rated"
        case .upcoming:
            return "Upcoming"
        }
    }
}


