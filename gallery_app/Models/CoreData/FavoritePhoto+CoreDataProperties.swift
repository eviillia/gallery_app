public import Foundation
public import CoreData


public typealias FavoritePhotoCoreDataPropertiesSet = NSSet

extension FavoritePhoto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoritePhoto> {
        return NSFetchRequest<FavoritePhoto>(entityName: "FavoritePhoto")
    }

    @NSManaged public var color: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var fullUrl: String?
    @NSManaged public var height: Int32
    @NSManaged public var id: String?
    @NSManaged public var photoDescription: String?
    @NSManaged public var regularUrl: String?
    @NSManaged public var width: Int32
    @NSManaged public var user: User?

}
