//
//  TestNetWorkDownload_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/4/26.
//  Copyright © 2022 com.mathew. All rights reserved.
//
//测试网络下载上传的VC
//MARK: - 笔记
/**
 
    1、
 */

class TestNetWorkDownload_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    private var imgView = UIImageView()
    
    //MARK: 测试组件
    private var connect:NSURLConnection!
    private let fileUrl = URL(fileURLWithPath: "/Users/mac/Desktop/myVideo.mp4")        //写文件到电脑桌面
    private var fileCurSize:Int = 0 //文件当前的大小
    private var fileTotalSize:Int = 0   //文件总大小
    private var fileHandler:FileHandle? //文件句柄，必须要及时关闭，不然会出问题
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试网络下载上传的VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }
    
    
    
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestNetWorkDownload_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、直接用data和url下载
            print("     (@@  直接用data和url下载")
            let myUrl  = URL.init(string: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fi.qqkou.com%2Fi%2F0a404548537x2815430900b26.jpg&refer=http%3A%2F%2Fi.qqkou.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1653555587&t=dcc5b600a9121d59752918e4a8c08d22")
            do {
                let imgData = try Data(contentsOf: myUrl!)
                imgView.image = UIImage(data: imgData)
            } catch let err {
                print("下载imgData数据失败:\(err)")
            }
            
        case 1:
            //TODO: 1、用NSURLConnection下载，已经丢弃
            print("     (@@ 用NSURLConnection下载，已经丢弃")
            let myUrl  = URL.init(string: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fi.qqkou.com%2Fi%2F0a404548537x2815430900b26.jpg&refer=http%3A%2F%2Fi.qqkou.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1653555587&t=dcc5b600a9121d59752918e4a8c08d22")
            let myReq = URLRequest.init(url: myUrl!)
            let connect = NSURLConnection.sendAsynchronousRequest(myReq, queue: .main) { [weak self](resp, data, err) in
                if data != nil {
                    self?.imgView.image = UIImage(data: data!)
                }
                
            }
        case 2:
            //TODO: 2、用NSURLConnection下载大文件，已经丢弃
            /**
                    fileUrl: "http://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4",
                    fileUrl: "http://vfx.mtime.cn/Video/2019/03/19/mp4/190319222227698228.mp4",
                    fileUrl: "http://vjs.zencdn.net/v/oceans.mp4",
                    fileUrl: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4",
                    fileUrl: "http://music.163.com/song/media/outer/url?id=447925558.mp3",
             
             1、NSURLConnection的cancel方法是不可恢复的，是直接取消整个下载，下次start是从新开始下载的。
             2、通过设置请求头来实现断点下载。
             */
            print("     (@@ 用NSURLConnection下载大文件，已经丢弃")
            let myUrl  = URL.init(string: "http://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4")
            let myReq = URLRequest.init(url: myUrl!)
            connect = NSURLConnection.init(request: myReq, delegate: self)
            connect.start()
//            connect?.cancel()
            
        case 3:
            //TODO: 3、用NSURLConnection断点下载大文件，设置请求头，已经丢弃
            /**
              1、设置请求头的Range字段，请求的内容大小，从0开始计数。
                Range: bytes=0-499      //下载首500个字节
                Range: bytes=199-499        //下载第199到499个字节
                Range: bytes=177        //从第177个字节开始下载
             */
            print("     (@@ NSURLConnection断点下载大文件")
            let myUrl  = URL.init(string: "http://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4")
            var myReq = URLRequest.init(url: myUrl!)
            myReq.setValue("bytes=\(fileCurSize)-", forHTTPHeaderField: "Range")
            connect = NSURLConnection.init(request: myReq, delegate: self)
            connect.start()
        case 4:
            //TODO: 4、测试文件的上传
            /**
                1、上传文件是把文件分段，放在POST请求的请求体里。要设置请求头的字段，在请求头里设置文件信息，和上传信息。
                2、请求体里面也要设置一定的说明格式，然后才是文件数据。
            
             文件上传步骤：
              1.设置请求头
              Content-Type:multipart/form-data; boundary=----WebKitFormBoundaryjv0UfA04ED44AhWx
              
              2.按照固定的格式拼接请求体的数据
              
              ------WebKitFormBoundaryjv0UfA04ED44AhWx
              Content-Disposition: form-data; name="file"; filename="Snip20160225_341.png"
              Content-Type: image/png
              
              
              ------WebKitFormBoundaryjv0UfA04ED44AhWx
              Content-Disposition: form-data; name="username"
              
              123456
              ------WebKitFormBoundaryjv0UfA04ED44AhWx--
              
             //2.拼接请求体的数据格式的说明：
              拼接请求体
              分隔符:----WebKitFormBoundaryjv0UfA04ED44AhWx
              1)文件参数
                  --分隔符
                  Content-Disposition: form-data; name="file"; filename="Snip20160225_341.png"
                  Content-Type: image/png(MIMEType:大类型/小类型)
                  空行
                  文件参数(文件本身数据)
              2)非文件参数(可以没有)
                  --分隔符
                  Content-Disposition: form-data; name="username"
                  空行
                  123456
              3)结尾标识
                 --分隔符--
                    
             */
            print("     (@@ 测试文件的上传")
            //1.确定请求路径
            let url = URL(string: "http://vfx.mtime.cn/Video/2019/02/04/mp4")
            
            //2.创建可变的请求对象
            var request = URLRequest(url: url!)
            
            //3.设置请求方法
            request.httpMethod = "POST";
            
            //4.设置请求头信息
            //Content-Type:multipart/form-data; boundary=----WebKitFormBoundaryjv0UfA04ED44AhWx
            let Kboundary = "----WebKitFormBoundaryjv0UfA04ED44AhWx"    //分隔符
            request.setValue("multipart/form-data; boundary=\(Kboundary)", forHTTPHeaderField: "Content-Type")
            
            //5.拼接请求体数据
            var fileData = Data()
            //5.1 文件参数
            /*
             --分隔符
             Content-Disposition: form-data; name="file"; filename="Snip20160225_341.png"
             Content-Type: image/png(MIMEType:大类型/小类型)
             空行
             文件参数
             */
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
            
            //UIImage --->NSData
            fileData.append(image!.pngData()!)
            fileData.append(KNewLineData)
            
            
            //5.2 非文件参数
            /*
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
            /*
             --分隔符--
             */
            fileData.append("--\(Kboundary)--".data(using: .utf8)!)
            
            //6.设置请求体
            request.httpBody = fileData;
            
            //7.发送请求
            NSURLConnection.sendAsynchronousRequest(request, queue: .main) { [weak self](resp, data, err) in
                print("文件上传：respone：\(String(describing: resp)),\n --data:\(String(describing: data)),\n  --err:\(String(describing: err))")
            }
            
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
            //TODO: 11、
            print("     (@@ ")
        case 12:
            //TODO: 12、取消connection的下载
            print("     (@@ 取消connection的下载")
            connect.cancel()
        default:
            break
        }
    }
    
}
//MARK: - 遵循NSURLConnectionDelegate协议，网络下载，已丢弃。
extension TestNetWorkDownload_VC: NSURLConnectionDataDelegate{
    
    //1.当接收到服务器响应的时候被调用
    func connection(_ connection: NSURLConnection, didReceive response: URLResponse) {
        //得到本次请求的文件的总大小(本次请求的文件数据的总大小)
        print("     本次请求的文件数据的总大小:\(response.expectedContentLength)")
        /// 创建文件
        if !FileManager.default.fileExists(atPath: fileUrl.path) {
            FileManager.default.createFile(atPath: fileUrl.path, contents: nil, attributes: nil)
        }
        
        
    }
    
    //2.接收到服务器返回数据的时候调用,会被调用多次(数据量大时)
    func connection(_ connection: NSURLConnection, didReceive data: Data) {
        
        print("某次接收到的文件大小：\(data.count)")
        //TODO: 追加写文件到桌面，用文件句柄
        /**
            1、可以在这里拼接数据，追加拼接
         */
        fileHandler = FileHandle(forWritingAtPath: "/Users/mac/Desktop/myVideo.mp4")
        fileHandler?.seekToEndOfFile()
        fileHandler?.write(data)
        fileCurSize += data.count       //记录已经下载了的数据
    }
    
    //3.当请求失败的时候调用
    func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
        print("TestNetWorkDownload_VC的 \(#function) 方法～")
    }
    //4.请求结束的时候调用
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        print("TestNetWorkDownload_VC的 \(#function) 方法～，必须关闭文件句柄")
        //TODO: 必须关闭文件句柄
        fileHandler?.closeFile()
        fileHandler = nil
        
    }
    
}


//MARK: - 设置测试的UI
extension TestNetWorkDownload_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
        imgView.layer.borderWidth = 1.0
        imgView.layer.borderColor = UIColor.brown.cgColor
        self.view.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom).offset(20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(400)
            make.centerX.equalToSuperview()
        }
    }
    
}


//MARK: - 设计UI
extension TestNetWorkDownload_VC {
    
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
extension TestNetWorkDownload_VC: UICollectionViewDelegate {
    
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
    1、
 
 */
