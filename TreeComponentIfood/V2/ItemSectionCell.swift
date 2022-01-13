//
//  ItemSectionCell.swift
//  TreeComponentIfood
//
//  Created by douglas.moreira on 13/01/22.
//

import UIKit

protocol ItemSectionDelegate: NSObject {
    func updateSectionHeight()
}

final class ItemSectionCell: UITableViewCell {
    
    weak var sectionDelegate: ItemSectionDelegate?
    
    struct ItemSectionViewModel {
        let title: String
        let subSection: [SubSection]
    }
    
    var subsection: [SubSection]?
    
    let taxonomyIdentifier = String(describing: TaxonomyCell.self)
    
    lazy var itemTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemBlue
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
        
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "section"
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
        addSubview(titleLabel)
        addSubview(itemTableView)
        registerCells()
        setupConstraints()
    }
    
    private func registerCells() {
        itemTableView.register(TaxonomyCell.self, forCellReuseIdentifier: taxonomyIdentifier)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
            ]
        )
        
        NSLayoutConstraint.activate(
            [
                itemTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
                itemTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
                itemTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
                itemTableView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ]
        )
    }
    
    public func setupItemSection(with viewData: ItemSectionViewModel) {
        titleLabel.text = viewData.title
        subsection = viewData.subSection
        
        itemTableView.reloadData()
        sectionDelegate?.updateSectionHeight()

                
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
