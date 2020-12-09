//
//  NewsDetailController.swift
//  CKD
//
//  Created by casanube on 2020/12/3.
//  Copyright © 2020 casanube. All rights reserved.
//

import UIKit
import WebKit

class NewsDetailController: BaseViewController {

    var id: Any? {
        didSet {
            getData()
        }
    }
    
    var data: NSDictionary?
    
    lazy var lblAuthor: UILabel = createUILable(textColor: "#23BDC5".toUIColor(), font: PingFang(size: 14))
    lazy var lblTitle: UILabel = createUILable(textColor: "#333333".toUIColor(), font: PingFang(size: 16), numberOfLines: 2)
    lazy var lblTime: UILabel = createUILable(textColor: Color9, font: PingFang(size: 14))
    lazy var lblLook: UILabel = createUILable(textColor: Color9, font: PingFang(size: 12))
    lazy var imgVLook: UIImageView = {
       let t = UIImageView()
        t.image = UIImage.init(named: "unread")
        return t
    }()
    lazy var wkWebView: WKWebView = {
        let webview = WKWebView()
        webview.navigationDelegate = self
        webview.scrollView.bounces = false
        webview.scrollView.bouncesZoom = false
        webview.scrollView.showsVerticalScrollIndicator = false
        webview.scrollView.isScrollEnabled = false
        return webview
    }()
    
    lazy var scrollView: UIScrollView = {
        let scr = UIScrollView()
        scr.showsHorizontalScrollIndicator = false
        scr.showsVerticalScrollIndicator = false
        return scr
    }()
    
    lazy var btnMore: UIButton = createUIButton(textColor: "#23BDC5".toUIColor(), font: PingFang(size: 14))
    lazy var btnCollect: UIButton = createUIButton(textColor: "#999999".toUIColor(), font: PingFang(size: 12))
    lazy var btnUseful: UIButton = createUIButton(textColor: "#999999".toUIColor(), font: PingFang(size: 12))
    
    deinit {
        wkWebView.scrollView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "资讯详情"
        setUI()

        edgesForExtendedLayout = []
        wkWebView.scrollView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func setUI() {
        let vBottom = UIView()
        view.addSubview(vBottom)
        vBottom.snp.makeConstraints { (m) in
            m.left.right.equalTo(0)
            m.bottom.equalTo(-keyWindow.safeAreaInsets.bottom)
            m.height.equalTo(44)
        }
        
        vBottom.addSubview(btnMore)
        btnMore.addTarget(self, action: #selector(btnMoreClicked), for: .touchUpInside)
        btnMore.snp.makeConstraints { (m) in
            m.left.equalTo(15)
            m.centerY.equalTo(0)
        }
        
        btnUseful.setImage(UIImage.init(named: "dislike"), for: .normal)
        btnUseful.setTitle("  有用", for: .normal)
        btnUseful.addTarget(self, action: #selector(btnUsefulClicked), for: .touchUpInside)
        vBottom.addSubview(btnUseful)
        btnUseful.snp.makeConstraints { (m) in
            m.right.equalTo(-15)
            m.centerY.equalTo(vBottom.snp.centerY)
        }
        
        btnCollect.setImage(UIImage.init(named: "collect"), for: .normal)
        btnCollect.addTarget(self, action: #selector(btnCollectClicked), for: .touchUpInside)
        vBottom.addSubview(btnCollect)
        btnCollect.snp.makeConstraints { (m) in
            m.right.equalTo(btnUseful.snp.left).offset(-30)
            m.centerY.equalTo(vBottom.snp.centerY)
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (m) in
            m.left.equalTo(15)
            m.top.equalTo(0)
            m.right.equalTo(-15)
            m.bottom.equalTo(vBottom.snp.top)
        }
        
        let vBg = UIView()
        scrollView.addSubview(vBg)
        vBg.snp.makeConstraints { (m) in
            m.left.top.right.bottom.equalTo(0)
            m.width.equalTo(screenW - 30)
        }
        
        vBg.addSubview(lblTitle)
        lblTitle.snp.makeConstraints { (m) in
            m.left.right.equalTo(0)
            m.top.equalTo(10)
        }
        
        vBg.addSubview(lblAuthor)
        lblAuthor.snp.makeConstraints { (m) in
            m.left.equalTo(0)
            m.top.equalTo(lblTitle.snp.bottom).offset(8)
        }

        vBg.addSubview(lblTime)
        lblTime.snp.makeConstraints { (m) in
            m.left.equalTo(lblAuthor.snp.right).offset(8)
            m.centerY.equalTo(lblAuthor.snp.centerY)
        }

        vBg.addSubview(lblLook)
        lblLook.snp.makeConstraints { (m) in
            m.right.equalTo(0)
            m.centerY.equalTo(lblAuthor.snp.centerY)
        }

        vBg.addSubview(imgVLook)
        imgVLook.snp.makeConstraints { (m) in
            m.centerY.equalTo(lblAuthor.snp.centerY)
            m.right.equalTo(lblLook.snp.left).offset(-5)
        }

        vBg.addSubview(wkWebView)
        wkWebView.snp.makeConstraints { (m) in
            m.left.right.bottom.equalTo(0)
            m.top.equalTo(lblAuthor.snp.bottom).offset(15)
            m.height.equalTo(screenH - 64 - 44 - 40)
        }
    }
    
    func getData() {
        CasHTTPProvider<HomeAPI>.request(api: .newsDetail(param: ["informationContentId": id ?? ""]), suc: { (res) in
            self.data = res as? NSDictionary
            self.wkWebView.loadHTMLString(self.data!["informationDetail"] as! String, baseURL: nil)
            self.lblAuthor.text = self.data?["author"] as? String
            self.lblTitle.text = self.data?["informationTitle"] as? String
            self.lblTime.text = self.handleTimeStr(time: "\(self.data?["createDttm"] ?? "")")
            self.lblLook.text = "\(self.data?["browseCount"] ?? "0" )"
            self.btnCollect.setTitle("  \(self.data?["collectionCount"] ?? "0")", for: .normal)
            if let t = self.data?["subjectName"] {
                self.btnMore.setTitle("更多“\(t)”相关文章", for: .normal)
            }
        }) { (msg) in
            
        }
    }
    
    func handleTimeStr(time: String) -> String {
        if time.count < 6 {
            return ""
        }
        let str: NSString = time as NSString
        return "\(time.prefix(4)).\(str.substring(with: .init(location: 4, length: 2))).\(str.substring(with: .init(location: 6, length: 2)))"
    }
    
    @objc func btnMoreClicked(){
        
    }
    
    @objc func btnCollectClicked(){
        
    }
    
    @objc func btnUsefulClicked(){
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            let size = change?[NSKeyValueChangeKey.newKey] as! CGSize
            wkWebView.snp.updateConstraints { (m) in
                m.height.equalTo(size.height)
            }
        }
    }
    
}

extension NewsDetailController: WKNavigationDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        let js = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width,  user-scalable=no'); document.getElementsByTagName('head')[0].appendChild(meta);"
//        webView.evaluateJavaScript(js, completionHandler: nil)
        
        print(wkWebView.scrollView.contentSize)
        
    }
}
