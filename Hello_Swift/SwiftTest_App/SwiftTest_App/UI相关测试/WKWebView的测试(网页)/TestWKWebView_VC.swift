//
//  TestWKWebView_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/4/28.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试WKWebView的VC
// MARK: - 笔记
/**
    1、首先要import WebKit。
    2、必须在WKNavigationDelegate 的 webView(_:decidePolicyFor:decisionHandler:) 方法中，执行decisionHandler闭包，允许网页跳转。
    3、WKWebView也可以用来加载pdf，ppt，图片,视频,html等等这些本地文件，也是传入文件url就可以了。
 
    历史：
    1.Safari openURL :自带很多功能(进度条,刷新,前进,倒退等等功能),必须要跳出当前应用
    2.UIWebView (没有功能) ,在当前应用打开网页,并且有safari,自己实现,UIWebView不能实现进度条
    3.SFSafariViewController:专门用来展示网页 需求:即想要在当前应用展示网页,又想要safari功能 iOS9才能使用
        3.1 导入#import <SafariServices/SafariServices.h>

    4.WKWebView:iOS8 (UIWebView升级版本,添加功能 1.监听进度 2.缓存)
        4.1 导入#import <WebKit/WebKit.h>
 
 */

import WebKit
class TestWKWebView_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 测试组件
    private var wkView = WKWebView()    //网页
    var progBar = UIProgressView()  //进度条
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试WKWebView的VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }
    
    
    
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestWKWebView_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、加载网页请求
            print("     (@@ 加载网页请求 ")
//            let url = URL(string: "http://www.baidu.com")
            let url = URL(string: "https://jfz-simu-ziguan-hentong.oss-cn-hangzhou.aliyuncs.com/2023-04-17/15/fat/5062444339_15_20230417104427522_previrew.pdf?debug=1")
            let request = URLRequest(url: url!)
            wkView.load(request)
        case 1:
            //TODO: 1、添加进度条
            print("     (@@ 添加进度条")
            // 加载网页的进度条
            progBar = UIProgressView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
            progBar.progress = 0.0
            progBar.tintColor = UIColor.red
            wkView.addSubview(progBar)
            // 监听网页加载的进度
            wkView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        case 2:
            //TODO: 2、网页后退
            print("     (@@ 网页后退")
            wkView.goBack()
        case 3:
            //TODO: 3、网页前进
            print("     (@@ 网页前进")
            wkView.goForward()
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
//MARK: - 遵循WKUIDelegate协议，网页配置
extension TestWKWebView_VC:WKUIDelegate{
    
    //TODO: WKWebView创建初始化加载的一些配置
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        print(" WKUIDelegate 初始化加载 \(#function) 方法")
        // 实现非安全链接的跳转。如果目标主视图不为空,则允许导航
        if !(navigationAction.targetFrame?.isMainFrame != nil) {
            wkView.load(navigationAction.request)
        }
        return nil
    }
    
    //TODO: 处理网页js中的提示框,若不使用该方法,则提示框无效
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        print(" WKUIDelegate js中的提示框 \(#function) 方法")
        // 修复弹窗弹出的问题
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) -> Void in
            completionHandler()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //TODO: iOS9.0中新加入的,处理WKWebView关闭的时间
    func webViewDidClose(_ webView: WKWebView) {
        print(" WKUIDelegate 关闭的时间 \(#function) 方法")
    }
    
    //TODO: 处理网页js中的确认框,若不使用该方法,则确认框无效
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        print(" WKUIDelegate js中的确认框 \(#function) 方法")
    }
    //TODO: 处理网页js中的文本输入
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        print(" WKUIDelegate js中的文本输入 \(#function) 方法")
    }
    
}

//MARK: - 遵循WKNavigationDelegate协议，网页导航
extension TestWKWebView_VC:WKNavigationDelegate{
   
    //TODO: 决定网页能否被允许跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print(" WKNavigationDelegate 允许跳转 \(#function) 方法")
        /// 允许跳转
        decisionHandler(.allow)
    }
     
    //TODO: 处理网页开始加载
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print(" WKNavigationDelegate 网页开始加载 \(#function) 方法")
    }
    
    //TODO: 处理网页证书校验
    ///访问是否下载证书，http请求不会回调该方法。
    ///challenge:质询的意思,信息都在保护空间里challenge.protectionSpace
    ///URLSession.AuthChallengeDisposition: 如何处理证书
    ///URLCredential: 授权信息
//    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void){
//        print(" WKNavigationDelegate 处理网页证书校验 \(#function) 方法")
//        /**
//         print("认证空间：\(challenge.protectionSpace)")
//         print("认证方式：\(challenge.protectionSpace.authenticationMethod)")
//
//         public enum AuthChallengeDisposition : Int {
//             case useCredential = 0     //使用该证书 安装该证书
//             case performDefaultHandling = 1    //默认采用的方式,该证书被忽略
//             case cancelAuthenticationChallenge = 2 //取消请求,证书忽略
//             case rejectProtectionSpace = 3 //拒绝
//         }
//         */
//
//
//        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
//            //通过服务器的证书来验证(信任)，也就是所谓的通过证书加密数据来进行传输。
//            let card = URLCredential.init(trust: challenge.protectionSpace.serverTrust!)
//            completionHandler(URLSession.AuthChallengeDisposition.useCredential,card)
//        }
//
//    }
     
    //TODO: 处理网页加载失败
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(" WKNavigationDelegate 网页加载失败 \(#function) 方法")
    }
    
    
    //TODO: 处理网页内容开始返回
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print(" WKNavigationDelegate 网页内容开始返回 \(#function) 方法")
    }

    //TODO: 处理网页加载完成
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(" WKNavigationDelegate 网页加载完成 \(#function) 方法")
    }
    //TODO: 处理网页返回内容时发生的失败
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(" WKNavigationDelegate 网页返回内容时发生的失败 \(#function) 方法")
    }
    //TODO: 处理网页进程终止
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print(" WKNavigationDelegate 网页进程终止 \(#function) 方法")
    }
}

//MARK: - KVO 监听WKWebView的属性的值的变化
extension TestWKWebView_VC{
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("TestWKWebView_VC 的 KVO 监听方法：\(#function)")
        
        if keyPath == "estimatedProgress" {
            self.progBar.alpha = 1.0
            progBar.setProgress(Float(wkView.estimatedProgress), animated: true)
            //进度条的值最大为1.0
            if(self.wkView.estimatedProgress >= 1.0) {
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: { () -> Void in
                    self.progBar.alpha = 0.0
                }, completion: { (finished:Bool) -> Void in
                    self.progBar.progress = 0
                })
            }
        }
    }
    
    override class func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("TestWKWebView_VC 的 KVO 类监听方法：\(#function)")
    }
    
}


//MARK: - 设置测试的UI
extension TestWKWebView_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
        //TODO:设置WKWebView的属性
        wkView.layer.borderWidth = 1.0
        wkView.layer.borderColor = UIColor.brown.cgColor
        self.view.addSubview(wkView)
        wkView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom).offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.95)
        }
        
        // 设置代理
        wkView.navigationDelegate = self
        
    }
    
}


//MARK: - 设计UI
extension TestWKWebView_VC {
    
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
extension TestWKWebView_VC: UICollectionViewDelegate {
    
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

