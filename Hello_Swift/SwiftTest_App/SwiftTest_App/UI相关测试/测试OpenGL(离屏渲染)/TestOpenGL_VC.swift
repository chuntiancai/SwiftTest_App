//
//  TestOpenGL_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/11/15.
//  Copyright © 2022 com.mathew. All rights reserved.
//
//测试OpenGL框架的VC
// MARK: - 笔记
/**
    1、OpenGL（英语：Open Graphics Library，译名：开放图形库或者“开放式图形库”）是用于渲染2D、3D矢量图形的跨语言、跨平台的应用程序编程接口（API）。
       这个接口由近350个不同的函数调用组成，用来绘制从简单的图形比特到复杂的三维景象，在iOS主要是用于绘制3D图形。
       OpenGL独立于操作系统的开放的三维图形的软件开发包，准确来说是一套图形绘制标准，然后根据这套标准，各个系统开发出相应的框架(C语言)。
       OpenGL是运行在GPU的，OpenGL ES的ES意思是嵌入式系统的意思。
       
       在iOS中，对应OpenGL的框架是OpenGL ES Framework，但是OpenGL ES框架在iOS 12.0已经丢弃了，现在用Metal这个框架了。
       但是Metal框架的实际就是对OpenGL ES的二次封装，使得更加符合iOS系统。
 
       OpenGL的核心是：矩阵。线性代数的矩阵。
 
    2、点、线、面。
       纯色着色 --> 纹理(背景图)
       光栅化：将输入的图元数学描述转换为屏幕位置对应的像素片元。 数学描述 --> 像素
       着色器：shader，其实就是一段运行在GPU上的程序。我们平时的程序大都是运行在CPU上，由于GPU和CPU的架构不一样，所以GPU需要一些新的编程语言。
             顶点着色器：确定图形的关键点，这些关键点就是顶点，然后就对顶点进行着色。点连成线，确定图形的轮廓。
             片元着色器：点之间有很多元素点，我们称之为片元，片元着色器就是对顶点连接的区域中的像素点进行着色。
 
    3、屏幕渲染方式：
        当前屏幕渲染(On-screen Rendering)：GPU的渲染操作是在当前显示的屏幕缓冲区中进行的。
        离屏渲染(Off-screen Rendering)：GPU的渲染操作是在当前显示的屏幕缓冲区 之外 另开辟一个缓冲区进行渲染的。
            离屏渲染的卡顿原因：复杂的动画不能直接渲染叠加显示出来，需要根据Command Buffer分通道进行，多个渲染通道需要重新组合。
                            在这个渲染通道的切换组合的过程中，CPU需要时间处理，GPU可能渲染完缓冲区就闲着了。
                            卡顿：一是需要CPU创建新的缓存区。二是需要CPU进行上下文(通道)切换。
 
        
 
 */

class TestOpenGL_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    let bgView = UIView()   //测试的view可以放在这里面
    
    //MARK: 测试组件
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试OpenGL框架的VC"
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestOpenGL_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("TestOpenGL_VC 点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、
            print("     (@@ 0、")
            let _ = self.bgView.subviews.map { $0.removeFromSuperview() }
            
        case 1:
            //TODO: 1、
            print("     (@@ 1、")
        case 2:
            //TODO: 2、
            print("     (@@ 2、")
        case 3:
            //TODO: 3、
            print("     (@@ 3、")
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
extension TestOpenGL_VC{
   
    //MARK: 0、
    func test0(){
        
    }
    
}


//MARK: - 设置测试的UI
extension TestOpenGL_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        /// 内容背景View，测试的子view这里面
        self.view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
    }
    
}


//MARK: - 设计UI
extension TestOpenGL_VC {
    
    /// 设置导航栏的UI
    private func setNavigationBarUI(){
        //设置子页面的navigation bar的返回按钮样式
        let backItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    /// 设置collection view的UI
    private func setCollectionViewUI(){
        
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: 80, height: 40)
        layout.sectionInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 0, right: 5)
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
extension TestOpenGL_VC: UICollectionViewDelegate {
    
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
