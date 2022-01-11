import UIKit

class RowTableCell: UITableViewCell {
    
    struct ViewModel {
        var taxonomies: [Taxonomy]
    }

    let taxonomyCellIdentifier = String(describing: TaxonomyCell.self)
    
    var dataSource: [Taxonomy] = []
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemBackground
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(tableView)
        registerCells()
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                tableView.topAnchor.constraint(equalTo: topAnchor),
                tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ]
        )
    }
    
    private func registerCells() {
        tableView.register(TaxonomyCell.self, forCellReuseIdentifier: taxonomyCellIdentifier)
    }
    
    func configure(viewModel: ViewModel) {
        dataSource = viewModel.taxonomies
    }
}

extension RowTableCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: taxonomyCellIdentifier, for: indexPath) as? TaxonomyCell else {
            return UITableViewCell()
        }
        
        cell.nameLabel.text = dataSource[indexPath.row].name
        
        return cell
    }
    
}
