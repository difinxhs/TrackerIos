import UIKit

final class TrackersCollectionCell: UICollectionViewCell {
    
    private let cardView: UIView = {
            let view = UIView()
            view.layer.cornerRadius = 16
            view.clipsToBounds = true
            return view
        }()
        
        private let emoji: UIView = {
            let view = UIView()
            view.backgroundColor = .white.withAlphaComponent(0.3)
            view.layer.cornerRadius = 12
            view.clipsToBounds = true
            
            let emojiLabel = UILabel()
            emojiLabel.text = "❤️"
            emojiLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(emojiLabel)
            NSLayoutConstraint.activate([
                emojiLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                emojiLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
            return view
        }()
        
        private let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "Tracker"
            label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            label.textColor = .white
            label.numberOfLines = 0
            return label
        }()
        
        private let counterLabel: UILabel = {
            let label = UILabel()
            label.text = "0 дней"
            label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            label.textColor = .black
            return label
        }()
        
        private let statsStack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.spacing = 8
            stack.alignment = .center
            return stack
        }()
    
    private let plusButton = UIButton(type: .system)
    private var isCompleted: Bool = false
    private var completionCount: Int = 0
    private var currentDate: Date = Date()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
            super.prepareForReuse()
            titleLabel.text = nil
            counterLabel.text = "0 дней"
            isCompleted = false
            completionCount = 0
            plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        }
    
    func configure(with title: String) {
        titleLabel.text = title
        titleLabel.numberOfLines = 0 // Разрешаем перенос строк
        titleLabel.lineBreakMode = .byWordWrapping
        
        // Обновляем цвет ячейки случайным образом из предопределенных цветов
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
        
        self.backgroundColor = colors.randomElement() ?? .gray
        
        // Настраиваем кнопку
        plusButton.tintColor = .white
        plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
    }
    
    private func setupView() {
            // Добавляем основную карточку
            contentView.addSubview(cardView)
            cardView.translatesAutoresizingMaskIntoConstraints = false
            
            // Добавляем элементы в карточку
            cardView.addSubview(emoji)
            cardView.addSubview(titleLabel)
            
            // Добавляем нижний стек с счетчиком и кнопкой
            contentView.addSubview(statsStack)
            statsStack.addArrangedSubview(counterLabel)
            statsStack.addArrangedSubview(plusButton)
            
            // Настраиваем кнопку
            plusButton.backgroundColor = UIColor(named: "Color selection 5")
            plusButton.layer.cornerRadius = 17
            plusButton.tintColor = .white
            plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
            
            // Устанавливаем констрейнты
            NSLayoutConstraint.activate([
                // Карточка
                cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
                cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                cardView.heightAnchor.constraint(equalToConstant: 90),
                
                // Эмодзи
                emoji.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
                emoji.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
                emoji.widthAnchor.constraint(equalToConstant: 24),
                emoji.heightAnchor.constraint(equalToConstant: 24),
                
                // Заголовок
                titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
                titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
                titleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
                
                // Стек с счетчиком и кнопкой
                statsStack.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 8),
                statsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
                statsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
                
                // Кнопка плюс
                plusButton.widthAnchor.constraint(equalToConstant: 34),
                plusButton.heightAnchor.constraint(equalToConstant: 34)
            ])
            
            // Делаем все view translatesAutoresizingMaskIntoConstraints = false
            [emoji, titleLabel, statsStack, plusButton].forEach { view in
                view.translatesAutoresizingMaskIntoConstraints = false
            }
        }
    
    private func setupButtonAction() {
        plusButton.addTarget(self, action: #selector(didTapPlusButton), for: .touchUpInside)
    }
    
    @objc private func didTapPlusButton() {
        if isCompleted {
            isCompleted = false
            completionCount -= 1
            plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        } else {
            isCompleted = true
            completionCount += 1
            plusButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        }
        
        updateCounterLabel()
    }
    
    private func updateCounterLabel() {
        counterLabel.text = "\(completionCount) " + (completionCount == 1 ? "день" : "дней")
    }
    
    func configure(with date: Date, initialCompletionCount: Int) {
        currentDate = date
        completionCount = initialCompletionCount
        updateCounterLabel()
        
        if Calendar.current.isDateInToday(currentDate) && isCompleted {
            plusButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        } else {
            plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        }
    }
}
