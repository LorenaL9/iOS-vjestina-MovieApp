//
//  MoviesDatabaseDataSource.swift
//  MovieApp
//
//  Created by Lorena Lazar on 5/24/22.
//

import Foundation
import CoreData

class MoviesDatabaseDataSource {
    
    func saveGenreToDatabase(genres: [Genre]) {
        let managedContext = CoreDataStack().persistentContainer.viewContext

        for genre in genres {
//            print("\(genre.name)")
            let entity = NSEntityDescription.entity(forEntityName: "MovieGenre", in: managedContext)!
            let genreEntity = MovieGenre(entity: entity, insertInto: managedContext)
            genreEntity.id = Int32(genre.id)
            genreEntity.name = genre.name
        }
        try? managedContext.save()
    }
    
    func fetchGenresFromDatabase() -> [Genre] {
        let managedContext = CoreDataStack().persistentContainer.viewContext
        let request: NSFetchRequest<MovieGenre> = MovieGenre.fetchRequest()
            do {
                let results = try managedContext.fetch(request)
                var genres: [Genre] = []
                for r in results {
                    let genre = Genre(id: Int(r.id), name: r.name!)
                    genres.append(genre)
                }
                return genres
            } catch let error as NSError {
                print("Error \(error) | Info: \(error.userInfo)")
        return []
                
        }
    }
    
    func saveMovieToDatabase(movies: [MyResult]) {
        let managedContext = CoreDataStack().persistentContainer.viewContext

        for movie in movies {
//            print("\(genre.name)")
            let entity = NSEntityDescription.entity(forEntityName: "Movie", in: managedContext)!
            let movieEntity = Movie(entity: entity, insertInto: managedContext)
            movieEntity.title = movie.title
            movieEntity.overview = movie.overview
            movieEntity.poster_path = movie.poster_path
            movieEntity.adult = movie.adult
            movieEntity.backdrop_path = movie.backdrop_path
//            movieEntity.genre_ids = movie.genre_ids
//            movieEntity.genre_ids = NSSet(array: movie.genre_ids)
            movieEntity.id = Int64(movie.id)
            movieEntity.original_language = movie.original_language
            movieEntity.original_title = movie.original_title
            movieEntity.popularity = movie.popularity
            movieEntity.release_date = movie.release_date
            movieEntity.video = movie.video
            movieEntity.vote_average = movie.vote_average
            movieEntity.vote_count = Int32(movie.vote_count)
            
        }
        try? managedContext.save()
    }

    func fetchMoviesFromDatabase(text: String) -> [MyResult] {
        let managedContext = CoreDataStack().persistentContainer.viewContext
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        if (text != "") {
            let predicate = NSPredicate(format: "title CONTAINS[c] '\(text)'")
            request.predicate = predicate
        }
            do {
                let results = try managedContext.fetch(request)
                var movies: [MyResult] = []
                for m in results {
//                    let array = m.genre_ids?.allObjects as! [Int]
                    let movie = MyResult(adult: m.adult, backdrop_path: m.backdrop_path, genre_ids: [], id: Int(m.id), original_language: m.original_language, original_title: m.original_title, overview: m.overview, popularity: m.popularity, poster_path: m.poster_path, release_date: m.release_date, title: m.title, video: m.video, vote_average: m.vote_average, vote_count: Int(m.vote_count))
                    movies.append(movie)

                }
                return movies
            } catch let error as NSError {
                print("Error \(error) | Info: \(error.userInfo)")
        return []
        }
    }
    
//    func fetchMoviesFromDatabaseGroup(group: String) -> [MyResult] {
//        let managedContext = CoreDataStack().persistentContainer.viewContext
//        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
////        if (group != "") {
////            let predicate = NSPredicate(format: "title CONTAINS[c] '\(text)'")
////            request.predicate = predicate
////        }
//            do {
//                let results = try managedContext.fetch(request)
//                var movies: [MyResult] = []
//                for m in results {
////                    let array = m.genre_ids?.allObjects as! [Int]
//                    let movie = MyResult(adult: m.adult, backdrop_path: m.backdrop_path, genre_ids: [], id: Int(m.id), original_language: m.original_language, original_title: m.original_title, overview: m.overview, popularity: m.popularity, poster_path: m.poster_path, release_date: m.release_date, title: m.title, video: m.video, vote_average: m.vote_average, vote_count: Int(m.vote_count))
//                    movies.append(movie)
//
//                }
//                return movies
//            } catch let error as NSError {
//                print("Error \(error) | Info: \(error.userInfo)")
//        return []
//        }
//    }
    
}
