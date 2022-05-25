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
}
