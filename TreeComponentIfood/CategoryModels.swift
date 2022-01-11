import Foundation

// MARK: - CategoryList
struct CatalogCategoryList: Codable {
    var categories: [CategoryList]
}

// MARK: - CategoryList
struct CategoryList: Codable {
    let id: Int
    let name: String
    var parentTaxonomies: [Taxonomy]
    var isExpanded: Bool
}

// MARK: - ParentTaxonomy
struct Taxonomy: Codable {
    let title: String?
    let description: String
    
    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
    
    init(description: String) {
        self.title = nil
        self.description = description
    }
}
