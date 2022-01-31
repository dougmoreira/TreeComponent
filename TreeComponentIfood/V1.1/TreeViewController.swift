import UIKit

class TreeViewController: UIViewController {
    
    let categoryHeaderIdentifier = String(describing: CategoryHeader.self)
    let subSectionCellIdentifier = String(describing: SubSectionCell.self)
    let itemCellIdentifier = String(describing: ItemCell.self)
    
    private var dataSource: [ItemsSection] = [
        ItemsSection(
            type: .grocery,
            title: "Itens reembolsados",
            icon: "",
            details: "(2 produtos)",
            subSections: [
                SubSection(
                    title: "",
                    icon: "",
                    items: [TreeItem(id: "0", name: "Guaraná"), TreeItem(id: "1", name: "Feijão")]
                )
            ],
            isExpanded: false
        ),
        ItemsSection(
            type: .grocery,
            title: "Todos os itens do seu pedido bla blab alb alb alba lb",
            icon: "",
            details: "(5 produtos)",
            subSections: [
                SubSection(
                    title: "Itens alterados",
                    icon: "",
                    items: [TreeItem(id: "0", name: "Heineken", originalItem: OriginalItem(id: "0", name: "Brahma")),
                            TreeItem(id: "1", name: "Arroz tipo 1", originalItem: OriginalItem(id: "0", name: "Arroz tipo 2"))]
                ),
                SubSection(
                    title: "Itens sem alteração",
                    icon: "",
                    items: [TreeItem(id: "0", name: "Ovo"),
                            TreeItem(id: "0", name: "Óleo"),
                            TreeItem(id: "1", name: "Coca-cola")]
                ),
            ],
            isExpanded: false
        ),
    ]
    
    private var viewModel: [SectionViewModel] = []
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemBrown
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        registerTableCells()
        setupConstraints()
        viewModel = makeViewModel()
    }
    
    private func registerTableCells() {
        tableView.register(SubSectionCell.self, forCellReuseIdentifier: subSectionCellIdentifier)
        tableView.register(ItemCell.self, forCellReuseIdentifier: itemCellIdentifier)
        tableView.register(CategoryHeader.self, forHeaderFooterViewReuseIdentifier: categoryHeaderIdentifier)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func makeViewModel() -> [SectionViewModel] {
        let sections = dataSource
            .map { section -> SectionViewModel in
                
                let items = section.subSections.map { subSection -> [ItemViewModable] in
                    let items = subSection.items.map { ItemViewModel(name: $0.name, type: .item, price: "20,00", originalItem: nil) }
                    
                    var viewModels: [ItemViewModable] = []
                    if let title = subSection.title, !title.isEmpty {
                        viewModels.append(SeparatorViewModel(name: title, type: .separator))
                    }
                    viewModels.append(contentsOf: items)
                    return viewModels
                    
                }.flatMap { $0 }
                
                
                return SectionViewModel(title: section.title ?? "", details: nil, expanded: false, items: items)
            }
        
        return sections
    }

}

extension TreeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel[section].expanded ? viewModel[section].items.count : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: categoryHeaderIdentifier) as? CategoryHeader else {
            return UIView()
        }
        
        header.titleLabel.text = viewModel[section].title
        header.delegate = self
        header.index = section
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel[indexPath.section].items[indexPath.row]
        switch item.type {
            case .separator:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: subSectionCellIdentifier, for: indexPath) as? SubSectionCell,
                      let separatorViewModel = item as? SeparatorViewModel
                else {
                    return UITableViewCell()
                }
                
                cell.configure(viewModel: .init(title: separatorViewModel.name))
                
                return cell
            case .item:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: itemCellIdentifier, for: indexPath) as? ItemCell,
                      let itemViewModel = item as? ItemViewModel else {
                    return UITableViewCell()
                }
                
                cell.configure(
                    viewModel: .init(
                        replacedItemName: itemViewModel.name,
                        replacedItemPrice: itemViewModel.price,
                        originalItemName: "",
                        originalItemPrice: ""
                    )
                )
                
                return cell
        }
    }
}

extension TreeViewController: CategoryHeaderDelegate {
    func didSelectHeader(at index: Int) {
        viewModel[index].expanded.toggle()
        tableView.reloadData()
    }
}
