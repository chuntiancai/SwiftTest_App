//
//  测试录音_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/10/27.
//  Copyright © 2022 com.mathew. All rights reserved.
//
//测试录音的VC
// MARK: - 笔记
/**
    1、录音功能用到了AVFoundation框架的AVAudioSession、AVAudioRecorder类。
 
        AVAudioSession是一个单例，用来管理多个APP对音频硬件设备（麦克风，扬声器）的资源使用。
        翻译成会话，相当于一个进程，用于管理多个App之间对硬件设备的音频资源的使用。
        APP启动的时候会自动帮激活AVAudioSession，当然我们可以手动激活。
        
        AVAudioSession的作用：
        > 设置自己的APP是否和其他APP音频同时存在，还是中断其他APP声音。
        > 在手机调到静音模式下，自己的APP音频是否可以播放出声音。
        > 电话或者其他APP中断自己APP的音频的事件处理。
        > 指定音频输入和输出的设备（比如是听筒输出声音，还是扬声器输出声音）。
        > 是否支持录音，录音同时是否支持音频播放。

 
    2、录音功能的步骤：
        2.0、请求麦克风权限。info.plist -> Privacy - Microphone Usage Description
        2.1、获取音频会话单例AVAudioSession。
            > 通过AVAudioSession单例请求麦克风权限。
            >
 
        2.1、创建录音存放的路径。URL要用文件的URL。
        2.2、设置录音器的配置。
        2.3、创建录音对象。
        2.4、准备录音、开始录音、停止录音。
 
    3、录音文件的格式：
        3.1、caf格式: 适用于几乎iOS中所有的编码格式。
        3.2、caf 文件格式, 因为某些编码设置, 文件有可能会很大, 而且caf, 格式并不是很通用, 所以在开发过程中, 一般会进行压缩转码成MP3格式。
        3.3、关于caf文件格式转换为mp3格式，参考LAME框架的使用。
 
    4、录音文件的格式转码(caf格式转为mp3格式)：
        Lame是一款优秀的mp3开源跨平台编码库，可以将音频的 裸PCM数据 编码成mp3。
        Lame框架下载地址：http://lame.sourceforge.net
        将Lame库编译成静态库的脚本，shell下载地址：https://github.com/kewlbear/lame-ios-build
            
        4.1、先去下载Lame源码。
        4.2、去下载将lame源码编译成静态库的shell脚本：build-lame.sh
                > 或者你直接在github上面复制build-lame.sh的代码，然后通过终端touch一个新的文件，copy代码进去就可以了。
        4.3、创建一个文件夹 存储lame源码和shell脚本，准备开始编译静态库操作。
        4.4、修改脚本里面的 SOURCE="lame" 名字与 下载的lame名字一致，也可以把 下载的lame名字 改为 lame,那么就不需要改脚本的内容。
        4.5、在终端，修改脚本的系统权限，修改为可执行脚本：
             chmod +x build-lame.sh         #修改脚本的权限。
             ./build-lame.sh            #执行脚本。
 
        4.6、执行脚本的结果是生成三个文件，我们要的是支持多种架构的 fat-lame 文件,把 fat-lame 里面的 lame.h 与 libmp3lame.a 拖走即可。
        4.7、导入静态库到工程, 开始使用，我们把代码都写在 JKLameTool 类里面。
             把fat-lame 里面的 lame.h 与 libmp3lame.a拖入到xcode的工程目录里面。
                xcode会自动把libmp3lame.a添加到 project -> target -> framework,libraries 里，或者你手动添加。
 
        4.8、写一个工具了，用于封装lame框架里面的api，由于lame方法内部多以 C 语言为主，用 Swift 语言写的时候有些问题，此处仍以 OC 文件。
 
        
 

 */

import AVFoundation

class TestVoiceRecord_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    let bgView = UIView()   //测试的view可以放在这里面
   
    
    //MARK: 测试组件
    var audioRecorder:AVAudioRecorder?   //录音器。
    var audioPlayer: AVAudioPlayer?     //音频播放器。
    let audioSession = AVAudioSession.sharedInstance()  //音频会话单例
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试录音的VC"
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestVoiceRecord_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("TestVoiceRecord_VC 点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、请求录音权限，配置音频会话对象。
            /**
                1、通过AVAudioSession单例请求麦克风权限。
                2、设置AVAudioSession单例的分类，也就是当前App需要的音频功能种类。
             */
            
            //1、首先要判断是否允许访问麦克风。
            audioSession.requestRecordPermission { [weak self] (allowed) in
                if !allowed{
                    print("用户拒绝麦克风权限。")
                    let alert = UIAlertController(title: "无法访问您的麦克风",
                                                  message: "请到设置 -> 隐私 -> 麦克风 ，打开访问权限",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "好的", style: .cancel, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }else{
                    print("用户允许麦克风权限。")
                    do {
                        //2、设置分类，也就是你请求的音频功能种类。
                        try self?.audioSession.setCategory(.playAndRecord, mode: .default)
//                        self?.audioSession.perform(NSSelectorFromString("setCategory:error:"), with: AVAudioSession.Category.playAndRecord)
                        try self?.audioSession.setActive(true)
                       
                    } catch let error as NSError{
                        print("配置音频会话单例出错：",error)
                    }
                }
            }
            

        case 1:
            //TODO: 1、创建录音对象。
            /**
                1、AVAudioRecorder可以根据url在沙盒中创建录音文件，但是不能在mac电脑本地创建文件。
             */
            print("     (@@ 1、创建录音对象。")
            
            if audioRecorder != nil { print("已经创建过录音器对象了"); break;}
            
//            let docUrl:URL = FileManager.default.urls( for: .documentDirectory,in:.userDomainMask).first!
//            let fileUrl:URL = docUrl.appendingPathComponent("ctchVoice.caf")
            
            let fileUrl:URL = URL(fileURLWithPath: "/Users/mathew/Desktop/ctchVoice.caf")
            // setting : 录音的设置项
            // 录音参数设置(不需要掌握, 一些固定的配置)
            let configDic: [String: AnyObject] = [
                AVFormatIDKey: NSNumber(value: Int32(kAudioFormatLinearPCM)),   // 编码格式
                AVSampleRateKey: NSNumber(value: 11025.0),  // 采样率
                AVNumberOfChannelsKey: NSNumber(value: 2),// 通道数
                AVEncoderAudioQualityKey: NSNumber(value: Int32(AVAudioQuality.min.rawValue))   // 录音质量
            ]
            
            
            do {
                let curRecord = try AVAudioRecorder(url: fileUrl, settings: configDic)
                // 准备录音(系统会给我们分配一些资源)
                curRecord.prepareToRecord()
                audioRecorder = curRecord
                audioRecorder?.delegate = self
            }catch {
                print("创建录音对象发生了错误：",error)
            }
            
        case 2:
            //TODO: 2、开始录音。
            print("     (@@ 2、开始录音。")
            // 开始录音
            // 直接就开始录音(需要我们手动通过代码结束录音)
            audioRecorder?.record()
            // 从未来的某个时间点, 开始录音(需要我们手动通过代码结束录音)
            //audioRecorder?.record(atTime: audioRecorder!.deviceCurrentTime + 3)
            
            // 从现在开始录音, 录多久
           // audioRecorder?.record(forDuration: 3)
            
            // 从哪个时间点开始录, 录多久
           // audioRecorder?.record(atTime: audioRecorder!.deviceCurrentTime, forDuration: 10)
            
            
        case 3:
            //TODO: 3、停止录音。
            print("     (@@ 3、停止录音。")
            // 根据当前的录音时间, 做处理。如果录音不超过两秒, 则删除录音。如果超过, 就正常处理
            if audioRecorder?.currentTime ?? 0 > 2 {
                audioRecorder?.stop()
            }else {
                print("录音时间太短：\(String(describing: audioRecorder?.currentTime) )")
                // 删除录音文件, 如果想要删除录音文件, 必须先让录音停止
                audioRecorder?.stop()
                audioRecorder?.deleteRecording()
            }
            audioRecorder?.stop()    // 结束录音
        case 4:
            //TODO: 4、测试lame框架的使用，caf转mp3格式。
            print("     @@ 4、测试lame框架的使用，caf转mp3。")
            
            let fileUrl:URL = URL(fileURLWithPath: "/Users/mathew/Desktop/ctchVoice.caf")
            let exist = FileManager.default.fileExists(atPath: fileUrl.path)
            
            //1、转换文件格式。
            if exist {
                // 将 .caf 转 .mp3 格式
                let mp3Path: String = LameTool.audio(toMP3: fileUrl.path, isDeleteSourchFile: false)
                print("将 .caf 转 .mp3 格式结果: \(mp3Path)")
            }
            
                  
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
//MARK: - 遵循录音的协议，AVAudioRecorderDelegate协议
extension TestVoiceRecord_VC: AVAudioRecorderDelegate{
   
  
}


//MARK: - 设置测试的UI
extension TestVoiceRecord_VC{
    
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
extension TestVoiceRecord_VC {
    
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
extension TestVoiceRecord_VC: UICollectionViewDelegate {
    
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
