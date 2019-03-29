//
//  ViewController.swift
//  MidTerm_Question3
//
//  Created by Minh Le on 2019-03-27.
//  Copyright © 2019 Minh Le. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    
    @IBOutlet weak var TextViewFrom: UITextField!
    
    @IBOutlet weak var TextViewTo: UITextField!

    @IBOutlet weak var TextViewDistance: UITextField!
    
    @IBOutlet weak var TextViewResult: UITextField!
    
    @IBOutlet weak var Button: UIButton!
    
    var listLocation: [Location] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func Calculate(_ sender: Any) {
        TextViewResult.text = ""
        
        let sourceLocation = Location.getLocation(LocationName: TextViewFrom.text!, listLocation: listLocation)
        let destinationLocation = Location.getLocation(LocationName: TextViewTo.text!,listLocation: listLocation)
        
        let path = Path.shortestPath(source: sourceLocation, destination: destinationLocation, listLocation: listLocation)
        
        if let succession: [String] = path?.array.reversed().flatMap({ $0 as? Location}).map({$0.name}) {
            for i in succession{
                TextViewResult.text! += i}
            
        } else {
            TextViewResult.text = "No path"
        }
        
    }
  
    @IBAction func Add(_ sender: Any) {
    
        //create Location
        var FromLocation = Location(name: TextViewFrom.text!)
        var ToLocation = Location(name: TextViewTo.text!)
        
        //Check if the Locations already in the list
        if (listLocation.isEmpty)
        {
            listLocation.append(FromLocation)
            listLocation.append(ToLocation)
        }
        else
        {
            for TestLocation: Location in listLocation
            {
                if (FromLocation == TestLocation){
                    FromLocation = TestLocation
                    break
                }
                else{listLocation.append(FromLocation)}
                
                if (ToLocation == TestLocation){
                    ToLocation = TestLocation
                    break
                }
                else{listLocation.append(ToLocation)}
            }
        }
        
        //create Matrix
        createMatrix(FromLocation: FromLocation, ToLocation: ToLocation)
       
        TextViewFrom.text = ""
        TextViewTo.text = ""
        TextViewDistance.text = ""
        TextViewResult.text = "Flight Added!"
    }
    
    func createMatrix(FromLocation: Location, ToLocation: Location) -> Void {
        let testConnection = Connection(from: FromLocation, to: ToLocation, distance: Double(TextViewDistance.text!)!)
        
        // Check if the connections Array is not null, an array must be not null to do a loop
        if (FromLocation.connections.isEmpty)
        {
            FromLocation.connections.append(testConnection)
            TextViewDistance.text = "Flight Added: "+testConnection.from.name+" To "+testConnection.to.name
        }
        else
        {
            for object:Connection in FromLocation.connections{
                if (testConnection == object){
                    TextViewDistance.text = "Duplicated Flight!"
                    break
                }
                else{
                    FromLocation.connections.append(testConnection)
                    TextViewDistance.text = "Flight Added: "+testConnection.from.name+" To "+testConnection.to.name
                }
            }
        }
    }
    
    
}

