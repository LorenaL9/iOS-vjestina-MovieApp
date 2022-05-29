//
//  MoviesDatabaseDataSource.swift
//  MovieApp
//
//  Created by Lorena Lazar on 5/24/22.
//

import Foundation
import CoreData

class MoviesDatabaseDataSource {
    private var managedContext: NSManagedObjectContext!
    
    init() {
        self.managedContext = CoreDataStack().persistentContainer.viewContext
    }
    
    func saveGenreToDatabase(genres: [Genre]) {
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
    }
    
    func fetchGenresFromDatabase() -> [Genre] {
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
    
    func saveMovieToDatabase(movies: [MyResultNetwork], idGroup: Int) {
        print("Spremam filmove u bazu")
        if fetchGroup(withId: idGroup) == nil {
            saveGroup(id: idGroup)
        }
        let group = fetchGroup(withId: idGroup)!
        for movie in movies {
            var movieEntity = fetchMovie(idMovie: movie.id)
            if movieEntity == nil {
                print("Film ne postoji u bazi")
                let entity = NSEntityDescription.entity(forEntityName: "Movie", in: managedContext)!
                movieEntity = Movie(entity: entity, insertInto: managedContext)
                movieEntity!.favorite = false
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
            
//            DispatchQueue.main.async {
//                for g in movie.genre_ids {
//                    self.movieToGenre(id: g, movie: movie.id)
//                }
//                self.movieToGroup(idGroup: idGroup, movieId: movie.id)
//            }
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

    func fetchMoviesFromDatabase(text: String) -> [MyResult] {
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
                return movies
            } catch let error as NSError {
                print("Error \(error) | Info: \(error.userInfo)")
        return []
        }
    }
    
    func fetchMoviesFromDatabaseGroupGenre(groupId: Int, genreId: Int) -> [MyResult] {
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
            do {
                let results = try managedContext.fetch(request)
                var movies: [MyResult] = []
                for m in results {
                    if (m.group!.contains(fetchGroup(withId: groupId)) && m.genre_ids!.contains(fetchGenre(idGenre: genreId))) {
                        let movie = MyResult(fromModel: m)
                        movies.append(movie)
                    }
                }
                return movies
            } catch let error as NSError {
                print("Error \(error) | Info: \(error.userInfo)")
        return []
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
