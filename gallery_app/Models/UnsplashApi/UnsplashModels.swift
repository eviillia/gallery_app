import Foundation

struct ReceivedPhotoApi: Codable, Sendable {
    let id: String
    let created_at: String
    let width: Int
    let height: Int
    let color: String
    let description: String
    let urls: urlsApi
    let user: UserApi
}

struct urlsApi: Codable, Sendable {
    let regular: String
    let full: String
}

struct UserApi: Codable, Sendable {
    let id: String
    let username: String
    let name: String
    let location: String
    let total_collections: Int
    let instagram_username: String
}
