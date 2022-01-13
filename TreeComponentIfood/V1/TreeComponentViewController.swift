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
    
    var viewModelDataSource: [ViewModelSection]? = []
    
    var dataSource: [ItemsSection]? = [
        ItemsSection(
            type: .grocery,
            title: "Itens reembolsados",
            icon: "",
            details: "(2 produtos)",
            subSections: [
                SubSection(
                    title: "",
                    icon: "",
                    items: [Item(id: "0", name: "Guaraná"), Item(id: "1", name: "Feijão")]
                )
            ],
            isExpanded: true
        ),
        ItemsSection(
            type: .grocery,
            title: "Todos os itens do seu pedido",
            icon: "",
            details: "(5 produtos)",
            subSections: [
                SubSection(
                    title: "Itens alterados",
                    icon: "",
                    items: [Item(id: "0", name: "Heineken", originalItem: OriginalItem(id: "0", name: "Brahma")),
                            Item(id: "1", name: "Arroz tipo 1", originalItem: OriginalItem(id: "0", name: "Arroz tipo 2"))]
                ),
                SubSection(
                    title: "Itens sem alteração",
                    icon: "",
                    items: [Item(id: "0", name: "Ovo"),
                            Item(id: "0", name: "Óleo"),
                            Item(id: "1", name: "Coca-cola")]
                ),
            ],
            isExpanded: true
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
        adapter()
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
    
    private func adapter() {
        var viewModelSection: [ViewModelSection] = []
        
        dataSource?.forEach { itemSection in
            var viewModelItems: [ViewModelItem] = []
            itemSection.subSections.forEach({ subSection in
                for (index, item) in subSection.items.enumerated() {
                    viewModelItems.append(ViewModelItem(title: index == 0 ? subSection.title : "", item: item))
                }
            })
            
            viewModelSection.append(
                ViewModelSection(
                    type: itemSection.type,
                    title: itemSection.title,
                    icon: itemSection.icon,
                    details: itemSection.details,
                    viewModelItems: viewModelItems,
                    isExpanded: itemSection.isExpanded
                )
            )
            
        }
        viewModelDataSource = viewModelSection
    }
    
}

extension TreeComponentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModelDataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRows = viewModelDataSource?[section].viewModelItems?.count,
              viewModelDataSource?[section].isExpanded == true else {
                  return 0
              }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: categoryIdentifier) as? CategoryHeader,
              let viewModel = viewModelDataSource?[section] else {
                  return nil
              }
        
        header.titleLabel.text = viewModel.title
        header.delegate = self
        header.index = section
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: taxonomyIdentifier, for: indexPath) as? TaxonomyCell,
              let viewModelItem = viewModelDataSource?[indexPath.section].viewModelItems?[indexPath.row]else {
                  return UITableViewCell()
              }
        
        cell.configure(viewModel: .init(title: viewModelItem.title ?? "", description: viewModelItem.item.name))
        
        return cell
    }
    
}

extension TreeComponentViewController: CategoryHeaderDelegate {
    func didSelectHeader(at index: Int) {
        guard var section = viewModelDataSource?[index] else { return }
        if section.isExpanded {
            section.viewModelItems?.removeAll()
        } else {
            section.viewModelItems = [
                ViewModelItem(title: "Novo viewModel", item: Item(id: "0", name: "Novo Item 01")),
                ViewModelItem(title: "", item: Item(id: "1", name: "Novo Item 02")),
                ViewModelItem(title: "", item: Item(id: "2", name: "Novo Item 03")),
                ViewModelItem(title: "", item: Item(id: "3", name: "Novo Item 04")),
                ViewModelItem(title: "Secão 02", item: Item(id: "0", name: "Novo Item Secáo 02 - 01")),
                ViewModelItem(title: "", item: Item(id: "1", name: "Novo Item Secáo 02 - 02")),
                ViewModelItem(title: "", item: Item(id: "2", name: "Novo Item Secáo 02 - 03")),
            ]
        }
        section.isExpanded.toggle()
        viewModelDataSource?[index] = section
        tableView.reloadData()
    }
}
