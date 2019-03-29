//
//  Connection.swift
//  MidTerm_Question3
//
//  Created by Minh Le on 2019-03-29.
//  Copyright © 2019 Minh Le. All rights reserved.
//

import Foundation

class Connection: Equatable {
    static func == (lhs: Connection, rhs: Connection) -> Bool {
        if(lhs.from.name == rhs.from.name && lhs.to.name == rhs.to.name)
        {
            return true
        }
        else {return false}
    }
    
    public let from: Node
    public let to: Node
    public let distance: Double
    
    public init(from: Node, to: Node, distance: Double) {
        //assert(distance >= 0, "Distance has to be equal or greater than zero")
        self.from = from
        self.to = to
        self.distance = distance
    }
}
