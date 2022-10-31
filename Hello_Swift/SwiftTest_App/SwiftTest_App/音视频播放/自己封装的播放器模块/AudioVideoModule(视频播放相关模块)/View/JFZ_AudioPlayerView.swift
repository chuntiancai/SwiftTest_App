//
//  JFZ_AudioPlayerView.swift
//  JFZFortune
//
//  Created by mathew on 2021/7/21.
//  Copyright © 2021 JinFuZi. All rights reserved.
//
// 音频播放器的view，在这里封装AVPalyer处理音频源。

import AVFoundation

class JFZ_AudioPlayerView : UIView {
    
    //MARK: - 对外属性
    /// - Tag: 用于回调外界的属性
    var togglePlayAction:((_ isToPlay:Bool)->Void)?  //点击了播放按钮
    
    
    
    //MARK: - 内部属性
    /// - Tag: AVPlayer相关属性：
    private var avPlayer: AVPlayer? //可选，是为了判断是不是第一次加载播放器，避免多次监听相关属性
    
    /// 监听播放器的当前播放状态，The `NSKeyValueObservation` for the KVO on `\AVPlayer.timeControlStatus`.
    private var playerTimeControlStatusObserver: NSKeyValueObservation?
    private var playerRateStatusObserver: NSKeyValueObservation?    //监听播放速度，rate==1时播放，rate==0时暂停

    ///监听播放器的时间进度，0.001秒，A token obtained from the player's `addPeriodicTimeObserverForInterval(_:queue:usingBlock:)` method.
    /// 必须要销毁，不然会占用线程
    private var timeObserverToken: Any?
    
    /// - Tag: AVPlayerItem相关属性：
    private var curPlayerItem: AVPlayerItem? {
        didSet {
            if let _ = curPlayerItem {
                /// swift监听KVO
                setupPlayerItemObservers()
            }
        }
    }
    
    /// 监听AVPlayerItem的可播放状态， The `NSKeyValueObservation` for the KVO on `\AVPlayer.currentItem?.status`.
    private var playerItemStatusObserver: NSKeyValueObservation?
    
    //MARK: 工具属性
    ///时间格式器
    private let timeRemainingFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.hour,.minute, .second]
        return formatter
    }()
    
    private var isTouchingSlider:Bool = false //是否正在点击slider
    private var isPlaying:Bool = false {    //是否在播放，更新按钮UI
        didSet{
            if isPlaying {
                playButton.setImage(UIImage(named: "jfz_video_ic_pause_nor"), for: .normal)
            }else{
                playButton.setImage(UIImage(named: "jfz_video_ic_play"), for: .normal)
            }
        }
    }
    
    //MARK: UI属性
    /// 播放｜暂停 按钮
    private var playButton: JFZResponseExpandButtton = {
        let btn = JFZResponseExpandButtton()
        btn.setImage(UIImage(named: "jfz_video_ic_play"), for: .normal)
        return btn
    }()
    
    /// 进度条
    var slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.minimumTrackTintColor = UIColor.init(red: 194/255.0, green: 154/255.0, blue: 99/255.0, alpha: 1.0)
        slider.maximumTrackTintColor = UIColor.init(red: 193/255.0, green: 193/255.0, blue: 193/255.0, alpha: 1.0)
        slider.setThumbImage(UIImage(named: "jfz_video_ic_slider"), for: .normal)
        return slider
    }()
    
    /// 开始播放时间的label
    private var startTimeLabel: UILabel = {
        let lab = UILabel()
        lab.text = "00:00:00"
        lab.font = UIFont.systemFont(ofSize: 11)
        lab.textColor = UIColor.init(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1.0)
        return lab
    }()
    
    
    /// 结尾播放时间指示label，总时间
    private var endTimeLabel: UILabel = {
        let lab = UILabel()
        lab.text = "/00:00:00"
        lab.font = UIFont.systemFont(ofSize: 11)
        lab.textColor = UIColor.init(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1.0)
        return lab
    }()
    

    //MARK: - 复写方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        if frame == .zero {
            let screenWidth = UIScreen.main.bounds.width
            ///let screenHeight = UIScreen.main.bounds.height
            self.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 40)
        }
        initUI()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print("JFZ_AudioPlayerView 的 hitTest方法～")
        return super.hitTest(point, with: event)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    deinit {
        destoryPlayerTimerObserver()
    }
}

//MARK: - 设置UI
extension JFZ_AudioPlayerView{
    
    /// 初始化UI
    func initUI(){
        let bgView = UIView()
        bgView.backgroundColor = UIColor.init(red: 229/255.0, green: 229/255.0, blue: 229/255.0, alpha: 1.0)
        let screenWidth = UIScreen.main.bounds.width
        self.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(screenWidth * (335/375.0))
            make.center.equalTo(self.snp.center)
        }
        
        ///暂停播放按钮
        bgView.addSubview(playButton)
        playButton.addTarget(self, action: #selector(playBtnAction(_:)), for: .touchUpInside)
        playButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 40, height: 40))
        }
        
        ///结尾的播放时间label
        bgView.addSubview(endTimeLabel)
        endTimeLabel.textAlignment = .left
        endTimeLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-8)
            make.centerY.equalTo(playButton.snp.centerY)
        }
        
        ///开始播放时间label
        bgView.addSubview(startTimeLabel)
        startTimeLabel.textAlignment = .right
        startTimeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(endTimeLabel.snp.left)
            make.centerY.equalTo(playButton.snp.centerY)
        }
        
        
        
        ///播放进度条
        bgView.addSubview(slider)
        slider.addTarget(self, action: #selector(sliderProgressAction(_:)), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderTouchUpAction(_:)), for: .touchUpInside)
        slider.addTarget(self, action: #selector(sliderTouchUpAction(_:)), for: .touchUpOutside)
        slider.addTarget(self, action: #selector(sliderDownAction(_:)), for: .touchDown)
        slider.snp.makeConstraints { (make) in
            make.left.equalTo(playButton.snp.right).offset(8)
            make.right.equalTo(startTimeLabel.snp.left).offset(-8)
            make.height.equalTo(16)
            make.centerY.equalTo(playButton.snp.centerY).offset(-1)
        }
        
    }
    
    
}

//MARK: - 对外提供的方法
extension JFZ_AudioPlayerView{
    
    /// 播放音频源
    /// - Parameter model: 音频源的model
    func playAudioModel(model:JFZAudioVideoModel){
        guard let url = URL(string: model.fileUrl) else {
            print("传入的URL字符串无效")
            return
        }
        if let playItem = curPlayerItem {
            if let curUrl = (playItem.asset as? AVURLAsset)?.url {
                if curUrl == url {
                    print("传入的url和当前curPlayerItem中的asset的url相同")
                    return
                }else{
                    print("传入的url和当前curPlayerItem中的asset的url不一样")
                }
            }
        }
        let asset = AVURLAsset(url: url)
        ///加载视频资产AVURLAsset的key，并验证它的key是否都有效，然后加载播放器
        loadPropertyValues(forAsset: asset)
        
        /// 播放结束的通知
        NotificationCenter.default.addObserver(self, selector: #selector(playToEndTime), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: curPlayerItem)
    }
    
    /// 播放音频
    func playAudio(){
        if let player = avPlayer {
            if let _ = player.currentItem{
                avPlayer?.play()
            }else{
                avPlayer?.replaceCurrentItem(with: self.curPlayerItem)
                avPlayer?.play()
            }
        }
    }
    
    /// 暂停播放
    func pauseAudio(){
        if let player = avPlayer {
            if let _ = player.currentItem{
                avPlayer?.pause()
            }
        }
    }
    
    
}

//MARK: - KVO监听
extension JFZ_AudioPlayerView{
    
    ///  设置播放器相关的KVO监听
    func setupPlayerObservers() {
        if avPlayer == nil {
            avPlayer = AVPlayer()
        }else{
            /// 已经初始化过了，不需要再次初始化，避免多次监听AVPlayer
            return
        }
        ///监听播放器播放状态，切换播放/暂停按钮UI
        if #available(iOS 10.0, *) {
            playerTimeControlStatusObserver = avPlayer?.observe(\AVPlayer.timeControlStatus,
                                                                options: [.initial, .new]) { [weak self] _, _ in
                DispatchQueue.main.async {
                    self?.updateUIforPlayerStatus()  //根据播放状态更新UI
                }
            }
        } else {
            print("目标机器不是iOS 10.0以上，不通过timeControlStatus监听播放｜暂停状态")
            playerRateStatusObserver = avPlayer?.observe(\AVPlayer.rate, options: [.initial, .new], changeHandler: { [weak self] player, change in
                DispatchQueue.main.async {
                    self?.updateUIforPlayerStatus()  //根据播放状态更新UI
                }
            })
        }
        
        
        
        
        /// 监听播放时间，更新时间进度滑块Slider的值
        let interval = CMTime(value: 1, timescale: 2)
        timeObserverToken = avPlayer?.addPeriodicTimeObserver(forInterval: interval,
                                                              queue: .main) { [weak self] time in
            
            if !(self?.isTouchingSlider ?? true) {   //没有正在点击才去更新值
                let timeElapsed = Float(time.seconds)
                self?.slider.value = timeElapsed
                self?.startTimeLabel.text = self?.createTimeString(time: timeElapsed)
            }
            
            ///print("监听到的时间变化是：\(timeElapsed)")
        }
        
    }
    
    /// 设置AVPlayerItem的KVO监听
    func setupPlayerItemObservers(){
        
        /// AVPlayerItem的status属性监听，当前视频资产可播放状态
        playerItemStatusObserver = curPlayerItem?.observe(\AVPlayerItem.status, options: [.new, .initial]) { [weak self] playItem, changeDict in
            DispatchQueue.main.async {
                
                print("当前监听的status的playItem是：\(playItem)")
                ///当资产可播放时，更新UI
                self?.updateUIforPlayerItemStatus()
            }
        }
    }
    
}

//MARK: - 通知方法
@objc extension JFZ_AudioPlayerView{
    func playToEndTime(){
        print("播放完成～")
    }
    
}

//MARK: - 内部逻辑方法
extension JFZ_AudioPlayerView{
    
    /// 先验证传入的视频资产AVURLAsset是否有效，加载AVURLAsset的相关key，从而再创建播放器
    func loadPropertyValues(forAsset newAsset: AVURLAsset) {
        
        let assetKeysRequiredToPlay = [
            "playable", //当前视频资产是否可播放的key
            "hasProtectedContent"   //是否有受保护内容，有则不可以播放
        ]
        
        /// 使用异步线程，避免加载AVURLAsset的key造成主线程堵塞
        newAsset.loadValuesAsynchronously(forKeys: assetKeysRequiredToPlay) {
            /*
             这个 completion handler是在随机线程中执行的，所以要在主线程中统一维护状态。
             */
            DispatchQueue.main.async {
                
                if self.validateValues(forKeys: assetKeysRequiredToPlay, forAsset: newAsset) {
                    
                    /// 设置监听播放器的属性更新
                    self.setupPlayerObservers()
                    
                   /// 更新播放器和视频资源管理项
                    self.setupPlayerAndItem(forAsset: newAsset)
                }
            }
        }
    }
    
    /// 设置播放器和视频管理项
    func setupPlayerAndItem(forAsset newAsset: AVURLAsset){
        let playerItem = AVPlayerItem(asset: newAsset)
        self.curPlayerItem = playerItem
        self.avPlayer?.replaceCurrentItem(with: playerItem)
    }
    
    /// （监听到AVPlayer的状态发生变化）更新播放的UI
    func updateUIforPlayerStatus() {
        
        if #available(iOS 10.0, *) {
            switch self.avPlayer?.timeControlStatus {
            case .playing:
                self.isPlaying = true
            case .paused, .waitingToPlayAtSpecifiedRate:
                self.isPlaying = false
            case .none:
                break
            @unknown default:
                self.isPlaying = false
            }
        } else {
            if let player = self.avPlayer {
                if  (player.rate != 0) && (player.error == nil) { //正在播放
                    self.isPlaying = true
                }else { //正在暂停
                    self.isPlaying = false
                }
            }
        }
        
    }
    
    /// （监听到AVPlayerItem的状态变化），进行播放，更新UI等操作
    func updateUIforPlayerItemStatus() {
        guard let currentItem = curPlayerItem else { return }
        
        switch currentItem.status {
        case .failed:
            ///资产不可以播放时，无效化 播放按钮，时间进度条 等UI
            print("AVPlayerItem无法播放")
            /*
             Display an error if the player item status property equals `.failed`.
             */
            playButton.isEnabled = false
            slider.isEnabled = false
            startTimeLabel.isEnabled = false
            endTimeLabel.isEnabled = false
//            handleErrorWithMessage(currentItem.error?.localizedDescription ?? "", error: currentItem.error)
            
        case .readyToPlay:
            print("AVPlayerItem播放就绪")
            
            /*
             更新播放按钮，进度条，播放时间的UI
             */
            playButton.isEnabled = true
            let newDurationSeconds = Float(currentItem.duration.seconds)
            
            let currentTime = Float(CMTimeGetSeconds(avPlayer!.currentTime()))
            
            slider.maximumValue = newDurationSeconds
            slider.isEnabled = true
            startTimeLabel.isEnabled = true
            startTimeLabel.text = createTimeString(time: currentTime)
            endTimeLabel.isEnabled = true
            endTimeLabel.text = "/" + createTimeString(time: newDurationSeconds)
            
        default:
            playButton.isEnabled = false
            slider.isEnabled = false
            startTimeLabel.isEnabled = false
            endTimeLabel.isEnabled = false
        }
    }
    
   
    
    /// 清除播放时间的监听，避免线程占用
    func destoryPlayerTimerObserver(){
        print("销毁对播放器的监听～")
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

//MARK: - 动作方法，点击事件
@objc extension JFZ_AudioPlayerView{
    
    /// - Parameter sender: 播放按钮
    private func playBtnAction(_ sender: UIButton){
        print("JFZ_AudioPlayerView 点击了播放按钮")
        guard let _ = self.avPlayer else {
            return
        }
        if #available(iOS 10.0, *) {
            switch self.avPlayer?.timeControlStatus {
            case .playing:
                self.avPlayer?.pause()
                self.isPlaying = false
            case .paused:
                /// 如果是播放结束导致的暂停状态，则从头开始播放
                let currentItem = self.avPlayer?.currentItem
                if currentItem?.currentTime() == currentItem?.duration {
                    currentItem?.seek(to: .zero, completionHandler: nil)
                }
                self.avPlayer?.play()
                
            default:
                self.avPlayer?.pause()
            }
        } else {
            if let player = self.avPlayer {
                if  (player.rate != 0) && (player.error == nil) { //正在播放
                    self.avPlayer?.pause()
                }else { //正在暂停
                    /// 如果是播放结束导致的暂停状态，则从头开始播放
                    let currentItem = self.avPlayer?.currentItem
                    if currentItem?.currentTime() == currentItem?.duration {
                        currentItem?.seek(to: .zero, completionHandler: nil)
                    }
                    self.avPlayer?.play()
                }
            }
        }
        
        if togglePlayAction != nil {
            togglePlayAction!(isPlaying)
        }
    }
    
    /// 进度条值变化的方法
    private func sliderProgressAction(_ slider: UISlider){
        guard let _ = self.avPlayer else {
            return
        }
        /// 跳转到播放时间
        let newTime = CMTime(seconds: Double(slider.value), preferredTimescale: 600)
        self.avPlayer!.seek(to: newTime, toleranceBefore: .zero, toleranceAfter: .zero)
        ///更新开始时间的值
        self.startTimeLabel.text = self.createTimeString(time: slider.value)
    }
    
    /// 进度条手指抬起
    private func sliderTouchUpAction(_ slider: UISlider){
        isTouchingSlider = false
    }
    /// 进度条手指按下
    private func sliderDownAction(_ slider: UISlider){
        isTouchingSlider = true
    }
    
}


//MARK: - 内部工具方法
extension JFZ_AudioPlayerView{
    
    /// 创建时间格式的字符串
    /// - Parameter time: 秒
    /// - Returns: 时间字符串
    func createTimeString(time: Float) -> String {
        let components = NSDateComponents()
        components.second = Int(max(0.0, time))
        return timeRemainingFormatter.string(from: components as DateComponents)!
    }
    
    
    /// 校验AVAsset的key是否有效
    func validateValues(forKeys keys: [String], forAsset newAsset: AVAsset) -> Bool {
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
    func handleErrorWithMessage(_ message: String, error: Error? = nil) {
        if let err = error {
            print("Error occurred with message: \(message), error: \(err).")
        }
    }
    
    
    
}
