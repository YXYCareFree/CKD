//
//  WebViewController.swift
//  CKD
//
//  Created by casanube on 2020/12/11.
//  Copyright © 2020 casanube. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: BaseViewController {
    
    var urlStr: String = ""{
        didSet{
            
        }
    }
    
    lazy var webView: WKWebView = {
        let w = WKWebView()
        return w
    }()
    
    init(title: String = "", url: String) {
        self.urlStr = url
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(webView)
        webView.snp.makeConstraints { (m) in
            m.edges.equalTo(view)
        }
        webView.load(.init(url: URL.init(string: urlStr)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10))
    }
    
}
