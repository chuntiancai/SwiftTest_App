//
//  测试UIVIew的frame_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/7/13.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试UIView的frame和bounds

// MARK: - 笔记
/**
    1、layer的position属性是参考父view坐标系的，绑定了Layer里的某一个点。设置position属性，就是把layer的这个点，移动到父view中position的值的位置。
       position是Layer中的一个点，这个点就是由Layer的anchorPoint属性决定的，也是锚点，它的丈量是0～1，也就是按比例来计算定位Layer中的点。
       anchorPoint是参考Layer自身坐标系的，但是是按照0～1的比例来丈量，不是精确到坐标系的每一点来丈量。anchorPoint默认值是(0.5,0.5)。
 
 */

class TestUIViewFrame_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 测试组件
     let redView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试UIVIew的frame_VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }
    
    
    
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestUIViewFrame_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、测试layer的position属性。
            /**
             1、layer的position属性是参考父view坐标系的，绑定了Layer里的某一个点。设置position属性，就是把layer的这个点，移动到父view中position的值的位置。
             2、上面1说的position是Layer中的一个点，这个点就是由Layer的anchorPoint属性决定的，也是锚点，它的丈量是0～1，也就是按比例来计算定位Layer中的点。
                anchorPoint是参考Layer自身坐标系的，但是是按照0～1的比例来丈量，不是精确到坐标系的每一点来丈量。anchorPoint默认值是(0.5,0.5)。
             */
            print("     (@@ 0、")
        case 1:
            //TODO: 1、测试view的center属性。
            print("     (@@ 1、")
        case 2:
            //TODO: 2、测试view的bounds属性。
            print("     (@@ 2、")
        case 3:
            //TODO: 3、测试view的frame属性。
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
extension TestUIViewFrame_VC{
   
    //MARK: 0、
    func test0(){
        
    }
    
}


//MARK: - 设置测试的UI
extension TestUIViewFrame_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
        redView.backgroundColor = .red
        
    }
    
}


//MARK: - 设计UI
extension TestUIViewFrame_VC {
    
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
extension TestUIViewFrame_VC: UICollectionViewDelegate {
    
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

