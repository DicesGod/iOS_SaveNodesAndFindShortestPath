//
//  Path.swift
//  MidTerm_Question3
//
//  Created by Minh Le on 2019-03-29.
//  Copyright © 2019 Minh Le. All rights reserved.
//

import Foundation

class Path {
    public let cumulativeDistance: Double
    public let node: Node
    public let previousPath: Path?
    
    init(to node: Node, via connection: Connection? = nil, previousPath path: Path? = nil) {
        if
            let previousPath = path,
            let viaConnection = connection {
            self.cumulativeDistance = viaConnection.distance + previousPath.cumulativeDistance
        } else {
            self.cumulativeDistance = 0
        }
        
        self.node = node
        self.previousPath = path
    }
}

extension Path {
    var array: [Node] {
        var array: [Node] = [self.node]
        
        var iterativePath = self
        while let path = iterativePath.previousPath {
            array.append(path.node)
            
            iterativePath = path
        }
        
        return array
    }
}
