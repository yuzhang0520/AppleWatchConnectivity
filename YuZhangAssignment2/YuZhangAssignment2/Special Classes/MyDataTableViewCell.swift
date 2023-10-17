//
//  MyDataTableViewCell.swift
//  YuZhangAssignment2
//
//  Created by Xcode User on 2020-11-22.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import UIKit

class MyDataTableViewCell: UITableViewCell {
    
    @IBOutlet var myMake: UILabel!
    @IBOutlet var myPrice: UILabel!
    @IBOutlet var myImage: UIImageView!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
