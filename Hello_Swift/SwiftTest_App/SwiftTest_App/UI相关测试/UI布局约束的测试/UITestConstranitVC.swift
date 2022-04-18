//
//  UITestConstranitVC.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/7/23.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试UI的布局约束

import UIKit

class UITestConstranitVC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    private var testView1 = TestConstraintView()    //测试在VC中viewDidLayoutSubviews布局约束与在view的layoutSubviews，布局约束与snpkit的计算时机
    private var redView = UIView()
    var widthConstraint:NSLayoutConstraint = NSLayoutConstraint()
    
    private var greenView = TestConstraintView()
    private var blueView = TestConstraintView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .bottom
        self.view.backgroundColor = .white
        self.title = "测试UI的布局约束"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("UITestConstranitVC 的 viewDidLayoutSubviews 方法")
        for cons in testView1.constraints{
            print("testView1的约束===>：\(cons)")
        }
        
    }


}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension UITestConstranitVC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 添加一个view,测试snpkit的约束计算时机
            print("     (@@添加一个view")
            let curView = TestConstraintView()
            curView.tag = 12345
            curView.backgroundColor = .cyan
//            view.frame = CGRect.init(x: 0, y: 160, width: 400, height: 300)
            self.view.addSubview(curView)
            curView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.equalTo(200)
                make.height.equalTo(100)
            }
            
            break
        case 1:
            print("     (@@移除一个View")
            let curView = self.view.viewWithTag(12345)
            curView?.removeFromSuperview()
            
        case 2:
            print("     (@@ 重新设置snpkit")
            let curView = self.view.viewWithTag(12345)
//            if let consArr = curView?.constraints {
//                for cons in consArr {
//                    curView?.removeConstraint(cons)
//                }
//            }
//
            curView?.snp.remakeConstraints({ make in
                make.left.equalToSuperview().offset(10)
                make.centerY.equalToSuperview().offset(20)
                make.width.equalTo(120)
                make.height.equalTo(60)
            })
            
        case 3:
            print("     (@@旋转view")
            let curView = self.view.viewWithTag(12345)
            curView?.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi / 2)
            print("旋转后")
            break
        case 4:
            print("     (@@ 复原view的矩阵变换")
            let curView = self.view.viewWithTag(12345)
            curView?.transform = CGAffineTransform.identity
            break
            
        case 5://TODO: 5、手工纯代码写View的约束。
            print("     (@@手工纯代码写View的约束。")
            //创建一个红色的view添加到界面上，试验添加一个红色的view到界面上，距上220，距左各20，宽200，高100.
            redView.backgroundColor = .red
            redView.translatesAutoresizingMaskIntoConstraints = false   //不要把AutoResizing转换为autoLayout
            view.addSubview(redView)
                    
            //添加距离顶部200
            let topConstraint = NSLayoutConstraint.init(item: redView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 220)
            topConstraint.isActive = true
                    
            //添加距离左边20
             let leftConstraint = NSLayoutConstraint.init(item: redView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 20)
            leftConstraint.isActive = true
                    
            //添加宽为200
            widthConstraint = NSLayoutConstraint.init(item: redView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 200)
            widthConstraint.isActive = true
            //添加高为100
            let heightConstraint = NSLayoutConstraint.init(item: redView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100)
            heightConstraint.isActive = true
            
            ///实现约束的动画效果
            
            
            
        case 6: //TODO: 6、测试view从父控件中移除时，约束会不会也被移除掉。答：不会被移除，但是参考的view会因为没有参考物，而被移除掉。(或者说默认是0)
            print("     (@@测试view从父控件中移除时，约束会不会也被移除掉")
            if greenView.superview ==  nil{
                greenView.backgroundColor = .green
                self.view.addSubview(greenView)
                greenView.snp.makeConstraints { make in
                    make.top.equalTo(baseCollView.snp.bottom).offset(20)
                    make.height.width.equalTo(40)
                    make.left.equalToSuperview().offset(20)
                }
                
                blueView.backgroundColor = .blue
                self.view.addSubview(blueView)
                blueView.snp.makeConstraints { make in
                    make.top.equalTo(greenView.snp.top)
                    make.left.equalTo(greenView.snp.right).offset(20)
                    make.width.equalTo(greenView.snp.width)
                    make.height.equalTo(greenView.snp.height)
                }
                
            }
        case 7:
            print("     (@@从父控件中移除带有约束的greenView")
            greenView.removeFromSuperview()
        case 8:
            print("     (@@实现约束的动画效果")
            //setNeedsLayout方法与layoutIfNeeded方法的区别。
            widthConstraint.constant = 20
            UIView.animate(withDuration: 2) {
                [weak self] in
                self?.view.layoutIfNeeded()   //立马更新，不等下一个UI周期。
            }
        case 9:
            print("     (@@")
        case 10:
            print("     (@@ 打印测试的view")
            let curView = self.view.viewWithTag(12345)
            print("curView:\(String(describing: curView))")
        case 11:
            print("     (@@")
        case 12:
            print("     (@@")
        default:
            break
        }
    }
    
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
    
}



//MARK: - 工具方法
extension UITestConstranitVC{
    
    //TODO: 测试在VC中viewDidLayoutSubviews布局约束与在view的layoutSubviews，布局约束与snpkit的计算时机
    func initTestViewUI(){
        testView1.tag = 1000
        testView1.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(testView1)
        testView1.backgroundColor = .brown
        let leffCons = NSLayoutConstraint.init(item: testView1, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 50.0)
        let topCons = NSLayoutConstraint.init(item: testView1, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 380)
        let widthCons = NSLayoutConstraint.init(item: testView1, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 60)
        let hCons = NSLayoutConstraint.init(item: testView1, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)
        NSLayoutConstraint.activate([leffCons,topCons,widthCons,hCons])
//        testView1.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(400)
//            make.left.equalToSuperview().offset(50)
//            make.width.height.equalTo(100)
//        }
    }
    
    
}

//MARK: - 遵循委托协议,UICollectionViewDelegate
extension UITestConstranitVC: UICollectionViewDelegate {
    ///一旦入栈，就隐藏入栈vc的tabBar，底部工具栏
    private func pushNext(viewController: UIViewController) {
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
}

//MARK: - 设计UI
extension UITestConstranitVC {
    
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
        
        baseCollView = UICollectionView.init(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width,height:200),
                                             collectionViewLayout: layout)
        
        baseCollView.backgroundColor = UIColor.cyan
        baseCollView.contentSize = CGSize.init(width: UIScreen.main.bounds.size.width * 2, height: UIScreen.main.bounds.size.height)
        baseCollView.showsVerticalScrollIndicator = true
        baseCollView.alwaysBounceVertical = true
        baseCollView.delegate = self
        baseCollView.dataSource = self
        baseCollView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionView_Cell_ID")
        
        self.view.addSubview(baseCollView)
        
    }
}

//MARK: - 笔记
/**
    1、UIKit会先调用VC的viewDidLayoutSubviews方法，然后再调用view的layoutSubviews方法。
 
    2、AutoResizing是iOS6之前的技术了，很老很老了，已经抛弃了，iOS6之后推出了AutoLayout,目前还在用这个。
       AutoResizing只能定义父子控件之间的约束关系，AutoLayout可以定义任意控件之间的关系。
       AutoLayout如果你不指明约束参考哪个控件，那么它默认参考最近的控件(在storyboard的布局约束中)。
 
    3、UILabel使用AutoLayout，在没有AutoLayout之前label中的文字上下总是居中显示。因为label回根据文字的多少和字体来计算宽度，
      所以在label中使用约束时，需要指明label的宽高。
 
    4、纯代码写约束，以前是添加到view的方法里，现在是直接设置widthConstraint.isActive = true就可以了，会自动绑定到view里面去。但还是可以遍历view的约束数组。
 
    5、viewB参考viewA的约束，那么viewA移除之后，viewB也会因为没有约束而移除，所以viewB可以设置多一些相同的约束参考，但是优先级必须不一样，否则会冲突。
        也就是viewB再设置参考viewC的约束，但是优先级要比参考viewA的约束低，这样viewA被删除后，viewB还是可以参考viewC的约束。
 
    6、实现约束的动画效果，必须是在UIView的动画方法里立即更新父view的布局约束，更新自身的没用。因为在使用约束添加动画的时候，有个原则就是动画要添加到当前视图的父视图上。
       因为约束最终是反映在frame上，所以要在UIView的动画block里面调用父view的layoutIfNeeded()方法，这是不等下一个周期里面更新UI，也就是里面设置frame， 这和直接设置frame的效果是一样的，如果是调用setNeedsLayout()方法，则当前修改的约束还没应用到frame上，也就是frame的值还是之前的，要等到下一个UI周期才会应用到frame上， 所以在UIview的动画block里的frame值还是旧的值，所以就不会用动画效果，而是在下一个UI周期时，直接就修改了view的frame就直接渲染了，没有在动画效果。
 
    7、translatesAutoresizingMaskIntoConstraints 的本意是将 frame 布局 自动转化为 约束布局，转化的结果是为这个视图自动添加所有需要的约束， 如果我们这时给视图添加自己创建的约束就一定会约束冲突。为了避免上面说的约束冲突，我们在代码创建 约束布局 的控件时 直接指定这个视图不能用frame 布局 （即translatesAutoresizingMaskIntoConstraints=NO），可以放心的去使用约束了。


 
 */
