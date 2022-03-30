//
//  JFZVideoControlPanelView.swift
//  SwiftTest_App
//
//  Created by chuntiancai on 2021/7/18.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 视频播放控制面板，滑动条，暂停按钮，时间进度，全屏按钮，标题，返回按钮


import UIKit

class JFZVideoControlPanelView: UIView {
    
    //MARK: - 对外属性
    
    /// - Tag: 动作方法
    var togglePlayAction:(()->Void)?  //点击了播放按钮
    var toggleFullScreenAction:(()->Void)?  //点击了全屏按钮
    var sliderTapDownAction:((_ sliderValue: Float)->Void)?  //滑块按下时的值
    var sliderValueChangingAction:((_ sliderValue: Float)->Void)?  //滑动了滑块,滑动时的值
    var sliderValueDidChangedAction:((_ sliderValue: Float)->Void)?  //滑动了滑块,抬起时的值

    /// - Tag: 对外状态
    var isPlaying:Bool = false {    //是否在播放，更新按钮UI
        didSet{
            if isPlaying {
                playButton.setImage(UIImage(named: "jfz_video_ic_pause_nor"), for: .normal)
            }else{
                playButton.setImage(UIImage(named: "jfz_video_ic_play"), for: .normal)
            }
        }
    }
    
    var isFullScreen:Bool = false { //是否全屏，更新按钮UI
        didSet{
            if isFullScreen {
                screenButton.setImage(UIImage(named: "jfz_video_ic_normalScreen"), for: .normal)
            }else{
                screenButton.setImage(UIImage(named: "jfz_video_ic_fullscreen"), for: .normal)
            }
        }
    }
    
    var sliderValue:Float = 0.0 {   //外部可以设置的slider的值,没有点击slider，则更新，否则不更新UI
        didSet{
            if !isTouchingSlider {
                slider.value = sliderValue
            }
        }
    }
    var isTouchingSlider:Bool{   //是否正在点击slider
        get{
            return isTouchingSliderTag
        }
    }
    
    
    /// 播放｜暂停
    var playButton: JFZResponseExpandButtton = {
        let btn = JFZResponseExpandButtton()
        btn.setImage(UIImage(named: "jfz_video_ic_play"), for: .normal)
        return btn
    }()
    
    /// 进度条
    var slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.minimumTrackTintColor = UIColor.white
        slider.maximumTrackTintColor = UIColor.white.withAlphaComponent(0.4)
        slider.setThumbImage(UIImage(named: "jfz_video_ic_slider"), for: .normal)
        return slider
    }()
    
    /// 前面播放器时间指示label
    var startTimeLabel: UILabel = {
        let lab = UILabel()
        lab.text = "00:00:00"
        lab.font = UIFont.systemFont(ofSize: 11)
        lab.textColor = UIColor.white
        return lab
    }()
    
    
    
    /// 结尾播放时间指示label
    var endTimeLabel: UILabel = {
        let lab = UILabel()
        lab.text = "00:00:00"
        lab.font = UIFont.systemFont(ofSize: 11)
        lab.textColor = UIColor.white
        return lab
    }()
    
    /// 全屏按钮
    private var screenButton: JFZResponseExpandButtton = {
        let btn = JFZResponseExpandButtton()
        btn.setImage(UIImage(named: "jfz_video_ic_fullscreen"), for: .normal)
        return btn
    }()
    
    //MARK: - 内部属性
    /// - Tag: 播放器进度条相关
//    private var sliderChangedValue:Float? //滑块改变的值，用于作为滑块手指抬起的标志器
    private var isTouchingSliderTag:Bool = false //是否正在点击slider
    
    //MARK: - 工具属性
    private var hideTimer:Timer?   //隐藏控制面板的定时器
    private var isFirstPlay:Bool = true //是否第一次播放
    

    //MARK: - 复写方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        if frame == .zero {
            self.frame = CGRect.init(x: 0, y: 0, width: 345, height: 194)
        }
        initUI()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print("JFZVideoControlPanelView 的 hitTest(_ point:方法 ")
        self.alpha = 1
        if !isFirstPlay {
            if let timer = hideTimer { //定时器不为空
                timer.invalidate()
                hideTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(hideCtrlViewTimeAction), userInfo: nil, repeats: false)
            }else{  //定时器为空
                hideTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(hideCtrlViewTimeAction), userInfo: nil, repeats: false)
            }
        }
        return super.hitTest(point, with: event)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        if let timer = hideTimer {
            timer.invalidate()
            hideTimer = nil
        }
    }
    
}

//MARK: - 初始化UI
extension JFZVideoControlPanelView{
    
    /// 初始化UI
    private func initUI(){
        
//        backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
        
        ///暂停播放按钮
        addSubview(playButton)
        playButton.addTarget(self, action: #selector(playBtnAction(_:)), for: .touchUpInside)
        playButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 40, height: 40))
        }
        
        ///前面的播放时间label
        addSubview(startTimeLabel)
        startTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(playButton.snp.right)
            make.centerY.equalTo(playButton.snp.centerY)
        }
        
        ///全屏播放按钮
        addSubview(screenButton)
        screenButton.addTarget(self, action: #selector(fullScreenBtnAction(_:)), for: .touchUpInside)
        screenButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(-10)
            make.centerY.equalTo(playButton.snp.centerY)
            make.height.width.equalTo(30)
        }
        
        
        ///结尾的播放时间label
        addSubview(endTimeLabel)
        endTimeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(screenButton.snp.left).offset(-8)
            make.centerY.equalTo(playButton.snp.centerY)
        }
        
        ///播放进度条
        addSubview(slider)
        slider.addTarget(self, action: #selector(progressSliderAction(_:)), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderTouchUpAction(_:)), for: .touchUpInside)
        slider.addTarget(self, action: #selector(sliderTouchUpAction(_:)), for: .touchUpOutside)
        slider.addTarget(self, action: #selector(sliderDownAction(_:)), for: .touchDown)
        slider.snp.makeConstraints { (make) in
            make.left.equalTo(startTimeLabel.snp.right).offset(8)
            make.right.equalTo(endTimeLabel.snp.left).offset(-8)
            make.height.equalTo(16)
            make.centerY.equalTo(playButton.snp.centerY).offset(-1)
        }
    }
    
    
}

//MARK: - 动作方法
@objc extension JFZVideoControlPanelView{
    /// 播放按钮的动作方法
    /// - Parameter sender: 播放按钮
    private func playBtnAction(_ sender: UIButton){
        print("点击了播放按钮")
        isFirstPlay = false
        if togglePlayAction != nil {
            togglePlayAction!()
        }
        
    }
    /// 全屏按钮的动作方法
    /// - Parameter sender: 全屏按钮
    private func fullScreenBtnAction(_ sender: UIButton){
        print("点击了全屏按钮")
        if toggleFullScreenAction != nil {
            toggleFullScreenAction!()
        }
        
    }
    /// 播放进度条的方法
    /// - Parameter slider: 进度条
    private func progressSliderAction(_ slider: UISlider){
        ///print("slider的值发生变化：\(slider.value)")
        if sliderValueChangingAction != nil {
            sliderValueChangingAction!(slider.value) //调用对外回调方法
        }
        
    }
    
    /// 进度条手指抬起
    private func sliderTouchUpAction(_ slider: UISlider){
        isTouchingSliderTag = false
        hideTimer?.fireDate = .distantPast  //开启定时器
        if sliderValueDidChangedAction != nil {
            sliderValueDidChangedAction!(slider.value) //调用对外回调方法
        }
//        print("手指抬起的值：\(sliderChangedValue)")
        
    }
    /// 进度条手指按下
    private func sliderDownAction(_ slider: UISlider){
        isTouchingSliderTag = true
        hideTimer?.fireDate = .distantFuture    //暂停定时器
        if sliderTapDownAction != nil {
            sliderTapDownAction!(slider.value)
        }
        print("手指按下的的值：\(slider.value)")
    }
    
    /// 隐藏控制面板的定时器动作方法
    func hideCtrlViewTimeAction(){
        print("隐藏控制面板的定时器动作方法 hideCtrlViewTimeAction")
        DispatchQueue.main.async {
            [weak self] in
            UIView.animate(withDuration: 1.0) {
                self?.alpha = 0
            }
        }
        
    }
    
}

//MARK: -
extension JFZVideoControlPanelView{
    
}

//MARK: -
extension JFZVideoControlPanelView{
    
}
