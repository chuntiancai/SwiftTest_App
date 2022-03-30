//
//  JFZRecordAudioVedioController.swift
//  SwiftNote_App
//
//  Created by mathew on 2021/7/14.
//  Copyright © 2021 com.mathew. All rights reserved.
//

// 双录音视频，展示VC
///UI布局，一个tableView，两个section，一个放音频，一个放视频

import UIKit

class JFZRecordAudioVedioController:UIViewController {
    //MARK: - 对外属性
    var contractCode:String = "" {  //设置合同编码，去请求音视频
        didSet{
//            requestVideoFilesAPI(forContractCode: contractCode)
        }
    }
    /// 音视频播放列表
    var playerModelArray: [JFZAudioVideoModel]
        = [JFZAudioVideoModel]()
    {
        didSet{
            if videoModelArr == nil {
                videoModelArr = [JFZAudioVideoModel]()
            }
            if audioModelArr == nil {
                audioModelArr = [JFZAudioVideoModel]()
            }
            videoModelArr?.removeAll()
            audioModelArr?.removeAll()
            for item in playerModelArray {
                if item.isVideo {
                    videoModelArr?.append(item)
                }else{
                    audioModelArr?.append(item)
                }
            }
            self.tableView.reloadData()
        }
        
    }
    
    
    //MARK: - 内部属性
    //MARK: 工具属性
    private var isFullScreen:Bool = false { //隐藏状态栏
        didSet{
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    /// - Tag: 状态标志器
    private var preVideoIndexPath:IndexPath?    //前一个播放的视频View的索引
    private var preAudioView:JFZ_AudioPlayerView?   //前一个播放音频的View
    private var audioModelArr:[JFZAudioVideoModel]? //音频model的数组
    private var videoModelArr:[JFZAudioVideoModel]?     //视频model的数组
    private var playerViewDict = Dictionary<IndexPath,UIView>() //存储播放过的视频播放器，目前用于存放开始页面
    
    //MARK: UI属性
    private var tableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(JFZPlayerAudioTableViewCell.self, forCellReuseIdentifier: "JFZPlayerAudioTableViewCell_ID")
        tableView.register(JFZPlayerVideoTableViewCell.self, forCellReuseIdentifier: "JFZPlayerVideoTableViewCell_ID")

        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
        tableView.bounces = true
        tableView.separatorStyle = .none
        
        let tHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20))
        tHeaderView.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
        tableView.tableHeaderView = tHeaderView
        
        return tableView
    }()

    //MARK: - 复写方法
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "双录"
        self.view.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
        self.edgesForExtendedLayout = .bottom
//        requestVideoFilesAPI(forContractCode: "HT2021070200001")
        initUI()
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait,.landscapeRight]
    }
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        get{
            return .portrait
        }
    }
    override var prefersStatusBarHidden: Bool { //是否显示状态栏
        get{
            if isFullScreen {
                return true
            }else{
                return false
            }
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("JFZRecordAudioVedioController 的 touchesBegan方法")
        super.touchesBegan(touches, with: event)
    }
}

//MARK: - 设置UI
extension JFZRecordAudioVedioController{
    /// 初始化UI
    private func initUI(){
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.mj_header = MJRefreshHeader.init(refreshingBlock: {[weak self] () -> Void in
            print("mj_header 的更新方法:\(String(describing: self?.view.backgroundColor))")
        })
        
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
        
        if section == 0 {
            return audioModelArr?.count ?? 0
        }else{
            return videoModelArr?.count ?? 0
        }
        
    }
    
    //section头部View
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {//音频
            let audioHView = UIView(frame: CGRect.init(x: 0, y: 0, width: 375, height: 49))
            audioHView.backgroundColor = .white
            
            //左侧小方块
            let yellowBlockView = UIView.init(frame: CGRect.init(x: 15, y: 17, width: 4, height: 14))
            yellowBlockView.backgroundColor = UIColor.init(red: 194/255.0, green: 194/255.0, blue: 99/255.0, alpha: 1.0)
            audioHView.addSubview(yellowBlockView)
            
            let label = UILabel()
            label.text = "音频"
            label.textColor = .black
            audioHView.addSubview(label)
            label.snp.makeConstraints { make in
                make.left.equalTo(yellowBlockView.snp.right).offset(10)
                make.centerY.equalToSuperview()
            }
            //下划线
            let lineView = UIView()
            lineView.backgroundColor = UIColor.init(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
            audioHView.addSubview(lineView)
            lineView.snp.makeConstraints { make in
                make.bottom.equalToSuperview()
                make.left.equalToSuperview()
                make.height.equalTo(1)
                make.width.equalToSuperview()
            }
            
            //FIXME: 测试用
            label.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer.init(target: self, action:  #selector(testAction))
            label.addGestureRecognizer(tapGesture)
            
            return audioHView
        }else {//视频
            let videoHView = UIView()
            videoHView.backgroundColor = .white
            
            //左侧小方块
            let yellowBlockView = UIView.init(frame: CGRect.init(x: 15, y: 17, width: 4, height: 14))
            yellowBlockView.backgroundColor = UIColor.init(red: 194/255.0, green: 194/255.0, blue: 99/255.0, alpha: 1.0)
            videoHView.addSubview(yellowBlockView)
            
            let label = UILabel()
            label.text = "视频"
            label.textColor = .black
            videoHView.addSubview(label)
            label.snp.makeConstraints { make in
                make.left.equalTo(yellowBlockView.snp.right).offset(10)
                make.centerY.equalToSuperview()
            }
            
            //下划线
            let lineView = UIView()
            lineView.backgroundColor = UIColor.init(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
            videoHView.addSubview(lineView)
            lineView.snp.makeConstraints { make in
                make.bottom.equalToSuperview()
                make.left.equalToSuperview()
                make.height.equalTo(1)
                make.width.equalToSuperview()
            }
            return videoHView
        }
        
    }
    
    ///设置section头部的高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 49
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 92
        }else{
            return 234
        }
    }
    
    ///设置cell的UI
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        if indexPath.section == 0 { //音频
            cell = tableView.dequeueReusableCell(withIdentifier: "JFZPlayerAudioTableViewCell_ID", for: indexPath) as! JFZPlayerAudioTableViewCell
            (cell as! JFZPlayerAudioTableViewCell).title = audioModelArr![indexPath.row].fileName
            var curAudioView:JFZ_AudioPlayerView!
            if let curView = playerViewDict[indexPath] {
                curAudioView = curView as? JFZ_AudioPlayerView
            }else{
                curAudioView = JFZ_AudioPlayerView()
                playerViewDict[indexPath] = curAudioView
                curAudioView.togglePlayAction = {       //暂停播放音频文件
                    [weak self] _ in
                    if let preVIndex = self?.preVideoIndexPath {    //暂停播放视频
                        let prePlayerView = self?.playerViewDict[preVIndex] as? JFZ_VideoPlayerView
                        prePlayerView?.pauseVideo()
                    }
                    if let preView = self?.preAudioView {
                        if preView == curAudioView {    //点击了同一个view
                            return
                        }
                        preView.pauseAudio()    //暂停播放上一个音频
                    }
                    self?.preAudioView = curAudioView   //设置标志器
                }
            }
            
            (cell as! JFZPlayerAudioTableViewCell).baseAudioView.addSubview(curAudioView)
            curAudioView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            curAudioView.playAudioModel(model: audioModelArr![indexPath.row])
        }else{  //视频
            cell = tableView.dequeueReusableCell(withIdentifier: "JFZPlayerVideoTableViewCell_ID", for: indexPath) as! JFZPlayerVideoTableViewCell
            (cell as! JFZPlayerVideoTableViewCell).title = videoModelArr![indexPath.row].fileName
            (cell as! JFZPlayerVideoTableViewCell).playerConfig = videoModelArr![indexPath.row]
            var curVideoView:JFZ_VideoPlayerView!
            
            /// 缓存每一个JFZ_VideoPlayerView在字典里
            if let curView = playerViewDict[indexPath] {
                curVideoView = curView as? JFZ_VideoPlayerView
            }else{
                curVideoView = JFZ_VideoPlayerView()
                /// 设置回调
                curVideoView.isFullScreenAction = { //全屏的回调
                    [weak self] isFull in
                    self?.isFullScreen = isFull
                }
                curVideoView.indexPath = indexPath
                
                curVideoView.clickPlayerPanelAction = { //点击了控制面板按钮的回调
                    [weak self] index in
                    self?.preAudioView?.pauseAudio()    //暂停播放音频
                    
                    if let curIndex = self?.preVideoIndexPath {
                        if curIndex == index {  //点击了同一个cell的playerView，直接返回
                            return
                        }
                        let prePlayerView = self?.playerViewDict[curIndex] as? JFZ_VideoPlayerView
                        prePlayerView?.pauseVideo() //暂停播放视频
                    }
                    self?.preVideoIndexPath = index
                }
                playerViewDict[indexPath] = curVideoView
                curVideoView.playVideoModel(model: videoModelArr![indexPath.row])
            }
            /// 添加到cell
            (cell as! JFZPlayerVideoTableViewCell).addVideoView(subView: curVideoView)
            
        }
        
        return cell
    }
    
    ///点击了cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("JFZRecordAudioVedioController 点击了Cell")
    }
    
    ///结束展示的cell
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        print("结束展示的cell：",cell)
        if indexPath.section == 1 {
            guard let curCell = (cell as? JFZPlayerVideoTableViewCell) else {
                return
            }
            for subV in curCell.baseVideoView.subviews {
                if subV.isKind(of: JFZ_VideoPlayerView.self) {
                    //print("@@ JFZPlayerVideoTableViewCell\(self) 结束显示时，则暂停播放")
                    (subV as! JFZ_VideoPlayerView).pauseVideo()
                }
            }
        }
        
    }
    
    ///即将要显示的cell
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
}

//MARK: - 请求网络
extension JFZRecordAudioVedioController{
    
    /**
     /// 请求音视频文件
     private func requestVideoFilesAPI(forContractCode code:String){
         self.tableView.mj_header.endRefreshing()
         if code.isEmpty {
             print("请求的合同编码为空")
             return
         }
         let api = JFZAudioVideoFilesAPI()
         api.contractCode = code
         api.start { (res, err) in
             if err != nil {
                 // 拉取失败则重新拉取
                 print(" 拉取失败则重新拉取 JFZAudioVideoFilesAPI err:\(String(describing: err))")
                 return
             }
             
             if let res = res as? [String:Any] {
                 if let data = res["data"] as? [Dictionary<String, Any>] {
                     
                     var modelArr = [JFZAudioVideoModel]()
                     for curDict in data {
                         print("curDict:\(curDict)")
                         var vModel = JFZAudioVideoModel(fileName:"测试视频",
                                                    fileUrl: "",
                                                    imageUrlStr:"hahaha")
                         vModel.fileName = curDict["fileName"] as? String
                         vModel.fileUrl = curDict["url"] as? String ?? ""
                         vModel.createrTime = curDict["createrTime"] as? String
                         modelArr.append(vModel)
                     }
                     self.playerModelArray = modelArr
                     print("JFZAudioVideoFilesAPI data:\(data)")
                 }
                 
             }
         }
     }
     */
    
}

//MARK: - 内部工具方法
@objc extension JFZRecordAudioVedioController{
    /// FIXME:测试用
    func testAction(){
        print("点击测试")
         playerModelArray = [
                 JFZAudioVideoModel(fileName:"网络视频0",
                               fileUrl: "http://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4",
                               imageUrlStr:"hahaha"),
                 JFZAudioVideoModel(fileName:"网络音频0",
                               fileUrl: "http://music.163.com/song/media/outer/url?id=447925558.mp3",
                               imageUrlStr:"hahaha"),
                 JFZAudioVideoModel(fileName:"网络音频2",
                               fileUrl: "http://music.163.com/song/media/outer/url?id=27845048.mp3",
                               imageUrlStr:"hahaha"),
                 JFZAudioVideoModel(fileName:"网络视频1",
                               fileUrl: "http://vfx.mtime.cn/Video/2019/03/19/mp4/190319222227698228.mp4",
                               imageUrlStr:"hahaha"),
                 JFZAudioVideoModel(fileName:"网络视频2",
                               fileUrl: "http://vjs.zencdn.net/v/oceans.mp4",
                               imageUrlStr:"hahaha"),
             JFZAudioVideoModel(fileName:"网络视频3",
                           fileUrl: "http://vjs.zencdn.net/v/oceans.mp4",
                           imageUrlStr:"hahaha"),
             JFZAudioVideoModel(fileName:"网络视频4",
                           fileUrl: "http://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4",
                           imageUrlStr:"hahaha"),
             JFZAudioVideoModel(fileName:"网络视频5",
                           fileUrl: "http://vt1.doubanio.com/202001021917/01b91ce2e71fd7f671e226ffe8ea0cda/view/movie/M/301120229.mp4",
                           imageUrlStr:"hahaha"),
             JFZAudioVideoModel(fileName:"网络视频6",
                           fileUrl: "http://vjs.zencdn.net/v/oceans.mp4",
                           imageUrlStr:"hahaha"),
             JFZAudioVideoModel(fileName:"网络视频7",
                           fileUrl: "http://vt1.doubanio.com/202001022001/7264e07afc6d8347c15f61c247c36f0e/view/movie/M/302100358.mp4",
                           imageUrlStr:"hahaha"),
             JFZAudioVideoModel(fileName:"网络视频8",
                           fileUrl: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4",
                           imageUrlStr:"hahaha"),
             JFZAudioVideoModel(fileName:"网络视频9",
                           fileUrl: "https://mvvideo5.meitudata.com/56ea0e90d6cb2653.mp4",
                           imageUrlStr:"hahaha"),
             JFZAudioVideoModel(fileName:"网络视频10",
                           fileUrl: "http://vt1.doubanio.com/202001021947/7ae57141cc259bfb49e75bdf6b716caf/view/movie/M/301650578.mp4",
                           imageUrlStr:"hahaha"),
             ]
        
    }
}


