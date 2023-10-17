//
//  GetData.swift
//  YuZhangAssignment2
//
//  Created by Xcode User on 2020-11-22.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import UIKit

class GetData: NSObject {

    var dbData : [NSDictionary]?
    let myUrl = "https://zhang30.dev.fast.sheridanc.on.ca/iosAssignment2/sqlToJson.php" as String
    
    enum JSONError : String, Error{
        case NoData = "Error: No Data"
        case ConversionFailed = "Error: conversion from JSON Failed"
    }
    
    func jsonParser(){
        
        guard let endpoint = URL(string: myUrl) else{
            print("Error creating connection")
            return
        }
        
        let request = URLRequest(url: endpoint)
        
        URLSession.shared.dataTask(with: request){
            (data, response, error) in
            do{
                let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print(dataString!)
                
                guard let data = data else{
                    throw JSONError.NoData
                }
                
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [NSDictionary]
                    else{
                        throw JSONError.ConversionFailed
                }
                print(json)
                self.dbData = json
                
            }catch let error as JSONError{
                print(error.rawValue)
            }catch let error as NSError{
                print(error.debugDescription)
            }
            
            }.resume()
        
    }
}
