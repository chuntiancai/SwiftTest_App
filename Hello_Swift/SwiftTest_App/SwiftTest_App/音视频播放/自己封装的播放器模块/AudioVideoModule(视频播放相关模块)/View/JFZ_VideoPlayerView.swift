//
//  JFZ_VideoPlayerView.swift
//  SwiftTest_App
//
//  Created by chuntiancai on 2021/7/18.
//  Copyright © 2021 com.mathew. All rights reserved.
//
//视频播放的View，在这里封装AVPalyer处理视频源。一开始不播放，点击按钮后才播放。
//MARK: - 笔记
/**
    1、可以全屏，全屏主要用了transform，添加到window上，然后transform当前的view。
        目前还没兼容手机锁定方向时，全屏旋转的问题。
    2、在playVideoModel(_:)方法传入视频源model即可。已经适配了snpkit，或者一开始就传入frame。
 */

import UIKit
import AVFoundation

class JFZ_VideoPlayerView : UIView {
    
    //MARK: - 对外属性
    /// 视频源
    var isFullScreenAction:((_ isFull:Bool)->Void)?
    var isPlaying:Bool {    //是否正在播放
        get{
            var isBool = false
            if let player = avPlayer {
                if #available(iOS 10.0, *) {
                    switch player.timeControlStatus {
                    case .playing:
                        isBool = true
                    case .waitingToPlayAtSpecifiedRate:
                        isBool = true
                    case .paused:
                        isBool = false
                    @unknown default:
                        isBool = false
                    }
                } else {
                    if  (player.rate != 0) && (player.error == nil) { //正在播放
                        isBool = true
                    }else { //正在暂停
                        isBool = false
                    }
                }
            }
            return isBool
        }
    }
    var curVideoFrameImg:UIImage?{  //返回当前播放的那一帧的视频帧的截图
        get{
            return getCurAVAssetFrameImg()
        }
    }
    var clickPlayerPanelAction:((_ indexPath:IndexPath?)->Void)?  //点击了当前view的动作方法
    var indexPath:IndexPath?    //暂时是为了方便寻找所在的cell
    
    //MARK: - 内部属性
    /// - Tag: AVPlayer相关属性：
    private var avPlayer: AVPlayer? //可选，是为了判断是不是第一次加载播放器，避免多次监听相关属性
    
    /// 监听播放器的当前播放状态，The `NSKeyValueObservation` for the KVO on `\AVPlayer.timeControlStatus`.
    private var playerTimeControlStatusObserver: NSKeyValueObservation?
    
    /// 监听播放速度，rate==1时播放，rate==0时暂停
    private var playerRateStatusObserver: NSKeyValueObservation?
    
    ///监听播放器的时间进度，0.001秒，A token obtained from the player's `addPeriodicTimeObserverForInterval(_:queue:usingBlock:)` method.必须要销毁，不然会占用线程
    private var timeObserverToken: Any?
    
    /// 监听AVPlayerItem的可播放状态， The `NSKeyValueObservation` for the KVO on `\AVPlayer.currentItem?.status`.
    private var playerItemStatusObserver: NSKeyValueObservation?
    
    
    /// AVPlayerItem相关属性：
    private var curPlayerItem: AVPlayerItem? {
        didSet {
            if oldValue != nil {        //移除原来对AVPlayerItem的监听
                playerItemStatusObserver?.invalidate()
                playerItemStatusObserver = nil
            }
            if let _ = curPlayerItem {
                
                playerItemStatusObserver = curPlayerItem?.observe(\AVPlayerItem.status, options: [.new, .initial]) { [weak self] playItem, changeDict in
                    DispatchQueue.main.async {
                        print("当前监听的status的playItem是：\(playItem)")
                        ///当资产可播放时，更新UI
                        self?.updateUIforPlayerItemStatus()
                    }
                }
                ///获取封面图
                self.stratVideoFrameImgView.image = getCurAVAssetFrameImg()
            }
        }
    }
    
    ///  显示的视频的layer：
    private var videoLayer = AVPlayerLayer()
   
    //MARK: UI属性
    /// 播放控制面板的View
    private var ctrlPanelView = JFZVideoControlPanelView()
    private var preFatherView:UIView?   //前一个父View
    private let stratVideoFrameImgView:UIImageView = UIImageView()  //视频的开始帧图片
    private var loadAVAssetFailedView:UIView!   //加载失败的View
    private let loadingVideoView:UIView=UIView()   //正在加载视频，还没得播放的View

    //MARK: 工具属性
    ///时间格式器
    private let timeRemainingFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.hour,.minute, .second]
        return formatter
    }()
    private var curVideoModel:JFZAudioVideoModel?   //当前传入的视频model
    private var curAVURLAsset:AVURLAsset?   //当前传入的AVURLAsset
    private var isLoadingAVAssetFailed:Bool?{   //是否加载AVAsset失败
        didSet{
            if let isFailed = isLoadingAVAssetFailed{
                if isFailed{    //加载AVAsset失败
                    
                }else{  //加载AVAsset成功
                    
                }
            }
        }
    }
    private var curPlayTime:Double = 0.2 //当前的播放时间
    private var playerItemDict = Dictionary<String,AVPlayerItem>() //简单的一个播放缓存
    

    //MARK: - 复写方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        if frame == .zero {
            ///let screenWidth = UIScreen.main.bounds.width
            ///let screenHeight = UIScreen.main.bounds.height
            self.frame = CGRect.init(x: 0, y: 0, width: 345, height: 194)
        }
        self.backgroundColor = .black
        self.isUserInteractionEnabled = true
        videoLayer.frame = self.frame
        self.layer.addSublayer(videoLayer)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let isPointed = super.point(inside: point, with: event)
        return isPointed
    }
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print("JFZ_VideoPlayerView 的 hitTest(_ point 方法")
        let hitView = super.hitTest(point, with: event)
        let isPointed = self.point(inside: point, with: event)
        //TODO: 为了回传当前view被点击，后期优化
        if isPointed,let isCtrl = hitView?.isKind(of: UIControl.self),isCtrl{
            if clickPlayerPanelAction != nil{
                clickPlayerPanelAction!(self.indexPath)
            }
        }
        
        return hitView
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /// 如果事件没有从响应者链传到这里，而point(inside方法又是true，则证明子view们，没有消化事件
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /**
         let orient = UIDevice.current.orientation
         print("当前设备的方向:\(orient.rawValue)")
         print("当前frame的尺寸：\(self.frame)")
         print("当前的superView是：\(self.superview)")
         print("当前的superView的frame是：\(self.superview?.frame)")
         */
        
        if let superView = self.superview, superView.isKind(of: UIWindow.self){
            print("在window中，当前view的frame是：\(self.frame)")
            videoLayer.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width)
        }else{
            videoLayer.frame = self.frame
        }
        
    }
    
    deinit {
        destoryPlayerTimerObserver()
    }
}

//MARK: - 设置UI
extension JFZ_VideoPlayerView{
    
    /// 初始化UI
    func initUI(){
        ///当前视频帧的imgView
        stratVideoFrameImgView.contentMode = .scaleAspectFit
        self.addSubview(stratVideoFrameImgView)
        stratVideoFrameImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        ///控制面板View
        self.addSubview(ctrlPanelView)
        ctrlPanelView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        ///加载失败的View
        loadAVAssetFailedView = getPlayFailedView()
        self.addSubview(loadAVAssetFailedView)
        loadAVAssetFailedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        ///正在加载视频的View
        loadingVideoView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        loadingVideoView.isHidden = true
        self.addSubview(loadingVideoView)
        loadingVideoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    /// 设置控制面板的逻辑
    private func setCtrlPanelViewLogic(){
        
        // 点击了播放按钮的回调
        ctrlPanelView.togglePlayAction = {
            [weak self] in
            guard let _ = self?.avPlayer else {
                return
            }
            if #available(iOS 10.0, *) {
                switch self?.avPlayer?.timeControlStatus
                {
                case .playing:
                    self?.pauseVideo()
                case .paused:
                    /// 如果是播放结束导致的暂停状态，则从头开始播放
                    let currentItem = self?.avPlayer?.currentItem
                    if currentItem?.currentTime() == currentItem?.duration {
                        currentItem?.seek(to: .zero, completionHandler: nil)
                    }
                    self?.playVideo()
                    
                default:
                    break
                }
            } else
            {
                if let player = self?.avPlayer
                {
                    if  (player.rate != 0) && (player.error == nil) { //正在播放
                        self?.pauseVideo()
                    }else { //正在暂停
                        /// 如果是播放结束导致的暂停状态，则从头开始播放
                        let currentItem = self?.avPlayer?.currentItem
                        if currentItem?.currentTime() == currentItem?.duration
                        {
                            currentItem?.seek(to: .zero, completionHandler: nil)
                        }
                        self?.playVideo()
                    }
                }
            }
        }
        
        // 播放进度条的值发生改变。
        ctrlPanelView.sliderValueChangingAction = {     //滑块值变化的回调
            [weak self] sliderValue -> Void  in
            guard let _ = self?.avPlayer else {
                return
            }
            self?.pauseVideo() //暂停播放
            /// 跳转到播放时间
            let newTime = CMTime(seconds: Double(sliderValue), preferredTimescale: 600)
            self?.avPlayer!.seek(to: newTime, toleranceBefore: .zero, toleranceAfter: .zero)
            ///更新开始时间的值
            self?.ctrlPanelView.startTimeLabel.text = self?.createTimeString(time: sliderValue)
            ///print("滑块值变化的回调：\(sliderValue)")
        }
        
        //滑块已经抬起时的值
        ctrlPanelView.sliderValueDidChangedAction = {
            [weak self] sliderValue -> Void  in
            self?.playVideo()  //开始播放
        }
        
        //全屏播放按钮的回调
        ctrlPanelView.toggleFullScreenAction = {
            [weak self] in
            guard let _ = self?.avPlayer else {
                return
            }
            print("全屏播放按钮的回调～")
            DispatchQueue.main.async {
                if let isFull = self?.ctrlPanelView.isFullScreen {
                    if isFull
                    {
                        self?.toggleNormalScreen()
                    }else{
                        self?.toggleFullScreen()
                    }
                }
            }
            
        }
    }
    
    /// 显示加载AVAsset失败的View
    private func showLoadingAVAssetView(){
        loadAVAssetFailedView.isHidden = false
    }
    
    /// 隐藏加载AVAsset失败的View
    private func hideLoaidingAVAssetView(){
        loadAVAssetFailedView.isHidden = true
    }
    
    /// 显示正在加载视频的View
    private func showLoadingVideoView(){
        loadingVideoView.isHidden = false
    }
    
    /// 隐藏正在加载视频的View
    private func hideLoadingVideoView(){
        loadingVideoView.isHidden = true
    }
    
}

//MARK: - 对外提供的方法
extension JFZ_VideoPlayerView{
    
    /// 播放视频
    func playVideo(){
        if let player = avPlayer {
            if self.curPlayerItem == player.currentItem{
                avPlayer?.play()
            }else{
                avPlayer?.replaceCurrentItem(with: self.curPlayerItem)
                avPlayer?.play()
            }
            stratVideoFrameImgView.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
                [weak self] in
                if #available(iOS 10.0, *) {
                    if self?.avPlayer?.timeControlStatus == .waitingToPlayAtSpecifiedRate { //正在加载视频
                        self?.showLoadingVideoView()
                    }
                }
            }
        }
       
    }
    
    /// 暂停播放
    func pauseVideo(){
        if let player = avPlayer {
            if let _ = player.currentItem{
                avPlayer?.pause()
            }
        }
    }
    
    /// 设置播放视频源
    /// - Parameter model: 视频源的model
    func playVideoModel(model:JFZAudioVideoModel){
        self.curVideoModel = model
        guard let url = URL(string: model.fileUrl) else {
            print("传入的URL字符串无效")
            return
        }
        if let playItem = curPlayerItem {   //当前有播放器
            if let curUrl = (playItem.asset as? AVURLAsset)?.url {
                if curUrl == url {
                    print("传入的url和当前curPlayerItem中的asset的url相同")
                    return
                }else{
                    print("传入的url和当前curPlayerItem中的asset的url不一样")
                }
            }
        }
        if let playItem = playerItemDict[model.fileUrl] {
            //从缓存中拿到了播放项
            print("从缓存中拿到了播放项")
            self.replacePlayerItem(playerItem: playItem)
            return
        }
        self.pauseVideo()
        let asset = AVURLAsset(url: url)
        print("JFZ_VideoPlayerView 传进来的asset:\(url)")
        
        ///加载视频资产AVURLAsset的key，并验证它的key是否都有效，然后加载播放器
        loadPropertyValues(forAsset: asset)
        
        
        /// 播放结束的通知
        NotificationCenter.default.addObserver(self, selector: #selector(playToEndTime), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: curPlayerItem)
    }
    
    
}


//MARK: - 内部逻辑方法
extension JFZ_VideoPlayerView{
    
    /// 先验证传入的视频资产AVURLAsset是否有效，加载AVURLAsset的相关key，从而再创建播放器
    func loadPropertyValues(forAsset newAsset: AVURLAsset) {
        
        let assetKeysRequiredToPlay = [
            "playable", //当前视频资产是否可播放的key
            "hasProtectedContent"   //是否有受保护内容，有则不可以播放
        ]
        self.showLoadingVideoView()
        self.loadAVAssetFailedView.isHidden = true  //先隐藏加载失败
        /// 使用异步线程，避免加载AVURLAsset的key造成主线程堵塞
        newAsset.loadValuesAsynchronously(forKeys: assetKeysRequiredToPlay) {
             
            /// 这个 completion handler是在随机线程中执行的，所以要在主线程中统一维护状态。
            DispatchQueue.main.async { [weak self] in
                
                if let isValidate = self?.validateValues(forKeys: assetKeysRequiredToPlay, forAsset: newAsset),isValidate {
                    /// 设置监听播放器和KVO监听
                    self?.setupPlayerAndObservers()
                    
                    /// 设置视频资源管理项
                     self?.setupAVPlayerItemAndObservers(forAsset: newAsset)
                }else{
                    print("AVURLAsset验证无效，不能播放～～\(newAsset)")
                    self?.loadAVAssetFailedView.isHidden = false  //显示加载失败
                }
                self?.hideLoadingVideoView()
            }
        }
        
    }
    
    ///  设置播放器以及相关的KVO监听
    func setupPlayerAndObservers() {
        if avPlayer == nil {
            avPlayer = AVPlayer()
        }else{
            /// 已经初始化过了，不需要再次初始化，避免多次监听AVPlayer
            return
        }
        self.videoLayer.player = avPlayer
        
        ///监听播放器播放状态，切换播放/暂停按钮UI
        if #available(iOS 10.0, *) {
            playerTimeControlStatusObserver = avPlayer?.observe(\AVPlayer.timeControlStatus,
                                                                options: [.initial, .new]) { [weak self] _, _ in
//                print("监听到播放器播放状态的变化status：\(String(describing: self?.avPlayer?.timeControlStatus.rawValue))")
                DispatchQueue.main.async {
                    self?.updateUIforPlayerStatus()  //根据播放状态更新UI
                }
            }
        } else {
            
            playerRateStatusObserver = avPlayer?.observe(\AVPlayer.rate, options: [.initial, .new], changeHandler: { [weak self] player, change in
//                print("目标机器不是iOS 10.0以上，不通过timeControlStatus监听播放｜暂停状态rate:\(String(describing: self?.avPlayer?.rate))")
                DispatchQueue.main.async {
                    self?.updateUIforPlayerStatus()  //根据播放状态更新UI
                }
            })
        }
        
        
        /// 监听播放时间，更新时间进度滑块Slider的值
        let interval = CMTime(value: 1, timescale: 2)
        timeObserverToken = avPlayer?.addPeriodicTimeObserver(forInterval: interval,
                                                              queue: .main) { [unowned self] time in
            
//            print("监听到播放的时间变化：\(time.seconds)")
            self.curPlayTime = time.seconds
            if !self.ctrlPanelView.isTouchingSlider {   //没有正在点击才去更新值
                let timeElapsed = Float(time.seconds)
                self.ctrlPanelView.sliderValue = timeElapsed
                self.ctrlPanelView.startTimeLabel.text = self.createTimeString(time: timeElapsed)
            }
            
        }
        
    }
    
    /// 设置播放器和视频管理项 和 KVO监听
    private func setupAVPlayerItemAndObservers(forAsset newAsset: AVURLAsset){
        let playerItem = AVPlayerItem(asset: newAsset)
        self.curPlayerItem = playerItem
        
        if let model  = self.curVideoModel {    //设置缓存
            playerItemDict[model.fileUrl] = playerItem
        }
        
        //MARK: swift监听KVO
        /// AVPlayerItem的status属性监听，当前视频资产可播放状态
        playerItemStatusObserver = curPlayerItem?.observe(\AVPlayerItem.status, options: [.new, .initial]) { [weak self] playItem, changeDict in
            DispatchQueue.main.async {
                print("当前监听的status的playItem是：\(playItem)")
                ///当资产可播放时，更新UI
                self?.updateUIforPlayerItemStatus()
            }
        }
        
    }
    
    /// 替换播放源
    private func replacePlayerItem(playerItem:AVPlayerItem){
        if avPlayer == nil {
            setupPlayerAndObservers()
        }
        self.curPlayerItem = playerItem
        avPlayer?.replaceCurrentItem(with: self.curPlayerItem)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {    //延迟0.05秒，等待curPlayerItem加载完
//            [weak self] in
//            self?.playVideo()
//        }
    }
}

//MARK: - KVO监听的动作方法
extension JFZ_VideoPlayerView{
    
    /// （监听到AVPlayer的状态发生变化）更新播放的UI
    func updateUIforPlayerStatus() {
        
        if #available(iOS 10.0, *) {
            switch self.avPlayer?.timeControlStatus {
            case .playing:
                hideLoadingVideoView()
                self.ctrlPanelView.isPlaying = true
            case .waitingToPlayAtSpecifiedRate:
                break
            case .paused:
                self.hideLoadingVideoView()
                self.ctrlPanelView.isPlaying = false
            case .none:
                break
            @unknown default:
                break
            }
        } else {
            if let player = self.avPlayer {
                if  (player.rate != 0) && (player.error == nil) { //正在播放
                    self.ctrlPanelView.isPlaying = true
                }else { //正在暂停
                    self.ctrlPanelView.isPlaying = false
                }
            }
        }
        
    }
    
    /// （监听到AVPlayerItem的状态变化），进行播放，更新UI等操作
    func updateUIforPlayerItemStatus() {
        guard let currentItem = curPlayerItem else { return }
        
        print("AVPlayerItem的状态是：\(currentItem.status.rawValue)")
        switch currentItem.status {
        case .failed:
            ///资产不可以播放时，无效化 播放按钮，时间进度条 等UI
            print("AVPlayerItem无法播放")
            /*
             Display an error if the player item status property equals `.failed`.
             */
            ctrlPanelView.playButton.isEnabled = false
            ctrlPanelView.slider.isEnabled = false
            ctrlPanelView.startTimeLabel.isEnabled = false
            ctrlPanelView.endTimeLabel.isEnabled = false
//            handleErrorWithMessage(currentItem.error?.localizedDescription ?? "", error: currentItem.error)
            
        case .readyToPlay:
            print("AVPlayerItem播放就绪")
            
            /*
             更新播放按钮，进度条，播放时间的UI
             */
            ctrlPanelView.playButton.isEnabled = true
            let newDurationSeconds = Float(currentItem.duration.seconds)
            
            let currentTime = Float(CMTimeGetSeconds(avPlayer!.currentTime()))
            
            ctrlPanelView.slider.maximumValue = newDurationSeconds
            ctrlPanelView.sliderValue = currentTime
            ctrlPanelView.slider.isEnabled = true
            ctrlPanelView.startTimeLabel.isEnabled = true
            ctrlPanelView.startTimeLabel.text = createTimeString(time: currentTime)
            ctrlPanelView.endTimeLabel.isEnabled = true
            ctrlPanelView.endTimeLabel.text = createTimeString(time: newDurationSeconds)
            
        //FIXME:暂时是播放
        /**
         avPlayer?.play()
         ctrlPanelView.isPlaying = true
         */
            
            
        default:
            break
//            ctrlPanelView.playButton.isEnabled = false
//            ctrlPanelView.slider.isEnabled = false
//            ctrlPanelView.startTimeLabel.isEnabled = false
//            ctrlPanelView.endTimeLabel.isEnabled = false
        }
    }
    
    
}

//MARK: - 处理全屏相关的逻辑、UI
extension JFZ_VideoPlayerView{
    
    /// 触发全屏
    private func toggleFullScreen(){
        
        guard let fatherView = self.superview else {
            print("没有父View")
            return
        }
         if isFullScreenAction != nil {
             isFullScreenAction!(true)
         }
        
        //感知设备方向 - 开启监听设备方向，无论是否在AppDelegate中禁用了旋转，都会发出该通知
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        //添加通知，监听设备方向改变
        NotificationCenter.default.addObserver(self, selector: #selector(self.observeDeviceOrientationAction),
                                                 name: UIDevice.orientationDidChangeNotification, object: nil)
        
        self.ctrlPanelView.isFullScreen = true
        self.preFatherView = fatherView
        
        removeFromSuperview()
        print("添加到window之前self的frame是：\(self.frame)")
        self.frame = CGRect.init(x: 0, y: 0, width: 375, height: 194)
        if UIApplication.shared.keyWindow != nil {
            UIApplication.shared.keyWindow!.addSubview(self)
            print("UIApplication.shared.keyWindow!的frame是：\(UIApplication.shared.keyWindow!.frame)")
        }else{
            UIApplication.shared.windows.first?.addSubview(self)
        }
        
        print("添加到window之后self的frame是：\(self.frame)")
        self.snp.remakeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.height)
            make.height.equalTo(UIScreen.main.bounds.width)
            make.center.equalToSuperview()
        }
        
        let deviceOreint = UIDevice.current.orientation
        let screenFrame = UIScreen.main.bounds
        let winCenterPoint = CGPoint(x:screenFrame.origin.x + ceil(screenFrame.size.width/2), y: screenFrame.origin.y + ceil(screenFrame.size.height/2))
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        self.center = winCenterPoint
        self.transform = CGAffineTransform.identity
        switch deviceOreint {
        case .landscapeLeft:
            self.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        case.landscapeRight:
            self.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        default:
            self.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        }
        UIView.commitAnimations()
        
        bringSubviewToFront(self)
        
        
//        UIApplication.shared.isStatusBarHidden = true
        
        
    }
    
    /// 触发回到小屏状态
    private func toggleNormalScreen(){
        self.ctrlPanelView.isFullScreen = false
        guard let fatherView = self.preFatherView else {
            print("没有父View")
            return
        }
        if isFullScreenAction != nil {
            isFullScreenAction!(false)
        }
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
        
        removeFromSuperview()
        fatherView.addSubview(self)
        snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        self.transform = CGAffineTransform.identity
        UIView.commitAnimations()
        
    }
    
    /// 清除播放时间的监听，避免线程占用
    func destoryPlayerTimerObserver(){
        print("销毁对播放器的监听～")
        
//        self.jfzf_hideLoadingView()
        playerTimeControlStatusObserver = nil
        playerRateStatusObserver = nil
        playerItemStatusObserver = nil
        avPlayer?.pause()
        NotificationCenter.default.removeObserver(self)
        if let timeObserverToken = timeObserverToken {
            avPlayer?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
        
    }
    
}

//MARK: - 动作方法，通知方法
@objc extension JFZ_VideoPlayerView{
    
    ///点击了加载失败的View的动作
    func tapLoadingFailedViewAction(){
        print("点击了加载AVAsset失败的View的动作方法～～")
        self.loadAVAssetFailedView.isHidden = true
        if let model = curVideoModel {
            self.playVideoModel(model: model)
        }
    }
    
    /// 监听到设备方向变化的动作方法
    func observeDeviceOrientationAction(){
        if self.ctrlPanelView.isFullScreen == false {
            print("不是全屏状态，不旋转")
            return
        }
        print("JFZ_VideoPlayerView 监听到设备的方向变化")
        let orient = UIDevice.current.orientation
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        switch orient {
        case .landscapeLeft:
            self.transform = CGAffineTransform.identity
            print( "JFZ_VideoPlayerView .landscapeLeft 面向设备保持水平，设备顶部在左侧")
            self.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        case.landscapeRight:
            self.transform = CGAffineTransform.identity
            print( "JFZ_VideoPlayerView .landscapeRight 面向设备保持水平，设备顶部在右侧")
            self.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        default:
            break
        }
        UIView.commitAnimations()
        
    }
    
    func playToEndTime(){
        print("播放完成～")
    }
    
}


//MARK: - 内部工具方法
extension JFZ_VideoPlayerView{
    
    /// 创建时间格式的字符串
    /// - Parameter time: 秒
    /// - Returns: 时间字符串
    private func createTimeString(time: Float) -> String {
        let components = NSDateComponents()
        components.second = Int(max(0.0, time))
        return timeRemainingFormatter.string(from: components as DateComponents)!
    }
    
    /// 获取播放失败的View
    private func getPlayFailedView() -> UIView {
        let failView = UIView()
        failView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        failView.isHidden = true
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(tapLoadingFailedViewAction))
        failView.addGestureRecognizer(gesture)
        let fLabel = UILabel()
        fLabel.text = "加载视频源失败，请点击屏幕重试!"
        fLabel.textColor = UIColor.white
        failView.addSubview(fLabel)
        fLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        return failView
    }
    
    
    /// 校验AVAsset的key是否有效
    private func validateValues(forKeys keys: [String], forAsset newAsset: AVAsset) -> Bool {
        for key in keys {
            var error: NSError?
            if newAsset.statusOfValue(forKey: key, error: &error) == .failed {
                let stringFormat = NSLocalizedString("The media failed to load the key \"%@\"",
                                                     comment: "You can't use this AVAsset because one of it's keys failed to load.")
                
                let message = String.localizedStringWithFormat(stringFormat, key)
                handleErrorWithMessage(message, error: error)
                
                return false
            }
        }
        
        if !newAsset.isPlayable || newAsset.hasProtectedContent {
            /*
             You can't play the asset. Either the asset can't initialize a
             player item, or it contains protected content.
             */
            let message = NSLocalizedString("The media isn't playable or it contains protected content.",
                                            comment: "You can't use this AVAsset because it isn't playable or it contains protected content.")
            handleErrorWithMessage(message)
            return false
        }
        return true
    }
    
    // MARK: 处理错误信息
    ///处理错误信息
    private func handleErrorWithMessage(_ message: String, error: Error? = nil) {
        if let err = error {
            print("Error occurred with message: \(message), error: \(err).")
        }
    }
    
    /// 获取当前视频源的帧图片
    private func getCurAVAssetFrameImg() -> UIImage?{
        
        
        guard let asset = curPlayerItem?.asset else {
            print("当前的 AVPlayerItem 为空")
            return nil
        }
         var curTime = CMTime.init(value: CMTimeValue(0.2), timescale: 600)
         if let playTime = avPlayer?.currentTime() {
             curTime = playTime
         }
     

         let avImgGen = AVAssetImageGenerator(asset: asset)
         avImgGen.appliesPreferredTrackTransform = true
 //        let cmTime = CMTimeMakeWithSeconds(Double(curTime), preferredTimescale: 600);
         //swift inout指针的使用
         var actualTime = CMTime()
         guard let cgImg:CGImage = try? avImgGen.copyCGImage(at: curTime, actualTime: &actualTime)  else {
             return nil
         }
         let curImg = UIImage.init(cgImage: cgImg)
         
         return curImg;
        /**
         UIGraphicsBeginImageContextWithOptions(self.videoLayer.bounds.size, self.isOpaque, 0)
         if let context = UIGraphicsGetCurrentContext() {
             self.layer.render(in: context)
             let curImg = UIGraphicsGetImageFromCurrentImageContext()
             UIGraphicsEndImageContext()
             return curImg
         }else{
             UIGraphicsEndImageContext()
             return nil
         }
         */
        
    }
    
    
    
    /// 获取含有当前View的第一个VC
    func getFirstViewController()->UIViewController?{
        
        for view in sequence(first: self.superview, next: {$0?.superview}){
            
            if let responder = view?.next{
                if responder.isKind(of: UIViewController.self){
                    return responder as? UIViewController
                }
            }
        }
        return nil
    }
    
    //获取视频缩略图
    static func getThumbnailImage(videoUrlStr: String,second: Float64) -> UIImage? {
        guard let videoUrl = URL.init(string: videoUrlStr) else {
            print("传入的url字符串无效")
            return nil
        }
        
       let asset = AVURLAsset(url: videoUrl)
       
       let avImgGen = AVAssetImageGenerator(asset: asset)
       
       avImgGen.appliesPreferredTrackTransform = true
       
       let cmTime = CMTimeMakeWithSeconds(second, preferredTimescale: 600);
       
       var actualTime = CMTime()
       
       guard let cgImg:CGImage = try? avImgGen.copyCGImage(at: cmTime, actualTime: &actualTime)  else {
           return nil
       }
       
       let curImg = UIImage.init(cgImage: cgImg)
      
        return curImg;
    }
}
