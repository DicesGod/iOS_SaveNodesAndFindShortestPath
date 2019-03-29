import Foundation

class Location: Equatable {
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        if (lhs.name == rhs.name){return true}
        else {return false}
    }
    
    var name = ""
    var visited = false
    var connections: [Connection] = []
    
    init(name: String) {
        self.name = name
        connections = []
    }
    
    static func getLocation(LocationName: String, listLocation: [Location] ) -> Location {
        let Location = listLocation.first(where:{$0.name == LocationName})
        return Location!
    }
}
