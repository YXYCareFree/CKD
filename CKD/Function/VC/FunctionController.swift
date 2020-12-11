//
//  FunctionController.swift
//  CKD
//
//  Created by casanube on 2020/12/7.
//  Copyright © 2020 casanube. All rights reserved.
//

import UIKit

class FunctionController: BaseViewController {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
//        layout.itemSize = CGSize(width: screenW / 3 , height: 110)
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.estimatedItemSize = CGSize(width: screenW / 3, height: 20)
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.backgroundColor = .clear
        v.showsVerticalScrollIndicator = false
        v.delegate = self
        v.dataSource = self
        v.register(UINib.init(nibName: "SubjectCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SubjectCollectionViewCellID")
        return v
    }()

    var data: [ToolModel?]? {
        didSet{
            collectionView.reloadData()
        }
    }
    lazy var btnClose: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "close"), for: .normal)
        btn.addTarget(self, action: #selector(closeClicked), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        getData()
    }
    
    func setUI() {
        
        view.addSubview(btnClose)
        btnClose.snp.makeConstraints { (m) in
            m.bottom.equalTo(-(keyWindow.safeAreaInsets.bottom + 25))
            m.centerX.equalTo(view)
        }
        
        let lblTitle = createUILable(textColor: "#030303".toUIColor(), font: PingFang(size: 17))
        lblTitle.text = "家云CKD"
        view.addSubview(lblTitle)
        lblTitle.snp.makeConstraints { (m) in
            m.top.equalTo(keyWindow.safeAreaInsets.top)
            m.centerX.equalTo(view)
        }
        
        let imgV = UIImageView()
        imgV.image = UIImage.init(named: "function_bg")
        view.addSubview(imgV)
        imgV.snp.makeConstraints { (m) in
            m.centerX.equalTo(view)
            m.top.equalTo(lblTitle.snp.bottom).offset(99)
        }
        
        view.addSubview(collectionView)
    }
    
    func getData() {
        CasHTTPProvider<HomeAPI>.request(api: .toolList, modelList: ToolModel.self, suc: { (res) in
            self.data = res
            var t = (self.data?.count ?? 0) / 3
            let m = (self.data?.count ?? 0) % 3
            if m != 0 {
                t += 1
            }
            self.collectionView.snp.makeConstraints { (m) in
                m.left.right.equalTo(0)
                m.bottom.equalTo(self.btnClose.snp.top).offset(-40)
                m.height.equalTo(110 * t)
            }
        }) { (msg) in
            
        }
        
    }
    
    @objc func closeClicked(){
        dismiss(animated: true, completion: nil)
    }

}

extension FunctionController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = data![indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubjectCollectionViewCellID", for: indexPath) as! SubjectCollectionViewCell
        cell.imgVHeighConstraint.constant = 50
        cell.imgVWidthConstraint.constant = 50
        cell.lblTitle.text = model?.toolName
        cell.lblTitle.textColor = "#333333".toUIColor()
        cell.imgV.setNetworkImage(urlStr: model?.toolImg)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = data![indexPath.item]
        print(model?.toolName! as Any)
    }
}
