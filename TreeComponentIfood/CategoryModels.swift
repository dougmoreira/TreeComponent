import Foundation

// MARK: - CategoryList
struct CatalogCategoryList: Codable {
    let categories: [CategoryList]
}

// MARK: - CategoryList
struct CategoryList: Codable {
    let id: Int
    let name: String
    let parentTaxonomies: [Taxonomy]
}

// MARK: - ParentTaxonomy
struct Taxonomy: Codable {
    let name: String
}
