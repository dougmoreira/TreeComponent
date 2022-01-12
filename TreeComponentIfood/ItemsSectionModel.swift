import Foundation

// MARK: - ItemsSection
struct ItemsSection: Codable {
    let type: ItemsSectionType
    let title: String?
    let icon: String?
    let details: String?
    let subSections: [SubSection]
    var isExpanded: Bool
}

// MARK: - SubSection
struct SubSection: Codable {
    let title: String?
    let icon: String?
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let id: String
    let name: String
    let originalItem: OriginalItem?
    
    init(id: String, name: String, originalItem: OriginalItem) {
        self.id = id
        self.name = name
        self.originalItem = originalItem
    }
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
        self.originalItem = nil
    }
}

// MARK: - OriginalItem
struct OriginalItem: Codable {
    let id: String
    let name: String
}

enum ItemsSectionType: String, Codable {
    case `default`
    case grocery
}


struct ViewModelSection: Codable {
    let type: ItemsSectionType
    let title: String?
    let icon: String?
    let details: String?
    var viewModelItems: [ViewModelItem]?
    var isExpanded: Bool
}

struct ViewModelItem: Codable {
    let title: String?
    let item: Item
}
