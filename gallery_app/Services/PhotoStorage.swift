import CoreData
import UIKit

class PhotoStorage {
    static let shared = PhotoStorage()
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
    }
    
    func addPhotoToFavourites(_ photo: ReceivedPhotoApi) throws {
        let request = FavoritePhoto.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", photo.id)

        if let existingPhoto = try context.fetch(request).first {
            return
        }
        
        let user = User(context: context)
        user.userId = photo.user.id
        user.username = photo.user.username
        user.name = photo.user.name
        user.location = photo.user.location
        user.instagramUsername = photo.user.instagram_username
        user.totalCollections = Int64(photo.user.total_collections ?? 0)
        
        let newPhoto = FavoritePhoto(context: context)
        newPhoto.id = photo.id
        newPhoto.regularUrl = photo.urls.regular
        newPhoto.fullUrl = photo.urls.full
        newPhoto.user = user
        newPhoto.createdAt = ISO8601DateFormatter().date(from: photo.created_at) ?? Date()
        newPhoto.width = Int32(photo.width)
        newPhoto.height = Int32(photo.height)
        newPhoto.color = photo.color
        newPhoto.photoDescription = photo.description
        newPhoto.altDescription = photo.alt_description
        
        try context.save()
    }
    
    func removeFavoritePhoto(photoId: String) throws {
        let request = FavoritePhoto.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", photoId)
        
        if let photoToDelete = try context.fetch(request).first {
            context.delete(photoToDelete)
            try context.save()
        }
    }
    
    
    func fetchFavoritePhotos() throws -> [FavoritePhoto] {
        let request = FavoritePhoto.fetchRequest()
        return try context.fetch(request)
    }
    

    func isFavourite(photoId: String) -> Bool {
        let request = FavoritePhoto.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", photoId)
        return (try? context.count(for: request)) ?? 0 > 0
    }
}
