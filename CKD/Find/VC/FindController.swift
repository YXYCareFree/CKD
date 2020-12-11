//
//  FindController.swift
//  CKD
//
//  Created by casanube on 2020/12/9.
//  Copyright © 2020 casanube. All rights reserved.
//

import UIKit

class FindController: BaseViewController {

    @IBOutlet weak var switchControlView: SwitchControlView!
    
    @IBOutlet weak var vSearchBg: UIView!
    @IBOutlet weak var tabVCategory: UITableView!
    
    @IBOutlet weak var tabVDetail: UITableView!
    
    @IBOutlet weak var txtF: UITextField!
    
    var selectedCategory = 0
    
    var categoryData: [[String: Any]]?{
        didSet{
            tabVCategory.reloadData()
        }
    }
    
    var categoryDetailData: [[String: Any]]?{
        didSet{
            tabVDetail.reloadData()
        }
    }
    
    var newsList: [NewsModel?]? {
        didSet{
            tabVDetail.reloadData()
        }
    }
    
    var switchType = 0
    
        
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        getCategoryData()
        getNewsData(param: ["": ""])
    }
     
    func setupUI() {
        view.backgroundColor = "#f2f2f2".toUIColor()
        txtF.returnKeyType = .search
        vSearchBg.clipsToBounds = true
        vSearchBg.layer.cornerRadius = 18
        vSearchBg.layer.borderWidth = 0.5
        vSearchBg.layer.borderColor = "#dddddd".toUIColor().cgColor
        
        let placeholder = NSAttributedString(string: "请输入关键字", attributes: [NSAttributedString.Key.font: PingFang(size: 15), NSAttributedString.Key.foregroundColor: "#999999".toUIColor()])
        txtF.attributedPlaceholder = placeholder
        
        tabVCategory.rowHeight = 40
        tabVCategory.register(UINib.init(nibName: "CategoryCell", bundle: nil), forCellReuseIdentifier: "CategoryCellID")
        
//        tabVDetail.rowHeight = 80
        tabVDetail.estimatedRowHeight = 80
        tabVDetail.register(UINib.init(nibName: "CategoryDetailCell", bundle: nil), forCellReuseIdentifier: "CategoryDetailCellID")
        tabVDetail.register(UINib.init(nibName: "PicNewsCell", bundle: nil), forCellReuseIdentifier: "PicNewsCellID")
        tabVDetail.register(UINib.init(nibName: "VideoCell", bundle: nil), forCellReuseIdentifier: "VideoCellID")
        self.tabVDetail.snp.remakeConstraints { (m) in
            m.left.right.bottom.equalTo(0)
            m.top.equalTo(self.vSearchBg.snp.bottom).offset(10)
        }
        
        switchControlView.titlesArr = ["肾病百问", "肾食百科"]
        switchControlView.itemClicked = { [unowned self] idx in
            print(idx)
            self.switchType = idx
            if idx == 0 {
                self.tabVDetail.snp.remakeConstraints { (m) in
                    m.left.right.bottom.equalTo(0)
                    m.top.equalTo(self.vSearchBg.snp.bottom).offset(10)
                }
            }else{
                self.tabVDetail.snp.remakeConstraints { (m) in
                    m.right.bottom.equalTo(0)
                    m.top.equalTo(self.vSearchBg.snp.bottom).offset(10)
                    m.left.equalTo(self.tabVCategory.snp.right).offset(0.5)
                }
            }
            self.tabVDetail.reloadData()
        }
        
    }
    
    func getCategoryData() {
        CasHTTPProvider<FindAPI>.request(api: .foodType, suc: { (res) in
            self.categoryData = res as? [[String : Any]]
            guard let _ = self.categoryData?.count else{
                return
            }
            self.getCategoryDetailData(param: ["foodTypeCode": self.categoryData?[0]["foodTypeCode"] as! String])
            
        }) { (msg) in
            
        }
    }
    
    func getCategoryDetailData(param: Parameters) {
        CasHTTPProvider<FindAPI>.request(api: .foodListByType(param: param), suc: { (res) in
            self.categoryDetailData = res as? [[String : Any]]
        }) { (msg) in
            
        }
    }
    
    func getNewsData(param: Parameters) {
        var p = param
        p["page"] = "1"
        p["limit"] = "100"
        CasHTTPProvider<FindAPI>.request(api: .news(param: p), modelList: NewsModel.self, suc: { (res) in
            self.newsList = res
            self.tabVDetail.emptyView?.isHidden = self.newsList?.count != 0
        }) { (msg) in
            
        }
    }
}

extension FindController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tabVCategory {
            return categoryData?.count ?? 0
        }
        if switchType == 0 {
            let count = newsList?.count ?? 0
            return count
        }else{
            let count = categoryDetailData?.count ?? 0
            tabVDetail.emptyView?.isHidden = count != 0
            return count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tabVCategory {
            let data = categoryData?[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCellID", for: indexPath) as! CategoryCell
            cell.lblTitle.text = data?["foodTypeName"] as? String
            cell.vTopSplit.isHidden = indexPath.row != 0
            if selectedCategory == indexPath.row {
                cell.isSelected = true
            }
            return cell
        }
        
        if switchType == 0 {
            let model = newsList?[indexPath.row]
            if model?.informationType == "RESOURCE_ARTICLE" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PicNewsCellID", for: indexPath) as! PicNewsCell
                cell.imgV.setNetworkImage(urlStr: model?.informationImg)
                cell.lblTitle.text = model?.informationTitle
                setBottomView(model: model, view: cell.vBottom)
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCellID", for: indexPath) as! VideoCell
                cell.imgV.setNetworkImage(urlStr: model?.informationImg)
                cell.lblTitle.text = model?.informationTitle
                setBottomView(model: model, view: cell.vBottom)
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryDetailCellID", for: indexPath) as! CategoryDetailCell
            let data = categoryDetailData?[indexPath.row]
            cell.imgV.setNetworkImage(urlStr: data?["pictureAddress"] as? String)
            cell.lblTitle.text = data?["foodName"] as? String
            cell.lblDetail.text = "蛋白质\(data?["proteinEvaluationReferenceUnit"] ?? "")\(data?["benchmarkUnit"] ?? "")/\(data?["benchmarkValues"] ?? "")\(data?["benchmarkUnit"] ?? "")"
            cell.lblK.isHidden = "\(data?["highPotassium"] ?? 0)" == "0"
            cell.lblP.isHidden = "\(data?["highPhosphorus"] ?? 0)" == "0"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tabVCategory {
            if selectedCategory == indexPath.row {
                return
            }
            let t = IndexPath(row: selectedCategory, section: 0)
            var cell = tableView.cellForRow(at: t)
            cell?.isSelected = false
            
            cell = tableView.cellForRow(at: indexPath)
            cell?.isSelected = true
            selectedCategory = indexPath.row
            
            self.getCategoryDetailData(param: ["foodTypeCode": self.categoryData?[selectedCategory]["foodTypeCode"] as! String])
        }
    }
    
    func setBottomView(model: NewsModel?, view: NewsBottomView) {
        view.btnLike.setImage(UIImage.init(named: (model?.isLike!)! > 0 ? "dislike" : "dislike"), for: .normal)
        view.btnRead.setImage(UIImage.init(named: "unread"), for: .normal)
        view.btnCollect.setImage(UIImage.init(named: (model?.isCollection!)! > 0 ? "collect" : "collect"), for: .normal)
        view.btnCollect.setTitle("\(model?.collectionCount ?? 0)", for: .normal)
        view.btnRead.setTitle("\(model?.browseCount ?? 0)", for: .normal)
        view.btnLike.setTitle("\(model?.likeCount ?? 0)", for: .normal)
    }
}

extension FindController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.getCategoryDetailData(param: ["keywords": textField.text ?? ""])
        
        return true
    }
}
