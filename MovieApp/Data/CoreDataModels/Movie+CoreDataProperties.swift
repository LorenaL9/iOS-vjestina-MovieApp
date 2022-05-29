

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var adult: Bool
    @NSManaged public var backdrop_path: String?
    @NSManaged public var favorite: Bool
    @NSManaged public var id: Int64
    @NSManaged public var original_language: String?
    @NSManaged public var original_title: String?
    @NSManaged public var overview: String?
    @NSManaged public var popularity: Float
    @NSManaged public var poster_path: String?
    @NSManaged public var release_date: String?
    @NSManaged public var title: String?
    @NSManaged public var video: Bool
    @NSManaged public var vote_average: Float
    @NSManaged public var vote_count: Int32
    @NSManaged public var image: Data?
    @NSManaged public var genre_ids: NSSet?
    @NSManaged public var group: NSSet?

}

// MARK: Generated accessors for genre_ids
extension Movie {

    @objc(addGenre_idsObject:)
    @NSManaged public func addToGenre_ids(_ value: MovieGenre)

    @objc(removeGenre_idsObject:)
    @NSManaged public func removeFromGenre_ids(_ value: MovieGenre)

    @objc(addGenre_ids:)
    @NSManaged public func addToGenre_ids(_ values: NSSet)

    @objc(removeGenre_ids:)
    @NSManaged public func removeFromGenre_ids(_ values: NSSet)

}

// MARK: Generated accessors for group
extension Movie {

    @objc(addGroupObject:)
    @NSManaged public func addToGroup(_ value: MovieGroup)

    @objc(removeGroupObject:)
    @NSManaged public func removeFromGroup(_ value: MovieGroup)

    @objc(addGroup:)
    @NSManaged public func addToGroup(_ values: NSSet)

    @objc(removeGroup:)
    @NSManaged public func removeFromGroup(_ values: NSSet)

}

extension Movie : Identifiable {

}
