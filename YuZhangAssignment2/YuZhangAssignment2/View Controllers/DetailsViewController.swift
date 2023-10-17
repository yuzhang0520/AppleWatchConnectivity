//
//  DetailsViewController.swift
//  YuZhangAssignment2
//
//  Created by Xcode User on 2020-11-22.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet var lblMake: UILabel!
    @IBOutlet var lblModel: UILabel!
    @IBOutlet var lblYear: UILabel!
    @IBOutlet var lblColour: UILabel!
    @IBOutlet var lblNewUsed: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblID: UILabel!
    @IBOutlet var imgImage: UIImageView!
    
    func updateCar(getData : GetData, select : Int){
        
        let rowData = (getData.dbData?[select])! as NSDictionary
        
        let imageUrlString = (rowData["Image"] as? String)!
        let imageUrl = URL(string: imageUrlString)!
        let imageData = try! Data(contentsOf: imageUrl)
        
        self.imgImage.image = UIImage(data: imageData)
        
        self.lblID.text = rowData["ID"] as? String
        self.lblMake.text = rowData["Make"] as? String
        self.lblModel.text = rowData["Year"] as? String
        self.lblColour.text = rowData["Colour"] as? String
        self.lblNewUsed.text = rowData["NewUsed"] as? String
        self.lblPrice.text = rowData["Price"] as? String
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
