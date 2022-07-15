//
//  测试帧动画的VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/1/7.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试帧动画的VC
// MARK: - 笔记
/**
    1、设置UIImageView的属性animationImages，即可实现帧动画，还有时长这些。
    2、渐变动画演示(逐渐变化)
        /// 开始动画，在设置开始到设置结束之间设置动画的一些属性。
        /// 设置动画的属性，市场，变化位移，形变这些。
        ///提交动画。
 
    3、CGAffineTransform是一个结构体，不是一个类。 CGAffineTransform，是相对于原始的redview的fram的x，y坐标进行加减的平移。
 
       而原始的redview的frame不是你设置的frame，而是UIKit根据view当前的frame和view当前的transform来计算出的的，它认为这个才是原始的frame。
       譬如：当前frame的origin=（100，200），transform = (...,tx:50,ty:-60),那么它认为原始的frame的origin = (X:100-50,y:200+60) = (X:50,y:260),也就是它认为当前的frame是已经形变过一次的了，所以你每次都需要重置清零transform属性才能达到你想要的效果。
 
       transform是作为view的一个存储属性，所以每一次transform之后，transform的痕迹都会被记录下来，而UIKit的机制就是参考上一次的transform，来决定它认为的原始的view的frame。
 
       如果你要实现transform是相对于上一次形变之后的形变，那么你要用transform的translatedBy(x: , y: )方法 对view的transform属性 进行累加。
 
       使用CGAffineTransform.identity属性可以对transform进行重置清零，但是这一刻只是把view重置为它认为的原始位置，并且清零tranform属性，所以你最好是先清零，后自定义view的位置。
 
 
 */


class TestFrameAnimation_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 测试组件
    let imgView1 = UIImageView()
    let redView = UIView()
    let blueView = UIView()
    let scaleView = UIView()
    
    var imgArr = [UIImage]()    //图片数组
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试帧动画的VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }


}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestFrameAnimation_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、初始化图片数组
            print("     (@@  ")
            if imgArr.isEmpty {
                for i in 1 ..< 9 {
                    if let img = UIImage(named: "labi0\(i)") {
                        imgArr.append(img)
                    }
                }
                imgView1.image = UIImage(named:  "labi01")
            }
            break
        case 1:
            //TODO: 1、帧动画演示
            print("     (@@ 1、帧动画演示")
            imgView1.animationImages = imgArr   //设置动画的每一帧图片
            imgView1.animationRepeatCount = 3   //动画重复次数，0是无限循环
            imgView1.animationDuration = 1  //一次动画的时长
            imgView1.startAnimating()   //开始动画,动画结束后，不会保留数组的最后一张作为静态演示。
        case 2:
            //TODO: 2、渐变动画演示(逐渐变化)
            print("     (@@渐变动画从左到右")
            var preFrame = CGRect.init(origin: redView.frame.origin, size: redView.frame.size)
            preFrame.origin.x = 0
            redView.frame = preFrame
            /// 开始动画，在设置开始到设置结束之间设置动画的一些属性
            UIView.beginAnimations(nil, context: nil)
            /// 设置动画的属性，时长，变化位移，形变这些
            UIView.setAnimationDuration(2.0)
            redView.frame = CGRect.init(x: 300, y: preFrame.origin.y, width: preFrame.size.width, height: preFrame.size.height)
            ///提交动画
            UIView.commitAnimations()
            
            //用UIView的其他封装的方法进行动画。
            UIView.animate(withDuration: 2, delay: 2.5, options: .curveLinear) {
                [weak self] in
                self?.redView.frame = CGRect.init(x: 10, y: preFrame.origin.y, width: preFrame.size.width, height: preFrame.size.height)
            } completion: { isFinsh in
                print("动画延迟两秒，执行两秒，已完成：\(isFinsh)")
            }

            
        case 3:
            //TODO: 3、缩放动画测试
            print("     (@@ 缩放动画测试")
            let preFrame = CGRect.init(origin: scaleView.frame.origin, size: scaleView.frame.size)
            scaleView.frame = preFrame
            /// snpkit的约束会和动画效果冲突，所以你在动画前需要移除snpkit的约束条件。
            scaleView.snp.removeConstraints()
            UIView.animate(withDuration: 2.0, delay: 0, options: .curveEaseIn) {
                [weak self] in
                self?.scaleView.frame = CGRect.init(x: 24, y: preFrame.origin.y, width: 240, height: 80)
            } completion: { isFinsh in
                print("动画延迟两秒，执行两秒，缩放动画已完成：\(isFinsh)")
            }

        case 4:
            //TODO: 4、UIview的transform属性，形变。
            print("     (@@ 测试transform形变属性。+ 100 ")
            /// 平移，是相对于原始的redview的fram的x，y坐标进行加减的平移。transform属性并不会参考transform之后的frame，只会参考非transform之前的frame
            redView.transform = CGAffineTransform(translationX: 100, y: 100)
            print("     (@@ redview的frame是：\(redView.frame)")
            print("     (@@ redview的transform是：\(redView.transform)")
        case 5:
            //TODO: 5、transform形变 -50
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
            //TODO: 9、
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
extension TestFrameAnimation_VC{
   
    //MARK: 0、图片的三种加载方式，资源存放测试
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
extension TestFrameAnimation_VC{
    
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
        
        redView.layer.borderWidth = 1.0
        redView.layer.borderColor = UIColor.red.cgColor
        self.view.addSubview(redView)
        redView.snp.makeConstraints { make in
            make.top.equalTo(imgView1.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(40)
        }
        
        blueView.backgroundColor = .blue
        self.view.addSubview(blueView)
        blueView.snp.makeConstraints { make in
            make.top.equalTo(redView.snp.top)
            make.left.equalTo(redView.snp_right).offset(5)
            make.height.width.equalTo(30)
        }
        
        scaleView.layer.borderWidth = 1.0
        scaleView.backgroundColor = UIColor.gray
        scaleView.layer.borderColor = UIColor.purple.cgColor
        self.view.addSubview(scaleView)
        scaleView.snp.makeConstraints { make in
            make.top.equalTo(redView.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.height.equalTo(24)
            make.width.equalTo(24)
        }
    }
    
}


//MARK: - 设计UI
extension TestFrameAnimation_VC {
    
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
extension TestFrameAnimation_VC: UICollectionViewDelegate {
    
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



