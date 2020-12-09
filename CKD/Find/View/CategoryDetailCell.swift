//
//  CategoryDetailCell.swift
//  CKD
//
//  Created by casanube on 2020/12/9.
//  Copyright © 2020 casanube. All rights reserved.
//

import UIKit

class CategoryDetailCell: UITableViewCell {

    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblK: UILabel!
    
    @IBOutlet weak var lblP: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lblK.clipsToBounds = true
        lblP.clipsToBounds = true
        lblP.layer.cornerRadius = 3.6
        lblK.layer.cornerRadius = 3.6
        
        imgV.clipsToBounds = true
        imgV.layer.cornerRadius = 5
        
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
