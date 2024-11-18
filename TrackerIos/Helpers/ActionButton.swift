import UIKit

final class ActionButton: UIButton {
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle()
    }
    
    private func setupStyle() {
        self.setTitleColor(UIColor(named: "White"), for: .normal)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 16
        self.backgroundColor = UIColor(named: "Black")
    }
}
