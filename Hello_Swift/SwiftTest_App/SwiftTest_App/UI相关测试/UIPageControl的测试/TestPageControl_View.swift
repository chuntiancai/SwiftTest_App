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
    1、如果有snpkit布局，改变frame无效。则只能通过ayer.bounds来改变位置和大小，layer.bounds.size也是有效。
        可以通过移除snp.removeConstraints()约束来使得frame的改变有效。
        也可以直接通过layer.bounds.size修改。
 */

class TestPageControl_View: UIView {
    //MARK: - 对外属性
    @objc var numberOfPages:Int = 0 {
        didSet{
            if numberOfPages <= 0 {
                self.isHidden = true
            }
            self.isHidden = false
            for curView in dotViewArr {
                if curView.superview != nil { curView.removeFromSuperview() }
            }
            dotViewArr.removeAll()
            
            let marginWidth = selectedSize.width + normalSize.width / 2
            /// 添加dotView
            for index in 0 ..< numberOfPages {
                let dotView = UIView()
                dotView.tag = 1000 + index
                dotView.layer.cornerRadius = 2.0
                dotView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
                if index == currentPage {
                    dotView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
                }
                dotsContainerView.addSubview(dotView)
                dotView.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(marginWidth / 2 + CGFloat(index) * marginWidth )
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
                make.width.equalTo(marginWidth / 2 + CGFloat(dotViewArr.count) * marginWidth )
                make.center.equalToSuperview()
            }
            
            
        }
    }
    
    @objc var currentPage:Int = 0 {
        didSet{
            if currentPage < 0 || currentPage >=  dotViewArr.count {
                currentPage = oldValue
                print("当前设置的页数大于数组的个数")
                return
            }
            let preView = self.viewWithTag(oldValue + 1000)
            if preView == nil || preView?.frame == .zero {
                print("preView的frame为零")
                return
            }
            let curView = dotsContainerView.viewWithTag(currentPage + 1000)
            
            /// snpkit的约束会和动画效果冲突，所以你在动画前需要移除snpkit的约束条件。
            /// snpkit会影响frame的布局，所以只能通过layer层来动画。
            UIView.animate(withDuration: 0.5) {
                preView?.backgroundColor = UIColor.white.withAlphaComponent(0.3)
                preView?.layer.bounds.size = self.normalSize
                
                curView?.backgroundColor = UIColor.white.withAlphaComponent(0.8)
                curView?.layer.bounds.size = self.selectedSize
            }
            
        }
    }
    
    @objc var selectedSize:CGSize = CGSize(width: 10, height: 4)
    @objc var normalSize:CGSize = CGSize(width: 4, height: 4)
    
    //MARK: - 内部属性
    private var dotViewArr = [UIView]()
    private var dotsContainerView = UIView()

    //MARK: - 复写方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        if frame == .zero {
            self.frame = CGRect.init(x: 0, y: 0, width: 60, height: 10)
        }
        self.clipsToBounds = false
        initDefaultUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - 设置UI
extension TestPageControl_View{
    //MARK: 设置初始化的UI
    func initDefaultUI(){
        dotsContainerView.layer.borderWidth = 0.5
        dotsContainerView.layer.borderColor = UIColor.red.cgColor
        self.addSubview(dotsContainerView)
        dotsContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

//MARK: - 动作方法
@objc extension TestPageControl_View{
    
}

//MARK: -
extension TestPageControl_View{
    
}
