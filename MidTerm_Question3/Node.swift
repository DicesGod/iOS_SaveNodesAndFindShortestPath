//
//  Node.swift
//  MidTerm_Question3
//
//  Created by Minh Le on 2019-03-29.
//  Copyright © 2019 Minh Le. All rights reserved.
//

import Foundation

class Node: Equatable {
    static func == (lhs: Node, rhs: Node) -> Bool {
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
}
