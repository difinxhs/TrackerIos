import UIKit

final class LinkCell: UITableViewCell {
    
    private var titleLabel = UILabel()
    private var captionLabel = UILabel()
    
    private var stackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStackView()
        setupTitleLabel()
        setupCaptionLabel()
        accessoryType = .disclosureIndicator
        
        self.selectionStyle = .none
        self.backgroundColor = UIColor(named: "Background")
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTitleLabel() {
        titleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = UIColor(named: "Black")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupCaptionLabel() {
        captionLabel.font = .systemFont(ofSize: 17, weight: .regular)
        captionLabel.textColor = UIColor(named: "Gray")
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupStackView() {
        contentView.addSubview(stackView)
        
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(captionLabel)
    }
    
    func configure(title: String, caption: String? = nil) {
        titleLabel.text = title
        if let caption = caption, !caption.isEmpty {
            captionLabel.text = caption
            captionLabel.isHidden = false
        } else {
            captionLabel.isHidden = true
        }
    }
}
