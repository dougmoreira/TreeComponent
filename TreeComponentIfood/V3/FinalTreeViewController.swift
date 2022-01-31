import UIKit

class FinalTreeViewController: UIViewController {

    private let dataSource = OrderDetail(
        id: "01",
        historyChanges: HistoryChanges(
            bag: Bag(
                items: [
                    Item(
                        price: 10,
                        id: "11",
                        itemDescription: "Coca-cola 2L",
                        uniqueID: "bag01",
                        name: "Coca-cola",
                        deltaType: DeltaType.replaced
                    ),
                    Item(
                        price: 8,
                        id: "12",
                        itemDescription: "Cerveja Heineken 600ml",
                        uniqueID: "bag02",
                        name: "Heineken",
                        deltaType: DeltaType.replaced
                    ),
                    Item(
                        price: 20,
                        id: "03",
                        itemDescription: "Arroz tipo 01 1kg",
                        uniqueID: "03",
                        name: "Arroz tipo 01",
                        deltaType: DeltaType.removed
                    )
                ]
            )
        ),
        bag: Bag(
            items: [
                Item(
                    price: 7,
                    id: "01",
                    itemDescription: "Guaraná 2L",
                    uniqueID: "bag01",
                    name: "Guaraná",
                    deltaType: nil
                ),
                Item(
                    price: 6,
                    id: "02",
                    itemDescription: "Cerveja Brahma 600ml",
                    uniqueID: "bag02",
                    name: "Brahma",
                    deltaType: nil
                ),
                Item(
                    price: 15,
                    id: "04",
                    itemDescription: "Vodka 1L",
                    uniqueID: "04",
                    name: "Vodka",
                    deltaType: nil
                )
            ]
        )
    )
    
    var viewModel: [OrderDetailViewModel] = []
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemTeal
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let categoryHeaderIdentifier = String(describing: CategoryHeader.self)
    let subSectionCellIdentifier = String(describing: SubSectionCell.self)
    let itemCellIdentifier = String(describing: ItemCell.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        registerTableViewCells()
        setupConstraints()
        makeViewModel()
    }
    
    private func registerTableViewCells() {
        tableView.register(SubSectionCell.self, forCellReuseIdentifier: subSectionCellIdentifier)
        tableView.register(ItemCell.self, forCellReuseIdentifier: itemCellIdentifier)
        tableView.register(CategoryHeader.self, forHeaderFooterViewReuseIdentifier: categoryHeaderIdentifier)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                tableView.topAnchor.constraint(equalTo: view.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ]
        )
    }
    
    private func makeViewModel() {
        let removedItemsSection = getRemovedItemsSection()
        let allItemsSection = getAllItemsSection()
        viewModel = [removedItemsSection, allItemsSection]
    }
    
    private func getRemovedItemsSection() -> OrderDetailViewModel {
        return OrderDetailViewModel(
            sectionTitle: "Itens com reembolso - \(dataSource.historyChanges.bag.items.filter({ $0.deltaType == .removed}).count) itens",
            icon: "",
            sectionSubTitle: "\(dataSource.historyChanges.bag.items.filter({ $0.deltaType == .removed}).count)",
            items: getRemovedItemsSubSection(),
            isExpanded: true
        )
    }
    
    private func getRemovedItemsSubSection() -> [ItemViewModable] {
        var viewModable: [ItemViewModable] = []
        return dataSource.historyChanges.bag.items.map { item -> [ItemViewModable] in
            if item.deltaType == .removed {
                viewModable.append(
                    ItemViewModel(
                        name: item.name,
                        type: .item,
                        price: "\(item.price)",
                        originalItem: nil
                    )
                )
            }
            return viewModable
        }.flatMap { $0 }
    }
    
    private func getAllItemsSection() -> OrderDetailViewModel {
        var itemsModable: [ItemViewModable] = []
        itemsModable.append(contentsOf: getItemsAndReplacedItemsSubSection())
        return OrderDetailViewModel(
            sectionTitle: "Todos os itens do pedido - \(dataSource.bag.items.count) itens",
            icon: "",
            sectionSubTitle: "\(dataSource.bag.items.count) itens",
            items: itemsModable,
            isExpanded: true
        )
    }
    
    private func getItemsAndReplacedItemsSubSection() -> [ItemViewModable] {
        var hasReplacedItemsSection = false
        var hasNoChangedItemsSection = false
        
        return dataSource.bag.items.map { item -> [ItemViewModable] in
            var viewModable: [ItemViewModable] = []
            
            if let originalItem = dataSource.historyChanges.bag.items.first(where: { $0.uniqueID == item.uniqueID }) {
                if originalItem.deltaType == .replaced {
                    if !hasReplacedItemsSection {
                        viewModable.append(SeparatorViewModel(name: "Itens alterados", type: .separator))
                        hasReplacedItemsSection = true
                    }
                    viewModable.append(
                        ItemViewModel(
                            name: item.name,
                            type: .item,
                            price: "\(item.price)",
                            originalItem: OriginalItemViewModel(
                                name: originalItem.name,
                                type: .item,
                                price: "\(originalItem.price)"
                            )
                        )
                    )
                }
            } else {
                if !hasNoChangedItemsSection {
                    viewModable.append(SeparatorViewModel(name: "Itens sem alteração",type: .separator))
                    hasNoChangedItemsSection = true
                }
                viewModable.append(
                    ItemViewModel(
                        name: item.name,
                        type: .item,
                        price: "\(item.price)",
                        originalItem: nil
                    )
                )
            }
            
            return viewModable
        }.flatMap { $0 }
    }

}

extension FinalTreeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel[section].isExpanded ? viewModel[section].items?.count ?? 0 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: categoryHeaderIdentifier) as? CategoryHeader else {
            return UIView()
        }
        
        header.titleLabel.text = viewModel[section].sectionTitle
        header.delegate = self
        header.index = section
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel[indexPath.section].items?[indexPath.row]
        switch item?.type {
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
                        originalItemName: itemViewModel.originalItem?.name ?? "",
                        originalItemPrice: itemViewModel.originalItem?.price ?? ""
                    )
                )
                
                return cell
            case .none:
                return UITableViewCell()
        }
    }
    
}

extension FinalTreeViewController: CategoryHeaderDelegate {
    func didSelectHeader(at index: Int) {
        viewModel[index].isExpanded.toggle()
        tableView.reloadData()
    }
}
