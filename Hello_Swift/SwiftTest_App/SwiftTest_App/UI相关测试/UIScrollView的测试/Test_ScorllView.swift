//
//  Test_ScorllView.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/1/16.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 用于测试的ScorllView

class Test_ScorllView: UIScrollView {
    //MARK: - 对外属性
    
    
    //MARK: - 内部属性

    //MARK: - 复写方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("Test_ScorllView初始化啦～")
        initDefaultUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - 设置UI
extension Test_ScorllView{
    //MARK: 设置初始化的UI
    func initDefaultUI(){
        
    }
}

//MARK: -
extension Test_ScorllView{
    
}

//MARK: -
extension Test_ScorllView{
    
}

//MARK: -
extension Test_ScorllView{
    
}

// MARK: - 笔记
/**
    1、下拉刷新，是把菊花图设置在scrollView的负数坐标系里，别忘了，负坐标系也是可以布局的。
    2、scrollView的subviews数组，子view的下标位置是不一定的，因为需要不断地调整子view。
    3、scrollview的坐标系还是以contentsize为标准，contentInset虽然可以显示内边距，但是只是在contentSize四周加上了边距而已，不对坐标系造成影响。contentInset应用场景是在初始化的时候留空白，为了滚动效果好看而已，滚动完之后可以重新设置为.zero。
 
 */
