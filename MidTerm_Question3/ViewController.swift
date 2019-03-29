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
        var FromNode = Node(name: TextViewFrom.text!)
        var ToNode = Node(name: TextViewTo.text!)
        
        //Check if the nodes already in the list
        if (listNode.isEmpty)
        {
            listNode.append(FromNode)
            listNode.append(ToNode)
        }
        else
        {
            for TestNode: Node in listNode
            {
                if (FromNode == TestNode){
                    FromNode = TestNode
                    break
                }
                else{listNode.append(FromNode)}
                
                if (ToNode == TestNode){
                    ToNode = TestNode
                    break
                }
                else{listNode.append(ToNode)}
            }
        }
        
        //create Matrix
        createMatrix(FromNode: FromNode, ToNode: ToNode)
       
        TextViewFrom.text = ""
        TextViewTo.text = ""
        Distance.text = ""
    }
    
    func createMatrix(FromNode: Node, ToNode: Node) -> Array<Node> {
        var testConnection = Connection(from: FromNode, to: ToNode, distance: Double(Distance.text!)!)
        
        // Check if the connections Array is not null, an array must be not null to do a loop
        if (FromNode.connections.isEmpty)
        {
            FromNode.connections.append(testConnection)
            TextViewDistance.text = "Flight Added: "+testConnection.from.name+" To "+testConnection.to.name
        }
        else
        {
            for object:Connection in FromNode.connections{
                if (testConnection == object){
                    TextViewDistance.text = "Duplicated Flight!"
                    test2.text = ""
                    break
                }
                else{
                    FromNode.connections.append(testConnection)
                    TextViewDistance.text = "Flight Added: "+testConnection.from.name+" To "+testConnection.to.name
                    test2.text = ""
                }
            }
        }
        return listNode
    }
    
    
}

