//
//  MusicVC.swift
//  SwiftTool_App
//
//  Created by ctch on 2024/4/2.
//  Copyright © 2024 com.fendaTeamIOS. All rights reserved.
//

import UIKit

class MusicVC:UIViewController {
    //MARK: - 对外属性
    
    
    //MARK: - 内部属性
    private let tableView = UITableView(frame: .zero, style: .grouped)


    //MARK: - 复写方法
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "双录音视频VC"
        self.view.backgroundColor = .white
        self.edgesForExtendedLayout = .bottom
        
    }
}

//MARK: - 设置UI
extension MusicVC{
    /// 初始化UI
    private func initUI(){
        
    }
}

//MARK: - 动作方法
@objc extension MusicVC{
    
}

//MARK: - 遵循代理协议
extension MusicVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

//MARK: - 内部工具方法
extension MusicVC{
    
}
