import Foundation

// MARK: - OrderDetail
struct OrderDetail: Codable {
    let id: String
    let historyChanges: HistoryChanges
    let bag: Bag
}

// MARK: - Bag
struct Bag: Codable {
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let price: Int
    let id, itemDescription, uniqueID: String
    let name: String
    let deltaType: DeltaType?
    
    enum CodingKeys: String, CodingKey {
        case price, id
        case itemDescription = "description"
        case uniqueID = "uniqueId"
        case name, deltaType
    }
}

// MARK: - HistoryChanges
struct HistoryChanges: Codable {
    let bag: Bag
}

enum DeltaType: String, Codable {
    case replaced
    case removed
}

struct OrderDetailViewModel {
    let sectionTitle: String?
    let icon: String?
    let sectionSubTitle: String?
    var items: [ItemViewModable]?
    var isExpanded: Bool
}

struct ViewModelItem: Codable {
    let title: String?
    let item: Item
}

protocol ItemViewModable {
    var name: String { get set }
    var type: ItemViewModelType { get set }
}

struct SeparatorViewModel: ItemViewModable {
    var name: String
    var type: ItemViewModelType
}

struct ItemViewModel: ItemViewModable {
    var name: String
    var type: ItemViewModelType
    let price: String
    let originalItem: OriginalItemViewModel?
}

struct OriginalItemViewModel: ItemViewModable {
    var name: String
    var type: ItemViewModelType
    let price: String
}
