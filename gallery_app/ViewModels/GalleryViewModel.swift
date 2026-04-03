import Foundation
import Combine

@MainActor
class GalleryViewModel: ObservableObject {

    @Published var photos: [ReceivedPhotoApi] = []
    @Published var errorMessage: String?

    private let apiService = UnsplashService()
    private let storage = PhotoStorage.shared

    private var currentPage = 1
    private var isPageLoading = false
    
    func getPhotos() async {
        
        if isPageLoading {
            return
        }
        
        isPageLoading = true
        
        do {
            let newPhotos = try await apiService.fetchPhotos(page: currentPage, perPage: 30)
            
            if newPhotos.isEmpty {
                isPageLoading = false
                return
            }
            
            photos.append(contentsOf: newPhotos)
            currentPage += 1
            isPageLoading = false
            
        } catch {
            errorMessage = "ошибка: \(error.localizedDescription)"
            isPageLoading = false
        }
    }
    

    
    func toggleFavoriteStatus(for photo: ReceivedPhotoApi) {
        let isFavourite = storage.isFavourite(photoId: photo.id)
        
        if isFavourite {
            try? storage.removeFavoritePhoto(photoId: photo.id)
        } else {
            try? storage.addPhotoToFavourites(photo)
        }
    }

    
    func getNewPhotos(currentIndex: Int) {
        if currentIndex >= photos.count - 6 && !isPageLoading {
                   Task {
                       await getPhotos()
            }
        }
    }
}
