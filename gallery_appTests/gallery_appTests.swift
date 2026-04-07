import Testing
import CoreData
@testable import gallery_app

@Suite("PhotoStorage Tests")
struct PhotoStorageTests {

    var storage: PhotoStorage!
    var context: NSManagedObjectContext!

    init() throws {
        let container = NSPersistentContainer(name: "gallery_app")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load in-memory store: \(error)")
            }
        }
        context = container.viewContext
        storage = PhotoStorage(context: context)
    }

    @Test("добавить фото в избранное")
    func addPhotoToFavourites() throws {
        let photo = createTestPhoto(id: "1")
        try storage.addPhotoToFavourites(photo)
        #expect(storage.isFavourite(photoId: "1") == true)
    }
    
    @Test("добавить фото с опциональными полями")
    func addPhotoWithNilFields() throws {
        let urls = UrlsApi(regular: "https://example.com", full: "https://example.com")
        let user = UserApi(
            id: "user111",
            username: "user",
            name: "User User",
            location: nil,
            total_collections: nil,
            instagram_username: nil
        )
        let photo = ReceivedPhotoApi(
            id: "photo111",
            created_at: "2024-01-01T00:00:00Z",
            width: 100,
            height: 100,
            color: nil,
            description: nil,
            alt_description: nil,
            urls: urls,
            user: user
        )
        try storage.addPhotoToFavourites(photo)
        #expect(storage.isFavourite(photoId: "photo111") == true)
    }

    private func createTestPhoto(id: String) -> ReceivedPhotoApi {
        let urls = UrlsApi(regular: "https://test.com", full: "https://test.com")
        let user = UserApi(
            id: "user1",
            username: "user",
            name: "User User",
            location: nil,
            total_collections: nil,
            instagram_username: nil
        )
        return ReceivedPhotoApi(
            id: id,
            created_at: "2024-01-01T00:00:00Z",
            width: 100,
            height: 100,
            color: "#FFFFFF",
            description: "Test photo \(id)",
            alt_description: "Test photo1 \(id)",
            urls: urls,
            user: user
        )
    }
}
