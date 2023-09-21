
import CoreLocation
import SwiftUI

struct NamedPhoto: Identifiable, Comparable {
    let id: UUID
    var name: String
    var image: UIImage?
    var location: CLLocationCoordinate2D?
    
    static func <(lhs: NamedPhoto, rhs: NamedPhoto) -> Bool {
        lhs.name < rhs.name
    }
    
    static func ==(lhs: NamedPhoto, rhs: NamedPhoto) -> Bool {
        lhs.id == rhs.id
    }
}
