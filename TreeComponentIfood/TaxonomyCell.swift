import UIKit

class TaxonomyCell: UITableViewCell {

    public let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "taxonomyCell - nameLabel"
        return label
    }()
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    private func setup() {
        addSubview(nameLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        subviews.forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate(
            [
                nameLabel.topAnchor.constraint(equalTo: topAnchor),
                nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            ]
        )
    }
}
