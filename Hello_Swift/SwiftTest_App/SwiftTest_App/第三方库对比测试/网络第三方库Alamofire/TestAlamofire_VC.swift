//
//  TestAlamofire_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/4/28.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试Alamofire的VC

import Alamofire

class TestAlamofire_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 测试组件
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试Alamofire的VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }
    
    
    
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestAlamofire_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、发送网络请求
            print("     (@@  发送网络请求")
            //GET请求
            let keyWord = NSString.init(string: "中国国宝").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as String
            let urlStr = "http://baike.baidu.com/api/openapi/BaikeLemmaCardApi?scope=103&format=json&appid=379020&bk_key=\(keyWord)&bk_length=600"
            //let url = URL(string:urlStr)!
            /// 传入url和urlStr均可，默认是GET请求
            
            AF.request(urlStr).responseJSON(queue: DispatchQueue.global(), options: .allowFragments) { resp in
                print("默认GET请求,当前线程：\(Thread.current)")
                switch resp.result {
                /// 返回的是一个已经解析完json字符串的json字典
                case .success(let json):
                    print("默认GET请求,返回的json类型：\(type(of: json))")
                    let jsonDict:[String:Any]? = json as? [String:Any]
                    print("jsonDice的card字段：\(String(describing: jsonDict!["card"]))")
                case .failure(let err):
                    print("默认GET请求,返回错误：\(err)")
                }
            }
            
            //POST请求
            /**
             mutableContainers: 解释jsonObject为可变的数组或者字典。
             mutableLeaves:  解释jsonObject为字典或者数组时，对应的元素是可变字符串。
             fragmentsAllowed: 得到的对象为any
             */
            let urlStr2 = "http://baike.baidu.com/api/openapi/BaikeLemmaCardApi"
            AF.request(urlStr2, method: .post, parameters: ["scope":103,"format":"json","bk_key":keyWord,"bk_length":600],
                              encoding: JSONEncoding.default,
                              headers: nil).responseJSON(queue: DispatchQueue.global(),options: .allowFragments) { resp in
                                print("POST请求请求,当前线程：\(Thread.current)")
                                switch resp.result {
                                /// 返回的是一个已经解析完json字符串的json字典
                                case .success(let json):
                                    print("POST请求请求,返回的json类型：\(type(of: json))")
                                    let jsonDict:[String:Any]? = json as? [String:Any]
                                    print("jsonDice的card字段：\(String(describing: jsonDict!["card"]))")
                                case .failure(let err):
                                    print("POST请求请求,返回错误：\(err)")
                                }
                              }
            
        case 1:
            //TODO: 1、文件下载
            print("     (@@ 文件下载")
            let videoUrl = "http://onapp.yahibo.top/public/videos/video.mp4"
            AF.download(videoUrl, to:  { _,_ in
                let timeStamp = Date().timeIntervalSinceNow
                let targetFileUrl = URL(fileURLWithPath: "/Users/mac/Desktop/AlamofireVideo\(timeStamp).mp4")
                return (targetFileUrl,[.removePreviousFile,.createIntermediateDirectories])
            }).downloadProgress { progress in
                print("下载进度：\(progress)")
            }
        case 2:
            //TODO: 2、上传文件
            print("     (@@ 上传文件")
//            let videoUrlStr = "http://onapp.yahibo.top/public/videos/video.mp4"
//            let imgData1 = UIImage(named: "labi01")!.pngData()!
//            let imgData2 = UIImage(named: "labi02")!.pngData()!
//            
//            /// 上传表单
//            AF.upload(multipartFormData: { (formData) in
//                print("拼凑POST的表头信息")
//                /// 拼接请求头的信息
//                formData.append("小新".data(using: .utf8)!, withName: "name")
//                formData.append("123456".data(using: .utf8)!, withName: "password")
//                formData.append(imgData1, withName: "labi01", fileName: "labi01file", mimeType: "image/png")
//                formData.append(imgData2, withName: "labi02", fileName: "labi02file", mimeType: "image/png")
//            }, to: videoUrlStr) { (result) in
//                switch result {
//                case .success(let upReq, let isStreamingFromDisk, let streamFileURL):
//                    print("---upReq:\(upReq),\n ---isStreamingFromDisk:\(isStreamingFromDisk),\n---streamFileURL:\(String(describing: streamFileURL)),")
//                    upReq.uploadProgress { progress in
//                        print("上传进度：\(progress)")
//                    }
//                case .failure(let err):
//                    print("上传错误：\(err)")
//                    break
//                }
//            }
        case 3:
            //TODO: 3、监听网络状态的改变
            print("     (@@ 监听网络状态的改变")
            
            let manager = NetworkReachabilityManager()
           
            let _ = manager!.startListening( onUpdatePerforming: { status in
                switch status {
                case .notReachable:
                    print("暂时没有网络连接")
                case .unknown:
                    print("网络状态未知")
                case .reachable(.ethernetOrWiFi):
                    print("以太网或者wifi")
                case .reachable(.cellular):
                    print("蜂窝数据")
                }
            })
            
            
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
//MARK: - 测试的方法
extension TestAlamofire_VC{
   
    //MARK: 0、
    func test0(){
        
    }
    
}


//MARK: - 设置测试的UI
extension TestAlamofire_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
    }
    
}


//MARK: - 设计UI
extension TestAlamofire_VC {
    
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
extension TestAlamofire_VC: UICollectionViewDelegate {
    
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

// MARK: - 笔记
/**
    1、Alamofire是链式编程，可以一直点点点下去。
 
 */
