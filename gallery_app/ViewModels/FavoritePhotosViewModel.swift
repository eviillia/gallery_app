import Foundation
import Combine

@MainActor
class FavoritePhotosViewModel: ObservableObject {
    
    @Published var favouritePhotos: [FavoritePhoto] = []
    @Published var errorMessage: String?

    private let storage = PhotoStorage.shared
    
    func loadFavoritePhotos() {
        
    }
