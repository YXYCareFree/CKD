//
//  VideoPlayerController.swift
//  CKD
//
//  Created by casanube on 2020/12/4.
//  Copyright © 2020 casanube. All rights reserved.
//

import UIKit
import BMPlayer

class VideoPlayerController: BaseViewController {
    

    var informationId: Int?
    
    lazy var player: BMPlayer = {
        let p = BMPlayer()
        return p
    }()
    
    init(id: Int?) {
        super.init(nibName: nil, bundle: nil)
        self.informationId = id
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(player)
        player.snp.makeConstraints { (m) in
            m.top.left.right.bottom.equalTo(0)
        }
    
        player.backBlock = { [unowned self] (isFullScreen) in
//            if isFullScreen {
                self.navigationController?.popViewController(animated: true)
//            }
        }
        player.updateUI(true)
        getData()
    }
    
    func getData() {
        CasHTTPProvider<HomeAPI>.request(api: .newsDetail(param: ["informationContentId": informationId ?? ""]), suc: { (res) in
            let data = res as? NSDictionary
            let str = data?["informationDetail"] as! String
            let url = URL(string: str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            guard let _ = url else{
                print(data?["informationDetail"] as Any)
                return
            }
            self.player.setVideo(resource: .init(url: url!, name: data?["informationTitle"] as! String))
        }) { (msg) in
            
        }
    }


}
