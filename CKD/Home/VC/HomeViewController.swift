//
//  HomeViewController.swift
//  CKD
//
//  Created by casanube on 2020/11/10.
//  Copyright © 2020 casanube. All rights reserved.
//

import UIKit
import FSPagerView

class HomeViewController: BaseViewController {
    
    deinit {
        print("deinit")
    }

    @IBOutlet weak var tableView: UITableView!


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
    
    var newsTypeIdx = 0
    lazy var categoryView: SwitchControlView = {
        let t = SwitchControlView{ [unowned self] (idx) -> Void in
            self.newsTypeIdx = idx
            self.loadMore()
        }
        return t
    }()
    
    
    var pageStartList: [Int] = []
    var newsList: [[NewsModel?]] = []

   
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
        
        tableView.es.addInfiniteScrolling {
            [unowned self] in
            self.loadMore()
        }
        
        tableView.es.addPullToRefresh {
            [unowned self] in
            self.getData()
        }
    
        self.getData()
//        tableView.es.startPullToRefresh()
        tableView.estimatedRowHeight = 85
        tableView.register(HomeToolCell.self, forCellReuseIdentifier: "HomeToolCellID")
        tableView.register(UINib.init(nibName: "HomeSubjectCell", bundle: nil), forCellReuseIdentifier: "HomeSubjectCellID")
        tableView.register(UINib.init(nibName: "PicNewsCell", bundle: nil), forCellReuseIdentifier: "PicNewsCellID")
        tableView.register(UINib.init(nibName: "VideoCell", bundle: nil), forCellReuseIdentifier: "VideoCellID")
    }
    
    func getData() {
        CasHTTPProvider<HomeAPI>.request(api: HomeAPI.homeData, model: HomeModel.self, suc: { (res) in
            
            self.homeModel = res
            
            
            if let count = res?.informationColumnList?.count {
                for i in 0..<count {
                    if i == 0 {
                        self.pageStartList.insert(2, at: 0)
                        self.newsList.insert((res?.informationList) ?? [], at: 0)
                    }else {
                        self.pageStartList.insert(1, at: i)
                        self.newsList.insert([], at: i)
                        if i == self.newsTypeIdx {
                            self.loadMore()
                        }
                    }
                }
            }
            
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
    
    func loadMore() {
        
        CasHTTPProvider<HomeAPI>.request(api: .newsList(param: ["limit": "10", "page": pageStartList[newsTypeIdx], "informationColumnCode": homeModel?.informationColumnList?[newsTypeIdx].informationColumnCode as Any]), modelList: NewsModel.self, suc: { (res) in
           
            self.tableView.es.stopLoadingMore()
            
            if let count = res?.count{
                if count > 0 {
                    var data = self.newsList[self.newsTypeIdx]
                    data.append(contentsOf: res!)
                    self.newsList.insert(data, at: self.newsTypeIdx)
                    self.tableView.reloadData()
                    return
                }
            }
            self.tableView.es.noticeNoMoreData()
            
        }) { (msg) in
            
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2: homeModel == nil ? 0 : newsList[newsTypeIdx].count
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
        
        let model = newsList[newsTypeIdx][indexPath.row]
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
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            
            let model = newsList[newsTypeIdx][indexPath.row]
            if model?.informationType == "RESOURCE_ARTICLE" {
                let vc = NewsDetailController()
                vc.id = model?.informationContentId
                navigationController?.pushViewController(vc, animated: true)
            }else{
                navigationController?.pushViewController(VideoPlayerController(id: model?.informationContentId), animated: true)
                
            }
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
