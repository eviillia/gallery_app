import Foundation
import Combine

@MainActor
class PhotoDetailsViewModel: ObservableObject {

    @Published var currentPhoto: ReceivedPhotoApi
    @Published var errorMessage: String?

    private let storage = PhotoStorage.shared

    private let allPhotos: [ReceivedPhotoApi]
    private var currentIndex: Int

    init(photo: ReceivedPhotoApi, allPhotos: [ReceivedPhotoApi], index: Int) {
        self.currentPhoto = photo
        self.allPhotos = allPhotos
        self.currentIndex = index
    }

    var isFavorite: Bool {
        return storage.isFavourite(photoId: currentPhoto.id)
    }

    func toggleFavoriteStatus() {
        let isFavourite = storage.isFavourite(photoId: currentPhoto.id)

        if isFavourite {
            try? storage.removeFavoritePhoto(photoId: currentPhoto.id)
        } else {
            try? storage.addPhotoToFavourites(currentPhoto)
        }

        objectWillChange.send()
    }

    func moveToNextPhoto() -> Bool {
        if currentIndex + 1 < allPhotos.count {
            currentIndex += 1
            currentPhoto = allPhotos[currentIndex]
            return true
        } else {
            return false
        }
    }

    func moveToBackPhoto() -> Bool {
        if currentIndex - 1 >= 0 {
            currentIndex -= 1
            currentPhoto = allPhotos[currentIndex]
            return true
        } else {
            return false
        }
    }

    func hasNextPhoto() -> Bool {
        return currentIndex + 1 < allPhotos.count
    }

    func hasPreviousPhoto() -> Bool {
        return currentIndex - 1 >= 0
    }

}
