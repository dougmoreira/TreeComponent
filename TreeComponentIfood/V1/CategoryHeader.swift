import UIKit

protocol CategoryHeaderDelegate: AnyObject {
    func didSelectHeader(at index: Int)
}

class CategoryHeader: UITableViewHeaderFooterView {
    
    var index: Int = 0
    weak var delegate: CategoryHeaderDelegate?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "section"
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func didTapHeader() {
        delegate?.didSelectHeader(at: index)
    }
    
    private func setup() {
        addSubview(titleLabel)
        setupConstraints()
        setupGestures()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                titleLabel.topAnchor.constraint(equalTo: topAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
                titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            ]
        )
    }
    
    private func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapHeader))
        contentView.addGestureRecognizer(tap)
    }
}
