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
    var callCount: Int = 0
    var dataSource: [CatalogCategoryList] = [
        CatalogCategoryList(
            categories: [
                CategoryList(
                    id: 1,
                    name: "Alimentos básicos",
                    parentTaxonomies: [
                        Taxonomy(name: "Feijões"),
                        Taxonomy(name: "Ovos"),
                        Taxonomy(name: "Sal")
                    ],
                    isExpanded: false
                )
            ]
        ),
        CatalogCategoryList(
            categories: [
                CategoryList(
                    id: 2,
                    name: "Feira",
                    parentTaxonomies: [
                        Taxonomy(name: "Frutas"),
                        Taxonomy(name: "Legumes"),
                        Taxonomy(name: "Verduras")
                    ],
                    isExpanded: false
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
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRows = dataSource[section].categories.first?.parentTaxonomies.count,
                dataSource[section].categories.first?.isExpanded == true else {
            return 0
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: categoryIdentifier) as? CategoryHeader,
              let viewModel = dataSource[section].categories.first else {
            return nil
        }
        header.titleLabel.text = viewModel.name
        header.delegate = self
        header.index = section
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: taxonomyIdentifier, for: indexPath) as? TaxonomyCell else {
            return UITableViewCell()
        }
        
        cell.nameLabel.text = dataSource[indexPath.section].categories.first?.parentTaxonomies[indexPath.row].name
        
        return cell
    }
    
}

extension TreeComponentViewController: CategoryHeaderDelegate {
    func didSelectHeader(at index: Int) {
        guard var aisle = dataSource[index].categories.first else { return }
        if aisle.isExpanded == true {
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
