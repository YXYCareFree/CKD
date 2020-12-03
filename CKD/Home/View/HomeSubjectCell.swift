//
//  HomeSubjectCell.swift
//  CKD
//
//  Created by casanube on 2020/11/27.
//  Copyright © 2020 casanube. All rights reserved.
//

import UIKit

class HomeSubjectCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    lazy var collectionView: UICollectionView = getCollectionView()
    
    var data: [SubjectModel]? {
        didSet {
            collectionView.reloadData()
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (m) in
            m.left.equalTo(15)
            m.right.equalTo(-15)
            m.bottom.equalTo(-10)
            m.height.equalTo(80)
            m.top.equalTo(lblTitle.snp.bottom).offset(0)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getCollectionView() -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: (screenW - 30) / 4, height: 80)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let v = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        v.backgroundColor = .white
        v.delegate = self
        v.dataSource = self
        v.register(UINib.init(nibName: "SubjectCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SubjectCollectionViewCellID")
        v.showsHorizontalScrollIndicator = false
        v.showsVerticalScrollIndicator = false
        return v
    }
}

extension HomeSubjectCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView .dequeueReusableCell(withReuseIdentifier: "SubjectCollectionViewCellID", for: indexPath) as! SubjectCollectionViewCell
        if let model = data?[indexPath.item] {
            cell.imgV.setNetworkImage(urlStr: model.subjectImg)
            cell.lblTitle.text = model.subjectName
        }
        return cell
    }
    
    
}
