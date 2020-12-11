//
//  SwitchControlView.swift
//  CKD
//
//  Created by casanube on 2020/11/27.
//  Copyright © 2020 casanube. All rights reserved.
//

import UIKit

class SwitchControlView: UIView {
    
    var selectedIdx = 0
    var itemClicked: (_ idx: Int) -> Void
    
    var titlesArr: [String]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.estimatedItemSize = CGSize(width: 100, height: 30)
        let v = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        v.register(SwitchControlCell.self, forCellWithReuseIdentifier: "SwitchControlCellID")
        v.delegate = self
        v.dataSource = self
        v.showsVerticalScrollIndicator = false
        v.showsHorizontalScrollIndicator = false
        v.backgroundColor = .white
        return v
    }()
    
    init(titles: [String]? = nil, clicked:  @escaping (_ idx: Int) -> Void) {
        self.titlesArr = titles
        self.itemClicked = clicked
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        self.itemClicked = {idx in}
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(collectionView)
        collectionView.snp.remakeConstraints { (m) in
            m.edges.equalTo(self)
        }
    }
}

extension SwitchControlView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titlesArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SwitchControlCellID", for: indexPath) as! SwitchControlCell
        cell.lbl.text = titlesArr?[indexPath.item]
        cell.isSelected = (indexPath.item == selectedIdx)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        itemClicked(indexPath.item)
        
        if selectedIdx == indexPath.item {
            return
        }
        
        let index = IndexPath(item: selectedIdx, section: 0)
        let t = collectionView.cellForItem(at: index)
        t?.isSelected = false
        
        selectedIdx = indexPath.item
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.isSelected = true
    }
    
}

class SwitchControlCell: UICollectionViewCell {

    lazy var lbl: UILabel = {
        let t = UILabel()
        t.textAlignment = .center
        t.font = UIFont.init(name: "PingFang SC", size: 14)
        t.textColor = "0x999999".toUIColor()
        return t
    }()
    
    lazy var indicatorV: UIView = {
        let v = UIView()
        let layer = CAGradientLayer()
        layer.colors = ["#22BDC6".toUIColor().cgColor, "#99CC67".toUIColor().cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        v.layer.insertSublayer(layer, at: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
            layer.frame = v.bounds;
        }
        return v
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubview(lbl)
        lbl.snp.remakeConstraints { (m) in
            m.top.equalTo(5)
            m.left.right.equalTo(5)
        }
        
        contentView.addSubview(indicatorV)
        indicatorV.snp.remakeConstraints { (m) in
            m.top.equalTo(lbl.snp.bottom).offset(4)
            m.bottom.equalTo(0)
            m.height.equalTo(3)
            m.width.equalTo(24)
            m.centerX.equalTo(lbl.snp.centerX)
        }
    }
    
    override var isSelected: Bool{
        didSet{
            lbl.textColor = isSelected ? "#333333".toUIColor() : "#999999".toUIColor()
            lbl.font = isSelected ? UIFont.init(name: "PingFang SC", size: 16) : UIFont.init(name: "PingFang SC", size: 14)
            indicatorV.isHidden = !isSelected
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attr = super.preferredLayoutAttributesFitting(layoutAttributes)
        let str: NSString = lbl.text! as NSString
        var rect = str.boundingRect(with: CGSize(width: 800, height: 30), options: NSStringDrawingOptions.usesFontLeading, attributes: [NSAttributedString.Key.font: UIFont.init(name: "PingFang SC", size: 14) ?? UIFont.systemFont(ofSize: 14)], context: nil)
        rect.size.width += 10
        rect.size.height += 12
        attr.frame = rect
        return attr
    }
}
