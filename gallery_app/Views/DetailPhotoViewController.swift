import UIKit

final class DetailPhotoViewController: UIViewController {
    
    private let photo: ReceivedPhotoApi
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor(named: "vanilla")
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let createdDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor(named: "vanilla")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dimensionsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor(named: "vanilla")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let colorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor(named: "vanilla")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor(named: "vanilla")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(named: "vanilla")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor(named: "vanilla")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let collectionsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor(named: "vanilla")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let instagramLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor(named: "vanilla")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(photo: ReceivedPhotoApi) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
        
        title = "Photo Detail"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor(named: "vanilla") ?? .white,
            .font: UIFont.systemFont(ofSize: 20, weight: .semibold)
        ]
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "midnight")
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(imageView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(createdDateLabel)
        contentView.addSubview(dimensionsLabel)
        contentView.addSubview(colorLabel)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(collectionsLabel)
        contentView.addSubview(instagramLabel)
        
        NSLayoutConstraint.activate([

            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            createdDateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            createdDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            createdDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            dimensionsLabel.topAnchor.constraint(equalTo: createdDateLabel.bottomAnchor, constant: 8),
            dimensionsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dimensionsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            colorLabel.topAnchor.constraint(equalTo: dimensionsLabel.bottomAnchor, constant: 8),
            colorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            colorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            usernameLabel.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 16),
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            nameLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            locationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            collectionsLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
            collectionsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            instagramLabel.topAnchor.constraint(equalTo: collectionsLabel.bottomAnchor, constant: 8),
            instagramLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            instagramLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            instagramLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    private func loadData() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: ISO8601DateFormatter().date(from: photo.created_at) ?? Date())
        
        descriptionLabel.text = photo.description ?? "нет описания"
        
        createdDateLabel.text = "Created: \(dateString)"
        
        dimensionsLabel.text = "Dimensions: w: \(photo.width) * h: \(photo.height)"
        
        if let color = photo.color {
            colorLabel.text = "Color: \(color)"
        } else {
            colorLabel.text = "Color: не указан"
        }
        
        usernameLabel.text = "Username: \(photo.user.username)"
        nameLabel.text = "Name: \(photo.user.name)"
        
        if let location = photo.user.location {
            locationLabel.text = "Location: \(location)"
        } else {
            locationLabel.text = "Location: не указана"
        }
        
        if let totalCollections = photo.user.total_collections {
            collectionsLabel.text = "Collections: \(totalCollections)"
        } else {
            collectionsLabel.text = "Collections: не указано"
        }
        
        if let instagram = photo.user.instagram_username {
            instagramLabel.text = "Instagram: @\(instagram)"
        } else {
            instagramLabel.text = "Instagram: не указан"
        }
        
        if let url = URL(string: photo.urls.full) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.imageView.image = image
                    }
                }
            }.resume()
        }
    }
}
