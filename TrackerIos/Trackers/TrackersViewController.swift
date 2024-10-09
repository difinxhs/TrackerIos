import UIKit

class TrackersViewController: UIViewController {
    
    @IBOutlet weak var addTrackerButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchInput: UISearchBar!
    @IBOutlet weak var datePicker: UIDatePicker!
    private var thumbnailView: UIView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupAddTrackerButton()
        setupDatePicker()
        setupTitle()
        setupSearchInput()
        setupThumbnail()
        
    }
    
    private func setupAddTrackerButton() {
        let addTrackerButton = UIButton.systemButton(
            with: UIImage(named: "add_tracker_icon")!,
            target: self,
            action: nil
        )
        addTrackerButton.tintColor = UIColor(named: "Black")
        addTrackerButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addTrackerButton)
        NSLayoutConstraint.activate([
            addTrackerButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6),
            addTrackerButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0)
        ])
        addTrackerButton.accessibilityIdentifier = "addTrackerButton"
        self.addTrackerButton = addTrackerButton
    }
    
    private func setupDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        let dateLabel = UILabel()
        dateLabel.textColor = .black
        dateLabel.font = UIFont.systemFont(ofSize: 17)
        dateLabel.textAlignment = .right
        
        view.addSubview(datePicker)
        view.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            datePicker.centerYAnchor.constraint(equalTo: addTrackerButton.centerYAnchor)
        ])
        self.datePicker = datePicker
    }
    
    private func setupTitle() {
        let titleLabel = UILabel()
        titleLabel.text = "Трекеры"
        titleLabel.textColor = UIColor(named: "Black")
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: UIFont.Weight.bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: addTrackerButton.bottomAnchor, constant: 8)
        ])
        self.titleLabel = titleLabel
    }
    
    private func setupSearchInput() {
        let searchInput = UISearchBar()
        searchInput.placeholder = "Поиск"
        searchInput.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchInput)
        NSLayoutConstraint.activate([
            searchInput.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            searchInput.trailingAnchor.constraint(equalTo: datePicker.trailingAnchor),
            searchInput.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            searchInput.heightAnchor.constraint(equalToConstant: 36)
        ])
        self.searchInput = searchInput
    }
    
    private func setupThumbnail() {
        let thumbnailView = UIView()
        thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "star_thumbnail")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(named: "Black")
        label.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        
        thumbnailView.addSubview(stackView)
        
        view.addSubview(thumbnailView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            stackView.centerXAnchor.constraint(equalTo: thumbnailView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: thumbnailView.centerYAnchor),
            
            thumbnailView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            thumbnailView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            thumbnailView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            thumbnailView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        self.thumbnailView = thumbnailView
    }
}

