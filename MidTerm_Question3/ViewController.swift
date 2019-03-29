//
//  ViewController.swift
//  MidTerm_Question3
//
//  Created by Minh Le on 2019-03-27.
//  Copyright © 2019 Minh Le. All rights reserved.
//

import UIKit



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
        }
}

class Connection {
    public let from: Node
    public let to: Node
    public let distance: Double
    
    public init(from: Node, to: Node, distance: Double) {
        assert(distance >= 0, "Distance has to be equal or greater than zero")
        self.from = from
        self.to = to
        self.distance = distance
    }
}

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



// **** EXAMPLE BELOW ****
//class MyNode: Node {
//    let name: String
//
//    init(name: String) {
//        self.name = name
//        super.init()
//    }
//}


class ViewController: UIViewController {
    
    var connections: [Connection] = []
    
    @IBOutlet weak var test1: UITextField!
    @IBOutlet weak var test2: UITextField!
    @IBOutlet weak var TextViewFrom: UITextField!
    
    
    @IBOutlet weak var TextViewTo: UITextField!
    
    @IBOutlet weak var TextViewDistance: UITextField!
    
    @IBOutlet weak var Distance: UITextField!
    
    @IBOutlet weak var Button: UIButton!
    
    @IBOutlet weak var Result: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func getNode(NodeName: String) -> Node {
        let Node = listNode.first(where:{$0.name == NodeName})
        return Node!
    }
    
    @IBAction func Calculate(_ sender: Any) {
        Distance.text = ""
        //createMatrix(list: list)
//        let nodeA = Node(name: "A")
//        let nodeB = Node(name: "B")
//        let nodeC = Node(name: "C")
//        let nodeD = Node(name: "D")
//        let nodeE = Node(name: "E")
//
//        nodeA.connections.append(Connection(to: nodeB, distance: 1))
//        nodeB.connections.append(Connection(to: nodeC, distance: 3))
//        nodeC.connections.append(Connection(to: nodeD, distance: 1))
//        nodeB.connections.append(Connection(to: nodeE, distance: 1))
//        nodeE.connections.append(Connection(to: nodeC, distance: 1))
        //nodeA.connections.append(Connection(to: node, distance: 1))
        
       
        let sourceNode = getNode(NodeName: TextViewFrom.text!)
        let destinationNode = getNode(NodeName: TextViewTo.text!)
      
        
        
        
        
        let path = shortestPath(source: sourceNode, destination: destinationNode)
        
        if let succession: [String] = path?.array.reversed().flatMap({ $0 as? Node}).map({$0.name}) {
            for i in succession{
                Distance.text! += i}
            
        } else {
            Distance.text = "No path"
        }
        
        
    }
    var listFlight = [Flight]()
    var listNode =  [Node]()

    struct Flight {
        var from = ""
        var to = ""
        var distance = 0.0
    }
    
    func shortestPath(source: Node, destination: Node) -> Path? {
        var frontier: [Path] = [] {
            didSet { frontier.sort { return $0.cumulativeDistance < $1.cumulativeDistance } } // the frontier has to be always ordered
        }
        
        frontier.append(Path(to: source)) // the frontier is made by a path that starts nowhere and ends in the source
        
        while !frontier.isEmpty {
            let cheapestPathInFrontier = frontier.removeFirst() // getting the cheapest path available
            guard !cheapestPathInFrontier.node.visited else { continue } // making sure we haven't visited the node already
            
            if cheapestPathInFrontier.node == destination {
                return cheapestPathInFrontier // found the cheapest path 😎
            }
            
            cheapestPathInFrontier.node.visited = true
            
            for connection in cheapestPathInFrontier.node.connections where !connection.to.visited { // adding new paths to our frontier
                frontier.append(Path(to: connection.to, via: connection, previousPath: cheapestPathInFrontier))
            }
        } // end while
        return nil // we didn't find a path 😣
    }
    
    @IBAction func Add(_ sender: Any) {
        //let distance = Int(Distance.text!)
        listFlight.append(ViewController.Flight.init(from: TextViewFrom.text!, to: TextViewTo.text!, distance: Double(Distance.text!)!))
        
        
        //create Node
        let FromNode = Node(name: TextViewFrom.text!)
        let ToNode = Node(name: TextViewTo.text!)
        
        //create Matrix
        createMatrix(FromNode: FromNode, ToNode: ToNode)
       
        TextViewFrom.text = ""
        TextViewTo.text = ""
        Distance.text = ""
    }
    
    func createMatrix(FromNode: Node, ToNode: Node) -> Array<Node> {
        //Check if the nodes already in the list
        let FromNodeName = TextViewFrom.text
        let ToNodeName = TextViewTo.text
        
        if (FromNode != listNode.first(where:{$0.name == FromNodeName})){
            listNode.append(FromNode)
            
        }

        if (ToNode != listNode.first(where:{$0.name == ToNodeName})){
            listNode.append(ToNode)
            
        }
        
        var testConnection = Connection(from: FromNode, to: ToNode, distance: Double(Distance.text!)!)
        
        var check = true
         for testConnection in FromNode.connections{
            if (testConnection == FromNode.connections[testConnection]){
                check = true}
                break
            else {check = false}
        }
        
//        if (FromNode.connections.contains(where: {testConnection in FromNode.connections
//            return true
//        })){}
        
        for testConnection in FromNode.connections{
            FromNode.connections.append(testConnection)
            test1.text = "this is from Node: "+FromNode.name
            test2.text = "This is toNode:"+ToNode.name
        }
        return listNode
    }
    
    
}

