import UIKit

class TrackersViewController: UIViewController {
    
    //navigation bar
    @IBOutlet weak var addTrackerButton: UIBarButtonItem!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchInput: UISearchBar!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    
    private var trackers: [Tracker] = []
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //collection view
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let cellIdentifier = "TrackerCell"
    let params = GeometricParams(
        cellCount: 2,
        leftInset: 16,
        rightInset: 16,
        cellSpacing: 10
    )
    
    private let thumbnailStateView: UIView = {
        let view = ThumbnailStateView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = false
        setupNavigationItems()
        setupTitle()
        setupSearchInput()
        setupConstraints()
        
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
    }
    
    // MARK: - Private Methods

       private func setupCollectionVeiw() {
           view.addSubview(collectionView)
           register()

           //DataSourse and Delegate
           collectionView.dataSource = self
           collectionView.delegate = self
       }

       private func setupConstraints() {

           //collectionView
           collectionView.translatesAutoresizingMaskIntoConstraints = false

           NSLayoutConstraint.activate([
               collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
               collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
               collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
               collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
           ])
       }

       private func register() {
           collectionView.register(TrackersCollectionCell.self, forCellWithReuseIdentifier: cellIdentifier)
       }
    
    //MARK: Layout
    
    
    
    private func thumbnailConstraints() {
        
        NSLayoutConstraint.activate([
            thumbnailStateView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            thumbnailStateView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
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
    
}

// MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
    // Количество элементов в коллекции
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        print("Data Source - numberOfItemsInSection: \(trackers.count)")
        return 50
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //создаем ячейку
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? TrackersCollectionCell else {return UICollectionViewCell()}
        return cell

    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {

    // Метод для задания размера ячейки
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth =  availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth, height: 148)
    }

    //отступы для секций в коллекциях insetForSectionAt 

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: params.leftInset, bottom: 16, right: params.rightInset)
    }

    //минимальный отступ между строками коллекции
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    //расстояние между столбцами
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return params.cellSpacing
    }
}

