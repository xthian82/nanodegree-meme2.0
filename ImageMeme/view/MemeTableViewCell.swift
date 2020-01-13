//
//  MemeTableViewCell.swift
//  ImageMeme
//
//  Created by Cristhian Recalde on 1/12/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

    let kTableViewCellID = "MemeTableViewCell"
    
    @IBOutlet weak var memedImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
