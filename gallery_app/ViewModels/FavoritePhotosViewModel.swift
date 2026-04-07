import Foundation
import Combine

@MainActor
class FavoritePhotosViewModel: ObservableObject {

    @Published var favouritePhotos: [FavoritePhoto] = []
    @Published var errorMessage: String?

    private let storage = PhotoStorage.shared

    func loadFavoritePhotos() {
        do {
            favouritePhotos = try storage.fetchFavoritePhotos()
        } catch {
            errorMessage = "ошибка загрузки: \(error.localizedDescription)"
        }
    }

    func removeFromFavorites(photoId: String) {
        do {
            try storage.removeFavoritePhoto(photoId: photoId)
            loadFavoritePhotos()
        } catch {
            errorMessage = "ошибка удаления: \(error.localizedDescription)"
        }
    }

    func isFavorite(photoId: String) -> Bool {
        return storage.isFavourite(photoId: photoId)
    }
}
