//
//  HomeViewController.swift
//  CKD
//
//  Created by casanube on 2020/11/10.
//  Copyright © 2020 casanube. All rights reserved.
//

import UIKit
import FSPagerView

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var newsList: [NewsModel] = []

    var homeModel: HomeModel?
    
    lazy var banner: FSPagerView = {
        let v = FSPagerView(frame: .init(x: 15, y: 0, width: screenW - 30, height: 100))
        v.isInfinite = true
        v.delegate = self
        v.dataSource = self
        v.automaticSlidingInterval = 3
        v.layer.cornerRadius = 4
        v.clipsToBounds = true
        v.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "FSPagerViewCellID")
        return v
    }()
    lazy var tableViewHeaderV: UIView = {
        let v = UIView(frame: .init(x: 0, y: 0, width: screenW, height: 100))
        v.addSubview(banner)
        return v
    }()
    
    lazy var pageControl: FSPageControl = {
        let control = FSPageControl()
        return control
    }()
    
    lazy var categoryView: SwitchControlView = {
        let v = UIView()
        let t = SwitchControlView{ (idx) -> Void? in
            print(idx)
        }
        return t
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    

    func setUI() {
        navigationItem.title = "家云CKD"
        tableView.tableHeaderView = tableViewHeaderV

        self.tableViewHeaderV.addSubview(self.pageControl)
        self.pageControl.snp.makeConstraints { (m) in
            m.left.equalTo(0)
            m.right.equalTo(0)
            m.bottom.equalTo(0)
            m.height.equalTo(25)
        }
        
        tableView.es.addPullToRefresh {
            [unowned self] in
            self.getData()
        }
        tableView.es.startPullToRefresh()
        tableView.estimatedRowHeight = 85
        tableView.register(HomeToolCell.self, forCellReuseIdentifier: "HomeToolCellID")
        tableView.register(UINib.init(nibName: "HomeSubjectCell", bundle: nil), forCellReuseIdentifier: "HomeSubjectCellID")
        tableView.register(UINib.init(nibName: "PicNewsCell", bundle: nil), forCellReuseIdentifier: "PicNewsCellID")
        tableView.register(UINib.init(nibName: "VideoCell", bundle: nil), forCellReuseIdentifier: "VideoCellID")
    }
    
    func getData() {
        CasHTTPProvider<HomeAPI>.request(api: HomeAPI.homeData, model: HomeModel.self, suc: { (res) in
            
            self.homeModel = res
            self.tableView.reloadData()
            
            if let list = self.homeModel?.bannerList {
                self.pageControl.numberOfPages = list.count
                self.banner.reloadData()
            }
   
            if let list = self.homeModel?.informationColumnList {
                self.categoryView.titlesArr = list.map{
                    $0.informationColumnName!
                }
            }
            self.tableView.es.stopPullToRefresh()
            
        }, fail: nil)
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2: homeModel == nil ? 0 : homeModel!.informationList!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        if indexPath.section == 0 {
            if row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomeToolCellID", for: indexPath) as! HomeToolCell
                cell.data = homeModel?.toolList
                return cell
            }
            if row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSubjectCellID", for: indexPath) as! HomeSubjectCell
                cell.data = homeModel?.subjectList
                return cell
            }
        }
        
        let model = homeModel?.informationList?[indexPath.row]
        if model?.informationType == "RESOURCE_ARTICLE" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PicNewsCellID", for: indexPath)
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCellID", for: indexPath)
            return cell
        }
                
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        return categoryView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 50
    }
}

extension HomeViewController: FSPagerViewDelegate, FSPagerViewDataSource{
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return homeModel?.bannerList?.count ?? 0
    }

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "FSPagerViewCellID", at: index)
        let bannerModel = homeModel?.bannerList![index]
        cell.imageView?.setNetworkImage(urlStr: bannerModel?.pictureUrl)
        cell.imageView?.contentMode = .scaleAspectFill
        return cell
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.pageControl.currentPage = pagerView.currentIndex
    }
}
