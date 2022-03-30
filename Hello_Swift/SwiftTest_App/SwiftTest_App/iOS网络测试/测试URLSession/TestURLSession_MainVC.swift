//
//  TestURLSession_MainVC.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/8/19.
//  Copyright © 2021 com.mathew. All rights reserved.
//
//测试URLSession的VC

import UIKit

class TestURLSession_MainVC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、"]

    ///UI组件
    private var baseCollView: UICollectionView!
   
    //MARK: 测试缓存
    private lazy var urlReq:URLRequest? = {
        /**
         测试视频网址：http://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4
         测试json网址：https://gank.io/api/v2/data/category/Girl/type/Girl/page/1/count/9
         */
        guard let url = URL.init(string: "http://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4")else {
            print("创建url失败～")
            return nil
        }
        let urlReq = URLRequest.init(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 5) //设置缓存策略
        return urlReq
    }()
    
    var urlSession:URLSession!  //测试缓存的网络会话
    
    private lazy var sessConfig:URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.urlCache = sessCache//配置config中的缓存对象
        config.requestCachePolicy = .returnCacheDataElseLoad
        return config
    }()
    let sessCache = URLCache.init()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "测试URLSession的VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
        initCacheTest()
    }


}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestURLSession_MainVC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、测试默认的、单例的URLSession与URLSessionDataTask组合
            print("     (@@ 测试默认的、单例的URLSession与URLSessionDataTask组合")
            testDefaultURLSession()
            break
        case 1:
            //TODO: 1、测试URLSessionDelegate的使用
            print("     (@@测试URLSessionDelegate的使用 ")
            testURLSessionDelegate()
        case 2:
            print("     (@@测试URLSession的下载任务")
            //TODO: 2、测试URLSession的下载任务
            testURLSessionDownload()
        case 3:
            print("     (@@测试URLCache缓存网络数据")
            //TODO: 3、测试URLRequest、URLCache、URLSessionConfiguration缓存网络数据
            testURLCache()
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
extension TestURLSession_MainVC{
    
    //MARK: 0、测试默认的、单例的URLSession与URLSessionDataTask组合,最简单的组合
    /// 单纯地请求json数据，这个组合就够了
    func testDefaultURLSession(){
        guard let url = URL.init(string: "https://gank.io/api/v2/data/category/Girl/type/Girl/page/1/count/9")else {
            print("创建url失败～")
            return
        }
        /// 该方法必须手动调用urlSession.resume()来启动任务
        let urlSessionTask = URLSession.shared.dataTask(with: url) { data, response, error in
            print("请求网络返回的结果～")
            
            /// 网络的响应体信息，一般就是响应的数据
            print("URLSession.shared返回的data:\(String(describing: data))")
            if let _ = data {
                do {
                    ///jsonObject为Any对象，需要转换成字典来提取使用
                    let jsonObject = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves)
                    ///print("用json解析数据，jsonObject为Any对象:\(jsonObject)\n\n")
                    guard let dict = (jsonObject as? [String:Any]) else {
                        print("强制转换错误～～")
                        return
                    }
                    print("============================分割线=================  \n\n\n")
                    ///print("jsonObject转换为字典了dict :\(dict.description)")
                    guard let dataArr = (dict["data"] as? Array<Any>) else {  //解析json中的数组
                        return
                    }
                    for curEntry in dataArr {
                        let curItem = curEntry as? [String:Any]
                        print("========>>:\njson中data中的每一项：\(String(describing: curItem))\n")
                    }

                } catch {
                    print("响应体数据data通过json解析错误～")
                }
            }
            
            /// URLResponse是响应头信息，不是响应体信息，如果是http协议，那就是http协议的响应头
            print("\n\nURLSession.shared返回的response:\(String(describing: response))")
            print("\n\nURLSession.shared返回的error:\(String(describing: error))")
        }
        /// 启动网络会话的任务
        urlSessionTask.resume()
    }
    
    //MARK: 1、测试URLSessionDelegate的使用：
    func testURLSessionDelegate(){
        /**
         1、是不是只有一个代理对象，实现了所有的代理协议，而且只能在URLSession初始方法传递进去？
            答：是的，初始化后URLSession的delegate属性就是只读的了
         测试视频网址：http://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4
         测试json网址：https://gank.io/api/v2/data/category/Girl/type/Girl/page/1/count/9
         */
        guard let url = URL.init(string: "http://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4")else {
            print("创建url失败～")
            return
        }
        let urlsessionDelegate = TestURLSessionDelegate()
        let opQueue = OperationQueue.init()
        
        ///默认的会话配置就好
        let urlSession = URLSession.init(configuration: .default, delegate: urlsessionDelegate, delegateQueue: opQueue)
        let dataTask = urlSession.dataTask(with: url)
        dataTask.resume()
        
    }
    
    //MARK: 2、测试URLSession的下载任务
    func testURLSessionDownload(){
        guard let url = URL.init(string: "http://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4")else {
            print("创建url失败～")
            return
        }
        let urlsessionDelegate = TestURLSessionDelegate()
        let opQueue = OperationQueue.init()
        
        ///默认的会话配置就好
        let urlSession = URLSession.init(configuration: .default, delegate: urlsessionDelegate, delegateQueue: opQueue)
        let dataTask = urlSession.downloadTask(with: url)
        /// 如果是downloadTask，直接不经过didReceive response代理方法，而是直接走URLSessionDownloadDelegate 的 didWriteData bytesWritten 方法。
        dataTask.resume()
    }
    
    
    //MARK: 3、测试URLRequest、URLCache、URLSessionConfiguration结合来缓存网络的数据
    func testURLCache(){
        
        /// 1、是在URLRequest中修改该请求的数据缓存策略，还有一个是在URLSessionConfiguration修改requestCachePolicy属性，修改所有请求的缓存策略。
        /// 2、目前，苹果只缓存HTTP和HTTPS响应。对于FTP和文件url，缓存策略的唯一作用是确定是否允许请求访问原始源。 而且response的headr有"Cache-Control"字段才会调用相应的代理方法，并在代理方法中将URLResponse缓存到URLSessionConfiguration的urlCache属性中。
        /// 3、URLCache是以URLResponse为单位进行缓存的，是用来缓存映射request和response的。调用urlCache的cachedResponse(for:)方法查看有没有缓存到响应对象。
        /// 4、赋值给URLSessionConfiguration的urlCache属性，然后api会把缓存存进该属性中。 所以你可以通过该urlCache属性的引用来手动设置添加缓存，也可以在请求之前先访问缓存，再决定是否去请求网络。
        
        let dataTask = urlSession.dataTask(with: urlReq!)
        dataTask.resume()
        
    }
    
    
}


//MARK: - 工具方法
extension TestURLSession_MainVC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
    }
    /// 初始化缓存测试
    func initCacheTest(){
        let urlsessionDelegate = TestURLSessionDelegate()
        let opQueue = OperationQueue.init()
        ///默认的会话配置就好
        urlSession = URLSession.init(configuration: sessConfig, delegate: urlsessionDelegate, delegateQueue: opQueue)
    }
    
}


//MARK: - 设计UI
extension TestURLSession_MainVC {
    
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
extension TestURLSession_MainVC: UICollectionViewDelegate {
    
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

//MARK: - 笔记
/**
    1、URLSession有自己的delegate，而URLSession中的task也有task自身的delegate，URLRequest也有自己的配置策略。
URLSession的层级结构

     URLSession
     URLSessionconfiguration
     URLSessionTask

     URLSessionDataTask
         URLSessionUploadTask
     URLSessionDownloadTask
     URLSessionStreamTask

 URLSession相关的代理方法

     URLSessionDelegate
     URLSessionTaskDelegate
     URLSessionDataDelegate
     URLSessionDownloadDelegate
     URLSessionStreamDelegate

 URLSession使用的时候也会用到相关的若干类：

     NSURL
     NSURLRequest
     URLResponse

     HTTPURLResponse

     CachedURLResponse


 */
