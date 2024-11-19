import UIKit

class TrackersViewController: UIViewController {
    
    //navigation bar
    @IBOutlet weak var addTrackerButton: UIBarButtonItem!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchInput: UISearchBar!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    private var currentDate: Date = Date()
    private var completedIds: Set<UUID> = []
    private var allTrackers: [Tracker] = []
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //collection view
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let cellIdentifier = "TrackerCell"
    private let headerIdentifier = "Header"
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
        makeMockData()
        view.addSubview(thumbnailStateView)
        navigationController?.navigationBar.isHidden = false
        setupNavigationItems()
        setupTitle()
        setupSearchInput()
        setupCollectionView()
        setupConstraints()
        collectionView.isHidden = true
        
    }
    
    //MARK: Actions
    
    @objc private func addTrackerButtonDidTap() {
        print("add button tapped!")
        let viewController = AddTrackerViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .formSheet
        present(navigationController, animated: true)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
        datePicker.removeFromSuperview()
        
        update()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateFormatter.string(from: currentDate)
        let weekday = WeekDay(date: currentDate)
        print("Выбранная дата: \(formattedDate), \(weekday.name)")
    }
    
    // MARK: - Private Methods
    
    private func makeMockData() {
        let t1 = Tracker(id: UUID(), name: "Поливать растения", color: UIColor(red: 51/255.0, green: 207/255.0, blue: 105/255.0, alpha: 1), emoji: "🌺", days: [.monday, .friday])
        let t2 = Tracker(id: UUID(), name: "Кошка заслонила камеру на созвоне", color: UIColor(red: 255/255.0, green: 136/255.0, blue: 30/255.0, alpha: 1), emoji: "😻", days: [.tuesday, .thursday, .saturday])
        let t3 = Tracker(id: UUID(), name: "Бабушка прислала открытку в вотсапе", color: UIColor(red: 255/255.0, green: 103/255.0, blue: 77/255.0, alpha: 1), emoji: "❤️", days: [.wednesday])
        //        let category = TrackerCategory(title: "Домашний уют", trackers: [t1, t2, t3])
        //        categories.append(category)
        
        let t4 = Tracker(id: UUID(), name: "Свидания в апреле", color: UIColor(red: 173/255.0, green: 86/255.0, blue: 218/255.0, alpha: 1), emoji: "💫", days: [.monday, .friday])
        let t5 = Tracker(id: UUID(), name: "Хорошее настроение", color: UIColor(red: 249/255.0, green: 212/255.0, blue: 212/255.0, alpha: 1), emoji: "🚴‍♂️", days: [.tuesday, .thursday, .saturday])
        let t6 = Tracker(id: UUID(), name: "Тест 3", color: UIColor(red: 246/255.0, green: 196/255.0, blue: 139/255.0, alpha: 1), emoji: "🚴‍♂️", days: [.tuesday, .thursday, .saturday])
        //        let category2 = TrackerCategory(title: "Радостные мелочи", trackers: [t4, t5, t6])
        //        categories.append(category2)
        allTrackers.append(contentsOf: [t1, t2, t3, t4, t5, t6])
        update()
    }
    
    private func update() {
        let completedIrregulars = Set(
            allTrackers.filter { tracker in
                !tracker.isRegular &&
                completedTrackers.first { $0.trackerId == tracker.id } != nil
            }
        )
        completedIds = Set(
            completedTrackers
                .filter { Calendar.current.isDate($0.date, inSameDayAs: currentDate) }
                .map { $0.trackerId }
        )
        
        let weekday = WeekDay(date: currentDate)
        let selectedTrackers = allTrackers.filter { tracker in
            if let days = tracker.days {
                return days.contains(weekday)
            } else {
                return completedIds.contains(tracker.id) || !completedIrregulars.contains(tracker)
            }
        }
        categories = selectedTrackers.isEmpty ? [] : [TrackerCategory(title: "Общая категория", trackers: selectedTrackers)]
        
        collectionView.reloadData()
        
        collectionView.isHidden = selectedTrackers.isEmpty
        thumbnailStateView.isHidden = !selectedTrackers.isEmpty
    }
    
    private func setupCollectionView() {
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
            collectionView.topAnchor.constraint(equalTo: searchInput.bottomAnchor, constant: 16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        //thumbnailStateView
        NSLayoutConstraint.activate([
            thumbnailStateView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            thumbnailStateView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func register() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(TrackersCollectionCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(TrackersCategoryHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
    
    
    //MARK: Layout
    
    private func setupNavigationItems() {
        let addButton = UIBarButtonItem(
            image: UIImage(named: "add_tracker_icon"),
            style: .plain,
            target: self,
            action: #selector(addTrackerButtonDidTap)
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

// MARK: - UICollectionViewDelegate
extension TrackersViewController: UICollectionViewDelegate {
    
    //header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as? TrackersCategoryHeader else {return UICollectionReusableView()}
        
        header.config(with: categories[indexPath.section])
        return header
    }
}



// MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
    
    // кол-во секций
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    
    // Количество элементов в коллекции
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //создаем ячейку
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? TrackersCollectionCell else {return UICollectionViewCell()}
        cell.prepareForReuse()
        cell.config(with: categories[indexPath.section].trackers[indexPath.row])
        return cell
        
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
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
    
    // header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 19)
    }
}

