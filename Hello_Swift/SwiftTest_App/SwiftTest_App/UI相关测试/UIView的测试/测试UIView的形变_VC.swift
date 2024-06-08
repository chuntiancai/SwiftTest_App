//
//  测试UIView的形变_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/7/13.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// MARK: - 笔记

import QuartzCore
/**
    1、CGAffineTransform是一个结构体，不是一个类。 CGAffineTransform，是相对于原始的redview的fram的x，y坐标进行加减的平移。
 
     而原始的redview的frame不是你设置的frame，而是UIKit根据view当前的frame和view当前的transform来计算出的的，它认为这个才是原始的frame。
     譬如：当前frame的origin=（100，200），transform = (...,tx:50,ty:-60),那么它认为原始的frame的origin = (X:100-50,y:200+60) = (X:50,y:260),
     也就是它认为当前的frame是已经形变过一次的了，所以你每次都需要重置清零transform属性才能达到你想要的效果。

     transform是作为view的一个存储属性，所以每一次transform之后，transform的痕迹都会被记录下来，而UIKit的机制就是参考上一次的transform，来决定它认为的原始的view的frame。

     如果你要实现transform是相对于上一次形变之后的形变，那么你要用transform的translatedBy(x: , y: )方法 对view的transform属性 进行累加。

     使用CGAffineTransform.identity属性可以对transform进行重置清零，但是这一刻只是把view重置为它认为的原始位置，并且清零tranform属性，所以你最好是先清零，后自定义view的位置。
 
    2、形变会改变目标view的frame，但不会改变目标view的约束布局，也不会重新计算布局约束。
        
      目标view形变之后，目标view的子view回跟随父view一起形变，子view的transform值不会被改变，而父view的值会被改变。
 */

class TestUIViewTransform_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 测试组件
    let redView = UIView()
    let innerRedView = UIView() //红色view里面的view
    let blueView = UIView()
    let scaleView = UIView()
    
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
extension TestUIViewTransform_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、UIview形变缩放
            print("     (@@ 0、UIview形变缩放")
            redView.transform = .identity   //重置transform属性。
            redView.transform = CGAffineTransform.init(scaleX: 2, y: 0.8)
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
            //TODO: 4、UIview的transform属性，形变。
            print("     (@@ 测试transform形变属性。+ 100 ")
            /// 平移，是相对于原始的redview的fram的x，y坐标进行加减的平移。transform属性并不会参考transform之后的frame，只会参考非transform之前的frame
            redView.transform = CGAffineTransform(translationX: 100, y: 100)
            print("     (@@ redview的frame是：\(redView.frame)")
            print("     (@@ redview的transform是：\(redView.transform)")
        case 5:
            //TODO: 5、transform形变平移 -50
            print("     (@@ transform形变 -50")
            redView.transform = CGAffineTransform(translationX: -50, y: -50)
            print("     (@@ redview的frame是：\(redView.frame)")
            print("     (@@ redview的transform是：\(redView.transform)")
        case 6:
            //TODO: 6、手动设置redView的frame
            redView.frame = CGRect.init(x: 100.0, y: 400.0, width: 40.0, height: 20.0)
            print("     (@@ 6、手动设置redView的frame：CGRect(x: 100.0, y: 400.0, width: 40.0, height: 20.0)")
            print("     (@@ redview的transform是：\(redView.transform)")
            
        case 7:
            //TODO: 7、对transform进行累加
            print("     (@@ 对transform进行累加")
            redView.transform = redView.transform.translatedBy(x: 10, y: -20)
//            redView.transform = redView.transform.rotated(by: 0.5) //这个是弧度
        case 8:
            //TODO: 8、对redview的transform进行重置
            print("     (@@ 对redview的transform进行重置")
            redView.transform = .identity
            print("     (@@ redview的frame是：\(redView.frame)")
            print("     (@@ redview的transform是：\(redView.transform)")
        case 9:
            //TODO: 9、打印UIView的frame和transform
            print("     (@@ redview的frame是：\(redView.frame)")
            print("     (@@ redview的transform是：\(redView.transform)")
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
extension TestUIViewTransform_VC{
   
    //MARK: 0、
    func test0(){
        
    }
    
}


//MARK: - 设置测试的UI
extension TestUIViewTransform_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        redView.layer.borderWidth = 1.0
        redView.layer.borderColor = UIColor.red.cgColor
        self.view.addSubview(redView)
        redView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom).offset(20)
            make.centerX.equalToSuperview().offset(-40)
            make.height.equalTo(50)
            make.width.equalTo(80)
        }
        
        
        innerRedView.backgroundColor = .red
        redView.addSubview(innerRedView)
        innerRedView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.top.equalToSuperview().offset(5)
            make.height.equalTo(20)
            make.width.equalTo(30)
        }
        
        blueView.backgroundColor = .blue
        self.view.addSubview(blueView)
        blueView.snp.makeConstraints { make in
            make.top.equalTo(redView.snp.top)
            make.left.equalTo(redView.snp.right).offset(5)
            make.height.width.equalTo(40)
        }
    }
    
}


//MARK: - 设计UI
extension TestUIViewTransform_VC {
    
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
extension TestUIViewTransform_VC: UICollectionViewDelegate {
    
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
