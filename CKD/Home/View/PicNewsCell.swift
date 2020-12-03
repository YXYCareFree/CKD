//
//  PicNewsCell.swift
//  CKD
//
//  Created by casanube on 2020/11/30.
//  Copyright © 2020 casanube. All rights reserved.
//

import UIKit

class PicNewsCell: UITableViewCell {


    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var vBottom: NewsBottomView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        
        imgV.clipsToBounds = true
        imgV.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
