//
//  TestSDWebImage_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/3/29.
//  Copyright © 2022 com.mathew. All rights reserved.
//
//测试的图片下载库 VC

import SDWebImage

class TestSDWebImage_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    var imgView1:UIImageView = UIImageView()    //用于测试SDWebImage的imgview
    var imgView2:UIImageView = UIImageView()    //用于测试SDWebImage的imgview2

    //MARK: 测试组件
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试图片下载库SDWebImage_VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }
    
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestSDWebImage_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、测试SDWebImage下载图片
            print("     (@@  测试SDWebImage下载图片")
            let imgUrl = URL.init(string: """
                                https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic.jj20.com%2Fup%2Fallimg%2F1111%2F09291Q50950%2F1P929150950-8.jpg&refer=http%3A%2F%2Fpic.jj20.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1651198164&t=c0e9207f7504e5b4d125340d789b3fc3
                                """)
            
            /// 参数一：下载图片的url
            /// 参数二：占位图片
            /// 参数三：设置下载的偏好选项
            /// 参数四：图片带有的额外信息，也就是SDWebImage为每一个图片关联了一个字典来存储信息。
            /// 参数五：图片下载进度的闭包
            /// 参数六：图片下载完成后的闭包
            imgView1.sd_setImage(with: imgUrl,
                                 placeholderImage: UIImage(named: "labi07"),
                                 options: [.highPriority,.retryFailed], context: nil) { (receivedSize, expectedSize, targetURL) in
                print("下载的大小进度：\(receivedSize)  --- 期待的大小：\(expectedSize)")
            } completed: { (image, error, cacheType, imageURL) in
                print("""
                        下载完成的图片：\(String(describing: image))
                            --error:\(String(describing: error))
                            --cacheType:\(cacheType.rawValue)
                            --imageURL:\(String(describing: imageURL))
                        """)
            }

        case 1:
            //TODO: 1、
            print("     (@@ ")
        case 2:
            //TODO: 2、
            print("     (@@ ")
        case 3:
            //TODO: 3、
            print("     (@@ ")
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
extension TestSDWebImage_VC{
   
    //MARK: 0、
    func test0(){
        
    }
    
}


//MARK: - 设置测试的UI
extension TestSDWebImage_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        self.view.addSubview(imgView1)
        imgView1.layer.borderWidth = 1.0
        imgView1.layer.borderColor = UIColor.brown.cgColor
        imgView1.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom).offset(20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(200)
            make.centerX.equalToSuperview()
        }
        
        self.view.addSubview(imgView2)
        imgView2.layer.borderWidth = 1.0
        imgView2.layer.borderColor = UIColor.gray.cgColor
        imgView2.snp.makeConstraints { make in
            make.top.equalTo(imgView1.snp.bottom).offset(20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(200)
            make.centerX.equalToSuperview()
        }
    }
    
}


//MARK: - 设计UI
extension TestSDWebImage_VC {
    
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
extension TestSDWebImage_VC: UICollectionViewDelegate {
    
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
    1、SDWebImage是一个OC写的库，但是swift仍然可以使用，因为还有人在维护，它暴露了桥接头文件。首先引入库的头文件 import SDWebImage
 */

