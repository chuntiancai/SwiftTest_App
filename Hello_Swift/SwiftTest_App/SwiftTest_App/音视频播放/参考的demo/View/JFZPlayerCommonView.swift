//
//  JFZPlayerCommonView.swift
//  SwiftNote_App
//
//  Created by mathew on 2021/7/13.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 基本的播放音视频页面，使用者提供父View。
// 设计思路是：当前view作为中转站，各个manager通过弱引用当前View，从而管理当前View的每个组件的状态，交互。

import UIKit
import SnapKit
import AVFoundation
import AVKit

class JFZPlayerCommonView: UIView {
    
    //MARK: - 对外属性
    /// 播放器回调
    weak var delegate: JFZPlayerCommonViewDelegate?
    /// 播放器的父view
    weak var fatherView: UIView?{
        didSet{
            if oldValue != nil {
//                self.dealToDisappear()
                self.playerPause()
            }
            if fatherView != nil {
                
                if fatherView?.frame == .zero {
                    fatherView?.frame = CGRect.init(x: 0, y: 0, width: 345, height: 194)
                }
                removeFromSuperview()
                fatherView?.addSubview(self)
                self.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
            
        }
    }
    
    /// 是否正在播放
    var isPlaying: Bool = false
    
    //MARK: View Control
    /// 封面图
    var placeHoldImgView: UIImageView! // 视频封面图
    /// 视频承载View
    var videoView: UIView!
    /// 中新播放按钮遮罩
    var centerDartView: UIView!
    /// 中心播放按钮
    var centerPlayBtn: UIButton!
    /// 控制播放面板
    var controlPanel: JFZPlayerControlPanelView!
    /// 全屏状态下遮罩
    var fullMaskView: JFZFullScreenMaskView?
    /// 音频播放界面（遮罩）
    var audioPlayView: JFZAudioPlayView?
    /// 播放完毕之后展示
    var endPlayView: JFZEndPlayView?
    /// 快捷操作提醒
    var speedyRemindView: JFZSpeedyRemindView?
    /// 无网提示界面
    lazy var noNetView: JFZWithoutNetView = {
        let view = JFZWithoutNetView()
        view.isHidden = true
        view.checkNetBtn.addTarget(self, action: #selector(checkLocalNet), for: .touchUpInside)
        return view
    }()
    /// 视频加速指示
    private lazy var accelerationView: HYAccelerationView = {
        let view = HYAccelerationView()
        view.isHidden = true
        view.alpha = 0
        view.speedLab.text = String(format: "%.1f", playerAcceleration) + "x"
        return view
    }()
    
    //MARK: 播放器相关
    
    /// 画中画播放器
    var pipVc: AVPictureInPictureController?
    /// 播放器
    var videoPlayer: AVPlayer?
    /// 播放器layer
    var playerLayer: AVPlayerLayer? {
        didSet {
            reloadPipVc()
        }
    }
    /// 媒体资源管理对象
    var playerItem: AVPlayerItem? {
        didSet {
            if let item = playerItem {
                item.addObserver(self, forKeyPath: "status", options: .new, context: nil)
            }
        }
    }
    /// 视频缓存器
    let videoCacher: JFZMediaCacher = JFZMediaCacher<JFZDefaultVideoCacheLocation>()
    
    //MARK: - 内部属性，Private Config
    /// 长按加速度
    private let playerAcceleration: Float = 2
    /// 普通事件管理
    private var manager: JFZAudiovisualCommonManager?
    /// 快捷操作管理
    private var speedyManager: JFZAudiovisualSpeedyOperateManager?
    /// 播放进度计时器
    private var playTimer: Timer?
    
    //MARK: - 复写方法
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let layerFrame = CGRect.init(x: 0, y: 0, width: videoView.frame.width, height: videoView.frame.height)
        playerLayer?.frame = layerFrame
        print("~~videoView:",videoView)
        print("~~playerLayer:",playerLayer)

    }
    
    convenience init(_ baseView: UIView) {
        self.init()
        
        fatherView = baseView
        manager = JFZAudiovisualCommonManager(self)
        speedyManager = JFZAudiovisualSpeedyOperateManager(self)
//        videoCacher.delegate = self
        
        createBaseView()
        addObserver()
        
        // 开启屏幕常亮
        UIApplication.shared.isIdleTimerDisabled = true
        //按下slider的时候会停，抬起手后恢复，其他时间计时器在运行
        playTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updatePanel(sender:)), userInfo: nil, repeats: true)
        
        
    }
    
    //MARK: 视图创建
    /** 创建基础试图*/
    private func createBaseView() {
        
//        if fatherView?.frame == .zero {
//            fatherView?.frame = CGRect.init(x: 15, y: 0, width: 345, height: 194)
//            self.frame = CGRect.init(x: 0, y: 0, width: 345, height: 194)
//        }
        fatherView?.addSubview(self)
        snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        videoView = UIView()
        let videoViewTap = UITapGestureRecognizer.init(target: self, action: #selector(playerViewDidTapped))
        videoView.addGestureRecognizer(videoViewTap)
        
//        let videoViewLongPress = UILongPressGestureRecognizer(target: self, action: #selector(playerViewLongPressed(_:)))
//        videoView.addGestureRecognizer(videoViewLongPress)
        //双击视频画面的手势
        let videoViewMoreTap = UITapGestureRecognizer.init(target:self, action: #selector(playButtonDidClicked))
        videoViewMoreTap.numberOfTapsRequired = 2
        videoView.addGestureRecognizer(videoViewMoreTap)
        videoView.backgroundColor = UIColor.black
        videoView.clipsToBounds = true
        addSubview(videoView)
        videoView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        audioPlayView = JFZAudioPlayView()
        let audioViewTap = UITapGestureRecognizer.init(target: self, action: #selector(playerViewDidTapped))
        audioPlayView?.addGestureRecognizer(audioViewTap)
        let audioViewMoreTap = UITapGestureRecognizer.init(target:self, action: #selector(playButtonDidClicked))
        audioViewMoreTap.numberOfTapsRequired = 2
        audioPlayView?.addGestureRecognizer(audioViewMoreTap)
        audioPlayView?.isHidden = true
        addSubview(audioPlayView!)
        audioPlayView?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
        ///操作文字提示的View
        speedyRemindView = JFZSpeedyRemindView()
        speedyRemindView?.isHidden = true
        addSubview(speedyRemindView!)
        speedyRemindView?.snp.makeConstraints({ (make) in
            make.center.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(50)
        })
        
        placeHoldImgView = UIImageView()
        placeHoldImgView.isHidden = true
        placeHoldImgView.contentMode = .scaleAspectFill
        placeHoldImgView.clipsToBounds = true
        addSubview(placeHoldImgView)
        placeHoldImgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        createAllScreenNavigationBar()
        createControlPanel()
        createEndPlayView()
        
        ///提醒没有网络的View
        addSubview(noNetView)
        noNetView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    /** 配置控制面板*/
    private func createControlPanel() {
        controlPanel = JFZPlayerControlPanelView()
        controlPanel.playButton.addTarget(self, action: #selector(playButtonDidClicked), for: .touchUpInside)
        controlPanel.screenButton.addTarget(self, action: #selector(screenButtonDidClicked), for: .touchUpInside)
        controlPanel.slider.addTarget(self, action: #selector(sliderTouchUp(_:)), for: .touchUpInside)
        controlPanel.slider.addTarget(self, action: #selector(sliderTouchUp(_:)), for: .touchUpOutside)
        controlPanel.slider.addTarget(self, action: #selector(sliderTouchDown(_:)), for: .touchDown)
        controlPanel.slider.addTarget(self, action: #selector(sliderDraging(_:)), for: .valueChanged)
        addSubview(controlPanel)
        controlPanel.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    /** 配置全屏界面*/
    private func createAllScreenNavigationBar()  {
        fullMaskView = JFZFullScreenMaskView()
        fullMaskView?.delegate = self
        let fullMaskTap = UITapGestureRecognizer.init(target: self, action: #selector(playerViewDidTapped))
        fullMaskView?.addGestureRecognizer(fullMaskTap)
        let fullMaskLongPress = UILongPressGestureRecognizer(target: self, action: #selector(playerViewLongPressed(_:)))
        fullMaskView?.addGestureRecognizer(fullMaskLongPress)
        let fullMaskMoreTap = UITapGestureRecognizer.init(target:self, action: #selector(playButtonDidClicked))
        fullMaskMoreTap.numberOfTapsRequired = 2
        fullMaskView?.addGestureRecognizer(fullMaskMoreTap)
        fullMaskView?.backBtn.addTarget(self, action: #selector(screenButtonDidClicked), for: .touchUpInside)
        fullMaskView?.lockBtn.addTarget(self, action: #selector(fullScreenLockClicked), for: .touchUpInside)
        fullMaskView?.moreBtn.addTarget(self, action: #selector(fullScreenMoreClicked), for: .touchUpInside)
        fullMaskView?.isHidden = true
        addSubview(fullMaskView!)
        fullMaskView?.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    /** 配置播放完毕展示视图*/
    private func createEndPlayView() {
        endPlayView = JFZEndPlayView()
        endPlayView?.isHidden = true
        endPlayView?.replayBtn.addTarget(self, action: #selector(replayItem), for: .touchUpInside)
        addSubview(endPlayView!)
        endPlayView?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
    }
    
    //MARK: 通知监听
    /** 添加通知监听*/
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(avplayerItemDidPlayToEndTime(_:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiverNotification), name: UIDevice.orientationDidChangeNotification, object: nil)
        
    }
    
    deinit {
        if let item = playerItem {
            item.removeObserver(self, forKeyPath: "status", context: nil)
        }
        NotificationCenter.default.removeObserver(self)
        print("JFZPlayerCommonView Deinit")
    }
}

//MARK: 公共配置方法
extension JFZPlayerCommonView {
    
    /// 更新当前播放内容
    /// - Parameter commonConfig: 播放配置
    func updateCurrentPlayer(playerConfig: JFZPlayerCommonConfig) {
        
        if let oldConfig = manager?.playerConfig {
            if oldConfig.audioUrl != playerConfig.audioUrl || oldConfig.videoUrl != playerConfig.videoUrl {
                manager?.playerConfig = playerConfig
            }
        } else {
            manager?.playerConfig = playerConfig
        }
        
        endPlayView?.isHidden = true
        audioPlayView?.isHidden = manager?.isVideo == true
    }
    
    /** 暂停播放器*/
    func playerPause() {
        manager?.playerStatus = .pause
        playTimer?.invalidate()
    }
    
    /** 继续播放*/
    func playerPlay() {
        manager?.playerStatus = .playing
        playTimer?.invalidate()
        playTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updatePanel(sender:)), userInfo: nil, repeats: true)
    }
    
    /** 重播*/
    @objc func replayItem() {
        manager?.replayPlayerItem()
        playTimer?.invalidate()
        playTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updatePanel(sender:)), userInfo: nil, repeats: true)
    }
    
    /// 更新播放结束页面
    /// - Parameter endView: 自定义结束页面
    func updateEndView(endView: UIView) {
        manager?.playerConfig?.customEndView = endView
    }
    
    /** 修改播放器进度*/
    func changePlayerProgress(progress: Float) {
        manager?.updatePanel()
        manager?.changePlayerProgress(progress: progress)
    }
    
    /** 退出页面时的处理*/
    func dealToDisappear(){
        
        // 保存当前播放时间记录
        if let config = manager?.playerConfig, config.playContinue {
            manager?.setPlayContinue()
        }
        
        // 关闭播放器
        manager?.playerStatus = .stop
        // 销毁播放器计时器
        playTimer?.invalidate()
        // 销毁隐藏控制面板计时器
        manager?.hideTimer?.invalidate()
        // 关闭屏幕常亮
        UIApplication.shared.isIdleTimerDisabled = false
    }
}

//MARK: 私有处理方法
extension JFZPlayerCommonView {
    
    /// 改变屏幕显示状态
    /// - Parameter orientationChange: 是否为物理旋转触发
    private func changeScreenStatus(orientationChange: Bool = false) {
        manager?.isFullScreen = !(manager?.isFullScreen ?? false)
        
        if let isFullScreen = manager?.isFullScreen {
            delegate?.changeFullScreen(isFull: isFullScreen)
        }
        
        if manager?.isFullScreen == true {
            // 画面状态调为自适应
            fullMaskView?.currentscreenStatus = 1
            dealForFullScreenPlayer(orientationChange: orientationChange)
        } else if manager?.isFullScreen == false {
            fullMaskView?.hidMoreFunctionView()
            dealForNormalScreenPlayer()
        }
        
        manager?.resetHideTimer()
    }
    
    /** 全屏播放处理*/
    private func dealForFullScreenPlayer(orientationChange: Bool = false)  {
        pipVc = nil
        
        backgroundColor = .black
        if manager?.isVerticalScreen == true {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        } else if orientationChange {
            let orient = UIDevice.current.orientation
            
            if orient == .landscapeRight {
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
            } else if orient == .landscapeLeft {
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            }
        } else {
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        }
        
        playerLayer?.frame = manager?.getVideoFrame() ?? CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        print("全屏时playerLayer?.frame：",playerLayer?.frame)
        print("playerLayer?.superlayer:\(playerLayer?.superlayer)")
        fullMaskView?.isHidden = false
        controlPanel?.screenButton.setImage(UIImage(named: "hy_video_ic_fullscreen", in: JFZ_PLAYER_SOURCE_BUNDLE, compatibleWith: nil), for: .normal)
        controlPanel.snp.remakeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
            make.bottom.equalTo(JFZ_IS_IPHONEX ? -15 : 0)
        }
        
        removeFromSuperview()
        //FIXME: 全屏
        if UIApplication.shared.keyWindow != nil {
            UIApplication.shared.keyWindow!.addSubview(self)
        }else{
            UIApplication.shared.windows.first?.addSubview(self)
        }
        
        snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        bringSubviewToFront(fullMaskView!)
        bringSubviewToFront(controlPanel)
        
    }
    
    /** 回到小屏播放处理*/
    private func dealForNormalScreenPlayer() {
        
        backgroundColor = .white
        
        fullMaskView?.isHidden = true
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        controlPanel.isHidden = false
        bringSubviewToFront(controlPanel)
        controlPanel.alpha = 1
        controlPanel?.screenButton.setImage(UIImage(named: "hy_video_ic_normalscreen", in: JFZ_PLAYER_SOURCE_BUNDLE, compatibleWith: nil), for: .normal)
        controlPanel.snp.remakeConstraints { (make) in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        
        removeFromSuperview()
        fatherView?.addSubview(self)
        snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        playerLayer?.frame = manager?.getVideoFrame() ?? CGRect(x: 0, y: 0, width: JFZ_SCREEN_WIDTH, height: JFZ_SCREEN_WIDTH / 16 * 9)
        print("小屏时playerLayer?.frame：",playerLayer)
        print("小屏时playerLayer?.superlayer：",playerLayer?.superlayer)
        print("小屏时的fatherView：",fatherView)
        print("小屏时的JFZPlayerCommonView：",self)
        print("小屏的videoView：",videoView)
        
        reloadPipVc()
    }
    
    /** 重新加载画中画*/
    private func reloadPipVc() {
        if let playerLayer = playerLayer, AVPictureInPictureController.isPictureInPictureSupported() {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback)
                try AVAudioSession.sharedInstance().setActive(true)
            } catch let error {
                print(error)
            }

            pipVc?.delegate = nil
            pipVc = AVPictureInPictureController(playerLayer: playerLayer)
            pipVc?.delegate = self
        }
    }
}

//MARK: 屏幕拖动处理（快进|快退|亮度、音量调节）
extension JFZPlayerCommonView {
    /** 开始滑动*/
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, fullMaskView?.isScreenLock == false {
            let touchPoint = touch.location(in: self)
            speedyManager?.startDrag(point: touchPoint)
        }
    }
    
    /** 滑动中*/
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, fullMaskView?.isScreenLock == false {
            let touchPoint = touch.location(in: self)
            speedyManager?.movedDrag(point: touchPoint)
        }
    }
    
    /** 结束滑动*/
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if fullMaskView?.isScreenLock == false {
            speedyManager?.endDrag()
        }
    }
}

//MARK: 控件事件
extension JFZPlayerCommonView {
    
    /** playerItem的监听*/
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let item = self.playerItem else { return }
        
        if keyPath == "status" {
            if item.status == .readyToPlay {
                print("播放器就绪")
                placeHoldImgView.isHidden = true
            }
        }
    }
    
    /** 设备旋转监听*/
    @objc func receiverNotification() {
        let orient = UIDevice.current.orientation
        
        if fullMaskView?.isScreenLock == false {
            if (orient == .portrait && manager?.isFullScreen == true) || ((orient == .landscapeLeft || orient == .landscapeRight) && manager?.isFullScreen != true) {
                changeScreenStatus(orientationChange: true)
            }
        }
    }
    
    /** app退出活跃状态*/
    @objc func applicationWillResignActive() {
        if AVPictureInPictureController.isPictureInPictureSupported() && pipVc != nil && manager?.isVideo == true {
            pipVc?.startPictureInPicture()
        } else {
            manager?.playerStatus = .pause
        }
        
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        
    }
    
    /** app进入活跃状态*/
    @objc func applicationDidBecomeActive() {
        if manager?.isFullScreen == true {
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        }
        
        noNetView.isHidden = JFZNetReach.isReachable()
        pipVc?.stopPictureInPicture()
    }
    
    /** 播放器屏幕被点击 -> 呼出控制面板*/
    @objc func playerViewDidTapped() {
        if fullMaskView?.moreFunctionView.tag == 1 {
            // 收起更多功能面板
            fullMaskView?.hidMoreFunctionView()
            manager?.hideControlPanel(sender: nil)
        } else {
            if controlPanel.alpha == 0 {
                // 控制面板隐藏 -> 呼出
                manager?.showControlPanel(animated: true)
            } else {
                // 隐藏控制面板
                manager?.hideControlPanel(sender: nil)
            }
        }
    }
    
    /** 播放器长按加速*/
    @objc private func playerViewLongPressed(_ sender: UILongPressGestureRecognizer) {
        if manager?.playerStatus == .playing {
            // 获取当前播放倍速
            let currentSpeed = UserDefaults.standard.value(forKey: "HYPlayer_rate") as? Float ?? 1
            
            if sender.state == UIGestureRecognizer.State.began && currentSpeed != playerAcceleration && videoPlayer?.rate != playerAcceleration {
                // 长按加速视频
                videoPlayer?.rate = playerAcceleration
                manager?.hideControlPanel(sender: nil)
                // 显示加速指示器
                if accelerationView.superview == nil {
                    addSubview(accelerationView)
                    accelerationView.snp.makeConstraints { (make) in
                        make.center.equalToSuperview()
                        make.height.width.equalTo(45)
                    }
                    accelerationView.startRotation()
                    accelerationView.isHidden = false
                    UIView.animate(withDuration: 0.3) {
                        self.accelerationView.alpha = 1
                    }
                }
            } else if sender.state == UIGestureRecognizer.State.ended && videoPlayer?.rate != currentSpeed {
                // 长按抬起 -> 恢复之前的速度
                videoPlayer?.rate = currentSpeed
                // 隐藏加速指示器
                if accelerationView.superview != nil {
                    UIView.animate(withDuration: 0.2) {
                        self.accelerationView.alpha = 0
                    } completion: { _ in
                        self.accelerationView.stopRotation()
                        self.accelerationView.isHidden = true
                        self.accelerationView.removeFromSuperview()
                    }

                }
            }
        }
    }
    
    /** 全屏响应处理的方法（全屏状态回到小屏，小屏状态展开全屏）*/
    @objc private func screenButtonDidClicked() {
        changeScreenStatus()
    }
    
    /** 播放｜暂停按钮被点击*/
    @objc private func playButtonDidClicked() {
        if manager?.playerStatus == .playing {
            manager?.playerStatus = .pause
        } else if manager?.playerStatus == .pause {
            manager?.playerStatus = .playing
        }
    }
    
    /** 全屏锁定｜解锁*/
    @objc private func fullScreenLockClicked() {
        if let isLock = fullMaskView?.isScreenLock {
            delegate?.fullScreenLock(isLock: !isLock)
            fullMaskView?.isScreenLock = !isLock
            if !isLock {
                controlPanel.isHidden = true
                fullMaskView?.naviView.isHidden = true
                fullMaskView?.hidMoreFunctionView()
            } else {
                controlPanel.isHidden = false
                fullMaskView?.naviView.isHidden = false
            }
            
            manager?.resetHideTimer()
        }
    }
    
    /** 全屏更多功能*/
    @objc private func fullScreenMoreClicked() {
        if fullMaskView?.moreFunctionView.tag == 0 {
            fullMaskView?.showMoreFunctionView(isVerticalScreen: manager?.isVerticalScreen ?? false)
            manager?.hideTimer?.invalidate()
        } else {
            fullMaskView?.hidMoreFunctionView()
            manager?.resetHideTimer()
        }
    }
    
    /** 检查本地网络*/
    @objc private func checkLocalNet() {
        
        if JFZNetReach.isReachable() {
            noNetView.isHidden = true
        } else {
            if let url = URL(string: UIApplication.openSettingsURLString){
                if (UIApplication.shared.canOpenURL(url)){
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
        }
    }
    
    /** 刷新播放器控制面板（进度｜时间）*/
    @objc func updatePanel(sender: Timer) {
        manager?.updatePanel()
    }
    
    /** 播放器进度条按下*/
    @objc func sliderTouchDown(_ sender: Any) {
        playerPause()
    }
    
    /** 播放器进度条拖拽过程*/
    @objc func sliderDraging(_ sender: UISlider) {
        manager?.updatePanel(progress: sender.value)
    }
    
    /** 播放器进度条抬起*/
    @objc func sliderTouchUp(_ sender: UISlider) {
        changePlayerProgress(progress: sender.value)
        playerPlay()
    }
    
    /** 视频播放完毕*/
    @objc func avplayerItemDidPlayToEndTime(_ notification: Notification) {
        endPlayView?.isHidden = false
        delegate?.stopPlayer()
    }
    
}

//MARK: - 更多功能调整，JFZFullScreenMaskViewDelegate
extension JFZPlayerCommonView: JFZFullScreenMaskViewDelegate {
    /** 更改播放器播放速度*/
    func changePlayerRate(rate: Float) {
        videoPlayer?.rate = rate
    }
    
    /** 更改播放器画面大小*/
    func changePlayerScreen(tofull: Bool) {
        if manager?.isFullScreen == true {
            if tofull {
                // 画面铺满
                playerLayer?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            } else {
                // 画面自适应
                playerLayer?.frame = manager?.getVideoFrame() ?? CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            }
        }
    }
}

//MARK: - 缓存回调，JFZMediaCacherDelegate
extension JFZPlayerCommonView: JFZMediaCacherDelegate {
    /** 缓存进度更新*/
    func cacher<LocationType>(_ cacher: JFZMediaCacher<LocationType>, cacheProgress progress: Float, of cache: JFZMediaCacheManager) where LocationType : JFZMediaCacheLocationDelegate {
        delegate?.inCaching(progress: progress)
        controlPanel.cacheView.frame = CGRect(x: 48, y: 20, width: (JFZ_SCREEN_WIDTH - 176) * CGFloat(progress), height: 1)
    }
    
    /** 缓存开始*/
    func cacher<LocationType>(_ cacher: JFZMediaCacher<LocationType>, didStartCacheOf cache: JFZMediaCacheManager) where LocationType : JFZMediaCacheLocationDelegate {
        delegate?.startCache()
    }
    
    /** 缓存完成*/
    func cacher<LocationType>(_ cacher: JFZMediaCacher<LocationType>, didFinishCacheOf cache: JFZMediaCacheManager) where LocationType : JFZMediaCacheLocationDelegate {
        delegate?.completeCache()
    }
    
    /** 缓存失败*/
    func cacher<LocationType>(_ cacher: JFZMediaCacher<LocationType>, didFailToCache cache: JFZMediaCacheManager) where LocationType : JFZMediaCacheLocationDelegate {
        delegate?.faildCache()
    }
    
}

//MARK: - 遵循AVPictureInPictureControllerDelegate协议
extension JFZPlayerCommonView: AVPictureInPictureControllerDelegate {
    /**
        @method        pictureInPictureControllerWillStartPictureInPicture:
        @param        pictureInPictureController
                    The Picture in Picture controller.
        @abstract    Delegate can implement this method to be notified when Picture in Picture will start.
     */
    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("即将开启画中画")
    }

    
    /**
        @method        pictureInPictureControllerDidStartPictureInPicture:
        @param        pictureInPictureController
                    The Picture in Picture controller.
        @abstract    Delegate can implement this method to be notified when Picture in Picture did start.
     */
    func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("已经开启画中画")
    }

    
    /**
        @method        pictureInPictureController:failedToStartPictureInPictureWithError:
        @param        pictureInPictureController
                    The Picture in Picture controller.
        @param        error
                    An error describing why it failed.
        @abstract    Delegate can implement this method to be notified when Picture in Picture failed to start.
     */
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, failedToStartPictureInPictureWithError error: Error) {
        print("开启画中画失败")
    }

    
    /**
        @method        pictureInPictureControllerWillStopPictureInPicture:
        @param        pictureInPictureController
                    The Picture in Picture controller.
        @abstract    Delegate can implement this method to be notified when Picture in Picture will stop.
     */
    func pictureInPictureControllerWillStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("即将关闭画中画")
    }

    
    /**
        @method        pictureInPictureControllerDidStopPictureInPicture:
        @param        pictureInPictureController
                    The Picture in Picture controller.
        @abstract    Delegate can implement this method to be notified when Picture in Picture did stop.
     */
    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("已经关闭画中画")
    }

    
    /**
        @method        pictureInPictureController:restoreUserInterfaceForPictureInPictureStopWithCompletionHandler:
        @param        pictureInPictureController
                    The Picture in Picture controller.
        @param        completionHandler
                    The completion handler the delegate needs to call after restore.
        @abstract    Delegate can implement this method to restore the user interface before Picture in Picture stops.
     */
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        print("关闭画中画且恢复播放界面")
    }
}

//MARK: - 更多功能
extension JFZPlayerCommonView{
    
    
    /// 获取当前视频的屏幕
    /// - Returns: 返回当前视频画面
    func getCurrentVideoImageView() -> UIImageView{
        UIGraphicsBeginImageContextWithOptions(frame.size, true, UIScreen.main.scale)
        self.playerLayer?.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIImageView(image: image)
    }
}
