//
//  MoviesDatabaseDataSource.swift
//  MovieApp
//
//  Created by Lorena Lazar on 5/24/22.
//

import Foundation
import CoreData
import UIKit

class MoviesDatabaseDataSource {
    private var managedContext: NSManagedObjectContext!
    
    init() {
        self.managedContext = CoreDataStack().persistentContainer.viewContext
    }
    
    func saveGenreToDatabase(genres: [Genre], completionHandler: @escaping () -> Void) {
        for genre in genres {
            var genreEntity = fetchGenre(idGenre: genre.id)
            if genreEntity == nil {
                let entity = NSEntityDescription.entity(forEntityName: "MovieGenre", in: managedContext)!
                genreEntity = MovieGenre(entity: entity, insertInto: managedContext)
            }
            genreEntity!.id = Int32(genre.id)
            genreEntity!.name = genre.name
        }
        try? managedContext.save()
        DispatchQueue.main.async {
            print("Save genre to database")
            completionHandler()
        }
    }
    
    func fetchGenresFromDatabase(completionHandler: @escaping ([Genre]) -> Void){
        let request: NSFetchRequest<MovieGenre> = MovieGenre.fetchRequest()
        let sorted = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sorted]
            do {
                let results = try managedContext.fetch(request)
                var genres: [Genre] = []
                for r in results {
                    let genre = Genre(fromModel: r)
                    genres.append(genre)
                }
                DispatchQueue.main.async {
                    completionHandler(genres)
                }
            } catch let error as NSError {
                print("Error \(error) | Info: \(error.userInfo)")
                DispatchQueue.main.async {
                    completionHandler([])
                }
        }
    }
    
    func fetchGenre(idGenre: Int) -> MovieGenre? {
        let request: NSFetchRequest<MovieGenre> = MovieGenre.fetchRequest()
        let predicate = NSPredicate(format: "id = %@", "\(idGenre)")
        request.predicate = predicate
        request.fetchLimit = 1
            do {
                return try managedContext.fetch(request).first
            } catch let error as NSError {
                print("Error \(error) | Info: \(error.userInfo)")
                return nil
        }
    }
    
    func deleteAllGenres() {
    let request: NSFetchRequest<MovieGenre> = MovieGenre.fetchRequest()
        do {
            let results = try managedContext.fetch(request)
            for r in results {
                managedContext.delete(r)
            }
            try? managedContext.save()
        } catch let error as NSError {
            print("Error \(error) | Info: \(error.userInfo)")
        }
    }
    
    func deleteAllMovies() {
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
            do {
                let results = try managedContext.fetch(request)
                for r in results {
                    managedContext.delete(r)
                }
                try? managedContext.save()
            } catch let error as NSError {
                print("Error \(error) | Info: \(error.userInfo)")
            }
    }
    
    func fetchGroup(withId: Int) -> MovieGroup? {
        let request: NSFetchRequest<MovieGroup> = MovieGroup.fetchRequest()
        let predicate = NSPredicate(format: "name = %@", "\(withId)")
        request.predicate = predicate
        request.fetchLimit = 1
            do {
                return try managedContext.fetch(request).first
            } catch let error as NSError {
                print("Error \(error) | Info: \(error.userInfo)")
                return nil
            }
    }
    
    func saveGroup(id: Int) {
        var groupEntity = fetchGroup(withId: id)
        if groupEntity == nil {
            let entity = NSEntityDescription.entity(forEntityName: "MovieGroup", in: managedContext)!
            groupEntity = MovieGroup(entity: entity, insertInto: managedContext)
        }
        groupEntity!.name = Int32(id)
        try? managedContext.save()
    }
    
    func saveMovieToDatabase(movies: [MyResultNetwork], idGroup: Int, completionHandler: @escaping() -> Void) {
        if fetchGroup(withId: idGroup) == nil {
            saveGroup(id: idGroup)
        }
        for movie in movies {
            var movieEntity = fetchMovie(idMovie: movie.id)
            if movieEntity == nil {
                print("Film ne postoji u bazi, sprema se i slika")
                let entity = NSEntityDescription.entity(forEntityName: "Movie", in: managedContext)!
                movieEntity = Movie(entity: entity, insertInto: managedContext)
                movieEntity!.favorite = false
                let urlString = "https://image.tmdb.org/t/p/original" + movie.poster_path
                let url = URL(string: urlString)!
                if let data = try? Data(contentsOf: url) {
                    let image = UIImage(data: data)
                    movieEntity?.image = image?.jpegData(compressionQuality: 1.0)
                }
            }
            movieEntity!.title = movie.title
            movieEntity!.overview = movie.overview
            movieEntity!.poster_path = movie.poster_path
            movieEntity!.adult = movie.adult
            movieEntity!.backdrop_path = movie.backdrop_path
            movieEntity!.id = Int64(movie.id)
            movieEntity!.original_language = movie.original_language
            movieEntity!.original_title = movie.original_title
            movieEntity!.popularity = movie.popularity
            movieEntity!.release_date = movie.release_date
            movieEntity!.video = movie.video
            movieEntity!.vote_average = movie.vote_average
            movieEntity!.vote_count = Int32(movie.vote_count)

            try? managedContext.save()
            
            let group = fetchGroup(withId: idGroup)
            group?.addToMovies(movieEntity!)

            for g in movie.genre_ids {
                let genre = fetchGenre(idGenre: g)
                genre?.addToMovies(movieEntity!)
            }
            DispatchQueue.main.async {
                print("Save movie to database")
                completionHandler()
            }
        }
    }

    func fetchMovie(idMovie: Int) -> Movie? {
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        let predicate = NSPredicate(format: "id = %@", "\(idMovie)")
        request.predicate = predicate
        request.fetchLimit = 1
            do {
                return try managedContext.fetch(request).first
            } catch let error as NSError {
                print("Error \(error) | Info: \(error.userInfo)")
                return nil
        }
    }
    
    func movieToGenre(id: Int, movie: Int) {
        guard
                let movie = fetchMovie(idMovie: movie),
                let genre = fetchGenre(idGenre: id)
        else {
            return
        }
        genre.addToMovies(movie)
        try? managedContext.save()
    }
    
    func movieToGroup(idGroup: Int, movieId: Int) {
        guard
            let group = fetchGroup(withId: idGroup),
            let movie = fetchMovie(idMovie: movieId)
        else {
            return
        }
        group.addToMovies(movie)
        try? managedContext.save()
    }

    func fetchMoviesFromDatabase(text: String, completionHandler: @escaping ([MyResult]) -> Void) {
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        if (text != "") {
            let predicate = NSPredicate(format: "title CONTAINS[c] '\(text)'")
            request.predicate = predicate
        }
            do {
                let results = try managedContext.fetch(request)
                var movies: [MyResult] = []
                for m in results {
                    let movie = MyResult(fromModel: m)
                    movies.append(movie)
                }
                DispatchQueue.main.async {
                    completionHandler(movies)
                }
            } catch let error as NSError {
                print("Error \(error) | Info: \(error.userInfo)")
                DispatchQueue.main.async {
                    completionHandler([])
                }
        }
    }
    
    func fetchMoviesFromDatabaseGroupGenre(groupId: Int, genreId: Int, completionHandler: @escaping ([MyResult]) -> Void) {
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        let predicateGroup = NSPredicate(format: "%@ in group.name", "\(groupId)")
        let predicateGenre = NSPredicate(format: "%@ in genre_ids.id", "\(genreId)")
        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [predicateGroup, predicateGenre])
        let sorted = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sorted]
        request.predicate = andPredicate
            do {
                let results = try managedContext.fetch(request)
                var movies: [MyResult] = []
                for m in results {
                    let movie = MyResult(fromModel: m)
                    movies.append(movie)
                }
                DispatchQueue.main.async {
                    completionHandler(movies)
                }
            } catch let error as NSError {
                print("Error \(error) | Info: \(error.userInfo)")
                DispatchQueue.main.async {
                    completionHandler([])
                }
        }
    }
    
    func addToFavorites(movieId: Int) {
        guard
            let movie = fetchMovie(idMovie: movieId)
        else {
            return
        }
        movie.favorite = true
        try? managedContext.save()
    }
    
    func removeFromFavorites(movieId: Int) {
        guard
            let movie = fetchMovie(idMovie: movieId)
        else {
            return
        }
        movie.favorite = false
        try? managedContext.save()
    }
    
    func fetchFavorites() -> [MyResult] {
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        let predicate = NSPredicate(format: "favorite = true")
        request.predicate = predicate
            do {
                let results = try managedContext.fetch(request)
                var movies: [MyResult] = []
                for m in results {
                    let movie = MyResult(fromModel: m)
                    movies.append(movie)
                }
                return movies
            } catch let error as NSError {
                print("Error \(error) | Info: \(error.userInfo)")
        return []
        }
    }
}
