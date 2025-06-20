import UIKit

final class TrackersViewController: UIViewController {
    
    //navigation bar
    @IBOutlet private weak var addTrackerButton: UIBarButtonItem!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var searchInput: UISearchBar!
    @IBOutlet private weak var datePicker: UIDatePicker!
    
    static let notificationName = NSNotification.Name("AddNewTracker")
    
    // MARK: Private properties
    private lazy var trackerStore: TrackerStoreProtocol = {
        TrackerStore(delegate: self, for: currentDate)
    }()
    
    private var currentDate: Date = Date().dayStart
    
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
    let params =  GeometricParams(columnCount: 2,
                                  rowCount: 0,
                                  leftInset: 16,
                                  rightInset: 16,
                                  topInset: 12,
                                  bottomInset: 16,
                                  columnSpacing: 10,
                                  rowSpacing: 0)
    
    private let thumbnailStateView: UIView = {
        let view = ThumbnailStateView()
        let text = "Что будем отслеживать?"
        view.config(with: text)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(thumbnailStateView)
        configureViewState()
        navigationController?.navigationBar.isHidden = false
        setupNavigationItems()
        setupTitle()
        setupSearchInput()
        setupCollectionView()
        setupConstraints()
        //        collectionView.isHidden = true
        configureViewState()
        
        NotificationCenter.default.addObserver(self, selector: #selector(addNewTracker), name: TrackersViewController.notificationName, object: nil)
    }
    
    //MARK: Actions
    
    @objc private func addNewTracker(_ notification: Notification) {
        guard let category = notification.object as? TrackerCategory,
              let tracker = category.trackers.first else {return}
        
        trackerStore.addNewTracker(tracker, to: category)
    }
    
    @objc private func addTrackerButtonDidTap() {
        print("add button tapped!")
        let viewController = AddTrackerViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .formSheet
        present(navigationController, animated: true)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = sender.date.dayStart
        datePicker.removeFromSuperview()
        
        trackerStore.updateDate(currentDate)
        collectionView.reloadData()
        configureViewState()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateFormatter.string(from: currentDate)
        let weekday = WeekDay(date: currentDate)
        print("Выбранная дата: \(formattedDate), \(weekday.name)")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: TrackersViewController.notificationName, object: nil)
    }
    
    // MARK: - Private Methods
    
    private func configureViewState() {
        collectionView.isHidden = trackerStore.isEmpty
        thumbnailStateView.isHidden = !trackerStore.isEmpty
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
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: headerIdentifier,
            for: indexPath
        ) as? TrackersCategoryHeader else {return UICollectionReusableView()}
        
        header.config(with: trackerStore.sectionName(for: indexPath.section))
        return header
    }
}



// MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
    
    // кол-во секций
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return trackerStore.numberOfSections
    }
    
    // Количество элементов в коллекции
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return trackerStore.numberOfItemsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //создаем ячейку
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellIdentifier,
            for: indexPath
        ) as? TrackersCollectionCell else {
            return UICollectionViewCell()
        }
        let completionStatus = trackerStore.completionStatus(for: indexPath)
        cell.config(with: completionStatus.tracker,
                    numberOfCompletions: completionStatus.numberOfCompletions,
                    isCompleted: completionStatus.isCompleted,
                    completionIsEnabled: currentDate <= Date().dayStart)
        cell.delegate = self
        return cell
        
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    // Метод для задания размера ячейки
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let availableWidth = collectionView.frame.width - params.totalInsetWidth
        let cellWidth =  availableWidth / CGFloat(params.columnCount)
        return CGSize(width: cellWidth, height: 148)
    }
    
    //отступы для секций в коллекциях insetForSectionAt 
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: params.topInset, left: params.leftInset, bottom: params.bottomInset, right: params.rightInset)
    }
    
    //минимальный отступ между строками коллекции
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
    
    //расстояние между столбцами
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return params.columnSpacing
    }
    
    // header
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 19)
    }
}


// MARK: - TrackerCellDelegate
extension TrackersViewController: TrackersCollectionCellDelegate {
    func trackersCellDidChangeCompletion(for cell: TrackersCollectionCell, to isCompleted: Bool) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        trackerStore.changeCompletion(for: indexPath, to: isCompleted)
    }
}

// MARK: - TrackerStoreDelegate
extension TrackersViewController: TrackerStoreDelegate {
    func didUpdate(_ update: TrackerStoreUpdate) {
        
        collectionView.performBatchUpdates({
            if !update.deletedSections.isEmpty {
                collectionView.deleteSections(IndexSet(update.deletedSections))
            }
            if !update.insertedSections.isEmpty {
                collectionView.insertSections(IndexSet(update.insertedSections))
            }
            
            collectionView.insertItems(at: update.insertedIndexes)
            collectionView.deleteItems(at: update.deletedIndexes)
            collectionView.reloadItems(at: update.updatedIndexes)
            
            for move in update.movedIndexes{
                collectionView.moveItem(at: move.from, to: move.to)
            }
        }, completion: nil)
        configureViewState()
    }
}


