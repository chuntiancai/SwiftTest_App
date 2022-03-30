//
//  JFZ_AVAssetResLoaderDelegateObject.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/8/25.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 用于遵循下载视频源的代理协议 的代理对象，拦截AVAsset的下载请求,AVAssetResourceLoaderDelegate
// 采取将AVAssetResourceLoadingRequest作为参数传递给JFZ_AVAssetLoaderUrlSession的方式去下载

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
    
    
    //MARK: ##shouldWaitForLoadingOfRequestedResourcet方法，表示代理类是否可以处理该请求，这里需要返回True表示可以处理该请求， 然后在这里保存所有发出的请求，然后发出我们自己构造的NSUrlRequest：
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool{
        print("\n -- ©Loader© AVAssetResourceLoaderDelegate的 shouldWaitForLoadingOfRequestedResource 方法")
        curLoadingRequest = loadingRequest  //保存loader的参数
        
        guard let customUrl = loadingRequest.request.url else {
            //guard语法，报错
            fatalError("        获取自定义的url失败")
        }
        let realReqUrl = URL.init(string: customUrl.absoluteString.replacingOccurrences(of: "jfz_http", with: "http"))
        var realRequest = URLRequest.init(url: realReqUrl!)
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
        print("©Loader© AVAssetResourceLoaderDelegate的 shouldWaitForRenewalOfRequestedResource 方法")
        return false
    }
    
    
    /**
     @method         resourceLoader:didCancelLoadingRequest:
     @abstract        Informs the delegate that a prior loading request has been cancelled.
     @param         loadingRequest
     The loading request that has been cancelled.
     @discussion    Previously issued loading requests can be cancelled when data from the resource is no longer required or when a loading request is superseded by new requests for data from the same resource. For example, if to complete a seek operation it becomes necessary to load a range of bytes that's different from a range previously requested, the prior request may be cancelled while the delegate is still handling it.
     */
    //MARK: ##didCancel loadingRequest方法，表示AVAssetResourceLoader放弃了本次请求，需要把该请求从我们保存的原始请求列表里移除。
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, didCancel loadingRequest: AVAssetResourceLoadingRequest){
        print("©Loader© AVAssetResourceLoaderDelegate的 didCancel loadingReques 方法")
        
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
        print("©Loader© AVAssetResourceLoaderDelegate的 shouldWaitForResponseTo authenticationChallenge 方法")
        return false
    }
    
    
    /**
     @method         resourceLoader:didCancelAuthenticationChallenge:
     @abstract        Informs the delegate that a prior authentication challenge has been cancelled.
     @param         authenticationChallenge
     The authentication challenge that has been cancelled.
     */
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, didCancel authenticationChallenge: URLAuthenticationChallenge){
        print("©Loader© AVAssetResourceLoaderDelegate的 didCancel authenticationChallenge 方法")
        
    }
}

//MARK: - 笔记
/**
    1、手动实现AVAssetResourceLoaderDelegate协议需要URL是自定义的URLScheme,只需要把源URL的http://或者https://替换成xxxx://， 然后再实现AVAssetResourceLoaderDelegate协议函数才可以生效，否则不会生效。
    2、保存func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool；代理方法中的loadingRequest参数，可以用一个成员变量来强引用保存，然后再次调用这个loadingRequest的finishLoading方法 ，可以再次回调起这个代理方法，并且参数是你修改后的loadingRequest？
 
 */
