//
//  V2ViewController.swift
//  TreeComponentIfood
//
//  Created by douglas.moreira on 13/01/22.
//

import UIKit

final class V2ViewController: UIViewController {
    
    private var dataSource: [ItemsSection]? = [
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
            isExpanded: true
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
            isExpanded: true
        ),
    ]
    
    private let itemSectionIdentifier = String(describing: ItemSectionCell.self)
    
    // MARK - View Components
    
    lazy var sectionTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemBlue
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        view.addSubview(sectionTableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemCyan
        
        registerCells()
        setupTableViewConstraints()
    }
    
    // MARK: - Private methods
    private func registerCells() {
        sectionTableView.register(ItemSectionCell.self, forCellReuseIdentifier: itemSectionIdentifier)
    }
    
    private func setupTableViewConstraints() {
        NSLayoutConstraint.activate(
            [
                sectionTableView.topAnchor.constraint(equalTo: view.topAnchor),
                sectionTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                sectionTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                sectionTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]
        )
    }
}


extension V2ViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource?.count ?? .zero
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: itemSectionIdentifier, for: indexPath) as? ItemSectionCell,
            let item = dataSource?[indexPath.item] else { return UITableViewCell() }
        
        cell.setupItemSection(with: .init(title: item.title ?? String(), subSection: item.subSections))
        
        return cell
    }
}
