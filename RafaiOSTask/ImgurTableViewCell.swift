//
//  ImgurTableViewCell.swift
//  RafaiOSTask
//
//  Created by Saraceni on 3/8/16.
//  Copyright © 2016 rafa. All rights reserved.
//

import UIKit

class ImgurTableViewCell: UITableViewCell {
    
    static let identifier = "imgurTableViewCell"

    @IBOutlet var imgurImageView: UIImageView!
    @IBOutlet var imgurLabel: UILabel!
    
    var imgurObject: ImgurObject?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
