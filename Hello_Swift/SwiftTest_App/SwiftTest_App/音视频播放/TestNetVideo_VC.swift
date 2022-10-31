//
//  TestNetVideo_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/8/10.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试播放网络音视频的VC
//MARK: - 笔记
/**
    FIXME: 暂时还没有完成边播边缓存功能。
    1、处理播放网络的音视频：
       AVURLAsset初始化自定义Url -> 设置avAsset.resourceLoader的代理 -> 代理拦截自定义url -> 保存代理中的request对象 -->
       在代理方法中把自定义url替换成真正的url -> 根据真正的url去请求网络数据 -> 网络数据填充request对象 -> 调用request对象的finish方法。
 
    2、AVPlayer与AVURLAsset中的绑定是通过AVPlayerItem的：AVPlayerItem绑定到AVURLAsset中，AVPlayer播放AVPlayerItem。
 */

import AVFoundation

class TestNetVideo_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    private var midView = UIView()  //中间放置视频的View
    
    //MARK: 测试用的工具属性
    private var avAsset:AVURLAsset!
    private var playItem :AVPlayerItem?
    private let avplayer = AVPlayer()
    private let loaderAVassetDelegate = JFZ_AVAssetResLoaderDelegateObject()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "播放网络音视频的VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
    }
    


}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestNetVideo_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、初始化AVURLAsset、AVPlayerLayer 的相关配置，并设置代理对象。
            /**
                1、添加视频图层：将AVPlayer绑定AVPlayerLayer的player上。   //AVPlayerLayer是一个视图Layer，专门处理视频的图层。
                2、将AVPlayerLayer添加的普通view的layer上。
                3、想要回调AVAssetResourceLoaderDelegate协议的方法,则需要用自定义的URLScheme,当delegate识别不了url,就会去回调代理方法,让程序员去处理。
                   例如：把源URL的http://或者https://替换成xxxx://， 否则不会回调。
             */
            print("0、初始化AVURLAsset、AVPlayerLayer 的相关配置，并设置代理对象。")
            if avAsset != nil {return }
            avAsset = AVURLAsset.init(url: URL.init(string: "jfz_http://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4")!)
            //设置AVURLAsset的代理对象。
            avAsset.resourceLoader.setDelegate(loaderAVassetDelegate, queue: loaderAVassetDelegate.loaderDelegateQueue)
            
            
            //普通的view。
            midView.backgroundColor = .darkGray
            self.view.addSubview(midView)
            midView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(40)
                make.width.equalToSuperview().multipliedBy(0.8)
                make.height.equalTo(250)
            }
            let avLayer = AVPlayerLayer()
            
            //绑定AVPlayer与AVPlayerLayer。
            avLayer.player = avplayer
            
            //添加视频AVPlayerLayer到普通view的layer上。
            self.midView.layer.addSublayer(avLayer)
            avLayer.frame = CGRect.init(x: 0, y: 0, width: 300, height: 200)
            
        case 1:
            //TODO: 1、将AVPlayerItem绑定到AVURLAsset中，AVPlayer播放AVPlayerItem。
            /**
                1、AVPlayer与AVURLAsset中的绑定是通过AVPlayerItem的。
                
             */
            print("     (@@1、将AVPlayerItem绑定到AVURLAsset中，AVPlayer播放AVPlayerItem。")
            if avplayer.currentItem == nil {
                playItem = AVPlayerItem.init(asset: avAsset)
                avplayer.replaceCurrentItem(with: playItem)
            }
            avplayer.play()
            
        case 2:
            print("     (@@2、点击调用finishloading方法")
            loaderAVassetDelegate.curLoadingRequest?.finishLoading()
        case 3:
            print("     (@@")
        case 4:
            print("     (@@")
        case 5:
            print("     (@@")
        case 6:
            print("     (@@")
        case 7:
            print("     (@@")
            break
        case 8:
            print("     (@@")
        case 9:
            print("     (@@")
        case 10:
            print("     (@@ 暂停播放")
            avplayer.pause()
        case 11:
            print("     (@@")
        case 12:
            print("     (@@")
        default:
            break
        }
    }
    
}
//MARK: - 测试的方法
extension TestNetVideo_VC{
    
    
    
}


//MARK: - 设计UI
extension TestNetVideo_VC {
    
    /// 设置导航栏的UI
    private func setNavigationBarUI(){
        
        ///布局从导航栏下方开始
        self.edgesForExtendedLayout = .bottom
        
        //设置子页面的navigation bar的返回按钮样式
        let backItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    /// 设置collection view的UI
    private func setCollectionViewUI(){
        
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: 80, height: 40)
        
        baseCollView = UICollectionView.init(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width,height:200),
                                             collectionViewLayout: layout)
        
        baseCollView.backgroundColor = UIColor.cyan
        baseCollView.contentSize = CGSize.init(width: UIScreen.main.bounds.size.width * 2, height: UIScreen.main.bounds.size.height)
        baseCollView.showsVerticalScrollIndicator = true
        baseCollView.alwaysBounceVertical = true
        baseCollView.delegate = self
        baseCollView.dataSource = self
        baseCollView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionView_Cell_ID")
        
        self.view.addSubview(baseCollView)
        
        
        
    }
}

//MARK: - 遵循委托协议,UICollectionViewDelegate
extension TestNetVideo_VC: UICollectionViewDelegate {
    
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

/**
 [
         JFZAudioVideoModel(fileName:"网络视频0",
                       fileUrl: "http://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4",
                       imageUrlStr:"hahaha"),
         JFZAudioVideoModel(fileName:"网络音频0",
                       fileUrl: "http://music.163.com/song/media/outer/url?id=447925558.mp3",
                       imageUrlStr:"hahaha"),
         JFZAudioVideoModel(fileName:"网络音频2",
                       fileUrl: "http://music.163.com/song/media/outer/url?id=447925558.mp3",
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
                   fileUrl: "http://vfx.mtime.cn/Video/2019/03/19/mp4/190319222227698228.mp4",
                   imageUrlStr:"hahaha"),
     JFZAudioVideoModel(fileName:"网络视频6",
                   fileUrl: "http://vjs.zencdn.net/v/oceans.mp4",
                   imageUrlStr:"hahaha"),
     JFZAudioVideoModel(fileName:"网络视频7",
                   fileUrl: "http://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4",
                   imageUrlStr:"hahaha"),
     JFZAudioVideoModel(fileName:"网络视频8",
                   fileUrl: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4",
                   imageUrlStr:"hahaha"),
     JFZAudioVideoModel(fileName:"网络视频9",
                   fileUrl: "http://vfx.mtime.cn/Video/2019/03/19/mp4/190319222227698228.mp4",
                   imageUrlStr:"hahaha"),
     JFZAudioVideoModel(fileName:"网络视频10",
                   fileUrl: "http://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4",
                   imageUrlStr:"hahaha"),
     ]
 */
