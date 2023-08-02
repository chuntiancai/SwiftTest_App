//
//  TestPageControl_View.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/7/20.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试PageControl的view
// MARK:  笔记
/**
    1、如果有snpkit布局，改变frame无效。则只能通过layer.bounds来改变位置和大小，layer.bounds.size也是有效。
        可以通过移除snp.removeConstraints()约束来使得frame的改变有效。
        也可以直接通过layer.bounds.size修改。
 */

class TestPageControl_View: UIView {
    //MARK: - 对外属性
    @objc var numberOfPages:Int = 0 {
        didSet{
            if numberOfPages <= 0 {
                self.isHidden = true
            }else{
                self.isHidden = false
            }
            initDotViewArrUI()
        }
    }
    
    var selectedDotColor:UIColor = UIColor(red: 0.87, green: 0.57, blue: 0.31, alpha: 1) //选中圆点的颜色
    var normalDotColor:UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1) //普通圆点的颜色

    @objc var currentPage:Int = 0 {
        didSet{
            setCurrentPageUI(oldVlaue: oldValue)
        }
    }
    
    @objc var selectedSize:CGSize = CGSize(width: 12, height: 4)
    @objc var normalSize:CGSize = CGSize(width: 4, height: 4)
    
    //MARK: - 内部属性
    private var dotViewArr = [UIView]()
    private var dotsContainerView = UIView()
    private var isFirstInitUI = true //是否是第一次完成初始化UI

    //MARK: - 复写方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        initDefaultUI()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if isFirstInitUI {
            isFirstInitUI = false
            initDotViewArrUI()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - 设置UI
extension TestPageControl_View{
    
    //MARK: 设置初始化的UI
    private func initDefaultUI(){
        
        self.clipsToBounds = false
        self.addSubview(dotsContainerView)
        dotsContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // 初始化小圆点数组的UI
    private func initDotViewArrUI(){
        
        for curView in dotViewArr {
            if curView.superview != nil { curView.removeFromSuperview() }
        }
        dotViewArr.removeAll()
        
//        let marginWidth = selectedSize.width + normalSize.width / 2
        /// 添加dotView
        for index in 0 ..< numberOfPages {
            let dotView = UIView()
            dotView.tag = 1000 + index
            dotView.layer.cornerRadius = 2.0
            dotView.backgroundColor = normalDotColor
            if index == currentPage {
                dotView.backgroundColor = selectedDotColor
            }
            dotsContainerView.addSubview(dotView)
            dotView.snp.makeConstraints { make in
                make.centerX.equalTo((CGFloat(index) + 0.5) * selectedSize.width)
                make.centerY.equalToSuperview()
                if index == currentPage {
                    make.width.equalTo(selectedSize.width)
                }else{
                    make.width.equalTo(normalSize.width)
                }
                make.height.equalTo(normalSize.height)
            }
            dotViewArr.append(dotView)
        }
        dotsContainerView.snp.remakeConstraints { make in
            make.height.equalTo(selectedSize.height + 10)
            make.width.equalTo(CGFloat(dotViewArr.count) * selectedSize.width )
            make.center.equalToSuperview()
        }
    }
    
    //设置选中点的UI
    private func setCurrentPageUI(oldVlaue:Int){
        
        if numberOfPages < 1 { return }
        let oldTag = (oldVlaue % numberOfPages + numberOfPages) % numberOfPages //对负数进行处理
        let preView = self.viewWithTag(oldTag + 1000)
        if preView == nil || preView?.frame == .zero {
            print("preView的frame为零")
            return
        }
        let targetTag = (currentPage % numberOfPages + numberOfPages) % numberOfPages //对负数进行处理
        let curView = dotsContainerView.viewWithTag(targetTag + 1000)
        
        /// snpkit的约束会和动画效果冲突，所以你在动画前需要移除snpkit的约束条件。
        /// snpkit会影响frame的布局，所以只能通过layer层来动画。
        UIView.animate(withDuration: 0.5) {
            preView?.backgroundColor = self.normalDotColor
            preView?.layer.bounds.size = self.normalSize
            
            curView?.backgroundColor = self.selectedDotColor
            curView?.layer.bounds.size = self.selectedSize
        }
        
    }
    
}







