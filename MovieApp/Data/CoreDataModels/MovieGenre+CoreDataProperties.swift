//
//  MovieGenre+CoreDataProperties.swift
//  MovieApp
//
//  Created by Lorena Lazar on 5/25/22.
//
//

import Foundation
import CoreData


extension MovieGenre {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieGenre> {
        return NSFetchRequest<MovieGenre>(entityName: "MovieGenre")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: Int32

}

extension MovieGenre : Identifiable {

}
