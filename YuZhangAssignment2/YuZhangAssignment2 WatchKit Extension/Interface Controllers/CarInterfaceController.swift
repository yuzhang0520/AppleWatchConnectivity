//
//  CarInterfaceController.swift
//  YuZhangAssignment2 WatchKit Extension
//
//  Created by Xcode User on 2020-11-23.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class CarInterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet var carTable : WKInterfaceTable!
    var cars : [CarObject] = []
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        
        var replayValues = Dictionary<String, AnyObject>()
        
        let loadedData = message["carData"]
        
        let loadedCar = NSKeyedUnarchiver.unarchiveObject(with: loadedData as! Data) as? [CarObject]
        
        cars = loadedCar!
        
        replayValues["status"] = "Car List Received" as AnyObject?
        replyHandler(replayValues)
    }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        if(WCSession.isSupported()){
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if(WCSession.default.isReachable){
            let message = ["getCarData" : [:]]
            WCSession.default.sendMessage(message, replyHandler:
                {
                    (result) -> Void in
                    if result["carData"] != nil
                    {
                        let loadedData = result["carData"]
                        
                        NSKeyedUnarchiver.setClass(CarObject.self, forClassName: "CarObject")
                        let loadedCar = NSKeyedUnarchiver.unarchiveObject(with: loadedData as! Data) as? [CarObject]
                        
                        self.cars = loadedCar!
                        
                        self.carTable.setNumberOfRows(self.cars.count, withRowType: "CarRowController")
                        
                        print(self.cars.count)
                        print(self.cars[0].make!)
                        print(self.cars[1].make!)
                        print(self.cars[2].make!)
                        
                        for(index, car) in self.cars.enumerated(){
                            let row = self.carTable.rowController(at: index) as! CarRowConroller

                            row.lblMake.setText(car.make)
                            row.lblModel.setText(car.model)
                            row.lblYear.setText(car.year)
                            row.lblPrice.setText(car.price)
                        }
                    }
            }, errorHandler: {(error) -> Void in
                print(error)
            })
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
