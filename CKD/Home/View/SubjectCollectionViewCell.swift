//
//  SubjectCollectionViewCell.swift
//  CKD
//
//  Created by casanube on 2020/11/27.
//  Copyright © 2020 casanube. All rights reserved.
//

import UIKit

class SubjectCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgV: UIImageView!
    
    @IBOutlet weak var imgVWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgVHeighConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

}
