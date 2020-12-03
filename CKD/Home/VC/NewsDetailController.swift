//
//  NewsDetailController.swift
//  CKD
//
//  Created by casanube on 2020/12/3.
//  Copyright © 2020 casanube. All rights reserved.
//

import UIKit
import WebKit

class NewsDetailController: UIViewController {

    @IBOutlet weak var wkWebView: WKWebView!
    
    var id: Any? {
        didSet {
            getData()
        }
    }
    
    var data: NSDictionary?
    
//    lazy var <#property name#> = <#expression#>
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "资讯详情"
        setUI()
        wkWebView.navigationDelegate = self
        wkWebView.scrollView.bounces = false
        wkWebView.scrollView.bouncesZoom = false
        wkWebView.scrollView.showsVerticalScrollIndicator = false
    }
    
    func setUI() {
        
    }
    
    func getData() {
        CasHTTPProvider<HomeAPI>.request(api: .newsDetail(param: ["informationContentId": id ?? ""]), suc: { (res) in
            self.data = res as? NSDictionary
            print(self.data!["informationDetail"]!)
            self.wkWebView.loadHTMLString(self.data!["informationDetail"] as! String, baseURL: nil)
//            self.wkWebView.load(.init(url: URL(string: "https://www.baidu.com/")!))
        }) { (msg) in
            
        }
    }
}

extension NewsDetailController: WKNavigationDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let js = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width,  user-scalable=no'); document.getElementsByTagName('head')[0].appendChild(meta);"
        webView.evaluateJavaScript(js, completionHandler: nil)
        
    }
}
