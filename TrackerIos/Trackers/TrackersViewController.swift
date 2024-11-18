import UIKit

class TrackersViewController: UIViewController {
    
    @IBOutlet weak var addTrackerButton: UIBarButtonItem!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchInput: UISearchBar!
    @IBOutlet weak var datePicker: UIDatePicker!
    private var thumbnailView: UIView?
    
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
        
    init() {
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.register(TrackersCollectionCell.self, forCellWithReuseIdentifier: "TrackerCell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = false
        setupNavigationItems()
        setupTitle()
        setupSearchInput()
        view.addSubview(thumbnailStateView)
        thumbnailConstraints()
        
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
    }
    
    //MARK: Layout
    
    
    private func setupNavigationItems() {
        let addButton = UIBarButtonItem(
            image: UIImage(named: "add_tracker_icon"),
            style: .plain,
            target: self,
            action: nil
        )
        addButton.tintColor = UIColor(named: "Black")
        navigationItem.leftBarButtonItem = addButton
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.preferredDatePickerStyle = .compact
        let datePickerItem = UIBarButtonItem(customView: datePicker)
        navigationItem.rightBarButtonItem = datePickerItem
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        NSLayoutConstraint.activate([
                    datePicker.widthAnchor.constraint(equalToConstant: 100)
                ])
        
        self.addTrackerButton = addButton
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
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        ])
        self.titleLabel = titleLabel
    }
    
    private func setupSearchInput() {
        let searchInput = UISearchBar()
        searchInput.placeholder = "Поиск"
        searchInput.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchInput)
        NSLayoutConstraint.activate([
            searchInput.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            searchInput.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            searchInput.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            searchInput.heightAnchor.constraint(equalToConstant: 36)
        ])
        self.searchInput = searchInput
    }
    
    private let thumbnailStateView: UIView = {
        let view = ThumbnailStateView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private func thumbnailConstraints() {

            NSLayoutConstraint.activate([
                thumbnailStateView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                thumbnailStateView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
            ])
        }
}


