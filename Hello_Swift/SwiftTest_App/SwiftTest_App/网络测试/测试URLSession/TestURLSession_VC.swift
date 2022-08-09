//
//  TestURLSession_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/8/19.
//  Copyright © 2021 com.mathew. All rights reserved.
//
//测试URLSession的VC
//MARK: - 笔记
/**
    1、URLSession有自己的delegate，而URLSession中的task也有task自身的delegate，URLRequest也有自己的配置策略。
        URLSession的层级结构
        
            URLSession
            URLSessionconfiguration
            URLSessionTask
        
            URLSessionDataTask (URLSessionDataTask的闭包里执行线程是子线程，不是主线程。)
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

    2、url地址中的中文字符，需要转换为百分号编码才可以被识别。
 
    3、URLSession的DownloadTask方法内部已经实现了边接受数据边写沙盒(tmp)的操作，不需要担心内存问题。
        如果是downloadTask，直接不经过didReceive response代理方法，而是直接走URLSessionDownloadDelegate 的 didWriteData bytesWritten 方法。
        downTask.resume()   //恢复下载
        downTask.suspend()  //暂停，是可以恢复
        downTask.cancel()   //cancel:取消是不能恢复;
  
        downTask.cancel(byProducingResumeData: (ResumeData?) -> Void)     //是可以恢复的，但是如果是程序闪退，则ResumeData保存到沙盒里也很难操作。因为还没封装好。
            // cancelByProducingResumeData:是可以恢复; 恢复下载的数据!=已下载文件数据，而是封装了的数据。
            // 对应的恢复方法是：URLSession.shared.downloadTask(withResumeData: ResumeData)
        
    
 */

import UIKit

class TestURLSession_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、"]

    ///UI组件
    private var baseCollView: UICollectionView!
   
    //TODO: 测试缓存
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
    
    var cacheUrlSession:URLSession!  //测试缓存的网络会话
    let sessCache = URLCache.init()
    
    private lazy var sessConfig:URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.urlCache = sessCache//配置config中的缓存对象
        config.requestCachePolicy = .returnCacheDataElseLoad
        return config
    }()
    
    //TODO: 测试断点下载
    private var fileCurSize:Int = 0     //已下载文件当前大小
    private var fileTotalSize:Int = 0       //文件总大小
    private var downSession:URLSession?         //下载的会话
    private var downTask:URLSessionDataTask?    //下载的任务
    private let downFileUrl:URL = URL(fileURLWithPath: "/Users/mac/Desktop/downTaskVideo2.mp4")  //下载文件的地址
    private var fileHandler:FileHandle?     //文件句柄
    
    //TODO: 测试文件上传
    private var upSession:URLSession?         //上传的会话

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试URLSession的VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
        initCacheTest()
    }

    deinit {
        print("TestURLSession_VC析构函数～\(#function)")
        //清理网络会话,session设置了代理的时候，是强引用，不会释放。
        downSession?.finishTasksAndInvalidate()
    }

}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestURLSession_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、测试默认的、单例的URLSession与URLSessionDataTask组合，最简单的组合
            print("     (@@ 测试默认的、单例的URLSession与URLSessionDataTask组合")
            /**
                1、单纯地请求json数据，这个组合就够了，免费的api：https://www.bejson.com/knownjson/webInterface/
            */
 
            ///这个是百度百科的接口,记得url地址中的中文要转换为百分号编码
            let keyWord = NSString.init(string: "中国国宝").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as String
            guard let url = URL.init(string: "http://baike.baidu.com/api/openapi/BaikeLemmaCardApi?scope=103&format=json&appid=379020&bk_key=\(keyWord)&bk_length=600")else {
                print("创建url失败～")
                return
            }
            /// 该方法必须手动调用urlSession.resume()来启动任务。 创建了默认的请求体，是GET请求方式。
            let urlSessionTask = URLSession.shared.dataTask(with: url) { data, response, error in
                print("请求网络返回的结果～")
                
                /// 网络的响应体信息，一般就是响应的数据.
                print("URLSession.shared返回的data:\(String(describing: String(data: data ?? Data(), encoding: .utf8)))")    //用utf8来解析返回的data
                if let _ = data {
                    do {
                        print("URLSessionDataTask闭包里的当前线程：\(Thread.current)")
                        ///用json格式来解析返回的data，jsonObject为Any对象，需要转换成字典来提取使用
                        let jsonObject = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves)
                        ///print("用json解析数据，jsonObject为Any对象:\(jsonObject)\n\n")
                        guard let dict = (jsonObject as? [String:Any]) else {
                            print("强制转换错误～～")
                            return
                        }
                        print("jsonObject转换为字典了dict: \n \(dict.description)")
                        print("============================分割线=================  \n\n\n")
                        guard let dataArr = (dict["card"] as? Array<Any>) else {  //解析json中的数组
                            print("json里面没有card字段")
                            return
                        }
                        for curEntry in dataArr {
                            let curItem = curEntry as? [String:Any]
                            print("========>>:\njson中card中的每一项：\(String(describing: curItem))\n")
                        }
                        
                    } catch {
                        print("响应体数据card通过json解析错误～")
                    }
                }
                
                /// URLResponse是响应头信息，不是响应体信息，如果是http协议，那就是http协议的响应头
                print("\n\nURLSession.shared返回的response:  \(String(describing: response))")
                print("\n\nURLSession.shared返回的error:  \(String(describing: error))")
            }
            /// 启动网络会话的任务
            urlSessionTask.resume()
            
        case 1:
            //TODO: 1、测试URLSessionDelegate的使用
            print("     (@@测试URLSessionDelegate的使用 ")
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
            
        case 2:
            //TODO: 2、测试URLSession的下载任务
            print("     (@@测试URLSession的下载任务")
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
            
        case 3:
            //TODO: 3、测试URLRequest、URLCache、URLSessionConfiguration结合来缓存网络的数据
            print("     (@@测试URLCache缓存网络数据")
            
            /**
                1、是在URLRequest中修改该请求的数据缓存策略，还有一个是在URLSessionConfiguration修改requestCachePolicy属性，修改所有请求的缓存策略。
                2、目前，苹果只缓存HTTP和HTTPS响应。对于FTP和文件url，缓存策略的唯一作用是确定是否允许请求访问原始源。
                而且response的headr有"Cache-Control"字段才会调用相应的代理方法，并在代理方法中将URLResponse缓存到URLSessionConfiguration的urlCache属性中。
                3、URLCache是以URLResponse为单位进行缓存的，是用来缓存映射request和response的。调用urlCache的cachedResponse(for:)方法查看有没有缓存到响应对象。
                4、赋值给URLSessionConfiguration的urlCache属性，然后api会把缓存存进该属性中。
                   所以你可以通过该urlCache属性的引用来手动设置添加缓存，也可以在请求之前先访问缓存，再决定是否去请求网络。
             */
            
            
            let dataTask = cacheUrlSession.dataTask(with: urlReq!)
            dataTask.resume()
            
        case 4:
            //TODO: 4、测试URLSession的POST请求
            print("     (@@ 测试URLSession的POST请求")
            //1.确定请求路径
            let urlStr = NSString(string: "http://baike.baidu.com/api/openapi/BaikeLemmaCardApi")
            let reqUrl = URL.init(string:  urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            
            //2.创建请求对象
            var request = URLRequest.init(url: reqUrl!)
            request.httpMethod = "POST"
            request.timeoutInterval = 10    //10秒没有返回，认为失败
            request.setValue("ios 16.0", forHTTPHeaderField: "User-Agent")
            request.httpBody = "scope=103&format=json&appid=379020&bk_key=中国&bk_length=600".data(using: .utf8)
            
            //3.发送请求
            let dataTask = URLSession.shared.dataTask(with: request) { data, resp, err in
                print("POST，返回的响应头信息：\(String(describing: resp))")
                if let curData = data {
                    let resStr = String(data: curData, encoding: .utf8)?.removingPercentEncoding
                    print("POST，返回的数据：\(resStr ?? "没看见数据")")
                }
                print("POST，返回的错误是：\(String(describing: err))")
            }
            dataTask.resume()
        
        case 5:
            //TODO: 5、测试URLSession的下载
            print("     (@@ 测试URLSession的下载")
            
            let fileUrl = URL(fileURLWithPath: "/Users/mac/Desktop/downTaskVideo.mp4")   //桌面文件
            
            ///该方法内部已经实现了边接受数据边写沙盒(tmp)的操作，不需要担心内存问题。
            let downTask = URLSession.shared.downloadTask(with: URL.init(string: "http://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4")!) {  locationUrl, resp, err in
                /// locationUrl是downloadTask 存储下载文件的 在沙盒中的 位置。
                print("在沙盒tmp文件夹中的位置：\(String(describing: locationUrl?.path))")
                
                /// 剪切文件
                do{
                    try FileManager.default.moveItem(atPath: locationUrl!.path, toPath: fileUrl.path)
                } catch let err { print("剪切文件的错误：\(err)") }
                
            }
            downTask.resume()   //启动或恢复下载
            
            
        case 6:
            //TODO: 6、测试断点下载，设置请求头
            print("     (@@ 测试断点下载，设置请求头")
            //1.确定请求路径
            let reqUrl = URL.init(string:  "http://vfx.mtime.cn/Video/2019/03/19/mp4/190319222227698228.mp4")
            
            /// 计算已存在的文件的大小,然后计算文件总大小
            if let fileDict = try? FileManager.default.attributesOfItem(atPath: downFileUrl.path) {
                let fileCount:Int = fileDict[FileAttributeKey.size] as? Int ?? 0
                fileCurSize = fileCount
            }
            
            //2.创建请求对象
            var request = URLRequest.init(url: reqUrl!)
            request.setValue("bytes=\(fileCurSize)-", forHTTPHeaderField: "Range")  //设置请求范围
            
            //3.发送请求
            if downSession == nil {
                downSession = URLSession.init(configuration: .default, delegate: self, delegateQueue: OperationQueue())
            }
            downTask = downSession!.dataTask(with: request)
            downTask!.resume()   //开启任务
            
        
        case 7:
            //TODO: 7、暂停，恢复，取消下载任务。
            print("     (@@ 暂停，恢复，取消下载任务。")
            
            downTask?.suspend()  //暂停，是可以恢复
            ///downTask?.cancel()   //cancel:取消是不能恢复;
        case 8:
            //TODO: 8、恢复下载
            print("     (@@恢复下载")
            downTask?.resume()   //恢复下载
        case 9:
            //TODO: 9、测试urlsession文件上传,手工拼凑参数
            print("     (@@ 测试urlsession文件上传")
            //1.确定请求路径
            let url = URL(string: "http://vfx.mtime.cn/Video/2019/02/04/mp4")
            
            //2.创建可变的请求对象，设置请求头信息
            var request = URLRequest(url: url!)
            request.httpMethod = "POST";
            /// Content-Type:multipart/form-data; boundary=----WebKitFormBoundaryjv0UfA04ED44AhWx
            let Kboundary = "----WebKitFormBoundaryhahahahahahahaha"    //分隔符
            request.setValue("multipart/form-data; boundary=\(Kboundary)", forHTTPHeaderField: "Content-Type")
            
            /// 拼接请求体数据
            var fileData = Data()
            let dataStr = "--\(Kboundary)"
            fileData.append(dataStr.data(using: .utf8)!)
            let KNewLineData = "\r\n".data(using: .utf8)!   //回车换行符
            fileData.append(KNewLineData)
            
            //name:file 服务器规定的参数
            //filename:Snip20160225_341.png 文件保存到服务器上面的名称
            //Content-Type:文件的类型
            fileData.append("Content-Disposition: form-data; name=\"file\"; filename=\"Snip20160225_341.png\"".data(using: .utf8)!)
            fileData.append(KNewLineData)
            fileData.append("Content-Type: image/png".data(using: .utf8)!)
            fileData.append(KNewLineData)
            fileData.append(KNewLineData)
            let image = UIImage(named: "labi07")
            fileData.append(image!.pngData()!)
            fileData.append(KNewLineData)
            
            
            /// 非文件参数
            /*
             (分隔符可以随便写，但是四个地方的分隔符要保持一致)
             --分隔符
             Content-Disposition: form-data; name="username"
             空行
             123456
             */
            fileData.append("--\(Kboundary)".data(using: .utf8)!)
            fileData.append(KNewLineData)
            fileData.append("Content-Disposition: form-data; name=\"username\"".data(using: .utf8)!)
            fileData.append(KNewLineData)
            fileData.append(KNewLineData)
            fileData.append("123456".data(using: .utf8)!)
            fileData.append(KNewLineData)
            
            //5.3 结尾标识
            fileData.append("--\(Kboundary)--".data(using: .utf8)!)
            
            
            //3.设置会话对象，唯一不同的是，请求体数据现在不放在请求头，而是放在upTask的创建方法里，由方法来拼接进去请求头对象。
            let config = URLSessionConfiguration.default
            config.allowsCellularAccess = true  //允许蜂窝网络访问
            config.timeoutIntervalForRequest = 15   //请求超时时间
            upSession = URLSession.init(configuration: config, delegate: self, delegateQueue: OperationQueue())
            let upTask = upSession!.uploadTask(with: request, from: fileData) { data, resp, err in
                print("上传文件结果：data：\(String(describing: data)),\n resp：\(String(describing: resp)),\n err：\(String(describing: err))")
            }
            upTask.resume()
            
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

//MARK: - 遵循URLSessionDataDelegate协议，测试断点下载
extension TestURLSession_VC: URLSessionDataDelegate{
    
    // MARK: 已经接受到服务器的初始应答(响应头), 准备接下来的数据任务的操作，:
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void){
        /**
         1、completionHandler: 方法，接收到服务器的响应被自动调用，一次请求只响应一次， 它默认会取消该请求，所以你要在completionHandler的闭包中，让系统不要取消。
         */
        print("©URLSessionDataDelegate©  的 \(#function) 方法")
        print("""
                响应头：--MimeType(mime类型):\(String(describing: response.mimeType)),
                --suggestedFilename(建议文件名):\(String(describing: response.suggestedFilename)),
                --expectedContentLength(本次请求总大小):\(response.expectedContentLength)
                """)
        /// 首次进入请求的是文件的总大小。
        if fileTotalSize == 0 {
            /// 文件不存在时
            if !FileManager.default.fileExists(atPath: downFileUrl.path) {
                FileManager.default.createFile(atPath: downFileUrl.path, contents: nil, attributes: nil)
                fileTotalSize = Int(response.expectedContentLength)
            }else{
                /// 计算已存在的文件的大小,然后计算文件总大小
                if let fileDict = try? FileManager.default.attributesOfItem(atPath: downFileUrl.path) {
                    let fileCount:Int = fileDict[FileAttributeKey.size] as? Int ?? 0
                    fileCurSize = fileCount
                    fileTotalSize = fileCount + Int(response.expectedContentLength)
                }
            }
           
        }
        if fileHandler == nil {  //创建文件句柄,首次进入，或者是退出后又进去的时候。
            fileHandler = FileHandle(forWritingAtPath: downFileUrl.path)
        }else{
            fileHandler!.seekToEndOfFile()  //文件句柄移动到文件末尾。
        }
        
        completionHandler(.allow)   //允许访问
        
    }
    
    // MARK: 已经转变成downloadTask:
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask){
        print("©URLSessionDataDelegate©  的 \(#function)  方法")
        
    }
    
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome streamTask: URLSessionStreamTask){
        print("©URLSessionDataDelegate©  的 \(#function) 方法")
        
    }
    
    // MARK: 已经接收到部分数据:
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data){
        print("©URLSessionDataDelegate©  的 \(#function) 方法")
        /// 写入数据到文件。
        fileHandler?.write(data)
        fileCurSize += data.count   //计算已经写入的文件大小
        print("文件下载进度：\(String(format: "%.2f", Double(fileCurSize)/Double(fileTotalSize)))")
        
    }
    
    // MARK: 当session任务完成后，会回调该方法，告诉代理者要不要缓存数据。然后才去回调didFinishCollecting方法
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void){
        ///1、uploads、 data tasks的session才会调用该方法，background 、ephemeral的session不会回调该方法。还与 前面的response的Headers有允许缓存的"Cache-Control"字段才会回调该方法。
        ///2、completionHandler参数我也不知道是怎么用，是不是要返回给系统的？是的，和didReceive response方法一样。把CachedURLResponse存进config的urlcache属性中。
        ///3、目前，苹果只缓存HTTP和HTTPS响应。对于FTP和文件url，缓存策略的唯一作用是确定是否允许请求访问原始源。
        ///4、一般你给出的completionHandler的参数都是基于proposedResponse修改而来。
        ///5、cache的策略优先从url request中取，如果没有，则从configuration中取。
        ///6、URLCache内含CachedURLResponse对象。
        ///7、如果request请求是下载文件，则不会调用该代理方法。由URLSessionConfiguration决定。
        /// The default session configuration uses a persistent disk-based cache (except when the result is downloaded to a file) and stores credentials in the user’s keychain.
        print("©URLSessionDataDelegate©  的 \(#function) 方法")
        if proposedResponse.response.url?.scheme == "https" {
            let updatedResponse = CachedURLResponse(response: proposedResponse.response,
                                                    data: proposedResponse.data,
                                                    userInfo: proposedResponse.userInfo,
                                                    storagePolicy: .allowedInMemoryOnly)
            completionHandler(updatedResponse)
        } else {
            completionHandler(proposedResponse)
        }
    }
    
    // MARK: 请求结束或者是失败的时候调用
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("©URLSessionDataDelegate©  的 \(#function) 方法")
        /// 关闭文件句柄
        fileHandler?.closeFile()
        fileHandler = nil
    }
    
    // MARK: 上传文件的进度
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        print("©URLSessionDataDelegate©  的 \(#function) 方法")
        print("上传进度：--bytesSent:\(bytesSent),\n --totalBytesSent:\(totalBytesSent),\n --totalBytesExpectedToSend:\(totalBytesExpectedToSend)")
    }
}


//MARK: - 设计UI
extension TestURLSession_VC {
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
    }
    /// 初始化缓存测试
    func initCacheTest(){
        let urlsessionDelegate = TestURLSessionDelegate()
        let opQueue = OperationQueue.init()
        ///默认的会话配置就好
        cacheUrlSession = URLSession.init(configuration: sessConfig, delegate: urlsessionDelegate, delegateQueue: opQueue)
    }
    
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
extension TestURLSession_VC: UICollectionViewDelegate {
    
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


