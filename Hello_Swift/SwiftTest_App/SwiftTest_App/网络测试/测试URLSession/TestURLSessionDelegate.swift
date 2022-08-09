//
//  TestURLSessionDelegate.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/8/23.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试URLSession的代理方法
//MARK: - 笔记
/**
    1、如果是downloadTask，直接不经过didReceive response代理方法，而是直接走URLSessionDownloadDelegate 的 didWriteData bytesWritten 方法。
 
 */

class TestURLSessionDelegate:NSObject,URLSessionDelegate {
    
    //MARK: 内部属性
    private var respMimeType:String?//响应类型
    
    override init() {
        super.init()
        print("测试的URLSession的代理者")
    }
    
    //MARK: - URLSessionDelegate的代理方法
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?){
        print(" ©URLSessionDelegate© 的 \(#function) 方法")
    }

    //MARK: ##didReceive challenge方法，系统告诉代理，我需要SSL证书之类的认证，你在completionHandler闭包中回传给我：
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void){
        print("©URLSessionDelegate© 的 \(#function) 方法")
        completionHandler(.useCredential,.none)
    }
  
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession){
        print("©TestURLSessionDelegate© 的 \(#function) 方法")
    }
    
}

//MARK: 遵循URLSessionTaskDelegate协议,会话的任务管理
extension TestURLSessionDelegate : URLSessionTaskDelegate{
    
    func urlSession(_ session: URLSession, task: URLSessionTask, willBeginDelayedRequest request: URLRequest, completionHandler: @escaping (URLSession.DelayedRequestDisposition, URLRequest?) -> Void){
        print("©task© 这是URLSessionTaskDelegate的 \(#function) 方法")
    }
    
    
    func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask){
        print("©task© 这是URLSessionTaskDelegate的 \(#function)  方法")
        
    }
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void){
        print("©task© 这是URLSessionTaskDelegate的 \(#function)  方法")
        
    }
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void){
        print("©task© 这是URLSessionTaskDelegate的 \(#function)  方法")
        
    }
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, needNewBodyStream completionHandler: @escaping (InputStream?) -> Void){
        print("©task© 这是URLSessionTaskDelegate的 \(#function)  方法")
        
    }
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64){
        print("©task© 这是URLSessionTaskDelegate的 \(#function)  方法")
        
    }
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics){
        print("©task© 这是URLSessionTaskDelegate的 \(#function)  方法")
        
    }
    // MARK: ##didCompleteWithError方法，告诉delegate, task已经完成:
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?){
        print("©task© 这是URLSessionTaskDelegate的 \(#function)  方法")
        
    }
}

//MARK: - 遵循URLSessionDataDelegate协议，处理传输的数据
extension TestURLSessionDelegate: URLSessionDataDelegate {
    
    // MARK: ## didReceive response方法，告诉delegate已经接受到服务器的初始应答(响应头), 准备接下来的数据任务的操作，:
    // MARK: ## completionHandler参数 必须赋值，用于告诉系统下一步该做什么。默认是取消任务。
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void){
        /**
         completionHandler: 方法，接收到服务器的响应被自动调用，一次请求只响应一次， 它默认会取消该请求，所以你要在completionHandler的闭包中，让系统不要取消。
         */
        print("©data© 这是 URLSessionDataDelegate 的 \(#function) 方法")
        respMimeType = response.mimeType
        if response.mimeType == "video/mp4" {
            print("     转换成下载任务")
//            completionHandler(.becomeDownload) //转换为下载任务
            completionHandler(.allow) //允许访问
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
        print("©data© 这是 URLSessionDataDelegate 的 \(#function)  方法")
        
    }
    
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome streamTask: URLSessionStreamTask){
        print("©data© 这是 URLSessionDataDelegate 的 \(#function) 方法")
        
    }
    
    // MARK: ## didReceive data方法，告诉delegate已经接收到部分数据:
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data){
        print("©data© 这是 URLSessionDataDelegate 的 \(#function) 方法")
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
    
    // MARK: ## willCacheResponse data方法，当session任务完成后，会回调该方法，告诉代理者要不要缓存数据。然后才去回调didFinishCollecting方法
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void){
        ///1、uploads、 data tasks的session才会调用该方法，background 、ephemeral的session不会回调该方法。还与 前面的response的Headers有允许缓存的"Cache-Control"字段才会回调该方法。
        ///2、completionHandler参数我也不知道是怎么用，是不是要返回给系统的？是的，和didReceive response方法一样。把CachedURLResponse存进config的urlcache属性中。
        ///3、目前，苹果只缓存HTTP和HTTPS响应。对于FTP和文件url，缓存策略的唯一作用是确定是否允许请求访问原始源。
        ///4、一般你给出的completionHandler的参数都是基于proposedResponse修改而来。
        ///5、cache的策略优先从url request中取，如果没有，则从configuration中取。
        ///6、URLCache内含CachedURLResponse对象。
        ///7、如果request请求是下载文件，则不会调用该代理方法。由URLSessionConfiguration决定。
        /// The default session configuration uses a persistent disk-based cache (except when the result is downloaded to a file) and stores credentials in the user’s keychain.
        print("©data© 这是 URLSessionDataDelegate 的 \(#function) 方法")
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
    
}


//MARK: - 遵循URLSessionDownloadDelegate协议，处理下载任务
extension TestURLSessionDelegate: URLSessionDownloadDelegate {
    
    // MARK: ## didFinishDownloadingTo方法，告诉代理者，网络数据已经下载完成了。
    /// 下载成功以后会在闭包中返回一个存在 temp 文件夹的文件URL，由于这个文件夹下的文件随时可能被清空，所以需要把文件移动到另一个文件夹下
    /// - Parameters:
    ///   - location: 临时 存放下载完的文件的 路径URL
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL){
        print("©down© 这是 URLSessionDownloadDelegate 的 \(#function)  方法")
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
    
    // MARK: ## didWriteData bytesWritten 方法，下载(写)数据
    /**
     *  @param session                   会话对象
     *  @param downloadTask              下载任务
     *  @param bytesWritten              本次写入的数据大小
     *  @param totalBytesWritten         下载的数据总大小
     *  @param totalBytesExpectedToWrite  文件的总大小
     */
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64){
        print("©down© 这是 URLSessionDownloadDelegate 的 \(#function) 方法")
        
    }
    
    // MARK: ## didResumeAtOffset fileOffset方法，当恢复下载的时候调用该方法
    ///   - fileOffset: 从什么地方下载
    ///   - expectedTotalBytes: 文件的总大小
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64){
        print("©down© 这是 URLSessionDownloadDelegate 的 \(#function)  方法")
        
    }
    
}

//MARK: - 遵循URLSessionStreamDelegate协议，处理流下载
extension TestURLSessionDelegate: URLSessionStreamDelegate {
    func urlSession(_ session: URLSession, readClosedFor streamTask: URLSessionStreamTask){
        print("©stream© 这是 URLSessionStreamDelegate 的 \(#function) 方法")
        
    }
    
    
    func urlSession(_ session: URLSession, writeClosedFor streamTask: URLSessionStreamTask){
        print("©stream© 这是 URLSessionStreamDelegate 的 \(#function)  方法")
        
    }
    
    
    func urlSession(_ session: URLSession, betterRouteDiscoveredFor streamTask: URLSessionStreamTask){
        print("©stream© 这是 URLSessionStreamDelegate 的 \(#function) 方法")
        
    }
    
    
    func urlSession(_ session: URLSession, streamTask: URLSessionStreamTask, didBecome inputStream: InputStream, outputStream: OutputStream){
        print("©stream© 这是 URLSessionStreamDelegate 的 \(#function) 方法")
        
    }
}




