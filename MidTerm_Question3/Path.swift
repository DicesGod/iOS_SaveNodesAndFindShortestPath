import Foundation

class Path {
    public let cumulativeDistance: Double
    public let Location: Location
    public let previousPath: Path?
    
    init(to Location: Location, via connection: Connection? = nil, previousPath path: Path? = nil) {
        if
            let previousPath = path,
            let viaConnection = connection {
            self.cumulativeDistance = viaConnection.distance + previousPath.cumulativeDistance
        } else {
            self.cumulativeDistance = 0
        }
        
        self.Location = Location
        self.previousPath = path
    }
    
    static func shortestPath(source: Location, destination: Location, listLocation: [Location]) -> Path? {
        for i in listLocation{
            i.visited = false
        }
        
        var frontier: [Path] = [] {
            didSet { frontier.sort { return $0.cumulativeDistance < $1.cumulativeDistance } } // the frontier has to be always ordered
        }
        
        frontier.append(Path(to: source)) // the frontier is made by a path that starts nowhere and ends in the source
        
        while !frontier.isEmpty {
            let cheapestPathInFrontier = frontier.removeFirst() // getting the cheapest path available
            guard !cheapestPathInFrontier.Location.visited else { continue } // making sure we haven't visited the Location already
            
            if cheapestPathInFrontier.Location == destination {
                return cheapestPathInFrontier // found the cheapest path 😎
            }
            
            cheapestPathInFrontier.Location.visited = true
            
            for connection in cheapestPathInFrontier.Location.connections where !connection.to.visited { // adding new paths to our frontier
                frontier.append(Path(to: connection.to, via: connection, previousPath: cheapestPathInFrontier))
            }
        } // end while
        return nil // we didn't find a path 😣
    }
}

extension Path {
    var array: [Location] {
        var array: [Location] = [self.Location]
        
        var iterativePath = self
        while let path = iterativePath.previousPath {
            array.append(path.Location)
            
            iterativePath = path
        }
        
        return array
    }
}
