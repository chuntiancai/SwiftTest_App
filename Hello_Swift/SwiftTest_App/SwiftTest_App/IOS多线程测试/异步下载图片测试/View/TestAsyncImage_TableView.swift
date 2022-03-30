//
//  TestAsyncImage_TableView.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/8/3.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试异步下载图片的tableview

import UIKit

class TestAsyncImage_TableView: UIView {
    //MARK: - 对外属性
    
    
    //MARK: - 内部属性
    private lazy var tableView:UITableView = {
        let tView = UITableView(frame: CGRect.zero, style: .plain)
        tView.register(AsyncImg_Cell.classForCoder(), forCellReuseIdentifier: "AsyncImg_Cell_ID")
        tView.delegate = self
        tView.dataSource = self
        return tView
    }()
    
    var modelArr:[AsyncImg_Model] = [AsyncImg_Model]()  //下载图片的描述信息model
    var imgDict:[String:UIImage] = [String:UIImage]()   //缓存图片的字典
    var opQue = OperationQueue()    //用于异步下载图片的队列
    var opDict:[String:Operation] = [String:Operation]()   //用于保存下载的任务，避免多次添加任务。
    
    

    //MARK: - 复写方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        initData()
        initDefaultUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: 填充初始数据
    func initData(){
        let filePath = Bundle.main.path(forResource: "ImageList.plist", ofType: nil) ?? ""
        if let imgArr = NSArray.init(contentsOf: URL.init(fileURLWithPath: filePath)) {
            for item in imgArr {
                if let itemDict:[String:String] = item as? [String:String] {
                    let model = AsyncImg_Model(name: itemDict["name"]!, icon: itemDict["icon"]!, url: itemDict["url"]!)
                    modelArr.append(model)
                }
            }
        }
        
    }
    /// 初始化UI
    func initDefaultUI(){
        
        self.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
}

//MARK: - 遵循tableview的协议 UITableViewDelegate,UITableViewDataSource
extension TestAsyncImage_TableView: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AsyncImg_Cell_ID")!
        outer: if !modelArr.isEmpty {
            
            var img:UIImage? = nil
            
            /// 图片的url字符串
            let urlStr = modelArr[indexPath.row].url!.absoluteString
            
            if imgDict[urlStr] != nil { //先检查内存有没有缓存图片
                cell.imageView?.image = imgDict[urlStr]
                break outer
            }
            
            /// 在沙盒缓存图片
            let cacheFilePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last! as NSString
            /// 获取图片的名称，但是不能包含"/"字符
            let imgName = urlStr.suffix(16)
            /// 拼接图片的全路径
            let cachePath = cacheFilePath.appendingPathComponent(String(imgName))
            
            /// 检查磁盘有没有图片数据
            if let imgData = try? Data(contentsOf: URL(fileURLWithPath: cachePath)) {
                print("在沙盒中有缓存图片～")
                img = UIImage(data: imgData)
            }else{
                ///在内存用字典来缓存图片，下载图片
                if imgDict[urlStr] == nil {
                    
                    if opDict[urlStr] == nil {
                        // 开子线程去下载图片
                        opDict[urlStr] = BlockOperation.init(block: {
                            [weak self] in
                            print("内存中没有图片，去网络下载图片～ \(Thread.current)")
                            sleep(1)    //模拟网速慢的情况，慢会导致重复下载图片问题，用户手速比网速快
                            do {
                                img = try UIImage(data: Data(contentsOf: (self?.modelArr[indexPath.row].url!)!))
                                let imgData = img?.jpegData(compressionQuality: 1.0)
                                
                                /// 把图片写入到沙盒中
                                try imgData?.write(to: URL(fileURLWithPath: cachePath))
                                
                                OperationQueue.main.addOperation {  //下载完成，刷新row
                                    self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                                }
                                self?.imgDict[urlStr] = img
                                self?.opDict[urlStr] = nil  //下载完成，则移除任务
                            } catch let wErr {
                                print("写入图片的错误：\(wErr)")
                            }
                        })
                        opQue.addOperation(opDict[urlStr]!)
                    }
                    
                }
            }
            
            imgDict[urlStr] = img
            cell.imageView?.image = imgDict[urlStr]
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("点击了\(indexPath.row)")
    }
    
}

//MARK: - 收到内存警告
extension TestAsyncImage_TableView{
    
}

//MARK: -
extension TestAsyncImage_TableView{
    
}

//MARK: -
extension TestAsyncImage_TableView{
    
}

//MARK: - 笔记
/**
    1、收到内存警告，要记得在VC上清理图片的缓存，内存上的缓存。要取消所有将要执行的任务。
 */
