
import SwiftUI

struct NamedPhoto: Identifiable, Comparable {
    let id: UUID
    var name: String
    var image: UIImage?
    
    static func <(lhs: NamedPhoto, rhs: NamedPhoto) -> Bool {
        lhs.name < rhs.name
    }
}
