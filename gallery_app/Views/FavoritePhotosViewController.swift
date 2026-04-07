import UIKit
import Combine

final class FavoritePhotosViewController: UIViewController {
    
    private let viewModel = FavoritePhotosViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "нет избранных фотографий("
        label.textColor = UIColor(named: "vanilla")
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let itemSpacing: CGFloat = 8
        let columns: CGFloat = 2
        let totalSpacing = itemSpacing * (columns + 1)
        let width = UIScreen.main.bounds.width
        let cellWidth = (width - totalSpacing) / columns
        let cellHeight = cellWidth * 1.6
        
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumInteritemSpacing = itemSpacing
        layout.minimumLineSpacing = itemSpacing
        layout.sectionInset = UIEdgeInsets(top: itemSpacing, left: itemSpacing, bottom: itemSpacing, right: itemSpacing)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(named: "midnight")
        cv.register(PhotoCellView.self, forCellWithReuseIdentifier: PhotoCellView.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.loadFavoritePhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadFavoritePhotos()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "midnight")
        
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor(named: "vanilla") ?? .white,
            .font: UIFont.systemFont(ofSize: 20, weight: .semibold)
        ]
        
        view.addSubview(collectionView)
        view.addSubview(emptyStateLabel)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func bindViewModel() {
        viewModel.$favouritePhotos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] photos in
                self?.collectionView.reloadData()
                self?.emptyStateLabel.isHidden = !photos.isEmpty
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                if let message = message, !message.isEmpty {
                    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alert, animated: true)
                }
            }
            .store(in: &cancellables)
    }
    
    private func openDetail(for photo: FavoritePhoto) {
        var allPhotos: [ReceivedPhotoApi] = []
        var currentIndex = 0
        
        for (idx, favPhoto) in viewModel.favouritePhotos.enumerated() {
            let urls = urlsApi(
                regular: favPhoto.regularUrl ?? "",
                full: favPhoto.fullUrl ?? ""
            )
            let user = UserApi(
                id: favPhoto.user?.userId ?? "",
                username: favPhoto.user?.username ?? "",
                name: favPhoto.user?.name ?? "",
                location: favPhoto.user?.location,
                total_collections: Int(favPhoto.user?.totalCollections ?? 0),
                instagram_username: favPhoto.user?.instagramUsername
            )
            let unsplashPhoto = ReceivedPhotoApi(
                id: favPhoto.id ?? "",
                created_at: "",
                width: Int(favPhoto.width),
                height: Int(favPhoto.height),
                color: favPhoto.color,
                description: favPhoto.altDescription,
                alt_description: favPhoto.altDescription,
                urls: urls,
                user: user
            )
            allPhotos.append(unsplashPhoto)
            if favPhoto.id == photo.id {
                currentIndex = idx
            }
        }
        
        let detailVC = DetailPhotoViewController(photo: allPhotos[currentIndex], allPhotos: allPhotos, index: currentIndex)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension FavoritePhotosViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.favouritePhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCellView.identifier, for: indexPath) as! PhotoCellView
        
        let photo = viewModel.favouritePhotos[indexPath.item]
        
        let urls = urlsApi(
            regular: photo.regularUrl ?? "",
            full: photo.fullUrl ?? ""
        )
        
        let user = UserApi(
            id: photo.user?.userId ?? "",
            username: photo.user?.username ?? "",
            name: photo.user?.name ?? "",
            location: photo.user?.location,
            total_collections: Int(photo.user?.totalCollections ?? 0),
            instagram_username: photo.user?.instagramUsername
        )
        
        let unsplashPhoto = ReceivedPhotoApi(
            id: photo.id ?? "",
            created_at: "",
            width: Int(photo.width),
            height: Int(photo.height),
            color: photo.color,
            description: photo.photoDescription,
            alt_description: photo.altDescription,
            urls: urls,
            user: user
        )
        
        cell.configure(with: unsplashPhoto, isFavourite: true)
        
        cell.onHeartTapped = { [weak self] photoId in
            self?.viewModel.removeFromFavorites(photoId: photoId)
        }
        
        cell.onCellTapped = { [weak self] _ in
            self?.openDetail(for: photo)
        }
        
        return cell
    }
}
