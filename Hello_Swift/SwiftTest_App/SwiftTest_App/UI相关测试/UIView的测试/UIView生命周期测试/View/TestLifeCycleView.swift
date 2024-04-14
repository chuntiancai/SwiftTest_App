//
//  TestLifeCycleView.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/7/23.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试生命周期的View
//MARK: - 笔记
/**
 
 
 
 */

class TestLifeCycleView: UIView {

    //MARK: - 添加一个View的顺序
    //MARK: 添加顺序：1、即将添加到window上
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        print(" 1、TestLifeCycleView willMove toWindow:\(String(describing: newWindow))")
    }
    
    //MARK: 添加顺序：2、即将添加的父view上
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        print(" 2、TestLifeCycleView willMove toSuperview:\(String(describing: newSuperview))")
    }
    
    //MARK: 添加顺序：3、已经添加到window上
    override func didMoveToWindow() {
        super.didMoveToWindow()
        print("3、TestLifeCycleView didMoveToWindow")
    }
    
    //MARK: 添加顺序：4、已经添加到父view上
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        print(" 4、TestLifeCycleView didMoveToSuperview")
    }
    
    //MARK: 添加顺序：5 或 6，它与layoutSubviews是异步的，在不同的情况下被调用。draw是绘制内容，layoutSubviews是计算布局尺寸。
    /**
        1、有时候你内容没变，但是位置变了，就只调用layoutSubviews。有时候你内容变了，尺寸没变，就调用draw。
        2、手动调用setNeedsDisplay()方法，会调用draw方法。rect为零时，draw方法不被调用。
        3、初始化时，先调用layoutSubviews再调用draw，因为有尺寸之后，才知道在哪里绘制内容。
        4、若使用 UIView 绘图，只能在 drawRect：方法中获取相应的 contextRef 并绘图。如果在其他方法中获取将获取到一个 invalidate 的 ref 并且不能用于画图。
        5、添加子View到当前view的时候，不会调用draw方法，因为添加子视图主要涉及到视图层次结构（view hierarchy）的变更，而不是视图内容的绘制。
            所以调用draw方法的时机只会是自身的内容需要绘制的时候，例如字体，颜色，这些，都是操作自身layer的方法，才会导致draw的调用。
            调用贝塞尔曲线在当前layer绘制的时候，不会调用draw方法，因为你绘制的子layer也是添加到layer的层次中。
            但是你可以用贝塞尔曲线在draw方法中，获取上下文来绘制图形。
     */
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        print(" 5、TestLifeCycleView draw rect: \(rect)")
        
    }
    
    //MARK: 添加顺序：6，子View的布局多次发生变化，这里就会多次被调用。这里已经计算完布局约束了。
    /**
        1、只有布局/布局约束发生变化时，才会调用这个方法，如果布局和布局约束没有发生变化，则不会调用该方法，所以不用担心在这里修改约束会被多次调用。
        2、添加子view的时候，或者被添加到父view的时候，都会调用这个方法，因为位置发生了变化。
        3、layoutSubviews的调用并不意味着视图的内容会立即重绘，它只是布局子视图的位置和大小，如果视图的内容需要重绘，那么还需要调用draw(_:)方法。
        4、当使用Auto Layout时，snapkit也是这个机制，布局是通过一组约束来定义的，这些约束描述了视图之间和视图与其父视图之间的相对位置和大小关系。
            当这些约束发生变化时，比如添加、移除或修改约束，Auto Layout系统会自动计算受影响视图的新布局，并在必要时触发layoutSubviews的调用。
            这种布局更新通常是异步的，发生在当前事务（transaction）的提交阶段，以确保所有相关的布局变化能够一次性地、一致地应用。
            所以使用自动约束的时候，layoutSubviews并不是十分可控，因为是异步的。
            无论是否使用Auto Layout，都可以通过调用setNeedsLayout方法来标记视图需要布局更新，并在下一个更新周期中触发layoutSubviews的调用。
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        print("6、 TestLifeCycleView layoutSubviews")
        print(" TestLifeCycleView frame: \(self.frame)")
        for cons in self.constraints {
            print("TestLifeCycleView constraints : \(cons)")
//            self.removeConstraint(cons)
        }
//        self.snp.makeConstraints { make in
////            make.width.height.equalTo(150)
//            make.center.equalTo(CGPoint.init(x: 200, y: 200))
//        }

    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print("TestLifeCycleView hitTest")
        return super.hitTest(point, with: event)
    }

    //MARK:
    override func removeFromSuperview(){
        super.removeFromSuperview()
        print(" TestLifeCycleView removeFromSuperview")
    }
    override func insertSubview(_ view: UIView, at index: Int) {
        super.insertSubview(view, at: index)
    }
       
    override func exchangeSubview(at index1: Int, withSubviewAt index2: Int) {
        super.exchangeSubview(at: index1, withSubviewAt: index2)
        print(" TestLifeCycleView exchangeSubview")
    }

    override func addSubview(_ view: UIView) {
        super.addSubview(view)
        print(" TestLifeCycleView addSubview")
    }
    override func insertSubview(_ view: UIView, belowSubview siblingSubview: UIView) {
        super.insertSubview(view, belowSubview: siblingSubview)
        print(" TestLifeCycleView insertSubview")
    }
    override func insertSubview(_ view: UIView, aboveSubview siblingSubview: UIView) {
        super.insertSubview(view, aboveSubview: siblingSubview)
        print(" TestLifeCycleView insertSubview")
    }

    override func bringSubviewToFront(_ view: UIView) {
        super.bringSubviewToFront(view)
        print(" TestLifeCycleView bringSubviewToFront")
    }
    override func sendSubviewToBack(_ view: UIView) {
        super.sendSubviewToBack(view)
        print(" TestLifeCycleView sendSubviewToBack")
    }

    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        print(" TestLifeCycleView didAddSubview")
    }
    override func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)
        print(" TestLifeCycleView willRemoveSubview ")
    }


    override func isDescendant(of view: UIView) -> Bool {
        print(" TestLifeCycleView isDescendant of view:\(view)")
        return super.isDescendant(of: view)
    }
    override func viewWithTag(_ tag: Int) -> UIView? {
//        print(" TestLifeCycleView viewWithTag:\(tag)")
//        print(" TestLifeCycleView super.viewWithTag(tag): \(String(describing: super.viewWithTag(tag)))")
        return super.viewWithTag(tag)
    }// recursive search. includes self

    // Allows you to perform layout before the drawing cycle happens. -layoutIfNeeded forces layout early
    override func setNeedsLayout() {
        super.setNeedsLayout()
        print(" TestLifeCycleView setNeedsLayout")
    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        print(" TestLifeCycleView layoutIfNeeded")
    }
    
    
    override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()
        print(" TestLifeCycleView layoutMarginsDidChange")
    }
    
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        print(" TestLifeCycleView safeAreaInsetsDidChange")
    }
}

