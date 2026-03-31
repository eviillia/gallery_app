
public import Foundation
public import CoreData


public typealias UserCoreDataPropertiesSet = NSSet

extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var instagramUsername: String?
    @NSManaged public var location: String?
    @NSManaged public var name: String?
    @NSManaged public var totalCollections: Int64
    @NSManaged public var userId: String?
    @NSManaged public var username: String?

}
