//
//  FileTestVC.swift
//  SwiftTest_App
//
//  Created by mathew2 on 2021/3/23.
//  Copyright © 2021 com.mathew. All rights reserved.
//
//测试文件的VC
// MARK: - 笔记
/**
    1、文件的压缩和解压缩，用第三方库SSZipArchive。
 
    2、在编译完成的时候，xcode都会把storyboard、图片、xib、plist等这些文件打包经main.bundle文件中，只是这个main.bundle是在编译后生成。
        bundle里面一般存放不需要编译的文件，例如图片，而不要放xib这些需要编译的文件。
 
 */

import MobileCoreServices

class FileTest_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 测试组件
    private var outStream:OutputStream? //文件输出流，记得关闭
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试文件的VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }


}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension FileTest_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、测试文件的输出流，可以参考第三方框架的实现来找实现方法，例如AFNetWork
            /**
                特点:如果该输出流指向的地址没有文件,那么会自动创建一个空的文件
             */
            print("     (@@  测试文件的输出流")
            let fileUrl = URL(fileURLWithPath: "/Users/mac/Desktop/OutputVedio.mp4")   //桌面文件
            guard let url = URL.init(string: "http://vfx.mtime.cn/Video/2019/03/19/mp4/190319222227698228.mp4")else { return  }
            
            let urlSessionTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let curData = data else { print("data数据为空"); return }
                ///第一个参数：输出的文件路径
                ///第二个参数：是否追加写入
                self?.outStream = OutputStream(toFileAtPath: fileUrl.path, append: false) ?? OutputStream()
                
                //打开输出流
                self?.outStream?.open()
                
                //通过输出流写入到文件，Data转换为UnsafePointer<UInt8>
                /**
                
                 /// 方法一，这样会另外开了一个数组，消耗很多内存。AFN的做法
                 var buffer = [UInt8](repeating: 0, count: curData.count)
                 curData.copyBytes(to: &buffer, count: curData.count)
                 self?.outStream?.write(buffer, maxLength: curData.count)
                 
                 ///方法二，我也不是很懂
                 let tempData:NSMutableData = NSMutableData()
                 curData.withUnsafeBytes {
                     tempData.replaceBytes(in: NSMakeRange(0, curData.count), withBytes: $0)
                 }
                 let p:UnsafePointer = tempData.bytes.assumingMemoryBound(to: UInt8.self)
                 self?.outStream?.write(p, maxLength: curData.count)
                
                 
                 */
                ///方法三，直接转换为NSData使用
                let point = (curData as NSData).bytes.bindMemory(to: UInt8.self, capacity: MemoryLayout<UInt8>.stride)
                self?.outStream?.write(point, maxLength: curData.count)
                
                
            }
            urlSessionTask.resume()
        case 1:
            //TODO: 1、获取文件的MIMEType
            /**
             1、 MIMEType是IETF 组织协商，以 RFC 的形式作为建议的一种标准，一般用于网络传输中说明文件的类型，例如： Content-Type: image/png(MIMEType:大类型/小类型)
             获取 MIME 类型的途径：
             1、发送网络请求，响应体里面有字段说明文件的MIME类型。response.mimeType
             2、百度MIME 参考手册。
             3、C语言的api也有提供。
             */
            print("     (@@ 获取文件的MIMEType")
            
            //通过响应头的字段获取
            let resp = URLResponse()
            print("response中的mime类型：\(String(describing: resp.mimeType))")
            
            // C语言的api获取,首先引入c语言库，import MobileCoreServices
            let fileUrl = URL(fileURLWithPath: "/Users/mac/Desktop/OutputVedio.mp4")   //桌面文件
            let filePathExtension = (fileUrl.path  as NSString).pathExtension   //文件后缀名
            var mimeType = ""
            
            if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                               filePathExtension as NSString,
                                                               nil)?.takeRetainedValue() {
                if let mime = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?
                    .takeRetainedValue() {
                    mimeType = mime as String
                    print("c语言获取到的mime类型：\(mime)")
                }else{
                    //未知文件资源类型，可传万能类型application/octet-stream，服务器会自动解析文件类型
                    mimeType = "application/octet-stream"
                    print("c语言获取到的mime类型：\(mimeType)")
                }
            }

        
        case 2:
            //TODO: 2、 
            print("     (@@  ")
        case 3:
            //TODO: 3、
            print("     (@@ ")
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
            //TODO: 12、关闭输出流
            print("     (@@ 关闭输出流")
            outStream?.close()
            outStream = nil
        default:
            break
        }
    }
    
}
//MARK: - 测试的方法
extension FileTest_VC{
   
    //MARK: 0、
    func test0(){
        
    }
    //MARK: 1、
    func test1(){
        
    }
    //MARK: 2、
    func test2(){
        
    }
    
}


//MARK: - 设置测试的UI
extension FileTest_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
    }
    
}


//MARK: - 设计UI
extension FileTest_VC {
    
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
extension FileTest_VC: UICollectionViewDelegate {
    
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


