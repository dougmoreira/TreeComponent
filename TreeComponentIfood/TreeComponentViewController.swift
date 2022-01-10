import UIKit

class TreeComponentViewController: UIViewController {

    let taxonomyIdentifier = String(describing: TaxonomyCell.self)
    let categoryIdentifier = String(describing: CategoryHeader.self)
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemBrown
        tableView.estimatedRowHeight = 50
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let dataSource: [Taxonomy] = [
        Taxonomy(name: "Feijões"),
        Taxonomy(name: "Ovos"),
        Taxonomy(name: "Sal")
    ]
    
    override func loadView() {
        super.loadView()
        view.addSubview(tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemCyan
        
        registerCells()
        setupTableViewConstraints()
    }
    
    // MARK: - Private methods
    private func registerCells() {
        tableView.register(CategoryHeader.self, forHeaderFooterViewReuseIdentifier: categoryIdentifier)
        tableView.register(TaxonomyCell.self, forCellReuseIdentifier: taxonomyIdentifier)
    }
    
    private func setupTableViewConstraints() {
        NSLayoutConstraint.activate(
            [
                tableView.topAnchor.constraint(equalTo: view.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ]
        )
    }
    
}

extension TreeComponentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: categoryIdentifier) as? CategoryHeader else {
            return nil
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: taxonomyIdentifier, for: indexPath) as? TaxonomyCell else {
            return UITableViewCell()
        }
        
        cell.nameLabel.text = dataSource[indexPath.row].name
        
        return cell
    }
    
}
