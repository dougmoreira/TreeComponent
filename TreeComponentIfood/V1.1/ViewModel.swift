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

