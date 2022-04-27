//
//  TestHTTPS_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/4/24.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试网络通信，http协议的VC
 

class TestHTTPS_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 测试组件
    private var currentElement:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试HTTP协议"
        
        setNavigationBarUI()
        setCollectionViewUI()
    }
    
    
    
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestHTTPS_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、测试NSURLConnection的GET请求，已丢弃，但原理是通用的
            print("     (@@  测试NSURLConnection的GET请求")
            /*
             请求:请求头(NSURLRequest默认包含)+请求体(GET没有)
             响应:响应头(真实类型--->NSHTTPURLResponse)+响应体(要解析的数据)
             
             GET:http://120.25.226.186:32812/login?username=123&pwd=456&type=JSON
             协议+主机地址+接口名称+?+参数1&参数2&参数3
             
             post:http://120.25.226.186:32812/login
             协议+主机地址+接口名称
             
             */
            //GET,没有请求体
            //1.确定请求路径
            let urlStr = NSString(string: "http://baike.baidu.com/api/openapi/BaikeLemmaCardApi?scope=103&format=json&appid=379020&bk_key=中国&bk_length=600")
            let reqUrl = URL.init(string:  urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            
            //2.创建请求对象
            ///一个URLRequest对象就代表一个请求，请求头不需要设置(有默认的请求头)，请求方法--->默认为GET
            let request = URLRequest.init(url: reqUrl!)
            
            
            ///响应头信息的真实类型:NSHTTPURLResponse
            var response:URLResponse?
            var resData:Data?
            
            //3.发送请求
            /*
             第一个参数:请求对象
             第二个参数:响应头信息
             */
            ///同步请求，该方法是阻塞的,即如果该方法没有执行完则后面的代码将得不到执行。该方法已经过时
            //                resData = try NSURLConnection.sendSynchronousRequest(request, returning: &response)
            
            /// 异步请求，
            NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.init()) { (resp, data, err) in
                print("异步，返回的响应头信息：\(String(describing: resp))")
                response = resp
                resData = data
                if let curData = data {
                    let resStr = String(data: curData, encoding: .utf8)?.removingPercentEncoding
                    print("异步，返回的数据：\(resStr ?? "没看见数据")")
                }
                print("异步，返回的错误是：\(String(describing: err))")
                
            }
            
            //4.解析 data--->字符串
            /// 用UTF-8来解析网络返回的data对象
            let resStr = String(data: resData!, encoding: .utf8)?.removingPercentEncoding
            print("返回的数据：\(resStr ?? "没看见数据")")
            print("返回的响应头信息：\(String(describing: response))")
            
            
        case 1:
            //TODO: 1、测试用代理的方式请求网络
            print("     (@@ 测试用代理的方式请求网络")
            //1.确定请求路径
            let urlStr = NSString(string: "http://baike.baidu.com/api/openapi/BaikeLemmaCardApi?scope=103&format=json&appid=379020&bk_key=中国&bk_length=600")
            let reqUrl = URL.init(string:  urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            
            //2.创建请求对象
            ///一个URLRequest对象就代表一个请求，请求头不需要设置(有默认的请求头)，请求方法--->默认为GET
            let request = URLRequest.init(url: reqUrl!)
            
            //3.设置代理
            ///代理方法:默认是在主线程中调用的。是代理方法。
            ///该方法内部其实会将connect对象作为一个source添加到当前的runloop中,指定运行模式为默认
            let connect = NSURLConnection.init(request: request, delegate: self)
            
            ///设置代理方法在哪个线程中调用
            connect?.setDelegateQueue(.main)
            
            ///开启请求网络
            /// 如果connect对象没有添加到runloop中,那么该方法内部会自动的添加到runloop
            /// 注意:如果当前的runloop没有开启,那么该方法内部会自动获得当前线程对应的runloop对象并且开启
            connect?.start()
//            connect?.cancel()
        case 2:
            //TODO: 2、测试发送POST请求
            print("     (@@ 测试发送POST请求")
            //1.确定请求路径
            let urlStr = NSString(string: "http://baike.baidu.com/api/openapi/BaikeLemmaCardApi")
            let reqUrl = URL.init(string:  urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            
            //2.创建请求对象
            ///一个URLRequest对象就代表一个请求，请求头不需要设置(有默认的请求头)，请求方法--->默认为GET
            var request = URLRequest.init(url: reqUrl!)
            
            /// 修改为POST请求
            request.httpMethod = "POST"
            
            /// 设置请求超时
            request.timeoutInterval = 10    //10秒没有返回，认为失败
            
            /// 手贱手动设置请求头
            request.setValue("ios 16.0", forHTTPHeaderField: "User-Agent")
            
            /// 设置请求体，把字符串转换为data对象
            request.httpBody = "scope=103&format=json&appid=379020&bk_key=中国&bk_length=600".data(using: .utf8)
            
            NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue()) { resp, data, err in
                print("POST，返回的响应头信息：\(String(describing: resp))")
                if let curData = data {
                    let resStr = String(data: curData, encoding: .utf8)?.removingPercentEncoding
                    
                    print("POST，返回的数据：\(resStr ?? "没看见数据")")
                }
                print("POST，返回的错误是：\(String(describing: err))")
            }
        
        
        case 3:
            //TODO: 3、解析JSON字符串，json字符串 --> data对象 --> OC对象 --> 字典/数组对象
            print("     (@@ 解析JSON格式的字符串")
            let fileUrl = URL(fileURLWithPath: "/Users/mac/Desktop/testJSON.txt")   //桌面文件
            let keyWord = NSString.init(string: "中国").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as String
            guard let url = URL.init(string: "http://baike.baidu.com/api/openapi/BaikeLemmaCardApi?scope=103&format=json&appid=379020&bk_key=\(keyWord)&bk_length=600")else { return  }
            
            /// 该方法必须手动调用urlSession.resume()来启动任务
            let urlSessionTask = URLSession.shared.dataTask(with: url) { data, response, error in
                
                /// 网络的响应体信息，一般就是响应的数据.
                /// 解析JDSON字符串
                guard let curData = data else { print("data数据为空"); return }
                do{
                    ///data对象  --> JSON格式的字符串 --> utf8编码 --> data对象 --> 写入到指定文件
                    let resStr = String(data: curData, encoding: .utf8)?.removingPercentEncoding
                    
                    if resStr != nil { try resStr!.data(using: .utf8)!.write(to: fileUrl, options: .atomic) }
                    
                    ///用OC对象(以json格式为协议)来解释 返回的data，jsonObject为Any对象，需要转换成字典来提取使用。
                    /**
                     mutableContainers: 解释jsonObject为可变的数组或者字典。
                     mutableLeaves:  解释jsonObject为字典或者数组时，对应的元素是可变字符串。
                     fragmentsAllowed: 得到的对象为any
                     */
                    let jsonObject = try JSONSerialization.jsonObject(with: curData, options: .fragmentsAllowed)
                    
                    /// json对象 --> 字典
                    guard let dict = (jsonObject as? [String:Any]) else { print("jsonObject强制转换错误～～"); return }
                    print("jsonObject转换为字典了dict: \n \(dict.description)")
                    print("\n  ============================分割线=================  \n")
                    
                    ///json对象 --> 数组
                    guard let dataArr = (dict["card"] as? Array<Any>) else { print("json里面没有card字段"); return }
                    
                    for curEntry in dataArr {
                        if let curItem = curEntry as? [String:Any]{ print("json中card字段的每一项==>>：\(String(describing: curItem))\n") }
                    }
                    
                }catch let err{ print("用JSON解析Data数据时，错误：\(err)"); }
                
                /// URLResponse是响应头信息，不是响应体信息，如果是http协议，那就是http协议的响应头
                print("\n\nURLSession.shared返回的response:  \(String(describing: response))")
                print("\n\nURLSession.shared返回的error:  \(String(describing: error))")
            }
            /// 启动网络会话的任务
            urlSessionTask.resume()
            
        case 4:
            //TODO: 4、字典、数组对象转换为JSON字符串
            print("     (@@ 字典、数组对象转换为JSON字符串")
            let dict:[String:Any] = ["名字":"张三","年龄":18,"婚否":false,"家产":["车子","房子","田地"],"工资":230688.88]
            do {
                /*
                 能转换为json字符串的oc对象：
                 - 最外层必须是 NSArray or NSDictionary
                 - 所有的元素必须是 NSString, NSNumber, NSArray, NSDictionary, or NSNull
                 - 字典中所有的key都必须是 NSStrings类型的
                 - NSNumbers不能死无穷大
                 */
                let jsonData = try  JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)   //美化输出.prettyPrinted
                let jsonStr = String(data: jsonData, encoding: .utf8)
                print("oc对象转换后的json字符串：\(jsonStr!)")
            } catch let err {
                print("oc对象转换json字符串的data对象，发生错误：\(err)")
            }
           
            
        case 5:
            //TODO: 5、原生框架XMLParser解析XML文档
            /**
                1、XMLParser是以SAX方式解析XML文档，所以就是逐行解析，所以要设置代理。
             */
            print("     (@@ 测试原生框架解析XML文档")
            /// 读取xml文件，plist文件其实就是xml文件。
            let filePathStr = Bundle.main.path(forResource: "xmlFile", ofType: "xml") ?? ""
            
            do {
                let fileData = try Data(contentsOf: URL(fileURLWithPath: filePathStr))
                let parser = XMLParser(data: fileData)  //创建xml解析器
                parser.delegate = self  //设置代理
                let flag = parser.parse()  //开始解析
                print("是否解析成功：\(flag)")
            } catch let err {
                print("文件转data错误：\(err)")
            }
            
        case 6:
            //TODO: 6、测试转换unicode字符串，后台输出unicode字符问题。
            /**
             1、未解决，首先要把字符串里的每一个unicode字符串转换为unicode格式，然后再拼接回去字符串里面。
             */
            print("     (@@ 测试转换unicode字符串")
            let fileUrl = URL(fileURLWithPath: "/Users/mac/Desktop/testJSON.txt")   //桌面文件
            let keyWord = NSString.init(string: "中国").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as String
            guard let url = URL.init(string: "http://baike.baidu.com/api/openapi/BaikeLemmaCardApi?scope=103&format=json&appid=379020&bk_key=\(keyWord)&bk_length=600")else { return  }
            
            /// 该方法必须手动调用urlSession.resume()来启动任务
            let urlSessionTask = URLSession.shared.dataTask(with: url) { data, response, error in
                
                /// 网络的响应体信息，一般就是响应的数据.
                /// 解析JDSON字符串
                guard let curData = data else { print("data数据为空"); return }
                do{
                    ///data对象  --> JSON格式的字符串 --> utf8编码 --> data对象 --> 写入到指定文件
                    let resStr = String(data: curData, encoding: .utf8)?.removingPercentEncoding
//                    let cStrUTF8:[CChar] = resStr!.cString(using: .utf8)!
//                    let cStr:String = String.init(cString: cStrUTF8)
//                    let curStr:String = String.init(cString: cStr.cString(using: .nonLossyASCII)!)
                    if resStr != nil { try resStr!.data(using: .utf8)!.write(to: fileUrl, options: .atomic) }
                   
                    /// json对象 --> 字典
                    let jsonObject = try JSONSerialization.jsonObject(with: curData, options: .fragmentsAllowed)
                    guard let dict = (jsonObject as? [String:Any]) else { print("jsonObject强制转换错误～～"); return }
                    print("jsonObject转换为字典了dict: \n \(dict.description)")
                    
                }catch let err{ print("用JSON解析Data数据时，错误：\(err)"); }
                
            }
            urlSessionTask.resume()
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
//MARK: - 设置UI
extension TestHTTPS_VC{
   
   
    
}


//MARK: - 遵循请求网络的代理协议，--NSURLConnectionDataDelegate
extension TestHTTPS_VC:NSURLConnectionDataDelegate{
    
    //1.当接收到服务器响应的时候被调用
    func connection(_ connection: NSURLConnection, didReceive response: URLResponse) {
        print("TestHTTPS_VC的 \(#function) 方法～")
    }
    
    //2.接收到服务器返回数据的时候调用,会被调用多次(数据量大时)
    func connection(_ connection: NSURLConnection, didReceive data: Data) {
        print("TestHTTPS_VC的 \(#function) Data 方法～")
        /// 可以在这里拼接数据
    }
    //3.当请求失败的时候调用
    func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
        print("TestHTTPS_VC的 \(#function) 方法～")
    }
    //4.请求结束的时候调用
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        print("TestHTTPS_VC的 \(#function) 方法～")
    }
    
}

//MARK: - 遵循XML解析的代理协议，XMLParserDelegate
extension TestHTTPS_VC:XMLParserDelegate{
    
    //1.开始解析XML文档的时候
    func parserDidStartDocument(_ parser: XMLParser) {
        print("XMLParserDelegate的\(#function)方法，开始解析~")
    }
    
    
    //2.开始解析某个元素
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        /// 只是解析元素的属性名和属性值，元素里的嵌套元素是独立解析的。
        print("""
                开始解析一个元素：elementName元素名:\(elementName)，
                               namespaceURI：\(String(describing: namespaceURI)),
                               qualifiedName: \(String(describing: qName)),
                               attributes:\(attributeDict)
                """)
        /// 过滤掉home元素
        if elementName == "home" {
            return
        }
        currentElement = elementName
    }
    
    ///3.解析遇到字符串时，也就是元素的内容。
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        /**
            1、因为没有记录当前元素的名字，所以你需要在didStartElement中记录在标志器中
         */
        let contentStr = string.trimmingCharacters(in: .whitespacesAndNewlines) //去掉空格和换行
        print("当前元素：\(currentElement) --- 元素的内容字符串：\(contentStr)")
    }
    
    //4.某个元素解析完毕
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print("结束某个元素: elementName元素名:\(elementName)，namespaceURI：\(String(describing: namespaceURI)),qualifiedName: \(String(describing: qName))")
    }
    
    //5.结束解析
    func parserDidEndDocument(_ parser: XMLParser) {
        print("XMLParserDelegate的\(#function)方法，结束解析~")
    }
    
}


//MARK: - 设计UI
extension TestHTTPS_VC {
    
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
extension TestHTTPS_VC: UICollectionViewDelegate {
    
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
    1、URL的基本格式 = 协议://主机地址/路径
                例如：http://www.520it.com/img/logo.png
       URL中常见的协议：HTTP://--远程的网络资源、
                     file://--本地计算机上的资源、
                     mailto:--电子邮件地址、
                     FTP://--共享主机的文件资源
 
    2、HTTP协议中的GET和POST请求：
        GET：在请求URL后面以?的形式跟上发给服务器的参数，多个参数之间用&隔开。URL后面附带的参数是有限制的，通常不能超过1KB。
        POST：参数全部放在请求体中。理论上，POST传递的数据量没有限制（具体还得看服务器的处理能力）。
     它们的响应体都是一样的，都是服务器返回来的数据。只是请求体有区别而已。
 
    3、HTTP协议的规定：
            HTTP协议中请求的规定：
 
                一、请求头：包含了对客户端的环境描述、客户端请求信息等
                GET /minion.png HTTP/1.1   // 包含了请求方法、请求资源路径、HTTP协议版本
                Host: 120.25.226.186:32812     // 客户端想访问的服务器主机地址
                User-Agent: Mozilla/5.0  // 客户端的类型，客户端的软件环境
                Accept: text/html, * / *     // 客户端所能接收的数据类型
                Accept-Language: zh-cn     // 客户端的语言环境
                Accept-Encoding: gzip     // 客户端支持的数据压缩格式
    
                二、请求体：客户端发给服务器的具体数据，比如文件数据(POST请求才会有)
    
            HTTP协议中响应的规定：
                 
                 一、响应头：包含了对服务器的描述、对返回数据的描述
                 HTTP/1.1 200 OK            // 包含了HTTP协议版本、状态码、状态英文名称
                 Server: Apache-Coyote/1.1         // 服务器的类型
                 Content-Type: image/jpeg         // 返回数据的类型
                 Content-Length: 56811         // 返回数据的长度
                 Date: Mon, 23 Jun 2014 12:54:52 GMT    // 响应的时间

                 二、响应体：服务器返回给客户端的具体数据，比如文件数据。

            
    4、NSURLRequest：一个NSURLRequest对象就代表一个请求，它包含的信息有
                    一个NSURL对象
                    请求方法、请求头、请求体
                    请求超时
                    … …
                    
                    NSMutableURLRequest：NSURLRequest的子类
                    
      NSURLConnection：相当于一个端口，建立起客户端与服务器之间的联系。代理方法默认在主线程执行，但是你可以设置属性，让它在子线程执行。
    
                    负责发送请求，建立客户端和服务器的连接
                    发送数据给服务器，并收集来自服务器的响应数据

    5、OC对象 --> JSON字符串 ：序列化
       JSON字符串 --> OC对象 ： 反序列化
       JOSN   OC
       {}     @{}
       []     @[]
       ""     @""
       false  NSNumber 0
       true   NSNumber 1
       null      NSNull为空
 
    6、XML文档，其实也是一个语法或者说协议。
        在XML文档前面必须写一段声明代码，用来声明XML文档的类型。
       XML的的元素：开始标签---结束标签。元素名。
                  元素之间可以嵌套元素。xml的元素内容对空行和换行敏感。
                  元素标签里的属性名--属性值，也可以用嵌套元素来替换。
      
       XML文档的解析：
                  DOM解析，一次性加载整个xml文档，然后再解析，适合小文档。
                  SAX解析，从根元素开始，一个个元素地解析，适合大文档。
 
      苹果原生的XML解析框架：NSXMLParser,是以SAX方式进行解析。
 
      Plist就是一个XML文档。
 
    6、xcode控制台输出unicode乱码的问题，重写被输出对象的description属性，

 */

