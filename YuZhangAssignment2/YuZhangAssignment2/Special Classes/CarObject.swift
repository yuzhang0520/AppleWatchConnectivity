//
//  CarObject.swift
//  YuZhangAssignment2
//
//  Created by Xcode User on 2020-11-22.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import UIKit

class CarObject: NSObject, NSCoding {

    var id: String?
    var make: String?
    var model: String?
    var year: String?
    var colour: String?
    var newUsed: String?
    var price: String?
    
    func initWithData (id: String, make: String, model: String, year: String,
                       colour: String, newUsed: String, price: String){
        self.id = id
        self.make = make
        self.model = model
        self.year = year
        self.colour = colour
        self.newUsed = newUsed
        self.price = price
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let id = decoder.decodeObject(forKey: "id") as? String,
            let make = decoder.decodeObject(forKey: "make") as? String,
            let model = decoder.decodeObject(forKey: "model") as? String,
            let year = decoder.decodeObject(forKey: "year") as? String,
            let colour = decoder.decodeObject(forKey: "colour") as? String,
            let newUsed = decoder.decodeObject(forKey: "newUsed") as? String,
            let price = decoder.decodeObject(forKey: "price") as? String
            else{
                return nil
        }
        self.init()
        self.initWithData(id: id, make: make, model: model, year: year, colour: colour, newUsed: newUsed, price: price)
    }
    
    func encode(with coder: NSCoder){
        coder.encode(self.id, forKey: "id")
        coder.encode(self.make, forKey: "make")
        coder.encode(self.model, forKey: "model")
        coder.encode(self.year, forKey: "year")
        coder.encode(self.colour, forKey: "colour")
        coder.encode(self.newUsed, forKey: "newUsed")
        coder.encode(self.price, forKey: "price")
    }
}
