//
//  TestUIScrollView_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/1/16.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试UIScrollView的VC

class TestUIScrollView_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 测试组件
    var testScrollView = Test_ScorllView()
    var scrollDelegate = TestScrollView_deleagate()
    var imgView = UIImageView()
    
    let pageIndicator = UIPageControl() // 显示页数小圆点
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试功能"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }


}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestUIScrollView_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、测试对UIScrollView里面的内容进行缩放
            print("     (@@  测试对UIScrollView里面的内容进行缩放")
            /// 设置缩放因子
            testScrollView.minimumZoomScale = 0.5
            testScrollView.maximumZoomScale = 5
            if imgView.superview == nil {
                let img = UIImage(named: "labi07")
                testScrollView.contentSize = img!.size
                imgView.image = img
                imgView.tag = 10086
                testScrollView.addSubview(imgView)
                imgView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
            break
        case 1:
            //TODO: 1、测试scrollView的分页效果"
            print("     (@@ 测试scrollView的分页效果")
            if testScrollView.contentSize.width != 300 * 6 {
                imgView.removeFromSuperview()
                ///设置scrollView的contentSize的height为0，则表示竖直方向不可以滚动，同理可得水平方向。
                testScrollView.contentSize = CGSize(width: 300 * 6, height: 200)
                /// 这个会根据contentSize和scrollView的frame进行计算，分多少页，然后滑动起来就有分页的效果。
                testScrollView.isPagingEnabled = true
                for index in 1 ... 6 {
                    let img = UIImage(named: "labi0\(index)")
                    let imgView = UIImageView(image: img)
                    imgView.tag = 1000 + index
                    testScrollView.addSubview(imgView)
                    imgView.frame = CGRect.init(x: 300 * (index - 1), y: 0, width: 300, height: 200)
                }
                
                /// 显示页数小圆点
                pageIndicator.tag = 1010
                pageIndicator.currentPageIndicatorTintColor = UIColor.gray   //选中的小圆点颜色
                pageIndicator.pageIndicatorTintColor = UIColor.white    //小圆点的默认渲染颜色
                pageIndicator.backgroundColor = UIColor.white.withAlphaComponent(0.4)
                pageIndicator.numberOfPages = 6
                pageIndicator.currentPage = 0
                self.view.addSubview(pageIndicator)
                pageIndicator.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.bottom.equalTo(testScrollView.snp.bottom)
                }
                
                
            }
            
        case 2:
            //TODO: 2、显示页数小圆点
            print("     (@@ 当前页控制器的小圆点是：\(pageIndicator.currentPage)")
            if pageIndicator.currentPage == 5 {
                pageIndicator.currentPage = 0
            }else{
                pageIndicator.currentPage += 1
            }
            testScrollView.contentOffset = CGPoint.init(x: 300 * pageIndicator.currentPage, y: 0)
            
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
            print("     (@@")
        default:
            break
        }
    }
    
}
//MARK: - 测试的方法
extension TestUIScrollView_VC{
   
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
extension TestUIScrollView_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
        testScrollView.backgroundColor = .magenta
        testScrollView.showsVerticalScrollIndicator = true
        testScrollView.showsHorizontalScrollIndicator = true
        testScrollView.delegate = scrollDelegate
        testScrollView.contentSize = CGSize.init(width: 720, height: 320)
        

        self.view.addSubview(testScrollView)
        testScrollView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom).offset(20)
            make.height.equalTo(200)
            make.width.equalTo(300)
            make.centerX.equalToSuperview()
        }
    }
    
}


//MARK: - 设计UI
extension TestUIScrollView_VC {
    
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
extension TestUIScrollView_VC: UICollectionViewDelegate {
    
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
    1、设置scrollView的maximumZoomScale缩放因子，可以实现缩放效果。
    2、设置scrollView的contentSize的height为0，则表示竖直方向不可以滚动，同理可得水平方向。
       testScrollView.isPagingEnabled属性会根据contentSize和scrollView的frame进行计算，分多少页，然后滑动起来就有分页的效果。
       如果要实现轮播图效果，则可以通过计算位移实现，肉眼是看不出来的。
    3、如果要设置UIPageControl选中的图片效果，可以通过KVC来设置，因为源代码是有这个私有变量的。
 */

