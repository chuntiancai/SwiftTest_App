//
//  TestImageRestore_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/1/7.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试图片的存放方式VC
// MARK: - 笔记
/**
 方式1、放在xcassets里面，通过图片名字获取。
    1、.xcassets资源文件，在编译后，会放在沙盒的bundle路径下，被打包成.car文件。
    2、不能拿到.xcassets文件里的图片路径，所以在.xcassets文件中的文件，不能通过bundle来加载图片。
    3、即便指向xcassets里面图片的指针被销毁，xcassets里面的图片仍停留在内存中。默认有缓存，图片经常被使用的时候，使用xcassets资源文件管理图片。
  
 方式2、通过bundle来加载图片。
    1、沙盒是表示整个app的存储空间，沙盒里的home目录和bunle是同一级别的文件夹。xocde工程程目录下的文件会存放在沙盒的bundle目录中。
    2、这里面的图片可以拿得到路径。可以通过bundle来加载图片,也可以通过UIImage(named: "labi01.jpg")来加载
    3、指向bundle里面图片的指针被销毁的话，xcassets里面的图片也会从内存中移除。没有缓存，大批量，或临时使用的图片，就可以用bundle资源文件来管理文件。
 */

class TestImageRestore_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 测试组件
    let imgView1 = UIImageView()
    let imgView2 = UIImageView()
    let imgView3 = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试图片的存放方式VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }


}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestImageRestore_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、
            
            break
        case 1:
            //TODO: 方式1、放在xcassets里面，通过图片名字获取。
            /**
             1、.xcassets资源文件，在编译后，会放在沙盒的bundle路径下，被打包成.car文件。
             2、不能拿到.xcassets文件里的图片路径，所以在.xcassets文件中的文件，不能通过bundle来加载图片。
             */
            imgView1.image = UIImage(named: "ha0")
            print("     (@@ ")
        case 2:
            //TODO: 方式2、通过bundle来加载图片。
            /**
             1、沙盒是表示整个app的存储空间，沙盒里的home目录和bunle是同一级别的文件夹。xocde工程程目录下的文件会存放在沙盒的bundle目录中。
             2、这里面的图片可以拿得到路径。可以通过bundle来加载图片,也可以通过UIImage(named: "labi01.jpg")来加载
             */
            print("     (@@  ")
            let bundlePath = Bundle.main.bundlePath //主bundle
            let labiBundlePath = Bundle.main.path(forResource: "labi", ofType: "bundle")    //自定义的bundle的路径
            let labiBundle = Bundle.init(path: labiBundlePath!)//自定义的bundle
            //获取bundle中的文件
            let labi01Path = labiBundle?.path(forResource: "labixiaoxin01", ofType: "jpg", inDirectory: "labixiaoxinImage/labi01")
            imgView2.image = UIImage.init(contentsOfFile: labi01Path!)
            print("bundle的路径:\(bundlePath)\n-- 自定义bundle:\(String(describing: labiBundle))")
            
        case 3:
            //TODO: 方式3、通过图片名字获取，但是图片直接放在xcode的工程目录中。
            print("     (@@ ")
            /**
             1、在Xcode的工程目录中，如果是创建文件夹的引用的话，那么你使用文件夹中的图片时，要把文件夹的路径也带上，因为这个文件夹就是一个引用的前缀。
             2、在Xcode的工程目录中，如果是创建实体文件夹的换，那么你使用文件夹中的图片时，可以直接使用图片名称。因为这不是一个引用名。
             3、在Xcode的工程目录中，无论是创建文件夹的引用，还是创建实体文件夹，在bundle中，都会被解开，直接把里面的图片放一堆。
             */
            imgView3.image = UIImage(named: "labi001.jpg")
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
extension TestImageRestore_VC{
   
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
extension TestImageRestore_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        imgView1.layer.borderWidth = 1.0
        imgView1.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(imgView1)
        imgView1.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.height.equalTo(150)
            make.width.equalTo(240)
        }
        
        imgView2.layer.borderWidth = 1.0
        imgView2.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(imgView2)
        imgView2.snp.makeConstraints { make in
            make.top.equalTo(imgView1.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.height.equalTo(150)
            make.width.equalTo(240)
        }
        
        imgView3.layer.borderWidth = 1.0
        imgView3.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(imgView3)
        imgView3.snp.makeConstraints { make in
            make.top.equalTo(imgView2.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.height.equalTo(150)
            make.width.equalTo(240)
        }
    }
    
}


//MARK: - 设计UI
extension TestImageRestore_VC {
    
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
extension TestImageRestore_VC: UICollectionViewDelegate {
    
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


