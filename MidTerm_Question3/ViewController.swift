//
//  ViewController.swift
//  MidTerm_Question3
//
//  Created by Minh Le on 2019-03-27.
//  Copyright © 2019 Minh Le. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    var connections: [Connection] = []
    

    @IBOutlet weak var TextViewFrom: UITextField!
    
    @IBOutlet weak var TextViewTo: UITextField!

    @IBOutlet weak var TextViewDistance: UITextField!
    
    @IBOutlet weak var TextViewResult: UITextField!
    
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
        TextViewResult.text = ""

        let sourceNode = getNode(NodeName: TextViewFrom.text!)
        
        let destinationNode = getNode(NodeName: TextViewTo.text!)
        
        
        let path = shortestPath(source: sourceNode, destination: destinationNode)
        
        if let succession: [String] = path?.array.reversed().flatMap({ $0 as? Node}).map({$0.name}) {
            for i in succession{
                TextViewResult.text! += i}
            
        } else {
            TextViewResult.text = "No path"
        }
        
        
    }
    var listFlight: [Flight] = []
    var listNode: [Node] = []
   

    struct Flight {
        var from = ""
        var to = ""
        var distance = 0.0
    }
    
    func shortestPath(source: Node, destination: Node) -> Path? {
       
        for i in listNode{
            i.visited = false
        }
        
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
        listFlight.append(ViewController.Flight.init(from: TextViewFrom.text!, to: TextViewTo.text!, distance: Double(TextViewDistance.text!)!))
        
        
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
        TextViewDistance.text = ""
    }
    
    func createMatrix(FromNode: Node, ToNode: Node) -> Array<Node> {
        var testConnection = Connection(from: FromNode, to: ToNode, distance: Double(TextViewDistance.text!)!)
        
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
                    break
                }
                else{
                    FromNode.connections.append(testConnection)
                    TextViewDistance.text = "Flight Added: "+testConnection.from.name+" To "+testConnection.to.name
                }
            }
        }
        return listNode
    }
    
    
}

