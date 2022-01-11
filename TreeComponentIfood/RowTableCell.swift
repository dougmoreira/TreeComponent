import UIKit

class RowTableCell: UITableViewCell {
    
    struct ViewModel {
        var taxonomies: [Taxonomy]
    }

    let taxonomyCellIdentifier = String(describing: TaxonomyCell.self)
    
    let tableView = UITableView()
    
    var dataSource: [Taxonomy] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
    }
    
    private func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemPink
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(TaxonomyCell.self, forCellReuseIdentifier: taxonomyCellIdentifier)
        
        addSubview(tableView)
        
        NSLayoutConstraint.activate(
            [
                tableView.topAnchor.constraint(equalTo: topAnchor),
                tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ]
        )
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
