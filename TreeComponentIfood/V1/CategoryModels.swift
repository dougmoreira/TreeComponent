import Foundation

// MARK: - CategoryList
public struct CatalogCategoryList: Codable {
    var categories: [CategoryList]
}

// MARK: - CategoryList
public struct CategoryList: Codable {
    let id: Int
    let name: String
    var parentTaxonomies: [Taxonomy]
    var isExpanded: Bool
}

// MARK: - ParentTaxonomy
public struct Taxonomy: Codable {
    let title: String?
    let description: String
    
    public init(title: String, description: String) {
        self.title = title
        self.description = description
    }
    
    public init(description: String) {
        self.title = nil
        self.description = description
    }
}
