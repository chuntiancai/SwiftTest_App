//
//  JFZRecordAudioVedioController.swift
//  SwiftNote_App
//
//  Created by mathew on 2021/7/14.
//  Copyright © 2021 com.mathew. All rights reserved.
//

// 双录音视频，展示VC
//MARK: - 笔记
/**
    UI布局，一个tableView，两个section，一个放音频，一个放视频。点击标题进行测试。
 
 */


class JFZRecordAudioVedioController:UIViewController {
    
    //MARK: - 对外属性
    /// 音视频播放列表模型数组
    /// tableview根据音视频列表进行加载。
    var playerModelArray: [JFZAudioVideoModel] = [JFZAudioVideoModel]()
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
        initUI()
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.all]
    }
    
    override var prefersStatusBarHidden: Bool { //是否显示状态栏
        get{
            if isFullScreen {  return true }else{  return false }
        }
    }
    
    ///VC的图层是否跟随旋转。
    override var shouldAutorotate: Bool {
        return true
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
    }
    
}


//MARK: - 遵循tableview的代理协议
extension JFZRecordAudioVedioController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 { return audioModelArr?.count ?? 0  }else{  return videoModelArr?.count ?? 0 }
        
    }
    
    //section头部View
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {//音频
            let audioHView = getTableHeaderView("音频")
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(testAddMidea))
            audioHView.addGestureRecognizer(tapGesture)
            return audioHView
        }else {//视频
            let videoHView = getTableHeaderView("视频")
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
                curVideoView.isTapFullScreenBtnAction = { //全屏的回调
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
    
    func requestNetWork(){
        /// 在这里填写请求网络的代码；
            print("请求网络。")
    }
    
}

//MARK: - 内部工具方法
@objc extension JFZRecordAudioVedioController{
    
    /// FIXME:测试用加载音视频列表
    func testAddMidea(){
        print("点击测试")
        if !playerModelArray.isEmpty { print("已经测试填充列表了");return}
        playerModelArray = [
//            JFZAudioVideoModel(fileName:"网络视频0",
//                               fileUrl: "http://vfx.mtime.cn/Video/2019/06/27/mp4/190627231412433967.mp4",
//                               imageUrlStr:"hahaha"),
//            JFZAudioVideoModel(fileName:"网络音频0",
//                               fileUrl: "http://music.163.com/song/media/outer/url?id=447925558.mp3",
//                               imageUrlStr:"hahaha"),
//            JFZAudioVideoModel(fileName:"网络音频2",
//                               fileUrl: "http://music.163.com/song/media/outer/url?id=27845048.mp3",
//                               imageUrlStr:"hahaha"),
//            JFZAudioVideoModel(fileName:"网络视频1",
//                               fileUrl: "http://vfx.mtime.cn/Video/2019/06/29/mp4/190629004821240734.mp4",
//                               imageUrlStr:"hahaha"),
//            JFZAudioVideoModel(fileName:"网络视频2",
//                               fileUrl: "http://vjs.zencdn.net/v/oceans.mp4",
//                               imageUrlStr:"hahaha"),
            JFZAudioVideoModel(fileName:"网络视频3",
                               fileUrl: "http://vjs.zencdn.net/v/oceans.mp4",
                               imageUrlStr:"hahaha"),
//            JFZAudioVideoModel(fileName:"网络视频4",
//                               fileUrl: "http://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4",
//                               imageUrlStr:"hahaha"),
//            JFZAudioVideoModel(fileName:"网络视频5",
//                               fileUrl: "http://vt1.doubanio.com/202001021917/01b91ce2e71fd7f671e226ffe8ea0cda/view/movie/M/301120229.mp4",
//                               imageUrlStr:"hahaha"),
//            JFZAudioVideoModel(fileName:"网络视频6",
//                               fileUrl: "http://vjs.zencdn.net/v/oceans.mp4",
//                               imageUrlStr:"hahaha"),
//            JFZAudioVideoModel(fileName:"网络视频7",
//                               fileUrl: "http://vt1.doubanio.com/202001022001/7264e07afc6d8347c15f61c247c36f0e/view/movie/M/302100358.mp4",
//                               imageUrlStr:"hahaha"),
//            JFZAudioVideoModel(fileName:"网络视频8",
//                               fileUrl: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4",
//                               imageUrlStr:"hahaha"),
//            JFZAudioVideoModel(fileName:"网络视频9",
//                               fileUrl: "https://mvvideo5.meitudata.com/56ea0e90d6cb2653.mp4",
//                               imageUrlStr:"hahaha"),
//            JFZAudioVideoModel(fileName:"网络视频10",
//                               fileUrl: "http://vt1.doubanio.com/202001021947/7ae57141cc259bfb49e75bdf6b716caf/view/movie/M/301650578.mp4",
//                               imageUrlStr:"hahaha"),
        ]
        /**
         URL(string: "http://vfx.mtime.cn/Video/2019/06/29/mp4/190629004821240734.mp4")!,
         URL(string: "http://vfx.mtime.cn/Video/2019/06/27/mp4/190627231412433967.mp4")!,
         URL(string: "http://vfx.mtime.cn/Video/2019/06/25/mp4/190625091024931282.mp4")!,
         URL(string: "http://vfx.mtime.cn/Video/2019/06/16/mp4/190616155507259516.mp4")!,
         URL(string: "http://vfx.mtime.cn/Video/2019/06/15/mp4/190615103827358781.mp4")!,
         URL(string: "http://vfx.mtime.cn/Video/2019/06/05/mp4/190605101703931259.mp4")!,
         */
    }
    
    /// 获取tableview的section view
    func getTableHeaderView(_ title:String) -> UIView{
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        //左侧小方块
        let yellowBlockView = UIView.init(frame: CGRect.init(x: 15, y: 17, width: 4, height: 14))
        yellowBlockView.backgroundColor = UIColor.init(red: 194/255.0, green: 194/255.0, blue: 99/255.0, alpha: 1.0)
        headerView.addSubview(yellowBlockView)
        
        let label = UILabel()
        label.text = title
        label.textColor = .black
        headerView.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalTo(yellowBlockView.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
        
        //下划线
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
        headerView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(1)
            make.width.equalToSuperview()
        }
        return headerView
    }
    
    
}


