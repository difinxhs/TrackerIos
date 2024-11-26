import UIKit

final class NewTrackerVC: UIViewController {
    
    // MARK: - Private Properties
    
    private let cancelButton = ActionButton(type: .system)
    private let createButton = ActionButton(type: .system)
    private let buttonStackView = UIStackView()
    
    private var name: String = ""
    private var days: Set<WeekDay>?
    
    // TableView
    private let tableView = UITableView()
    private let textCellID = "TextCell"
    private let linkCellID = "LinkCell"
    
    // MARK: - Init
    
    // тип экрана
    enum TrackerType {
        case regular
        case irregular
    }
    
    private var trackerType: TrackerType
    
    // Инициализатор для передачи типа экрана
    init(trackerType: TrackerType) {
        self.trackerType = trackerType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupCancelButton()
        setupCreateButton()
        setupButtonStackView()
        configureViewState()
        
        configureUI()
        
        setupTableView()
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Private Methods
    
    private func setupCancelButton() {
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        cancelButton.setTitleColor(UIColor(named: "Red"), for: .normal)
        cancelButton.backgroundColor = UIColor(named: "White")
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor(named: "Red")?.cgColor
        
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cancelButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupCreateButton() {
        createButton.setTitle("Сохранить", for: .normal)
        createButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        
        createButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            createButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func configureViewState() {
        let daysAreValid = days?.isEmpty == false || trackerType == .irregular
        createButton.isEnabled = !name.isEmpty && daysAreValid
    }
    
    private func setupButtonStackView() {
        view.addSubview(buttonStackView)
        
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 8
        buttonStackView.distribution = .fillEqually
        
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(createButton)
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureUI() {
        
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor(named: "Black") as Any
        ]
        
        switch trackerType {
        case .regular:
            title = "Новая Привычка"
        case .irregular:
            title = "Нерегулярное событие"
        }
    }
    
    //TableView
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(TextCell.self, forCellReuseIdentifier: textCellID)
        tableView.register(LinkCell.self, forCellReuseIdentifier: linkCellID)
        
        // delegate, dataSource
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    
    // MARK: - Actions
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func cancelButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        let colors = [
            UIColor(named: "Color selection 1"),
            UIColor(named: "Color selection 2"),
            UIColor(named: "Color selection 3"),
            UIColor(named: "Color selection 4"),
            UIColor(named: "Color selection 5"),
            UIColor(named: "Color selection 6"),
            UIColor(named: "Color selection 7"),
            UIColor(named: "Color selection 8"),
            UIColor(named: "Color selection 9"),
            UIColor(named: "Color selection 10"),
            UIColor(named: "Color selection 11"),
            UIColor(named: "Color selection 12"),
            UIColor(named: "Color selection 13"),
            UIColor(named: "Color selection 14"),
            UIColor(named: "Color selection 15"),
            UIColor(named: "Color selection 16"),
            UIColor(named: "Color selection 17"),
            UIColor(named: "Color selection 18")
        ].compactMap { $0 }
        
        guard let randomColor = colors.randomElement() else {return}
        
        guard let emoji = [
            "🌺", "😻", "❤️", "💫", "🥇","🌞", "🌙", "⭐️","🍀", "🌿", "🌳","🍎", "🥑", "🍒","🏃‍♂️", "🚴‍♀️","🎨", "🎸", "🎮", "🎧", "📚", "✍️","💡", "💻","😇", "🤗", "🥰", "😴", "🤓", "😎","🌍", "✈️", "🚀", "🚲", "🏕️","🎉", "🎈", "🎂", "🎁", "🎄"
        ].randomElement() else { return }
        let tracker = Tracker(id: UUID(), name: name, color: randomColor, emoji: emoji, days: days)
        NotificationCenter.default.post(name: TrackersViewController.notificationName, object: tracker)
        self.dismiss(animated: true)
    }
}

extension NewTrackerVC: UITableViewDataSource, UITableViewDelegate {
    
    // количество секций (по умолчанию 1)
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // количество ячеек в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch trackerType {
        case .regular:
            return section == 0 ? 1 : 2
        case .irregular:
            return 1
        }
    }
    // Настройка ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return configureTextCell(for: tableView, at: indexPath)
            
        case 1:
            return configureLinkCell(for: tableView, at: indexPath)
            
        default:
            return UITableViewCell()
        }
    }
    
    private func configureTextCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: textCellID, for: indexPath) as? TextCell else {
            return UITableViewCell()
        }
        tableView.applyCornerRadius(to: cell, at: indexPath)
        cell.onTextChange = { [weak self] text in
            self?.name = text
            self?.configureViewState()
        }
        return cell
    }
    
    private func configureLinkCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: linkCellID, for: indexPath) as? LinkCell else {
            return UITableViewCell()
        }
        
        tableView.addSeparatorIfNeeded(to: cell, at: indexPath)
        tableView.applyCornerRadius(to: cell, at: indexPath)
        
        let (title, caption) = getTitleAndCaptionForLinkCell(at: indexPath.row)
        cell.configure(title: title, caption: caption)
        
        
        return cell
    }
    
    private func getTitleAndCaptionForLinkCell(at row: Int) -> (String, String) {
        switch row {
        case 0:
            return ("Категория", "Общая категория")
        case 1:
            let caption: String
            if let days, days.count == WeekDay.allCases.count {
                caption = "Каждый день"
            } else {
                caption = days?.map { $0.shortName }.joined(separator: ", ") ?? ""
            }
            return ("Расписание", caption)
        default:
            return ("", "")
        }
    }
    
    
    // Обработка нажатий на ячейку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = ScheduleViewController(days: days)
        viewController.onCompletion = { [weak self] result in
            self?.days = result
            self?.tableView.reloadData()
            self?.configureViewState()
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // высота ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    // отступы между секциями
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 24
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
}
