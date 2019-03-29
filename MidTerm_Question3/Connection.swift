import Foundation

class Connection: Equatable {
    static func == (lhs: Connection, rhs: Connection) -> Bool {
        if(lhs.from.name == rhs.from.name && lhs.to.name == rhs.to.name)
        {
            return true
        }
        else {return false}
    }
    
    public let from: Location
    public let to: Location
    public let distance: Double
    
    public init(from: Location, to: Location, distance: Double) {
        //assert(distance >= 0, "Distance has to be equal or greater than zero")
        self.from = from
        self.to = to
        self.distance = distance
    }
}
