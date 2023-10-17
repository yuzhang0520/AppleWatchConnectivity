//
//  TableViewController.swift
//  YuZhangAssignment2
//
//  Created by Xcode User on 2020-11-22.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import UIKit
import WatchConnectivity

class TableViewController: UITableViewController, WCSessionDelegate {
    
    let getData = GetData()
    var timer : Timer!
    @IBOutlet var myTable : UITableView!
    
    var cars : [CarObject] = []
    var lastMessage : CFAbsoluteTime = 0
//    var getCarDic : [NSDictionary] = []
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        
        var replayValues = Dictionary<String, AnyObject>()
        
        if(message["getCarData"] != nil){
            NSKeyedArchiver.setClassName("CarObject", for:CarObject.self)
            
            let carData = NSKeyedArchiver.archivedData(withRootObject: cars)
            
            replayValues["carData"] = carData as AnyObject?
            replyHandler(replayValues)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.refreshTable), userInfo: nil, repeats: true)
        
        getData.jsonParser()
        print(cars)
        
    }
    
    @objc func refreshTable(){
        if(getData.dbData != nil){
            
            if(getData.dbData?.count)! > 0{
                self.myTable.reloadData()
                self.timer.invalidate()
            }
        }
    }
    
    func loadCarInfo(carData: [NSDictionary]){
        
        for(car) in carData{
            var count : Int = 0
            let getCar = CarObject()
            getCar.initWithData(id: (car["ID"] as? String)!, make: (car["Make"] as? String)!, model: (car["Model"] as? String)!, year: (car["Year"] as? String)!, colour: (car["Colour"] as? String)!, newUsed: (car["newUsed"] as? String)!, price: (car["Price"] as? String)!)
            cars.insert(getCar, at: count)
            count = count + 1
        }
        
        
        
    }
    
    func sendWatchMessage(_ msgData: Data){
        let currentTime = CFAbsoluteTimeGetCurrent()
        
        if lastMessage + 0.5 > currentTime{
            return
        }
        
        if(WCSession.default.isReachable){
            let message = ["carData" : msgData]
            WCSession.default.sendMessage(message, replyHandler: nil)
        }
        
        lastMessage = CFAbsoluteTimeGetCurrent()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if(WCSession.isSupported()){
            let session = WCSession.default
            session.delegate = self
            session.activate()
            
            if session.isPaired != true{
                print("Apple Watch is not paired")
            }
            if session.isWatchAppInstalled != true{
                print("WatchKit app is not installed")
            }
        }
        else{
            print("WatchConnectivity is not supported on this device")
        }
        
        print(cars)
        let carData = NSKeyedArchiver.archivedData(withRootObject: cars)
        sendWatchMessage(carData)
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if getData.dbData != nil{
            return (getData.dbData?.count)!
        }
        else{
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as? MyDataTableViewCell ?? MyDataTableViewCell(style: .default, reuseIdentifier: "myCell")
        
        // Configure the cell...
        let row = indexPath.row
        let rowData = (getData.dbData?[row])! as NSDictionary
        
        let carObject = CarObject()
        carObject.initWithData(id: (rowData["ID"] as? String)!, make: (rowData["Make"] as? String)!, model: (rowData["Model"] as? String)!, year: (rowData["Year"] as? String)!, colour: (rowData["Colour"] as? String)!, newUsed: (rowData["NewUsed"] as? String)!, price: (rowData["Price"] as? String)!)
        cars.insert(carObject, at: row)
        
        let imageUrlString = (rowData["Image"] as? String)!
        let imageUrl = URL(string: imageUrlString)!
        let imageData = try! Data(contentsOf: imageUrl)
        
        cell.myImage.image = UIImage(data: imageData)
        cell.myMake.text = rowData["Make"] as? String
        cell.myPrice.text = rowData["Price"] as? String
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let split = self.splitViewController{
            let controllers = split.viewControllers
            let detailsViewController = controllers[controllers.count - 1] as? DetailsViewController
            detailsViewController?.updateCar(getData: getData, select: indexPath.row)
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
