import UIKit

final class TrackersCollectionCell: UICollectionViewCell {
    private let emoji: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "White")
        view.backgroundColor?.withAlphaComponent(0.3)
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
        label.text = "1 день"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(named: "Black")
        return label
    } ()
    
    private let plusButton = UIButton.systemButton(
        with: UIImage(systemName: "plus")!,
        target: TrackersCollectionCell.self,
        action: nil
        
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
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
        plusButton.backgroundColor = UIColor.green
        plusButton.layer.cornerRadius = 17
        
        emoji.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // emoji
            emoji.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            emoji.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            emoji.widthAnchor.constraint(equalToConstant: 24),
            emoji.heightAnchor.constraint(equalToConstant: 24),
            
            // titleLabel
            titleLabel.leadingAnchor.constraint(equalTo: emoji.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: emoji.bottomAnchor, constant: 8),
            
            // counterLabel
            counterLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            counterLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
            
            // plusButton
            plusButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            plusButton.centerYAnchor.constraint(equalTo: counterLabel.centerYAnchor),
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            plusButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
}
