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
    
    var selectedCategory: Int?
    
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
        
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        getCategoryData()
    }
     
    func setupUI() {
        view.backgroundColor = "#f2f2f2".toUIColor()
        
        vSearchBg.clipsToBounds = true
        vSearchBg.layer.cornerRadius = 18
        vSearchBg.layer.borderWidth = 0.5
        vSearchBg.layer.borderColor = "#dddddd".toUIColor().cgColor
        
        let placeholder = NSAttributedString(string: "请输入关键字", attributes: [NSAttributedString.Key.font: PingFang(size: 15), NSAttributedString.Key.foregroundColor: "#999999".toUIColor()])
        txtF.attributedPlaceholder = placeholder
        
        tabVCategory.rowHeight = 40
        tabVCategory.register(UINib.init(nibName: "CategoryCell", bundle: nil), forCellReuseIdentifier: "CategoryCellID")
        
        tabVDetail.rowHeight = 80
        tabVDetail.register(UINib.init(nibName: "CategoryDetailCell", bundle: nil), forCellReuseIdentifier: "CategoryDetailCellID")
        
        switchControlView.titlesArr = ["肾病百问", "肾食百科"]
        switchControlView.itemClicked = { idx in
            print(idx)
        }
    }
    
    func getCategoryData() {
        CasHTTPProvider<FindAPI>.request(api: .foodType, suc: { (res) in
            self.categoryData = res as? [[String : Any]]
            guard let _ = self.categoryData?.count else{
                return
            }
            self.getCategoryDetailData(code: self.categoryData?[0]["foodTypeCode"] as! String)
            
        }) { (msg) in
            
        }
    }
    
    func getCategoryDetailData(code: String) {
        CasHTTPProvider<FindAPI>.request(api: .foodListByType(param: ["foodTypeCode": code]), suc: { (res) in
            self.categoryDetailData = res as? [[String : Any]]
        }) { (msg) in
            
        }
    }
}

extension FindController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tabVCategory {
            return categoryData?.count ?? 0
        }
        return categoryDetailData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tabVCategory {
            let data = categoryData?[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCellID", for: indexPath) as! CategoryCell
            cell.lblTitle.text = data?["foodTypeName"] as? String
            cell.vTopSplit.isHidden = indexPath.row != 0
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryDetailCellID", for: indexPath) as! CategoryDetailCell
        let data = categoryDetailData?[indexPath.row]
        cell.imgV.setNetworkImage(urlStr: data?["pictureAddress"] as? String)
        cell.lblTitle.text = data?["foodName"] as? String
        cell.lblDetail.text = "蛋白质\(data?["proteinEvaluationReferenceUnit"] ?? "")\(data?["benchmarkUnit"] ?? "")/\(data?["benchmarkValues"] ?? "")\(data?["benchmarkUnit"] ?? "")"
        cell.lblK.isHidden = "\(data?["highPotassium"] ?? 0)" == "0"
        cell.lblP.isHidden = "\(data?["highPhosphorus"] ?? 0)" == "0"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tabVCategory {
            if selectedCategory != nil {
                if selectedCategory == indexPath.row {
                    return
                }
                let t = IndexPath(row: selectedCategory!, section: 0)
                let cell = tableView.cellForRow(at: t)
                cell?.isSelected = false
            }
            
            let cell = tableView.cellForRow(at: indexPath)
            cell?.isSelected = true
            selectedCategory = indexPath.row
            
            self.getCategoryDetailData(code: self.categoryData?[selectedCategory!]["foodTypeCode"] as! String)
        }
    }
    
    
}
