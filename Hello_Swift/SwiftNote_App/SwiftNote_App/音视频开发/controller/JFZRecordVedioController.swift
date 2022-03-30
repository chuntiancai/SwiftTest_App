//
//  JFZRecordAudioVedioController.swift
//  SwiftNote_App
//
//  Created by chuntiancai on 2021/7/6.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 双录音视频，展示VC
///UI布局，一个tableView，两个section，一个放音频，一个放视频

import UIKit

class JFZRecordAudioVedioController:UIViewController {
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
extension JFZRecordAudioVedioController{
    /// 初始化UI
    private func initUI(){
        
    }
}

//MARK: - 动作方法
@objc extension JFZRecordAudioVedioController{
    
}

//MARK: - 遵循代理协议
extension JFZRecordAudioVedioController:UITableViewDelegate,UITableViewDataSource{
    
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
extension JFZRecordAudioVedioController{
    
}

