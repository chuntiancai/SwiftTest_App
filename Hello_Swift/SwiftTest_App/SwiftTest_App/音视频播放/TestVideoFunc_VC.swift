//
//  TestVideoFunc_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/8/10.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试音视频功能的VC

import UIKit
import AVFoundation

class TestVideoFunc_VC: UIViewController {
    
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
        self.title = "测试音视频功能的VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initAVPlayer()
    }
    


}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestVideoFunc_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //MARK: 测试AVAsset的拦截下载
            print("     (@@测试AVAsset的网络请求拦截下载")
            testAVAssetDownloadRequest()
            break
        case 1:
            print("     (@@点击调用finishloading方法")
            loaderAVassetDelegate.curLoadingRequest?.finishLoading()
            
        case 2:
            print("     (@@")
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
        case 13:
            print("     (@@")
        case 14:
            print("     (@@")
        case 15:
            print("     (@@")
        case 16:
            print("     (@@")
        case 17:
            print("     (@@")
        case 18:
            print("     (@@")
        case 19:
            print("     (@@")
        case 20:
            print("     (@@")
        case 21:
            print("     (@@")
        case 22:
            print("     (@@")
        case 23:
            print("     (@@")
        case 24:
            print("     (@@")
        default:
            break
        }
    }
    
}
//MARK: - 测试的方法
extension TestVideoFunc_VC{
    
    //MARK: 测试AVAsset的拦截下载
    /// 测试AVAsset的拦截下载
    func testAVAssetDownloadRequest(){
        
        //MARK: 手动实现AVAssetResourceLoaderDelegate协议需要URL是自定义的URLScheme,只需要把源URL的http://或者https://替换成xxxx://， 然后再实现AVAssetResourceLoaderDelegate协议函数才可以生效，否则不会生效。
        
        if avplayer.currentItem == nil {
            playItem = AVPlayerItem.init(asset: avAsset)
            avplayer.replaceCurrentItem(with: playItem)
        }
        avplayer.play()
        
    }
    
}


//MARK: - 工具方法
extension TestVideoFunc_VC{
    
    //MARK: 初始化AVPlayer的相关配置
    private func initAVPlayer(){
        avAsset = AVURLAsset.init(url: URL.init(string: "jfz_http://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4")!)
        // MARK: 设置AVURLAsset的代理对象。
        avAsset.resourceLoader.setDelegate(loaderAVassetDelegate, queue: loaderAVassetDelegate.loaderDelegateQueue)
        let avLayer = AVPlayerLayer()
        avLayer.player = avplayer
        self.midView.layer.addSublayer(avLayer)
        avLayer.frame = CGRect.init(x: 0, y: 0, width: 300, height: 200)
    }
    
    
}


//MARK: - 设计UI
extension TestVideoFunc_VC {
    
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
        
        midView.backgroundColor = .darkGray
        self.view.addSubview(midView)
        midView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(40)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(250)
        }
        
    }
}

//MARK: - 遵循委托协议,UICollectionViewDelegate
extension TestVideoFunc_VC: UICollectionViewDelegate {
    
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
