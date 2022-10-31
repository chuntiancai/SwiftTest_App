//
//  TestLocalVideo_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/10/31.
//  Copyright © 2022 com.mathew. All rights reserved.
//
//测试播放本地音乐的VC
// MARK: - 笔记
/**
    1、iOS系统中音频播放方式：AVAudioPlayer，AVPlayer，播放系统声音(音频服务)，音频队列。
        AVAudioPlayer：使用简单，功能强大，但只能播放本地音频，处理音频比较灵活。
                       由于AVAudioPlayer一次只能播放一个音频文件，所以上一曲、下一曲需要通过创建多个播放器对象来完成。
 
        AVPlayer：可以播放网络音频，本地音频和流媒体播放，但处理音频不够灵活。
 
        播放系统声音：系统声音属于非压缩的存储类型，但是系统声音时长短，不超过30s，格式为 : caf / wav / aiff。
 
    2、AVAudioSession是一个单例，用来管理多个APP对音频硬件设备（麦克风，扬声器）的资源使用。
        翻译成会话，相当于一个进程，用于管理多个App之间对硬件设备的音频资源的使用。
        APP启动的时候会自动帮激活AVAudioSession，当然我们可以手动激活。
 

 
 */

import AVFoundation

class TestLocalVideo_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    let bgView = UIView()   //测试的view可以放在这里面
    
    //MARK: 测试组件
    var audioPlayer: AVAudioPlayer?  //音频播放对象。
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试播放本地音乐的VC"
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestLocalVideo_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("TestLocalVideo_VC 点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、测试播放系统声音。
            /**
             1、import AVFoundation。
             2、生成音频文件的SystemSoundID，通过地址传值的方式创建SystemSoundID。
             3、通过SystemSoundID播放音效，在播放完毕的闭包里，释放SystemSoundID，释放资源。
             */
            print("     (@@ 0、测试播放系统声音。")
            
            
            // 1. 获取音效文件对应的soundid
            guard let url = Bundle.main.url(forResource: "m_17.wav", withExtension: nil) else {
                print("获取m_17.wav音效资源失败")
                return
            }
            let urlCF = url as CFURL
            
            /// 1.1 创建  SystemSoundID。 根据CFURL创建SystemSoundID。
            var soundID: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(urlCF, &soundID)
            
            guard let url2  = Bundle.main.url(forResource: "win.aac", withExtension: nil) else {
                print("获取win.aac音效资源失败")
                return
            }
            let urlCF2 = url2  as CFURL
            
            /// 1.1 创建第二个音效资源的SystemSoundID
            var soundID2: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(urlCF2, &soundID2)
            
            // 2. 根据soundID, 播放音效
            // 带振动播放
            AudioServicesPlayAlertSound(soundID)
            // 不带振动播放
            //        AudioServicesPlaySystemSound(soundID)
            
            // 带播放完成的回调
            AudioServicesPlaySystemSoundWithCompletion(soundID) {
                print("播放完成")
                // 3. 根据soundID, 释放音效
                AudioServicesDisposeSystemSoundID(soundID)
                
                //播发第二个音效。
                AudioServicesPlaySystemSoundWithCompletion(soundID2, {
                    // 3. 根据soundID, 释放音效
                    AudioServicesDisposeSystemSoundID(soundID2)
                })
            }
            
        case 1:
            //TODO: 1、测试AVAudioPlayer播放本地音乐。
            /**
                1、后台播放权限：target -> capabilities -> backgroud modes -> audio
                2、AVAudioSession会话，管理是否与其他App共享音响。
                3、AVAudioPlayer初始化的时候传人url，一次只能播放一个资源文件，所以要播放多个音频资源的话，需要创建多个AVAudioPlayer。
             */
            print("     (@@ 1、测试AVAudioPlayer播放本地音乐。")
            
            // 1. 创建播放器(NSURL, 只能是本地URL 地址, 远程音乐, 使用这个类, 播放不了)
            let url = Bundle.main.url(forResource: "简单爱.mp3", withExtension: nil)
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: url!)
                // 1.1 获取音频会话
                let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
                
                // 1.2 设置会话类型
                try audioSession.setCategory(AVAudioSession.Category.playback ) //playback 独占音频硬件资源，且后台播放。
                
                // 1.3 激活会话
                try audioSession.setActive(true)
            } catch let err {
                print("创建音频播放器失败:\(err)")
            }
            // 设置代理，监听播放完成。
            audioPlayer?.delegate = self
            
            // 设置可以速率播放
            audioPlayer?.enableRate = true
            
            // 准备播放
            audioPlayer?.prepareToPlay()
            
            
        case 2:
            //TODO: 2、测试AVAudioPlayer的播放功能。
            print("     (@@ 2、测试AVAudioPlayer的播放功能。")
            // 开始播放
            audioPlayer?.play()
            
            //设置播放速率
            audioPlayer?.rate = 1.5
            
            //设置播放声音，最大音量是系统当前的音量，只能在当前音量的限制内调节。
            audioPlayer?.volume = 0.85
            
            // 设置播放的时间进度，这个值, 系统自动会做好容错适配, 不需要我们处理 负数、或者大于最大播放时长 的数值
            audioPlayer?.currentTime += 15
            
        case 3:
            //TODO: 3、AVAudioPlayer停止播放。
            print("     (@@ 3、AVAudioPlayer停止播放。")
            // 重置当前播放事件
            audioPlayer?.currentTime = 0
            audioPlayer?.stop()
            
        case 4:
            print("     (@@")
        case 5:
            print("     (@@")
        case 6:
            print("     (@@")
        case 7:
            print("     (@@")
        case 8:
            print("     (@@")
        case 9:
            print("     (@@")
        case 10:
            print("     (@@")
        case 11:
            print("     (@@")
        case 12:
            print("     (@@")
        default:
            break
        }
    }
    
}
//MARK: - 遵循AVAudioPlayerDelegate协议，监听音频的播放。
extension TestLocalVideo_VC: AVAudioPlayerDelegate{
   
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("播放完成：\(#function) 方法～")
    }
    
}


//MARK: - 设置测试的UI
extension TestLocalVideo_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        /// 内容背景View，测试的子view这里面
        self.view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
    }
    
}


//MARK: - 设计UI
extension TestLocalVideo_VC {
    
    /// 设置导航栏的UI
    private func setNavigationBarUI(){
        //设置子页面的navigation bar的返回按钮样式
        let backItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    /// 设置collection view的UI
    private func setCollectionViewUI(){
        
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: 80, height: 40)
        layout.sectionInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 0, right: 5)
        baseCollView = UICollectionView.init(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width,height:200),
                                             collectionViewLayout: layout)
        
        baseCollView.backgroundColor = UIColor.cyan.withAlphaComponent(0.8)
        baseCollView.contentSize = CGSize.init(width: UIScreen.main.bounds.size.width * 2, height: UIScreen.main.bounds.size.height)
        baseCollView.showsVerticalScrollIndicator = true
        baseCollView.alwaysBounceVertical = true
        baseCollView.layer.borderWidth = 1.0
        baseCollView.layer.borderColor = UIColor.gray.cgColor
        baseCollView.delegate = self
        baseCollView.dataSource = self
        baseCollView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionView_Cell_ID")
        
        self.view.addSubview(baseCollView)
        
    }
}

//MARK: - 遵循委托协议,UICollectionViewDelegate
extension TestLocalVideo_VC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collDataArr.count
    }
    ///设置cell的UI
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionView_Cell_ID", for: indexPath)
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        cell.backgroundColor = .lightGray
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: cell.frame.size.width-20, height: cell.frame.size.height));
        label.numberOfLines = 0
        label.textColor = .white
        cell.layer.cornerRadius = 8
        label.text = collDataArr[indexPath.row];
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        cell.contentView.addSubview(label)
        
        return cell
    }
    ///一旦入栈，就隐藏入栈vc的tabBar，底部工具栏
    private func pushNext(viewController: UIViewController) {
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
