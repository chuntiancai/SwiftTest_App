//
//  JFZ_AVAssetLoaderUrlSession.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/8/25.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 下载视频资源AVAssetResourceLoader的网络下载的代理者，遵循URLSessionDelegate，负责下载视频源
// 一次性使用吗，不了，还是设置一个数组来保存AVAssetResourceLoadingRequest吧
import AVFoundation

class JFZ_AVAssetLoaderUrlSession:NSObject {
    
    //MARK: 对外属性
//    var resLoader:
    
    
    //MARK: 内部属性
    private var respMimeType:String?//响应类型
    private var loadingRequest:AVAssetResourceLoadingRequest!
    private var urlSession:URLSession = URLSession.shared
    private var loadingRequestArr = [AVAssetResourceLoadingRequest]()
    
    
    init(loadingRequest:AVAssetResourceLoadingRequest) {
        self.loadingRequest = loadingRequest
        super.init()
        initSessionConfig()
    }
    
    
}
//MARK: - 初始化方法
extension JFZ_AVAssetLoaderUrlSession  {
    
    /// 初始化url session 的相关配置
    private func initSessionConfig(){
        /// 初始化url session
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = true
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        config.networkServiceType = .video
        
        /// 拼凑真正的URLRequest请求
        var urlReq:URLRequest!
        guard let customUrl = loadingRequest.request.url else {
            return
        }
        var realReqUrl:URL!
        if customUrl.absoluteString.contains("jfz_http") {
            realReqUrl = URL.init(string: customUrl.absoluteString.replacingOccurrences(of: "jfz_http", with: "http"))
        }else{
            realReqUrl = customUrl
        }
        urlReq = URLRequest.init(url: realReqUrl, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 20)
        urlReq.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        urlReq.httpMethod = "GET"
        
        let sessQueue = OperationQueue.init()
        sessQueue.maxConcurrentOperationCount = 3
        /// 发起真正的下载任务，我在思考到底要不要一次性使用,不要，这样太浪费了
        urlSession = URLSession.init(configuration: config, delegate: self, delegateQueue: sessQueue)
        let dataTask = urlSession.downloadTask(with: urlReq)
        dataTask.resume()
    }
    
}
//MARK: - 对外提供的方法
extension JFZ_AVAssetLoaderUrlSession  {
    /// 添加视频的下载请求
    /// - Parameter loadingRequest: 视频的下载请求
    func addLoadingRequest(loadingRequest:AVAssetResourceLoadingRequest){
        
    }
    
}
//MARK: - 逻辑方法
extension JFZ_AVAssetLoaderUrlSession{
    
}
//MARK: - 工具方法
extension JFZ_AVAssetLoaderUrlSession{
    
}
//MARK: - 遵循URLSessionDataDelegate协议，处理传输的数据
extension JFZ_AVAssetLoaderUrlSession: URLSessionDataDelegate {
    
    // MARK: ## didReceive response方法，告诉delegate已经接受到服务器的初始应答(响应头), 准备接下来的数据任务的操作，:
    // MARK: ## completionHandler参数 必须赋值，用于告诉系统下一步该做什么。
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void){
        /**
         completionHandler: 方法，接收到服务器的响应被自动调用，一次请求只响应一次， 它默认会取消该请求，所以你要在completionHandler的闭包中，让系统不要取消。
         */
        print("©data© 这是 URLSessionDataDelegate 的 didReceive response: 方法")
        respMimeType = response.mimeType
        if response.mimeType == "video/mp4" {
            print("     转换成下载任务")
            completionHandler(.becomeDownload) //转换为下载任务
        }else{
            /// 转换json字符串为对象
            completionHandler(.allow)   //允许访问
        }
        /// 转换json字符串为对象
        //        completionHandler(.allow)   //允许访问
        
        
        /**
         completionHandler(.allow)的参数：
         public enum ResponseDisposition : Int {
             case cancel = 0 /* Cancel the load, this is the same as -[task cancel] */  取消任务，默认是这个
             case allow = 1 /* Allow the load to continue */ 允许任务继续
             case becomeDownload = 2 /* Turn this request into a download */ 变成下载任务
             case becomeStream = 3 /* Turn this task into a stream task */ 变成流任务
         }
         */
        
    }
    
    // MARK: ## didBecome downloadTask方法，告诉delegate, data task 已经转变成downloadTask:
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask){
        print("©data© 这是 URLSessionDataDelegate 的 didBecome downloadTask 方法")
        
    }
    
    
    // MARK: ## didReceive data方法，告诉delegate已经接收到部分数据:
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data){
        print("©data© 这是 URLSessionDataDelegate 的 didReceive data 方法")
        guard let mimeType = respMimeType else {
            print("     没有赋值给响应头的mimeType字符串～～")
            return
        }
        if mimeType == "video/mp4" {
            print("     接收的是mp4文件的data～")
        }
        if mimeType == "application/json" {
            print("     接收的是json字符串～")
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                print("     转换后json对象：\(jsonObject)")
                if let dict = (jsonObject as? [String:Any] ) {
                    print("     转换后的字典对象：\(String(describing: dict["page_count"]))")
                }
            } catch let err {
                print("     转换json出错：\(err)")
            }
        }
        
        
    }
    
    
}

//MARK: - 遵循URLSessionDownloadDelegate协议，处理下载任务
extension JFZ_AVAssetLoaderUrlSession: URLSessionDownloadDelegate {
    
    // MARK: ## didFinishDownloadingTo方法，告诉代理者，网络数据已经下载完成了。
    /// 下载成功以后会在闭包中返回一个存在 temp 文件夹的文件URL，由于这个文件夹下的文件随时可能被清空，所以需要把文件移动到另一个文件夹下
    /// - Parameters:
    ///   - location: 临时存放下载完的文件的路径URL
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL){
        print("©down© 这是 URLSessionDownloadDelegate 的 didFinishDownloadingTo 方法")
        print("     当前线程：\(Thread.current)")
        
        let targetDirPathStr = NSTemporaryDirectory().appending("downloadVideo")
        let fileSuffixStr =  downloadTask.response!.suggestedFilename ?? "superGirl.mp4"
        let targetFilePathStr = targetDirPathStr + "/\(fileSuffixStr)"
        //目标路径的URL,本地文件的URL必须用fileURLWithPath方法，不然报错
        let persistentURL = URL(fileURLWithPath: targetFilePathStr)
        do {
            let isExistDir = FileManager.default.fileExists(atPath: targetDirPathStr)
            if !isExistDir {
                try FileManager.default.createDirectory(atPath: targetDirPathStr,
                                                        withIntermediateDirectories: true, attributes: .none)
            }
            let isExistFile = FileManager.default.fileExists(atPath: targetFilePathStr)
            if !isExistFile{
                print("     如果该视频没有下载，则保存视频")
                try FileManager.default.moveItem(at: location, to: persistentURL)
            }
            
        } catch let err {
            print("     移动失败:\(err)")
        }
        
    }
    
    // MARK: ## didWriteData bytesWritten 方法，
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64){
        print("©down© 这是 URLSessionDownloadDelegate 的 didWriteData bytesWritten 方法")
        
    }
    
    // MARK: ## didResumeAtOffset fileOffset方法，
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64){
        print("©down© 这是 URLSessionDownloadDelegate 的 didResumeAtOffset fileOffset 方法")
        
    }
    
}

//MARK: - 遵循URLSessionTaskDelegate协议,会话的任务管理
extension JFZ_AVAssetLoaderUrlSession : URLSessionTaskDelegate{
    
    // MARK: ##didCompleteWithError方法，告诉delegate, task已经完成:
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?){
        print("©task© 这是URLSessionTaskDelegate的 didCompleteWithError 方法")
        
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, willBeginDelayedRequest request: URLRequest, completionHandler: @escaping (URLSession.DelayedRequestDisposition, URLRequest?) -> Void){
        print("©task© 这是URLSessionTaskDelegate的willBeginDelayedRequest方法")
    }
    
    
    func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask){
        print("©task© 这是URLSessionTaskDelegate的 taskIsWaitingForConnectivity 方法")
        
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void){
        print("©task© 这是URLSessionTaskDelegate的 willPerformHTTPRedirection 方法")
        
    }
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void){
        print("©task© 这是URLSessionTaskDelegate的 didReceive challenge 方法")
        
    }
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, needNewBodyStream completionHandler: @escaping (InputStream?) -> Void){
        print("©task© 这是URLSessionTaskDelegate的 needNewBodyStream 方法")
        
    }
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64){
        print("©task© 这是URLSessionTaskDelegate的 didSendBodyData 方法")
        
    }
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics){
        print("©task© 这是URLSessionTaskDelegate的 didFinishCollecting 方法")
        
    }
   
}







