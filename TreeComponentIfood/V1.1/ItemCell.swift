import UIKit

class ItemCell: UITableViewCell {
    
    struct ViewModel {
        let replacedItemName: String
        let replacedItemPrice: String
        let originalItemName: String?
        let originalItemPrice: String?
    }
    
    let replacedItemName: UILabel = {
        let label = UILabel()
        label.text = "replacedItemName - itemCell"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let originalItemNameLabel: UILabel = {
        let label = UILabel()
        label.text = "originalItemName - itemCell"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let replacedItemPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "replacedItemPriceLabel - itemCell"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let originalItemPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "originalItemPriceLabel - itemCell"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(replacedItemName)
        addSubview(replacedItemPriceLabel)
        addSubview(originalItemNameLabel)
        addSubview(originalItemPriceLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            replacedItemName.topAnchor.constraint(equalTo: topAnchor),
            replacedItemName.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            replacedItemPriceLabel.topAnchor.constraint(equalTo: replacedItemName.topAnchor),
            replacedItemPriceLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            replacedItemPriceLabel.bottomAnchor.constraint(equalTo: replacedItemName.bottomAnchor),
            
            originalItemNameLabel.topAnchor.constraint(equalTo: replacedItemName.bottomAnchor),
            originalItemNameLabel.leadingAnchor.constraint(equalTo: replacedItemName.leadingAnchor, constant: 32),
            originalItemNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            originalItemPriceLabel.topAnchor.constraint(equalTo: originalItemNameLabel.topAnchor),
            originalItemPriceLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            originalItemPriceLabel.bottomAnchor.constraint(equalTo: originalItemNameLabel.bottomAnchor),
        ])
    }
}

extension ItemCell {
    public func configure(viewModel: ViewModel) {
        replacedItemName.text = viewModel.replacedItemName
        replacedItemPriceLabel.text = "R$ \(viewModel.replacedItemPrice)"
        if let originalItemName = viewModel.originalItemName, originalItemName.isEmpty,
            let originalItemPrice = viewModel.originalItemPrice, originalItemPrice.isEmpty {
            originalItemNameLabel.isHidden = true
            originalItemPriceLabel.isHidden = true
            originalItemNameLabel.heightAnchor.constraint(equalToConstant: 0).isActive = true
            originalItemPriceLabel.heightAnchor.constraint(equalToConstant: 0).isActive = true
        } else {
            originalItemNameLabel.text = viewModel.originalItemName
            originalItemPriceLabel.text = "R$ \(viewModel.originalItemPrice ?? "")"
        }
    }
}
