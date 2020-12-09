//
//  CategoryCell.swift
//  CKD
//
//  Created by casanube on 2020/12/9.
//  Copyright © 2020 casanube. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var vTopSplit: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override var isSelected: Bool{
        didSet{
            contentView.backgroundColor = isSelected ? "#f2f2f2".toUIColor() : .white
        }
    }
}
