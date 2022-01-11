import UIKit

class TreeComponentViewController: UIViewController {

    let rowTableCellIdentifier = String(describing: RowTableCell.self)
    let categoryHeaderIdentifier = String(describing: CategoryHeader.self)
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemBackground
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var dataSource: [CatalogCategoryList] = [
        CatalogCategoryList(
            categories: [
                CategoryList(
                    id: 1,
                    name: "Itens reembolsados",
                    parentTaxonomies: [
                        Taxonomy(name: "Cerveja 01"),
                        Taxonomy(name: "Coca-cola"),
                        Taxonomy(name: "Amaciante")
                    ],
                    isExpanded: false
                )
            ]
        ),
        CatalogCategoryList(
            categories: [
                CategoryList(
                    id: 2,
                    name: "Todos os itens",
                    parentTaxonomies: [
                        Taxonomy(name: "Feijão"),
                        Taxonomy(name: "Arroz"),
                        Taxonomy(name: "Omo")
                    ],
                    isExpanded: true
                )
            ]
        ),
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
        tableView.register(CategoryHeader.self, forHeaderFooterViewReuseIdentifier: categoryHeaderIdentifier)
        tableView.register(RowTableCell.self, forCellReuseIdentifier: rowTableCellIdentifier)
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
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource[section].categories.first!.isExpanded ? 1 : 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: categoryHeaderIdentifier) as? CategoryHeader,
              let viewModel = dataSource[section].categories.first else {
            return nil
        }
        header.titleLabel.text = viewModel.name
        header.delegate = self
        header.index = section
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: rowTableCellIdentifier, for: indexPath) as? RowTableCell else {
            return UITableViewCell()
        }
        
        cell.configure(viewModel: .init(taxonomies: dataSource[indexPath.section].categories.first!.parentTaxonomies))
                
        return cell
    }
}

extension TreeComponentViewController: CategoryHeaderDelegate {
    func didSelectHeader(at index: Int) {
        guard var aisle = dataSource[index].categories.first else { return }
        if aisle.isExpanded {
            aisle.parentTaxonomies.removeAll()
        } else {
            aisle.parentTaxonomies = [
                Taxonomy(name: "taxonomy1"),
                Taxonomy(name: "taxonomy2"),
                Taxonomy(name: "taxonomy3"),
                Taxonomy(name: "taxonomy4"),
            ]
        }
        aisle.isExpanded.toggle()
        dataSource[index].categories[0] = aisle
        tableView.reloadData()
    }
}
