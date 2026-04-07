import UIKit

class PhotoCellView: UICollectionViewCell {
    
    static let identifier = "PhotoCell"
    
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor(named: "midnight")
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private lazy var heartButton: UIButton = {
        let button = UIButton(type: .custom)
        let normalImage = UIImage(systemName: "heart")
        let selectedImage = UIImage(systemName: "heart.fill")?
            .withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        
        button.setImage(normalImage, for: .normal)
        button.setImage(selectedImage, for: .selected)

        return button
    }()
    
    
    private var currentPhotoId: String?
    
    var onHeartTapped: ((String) -> Void)?
    
    var onCellTapped: ((String) -> Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(named: "vanilla")
        contentView.layer.cornerRadius = 10
        
        contentView.addSubview(photoImageView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(heartButton)
        
        heartButton.addTarget(self, action: #selector(heartTapped), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        contentView.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = contentView.bounds.width
        let height = contentView.bounds.height
        
        
        let cellUnitWidth = width / 10
        let cellUnitHeight = height / 16
        
        photoImageView.frame = CGRect(
            x: cellUnitWidth * 1,
            y: cellUnitHeight * 3,
            width: cellUnitWidth * 8,
            height: cellUnitHeight * 9
        )
        
        
        descriptionLabel.frame = CGRect(
            x: cellUnitWidth * 2,
            y: photoImageView.frame.maxY + cellUnitHeight * 1,
            width: cellUnitWidth * 6,
            height: cellUnitHeight * 2
        )
        
        
        let heartSize = min(cellUnitWidth, cellUnitHeight) * 1.5
        
        
        heartButton.frame = CGRect(
            x: width - cellUnitWidth * 1 - heartSize,
            y: cellUnitHeight * 1,
            width: heartSize,
            height: heartSize
        )
    }
    
    func configure(with photo: ReceivedPhotoApi, isFavourite: Bool) {
        currentPhotoId = photo.id
        heartButton.isSelected = isFavourite
        descriptionLabel.text = photo.description ?? photo.alt_description ?? "нет описания"
        
        if let url = URL(string: photo.urls.regular) {
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.photoImageView.image = image
                    }
                }
            }
            task.resume()
        }
    }
    
    @objc private func heartTapped() {
        heartButton.isSelected.toggle()
        
        if let photoId = currentPhotoId {
            onHeartTapped?(photoId)
        }
    }
    
    @objc private func cellTapped() {
        if let photoId = currentPhotoId {
            onCellTapped?(photoId)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        descriptionLabel.text = nil
        heartButton.isSelected = false
        currentPhotoId = nil
    }
}
