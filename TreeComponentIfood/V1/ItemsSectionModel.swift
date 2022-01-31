import Foundation

// MARK: - ItemsSection
public struct ItemsSection: Codable {
    let type: ItemsSectionTypeV1
    let title: String?
    let icon: String?
    let details: String?
    let subSections: [SubSection]
    var isExpanded: Bool
}

// MARK: - SubSection
public struct SubSection: Codable {
    let title: String?
    let icon: String?
    let items: [TreeItem]
}

// MARK: - Item
public struct TreeItem: Codable {
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
public struct OriginalItem: Codable {
    let id: String
    let name: String
}

public enum ItemsSectionTypeV1: String, Codable {
    case `default`
    case grocery
}


public struct ViewModelSectionV1: Codable {
    let type: ItemsSectionTypeV1
    let title: String?
    let icon: String?
    let details: String?
    var viewModelItems: [ViewModelItemV1]?
    var isExpanded: Bool
}

public struct ViewModelItemV1: Codable {
    let title: String?
    let item: TreeItem
}
