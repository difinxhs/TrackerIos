import UIKit

final class TrackersCollectionCell: UICollectionViewCell {
    private let emoji: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "White")?.withAlphaComponent(0.3)
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
    } ()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Tracker"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(named: "White")
        return label
    } ()
    
    private let counterLabel: UILabel = {
        let label = UILabel()
        label.text = "0 дней"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(named: "Black")
        return label
    } ()
    
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
    
    private func setupView() {
        self.backgroundColor = UIColor.green
        self.layer.cornerRadius = 12
        
        addSubview(emoji)
        addSubview(titleLabel)
        addSubview(counterLabel)
        addSubview(plusButton)
        
        plusButton.backgroundColor = UIColor(named: "Color selection 5")
        plusButton.layer.cornerRadius = 17
        plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        
        emoji.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emoji.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            emoji.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            emoji.widthAnchor.constraint(equalToConstant: 24),
            emoji.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: emoji.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: emoji.bottomAnchor, constant: 8),
            
            counterLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            counterLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
            
            plusButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            plusButton.centerYAnchor.constraint(equalTo: counterLabel.centerYAnchor),
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            plusButton.heightAnchor.constraint(equalToConstant: 34)
        ])
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
