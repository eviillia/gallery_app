import UIKit
import Combine

final class GalleryViewController: UIViewController {

    private let viewModel = GalleryViewModel()
    private var cancellables = Set<AnyCancellable>()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Photo gallery"
        label.textColor = UIColor(named: "vanilla")
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
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

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(named: "midnight")
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()

        Task {
            await viewModel.getPhotos()
        }
    }

    private func setupUI() {
        view.backgroundColor = UIColor(named: "midnight")

        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.addSubview(errorLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            titleLabel.heightAnchor.constraint(equalToConstant: 44),

            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func bindViewModel() {
        viewModel.$photos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.errorLabel.text = message
                if message == nil || message?.isEmpty == true {
                    self?.errorLabel.isHidden = true
                } else {
                    self?.errorLabel.isHidden = false
                }
            }
            .store(in: &cancellables)
    }

    private func openDetail(for photoId: String) {
        let foundPhoto = viewModel.photos.first { $0.id == photoId }
        if let photo = foundPhoto {
            let detailVC = DetailPhotoViewController(photo: photo)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

extension GalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoCell.identifier,
            for: indexPath
        ) as! PhotoCell

        let photo = viewModel.photos[indexPath.item]
        cell.configure(with: photo, isFavourite: viewModel.isFavourite(photoId: photo.id))

        cell.onHeartTapped = { [weak self] photoId in
            if let self = self,
               let photo = self.viewModel.photos.first(where: { $0.id == photoId }) {
                self.viewModel.toggleFavoriteStatus(for: photo)
                collectionView.reloadItems(at: [indexPath])
            }
        }

        cell.onCellTapped = { [weak self] photoId in
            self?.openDetail(for: photoId)
        }

        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height - 100 {
            viewModel.getNewPhotos(currentIndex: viewModel.photos.count - 1)
        }
    }
}
