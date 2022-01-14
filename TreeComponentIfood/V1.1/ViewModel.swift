import Foundation

struct SectionViewModel {
    let title: String
    let details: String?
    var expanded: Bool
    let items: [ItemViewModable]
}

enum ItemViewModelType {
    case item
    case separator
}

protocol ItemViewModable {
    var title: String { get set }
    var type: ItemViewModelType { get set }
}

struct SeparatorViewModel: ItemViewModable {
    var title: String
    var type: ItemViewModelType
}

struct ItemViewModel: ItemViewModable {
    var title: String
    var type: ItemViewModelType
    let price: String
}
