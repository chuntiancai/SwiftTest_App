//
//  TestScrollView_deleagate.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/1/16.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试scrollView的datasource

class TestScrollView_deleagate: NSObject, UIScrollViewDelegate {
    
    override init() {
        super.init()
        print("TestScrollView_deleagate初始化啦～")
    }
    
    //MARK: ScrollView正在滚动
    func scrollViewDidScroll(_ scrollView: UIScrollView){
//        print("TestScrollView_deleagate的\(#function)方法～")
    }
    
    //MARK: ScrollView的缩放因子已经发生改变
    func scrollViewDidZoom(_ scrollView: UIScrollView){
        print("TestScrollView_deleagate的\(#function)方法～")
    }
    
    
    
    // called on start of dragging (may require some time and or distance to move)
    //MARK: ScrollView将要开始拖拽
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
        print("TestScrollView_deleagate的\(#function)方法～")
    }
    
    
    // called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
    //MARK: ScrollView将要结束拖拽
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>){
        print("TestScrollView_deleagate的scrollViewDidZoom方法～")
    }
    
    
    // called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
    //MARK: ScrollView已经结束拖拽
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool){
        print("TestScrollView_deleagate的\(#function)方法，接下来是否加速：\(decelerate)～")
    }
    
    
    //MARK: ScrollView将要开始加速
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView){
        print("TestScrollView_deleagate的\(#function)方法～")
    }
    
    //MARK: ScrollView已经结束加速
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        print("TestScrollView_deleagate的\(#function)方法～")
    }
    
    
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView){
        print("TestScrollView_deleagate的\(#function)方法～")
    }
    
    
    //MARK: 你通过这个方法告诉ScrollView，你要缩放ScrollView里面的哪个子View
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        print("TestScrollView_deleagate的\(#function)方法～")
        let subView = scrollView.viewWithTag(10086) //缩放图片
        return subView
    }
    
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?){
        print("TestScrollView_deleagate的\(#function)方法～")
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print("TestScrollView_deleagate的\(#function)方法～")
    }
    
    
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool{
        print("TestScrollView_deleagate的\(#function)方法～")
        return true
    }
    
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        print("TestScrollView_deleagate的\(#function)方法～")
    }
    
    
    
    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView){
        print("TestScrollView_deleagate的\(#function)方法～")
    }
    
    
}

//MARK: - 笔记
/**
    1、UIScrollViewDelegate的调用顺序:
        手指按下 --> 调用scrollViewWillBeginDragging(_:)方法，表示将要开始拖拽。
        手指拖拽 --> 调用scrollViewDidScroll(_:)方法，表示已经开始拖拽，正在滚动。
                    同时也调用viewForZooming(in:)方法，表示需要你通过该方法告诉scrollview，你要缩放哪个子view。
        手指松开 --> 调用scrollViewDidZoom方法，表示缩放因子已经发生改变。(由拖拽状态变成其他状态)
        手指按松开之后 --> 调用scrollViewDidEndDragging(_:willDecelerate:)方法，表示拖拽状态已经结束。
                        调用scrollViewWillBeginDecelerating(_:)方法，表示由拖拽状态变成加速状态(减速)。
                        继续调用scrollViewDidScroll(_:)方法，表示scrollView还在滚动，但此时是加速度状态下的滚动。
                        调用scrollViewDidEndDecelerating(_:)方法，表示减速状态已经结束了（加速状态下的滚动也已经结束了）。
 
    2、通过设置scrollView的maximumZoomScale缩放因子，可以实现缩放效果。
        缩放的话，是缩放contentSize的尺寸。
 */
