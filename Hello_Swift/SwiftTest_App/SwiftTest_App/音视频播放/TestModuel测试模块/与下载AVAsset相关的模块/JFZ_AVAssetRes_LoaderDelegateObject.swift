//
//  JFZ_AVAssetResLoaderDelegateObject.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/8/25.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// AVAsset下载请求的AVAssetResourceLoaderDelegate
//MARK: - 笔记
/**
    1、用于遵循下载视频源的代理协议 的代理对象，拦截AVAsset下载的网络请求,AVAssetResourceLoaderDelegate
       采取将AVAssetResourceLoadingRequest作为参数传递给JFZ_AVAssetLoaderUrlSession的方式去下载。
    
    2、想要回调AVAssetResourceLoaderDelegate协议的方法,则需要用自定义的URLScheme,当delegate识别不了url，就会去回调代理方法，让程序员去处理。
       例如：把源URL的http://或者https://替换成xxxx://， 否则不会回调。
    
    3、保存代理方法 resourceLoader(_ resourceLoader: , loadingRequest: ) -> Bool 中的loadingRequest参数。
       可以用一个成员变量来强引用保存，然后再次调用这个loadingRequest的finishLoading方法，来停止下载数据。
       调用这个loadingRequest的finishLoading方法会再次再次回调起当前这个代理方法，并且参数是你修改后的loadingRequest。
 
    4、手动调用代理回传的loadingRequest的finishLoading方法，会再次调用相应的代理完成方法。
  

 */
import AVFoundation

class JFZ_AVAssetResLoaderDelegateObject: NSObject {
    
    //MARK: 对外属性
    /// 该代理对象的代理方法在那里执行。
    let loaderDelegateQueue = DispatchQueue.init(label: "JFZ_AVAssetResLoaderDelegateObject Queue～",attributes: .concurrent)
    ///保存loader的参数
    var curLoadingRequest:AVAssetResourceLoadingRequest?    //拦截的请求AVAsset的request请求
    

    //MARK: 内部属性
    /// 下载视频资源的url session
    var downloadSession:URLSession?
    let downloadSessionOpQueue = OperationQueue.init()
    
    
    override init() {
        super.init()
        print("JFZ_AVAssetResLoaderDelegateObject初始化啦～")
    }
}

//MARK: - 遵循AVAssetResourceLoaderDelegate协议，拦截AVAsset的下载请求
extension JFZ_AVAssetResLoaderDelegateObject:AVAssetResourceLoaderDelegate{
    
    
    //MARK: 代理对象是否可以处理该请求，一般是在这里处理自定义url。
    /**
        1、我们可以在这里处理我们自定义的网络请求前缀(url scheme)，替换成真正的网络请求，例如把 xxx:// 替换成 http://。
        2、处理自定义：保存参数loadingRequest，构造真正的NSUrlRequest：,并且发出真正的url请求去请求数据。
        4、调用当前参数loadingRequest的finishLoading()方法，会再次回调当前代理方法。
     */
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool{
        print("\n -- ©Loader© AVAssetResourceLoaderDelegate的 shouldWaitForLoadingOfRequestedResource 方法")
        curLoadingRequest = loadingRequest  //保存loader的参数
        
        guard let customUrl = loadingRequest.request.url else {
            //guard语法，报错
            fatalError("        获取自定义的url失败")
        }
        let realReqUrl = URL.init(string: customUrl.absoluteString.replacingOccurrences(of: "jfz_http", with: "http"))
        let realRequest = URLRequest.init(url: realReqUrl!)
        //        realRequest.setValue("bytes=0-1", forHTTPHeaderField: "Range")
        let task = URLSession.shared.dataTask(with: realRequest){ url, response, error in
            if let _ = response {
                print("首次请求返回的response方法，然后调用finish方法")
                loadingRequest.contentInformationRequest?.contentLength = 600
                //                loadingRequest.dataRequest?.currentOffset = 2
                loadingRequest.finishLoading()
            }
        }
        task.resume()
        /**
         /// 使用自己的url session来下载视频
         if downloadSession == nil {
         
         
         /// 初始化url session
         
         let config = URLSessionConfiguration.default
         config.allowsCellularAccess = true
         config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
         config.networkServiceType = .video
         
         var urlReq = URLRequest.init(url: realReqUrl!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 20)
         urlReq.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
         urlReq.httpMethod = "GET"
         
         
         downloadSession = URLSession.init(configuration: config, delegate: downloadSessionDelegate, delegateQueue: downloadSessionOpQueue)
         let dataTask = downloadSession?.downloadTask(with: urlReq)
         dataTask?.resume()
         print("test end")
         }
         */
        
        return true
        
    }
    
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForRenewalOfRequestedResource renewalRequest: AVAssetResourceRenewalRequest) -> Bool{
        print("©Loader© AVAssetResourceLoaderDelegate的 \(#function) 方法")
        return false
    }
    
    
    /**
     @method         resourceLoader:didCancelLoadingRequest:
     @abstract        Informs the delegate that a prior loading request has been cancelled.
     @param         loadingRequest
     The loading request that has been cancelled.
     @discussion    Previously issued loading requests can be cancelled when data from the resource is no longer required or when a loading request is superseded by new requests for data from the same resource. For example, if to complete a seek operation it becomes necessary to load a range of bytes that's different from a range previously requested, the prior request may be cancelled while the delegate is still handling it.
     */
    //MARK: AVAssetResourceLoader取消了本次请求，需要把该请求从我们保存的原始请求列表里移除。
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, didCancel loadingRequest: AVAssetResourceLoadingRequest){
        print("©Loader© AVAssetResourceLoaderDelegate的 \(#function) 方法")
        
    }
    
    
    /**
     @method         resourceLoader:shouldWaitForResponseToAuthenticationChallenge:
     @abstract        Invoked when assistance is required of the application to respond to an authentication challenge.
     @param         resourceLoader
     The instance of AVAssetResourceLoader asking for help with an authentication challenge.
     @param         authenticationChallenge
     An instance of NSURLAuthenticationChallenge.
     @discussion
     Delegates receive this message when assistance is required of the application to respond to an authentication challenge.
     If the result is YES, the resource loader expects you to send an appropriate response, either subsequently or immediately, to the NSURLAuthenticationChallenge's sender, i.e. [authenticationChallenge sender], via use of one of the messages defined in the NSURLAuthenticationChallengeSender protocol (see NSAuthenticationChallenge.h). If you intend to respond to the authentication challenge after your handling of -resourceLoader:shouldWaitForResponseToAuthenticationChallenge: returns, you must retain the instance of NSURLAuthenticationChallenge until after your response has been made.
     */
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForResponseTo authenticationChallenge: URLAuthenticationChallenge) -> Bool{
        print("©Loader© AVAssetResourceLoaderDelegate的 \(#function) 方法")
        return false
    }
    
    
    /**
     @method         resourceLoader:didCancelAuthenticationChallenge:
     @abstract        Informs the delegate that a prior authentication challenge has been cancelled.
     @param         authenticationChallenge
     The authentication challenge that has been cancelled.
     */
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, didCancel authenticationChallenge: URLAuthenticationChallenge){
        print("©Loader© AVAssetResourceLoaderDelegate的 \(#function) 方法")
        
    }
}

