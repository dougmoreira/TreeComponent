import UIKit

final class ItemSectionCell: UITableViewCell {
    
    struct ItemSectionViewModel {
        let title: String
        let subSection: [SubSection]
    }
    
    var subsection: [SubSection]?
    
    let taxonomyIdentifier = String(describing: TaxonomyCell.self)
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var itemTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemBlue
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
        
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "section"
        label.numberOfLines = 0
        return label
    }()

    override  init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(itemTableView)
        
        registerCells()
        setupConstraints()
    }
    
    private func registerCells() {
        itemTableView.register(TaxonomyCell.self, forCellReuseIdentifier: taxonomyIdentifier)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                stackView.topAnchor.constraint(equalTo: topAnchor),
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            ]
        )
        
    }
    
    public func setupItemSection(with viewData: ItemSectionViewModel) {
        titleLabel.text = viewData.title
        subsection = viewData.subSection
        
        itemTableView.invalidateIntrinsicContentSize()
        itemTableView.layoutIfNeeded()
        
        itemTableView.reloadData()
    }

}

extension ItemSectionCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        subsection?[section].items.count ?? .zero
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        subsection?.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: taxonomyIdentifier, for: indexPath) as? TaxonomyCell,
            let item = subsection?[indexPath.section].items[indexPath.row]
        else { return UITableViewCell() }
        
        cell.configure(viewModel: .init(title: String(), description: item.name))
    
        return cell
    }
    
    
}
