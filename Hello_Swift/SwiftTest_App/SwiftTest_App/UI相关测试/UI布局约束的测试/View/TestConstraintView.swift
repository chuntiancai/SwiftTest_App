//
//  TestConstraintView.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/7/23.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试布局约束的View，同时也是测试生命周期了。

import UIKit

class TestConstraintView: UIView {

    //MARK: - 添加一个View的顺序
    //MARK: 添加顺序：1
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        print(" TestConstraintView willMove toWindow:\(String(describing: newWindow))")
    }
    
    //MARK: 添加顺序：2
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        print(" TestConstraintView willMove toSuperview:\(String(describing: newSuperview))")
    }
    
    //MARK: 添加顺序：3
    override func didMoveToWindow() {
        super.didMoveToWindow()
        print(" TestConstraintView didMoveToWindow")
    }
    
    //MARK: 添加顺序：4
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        print(" TestConstraintView didMoveToSuperview")
    }
    
    //MARK: 添加顺序：5 或 6，它与layoutSubviews是异步的，在不同的情况下被调用
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        print(" TestConstraintView draw rect: \(rect)")
    }
    
    //MARK: 添加顺序：6、frame发生改变，UIKit才会调用该方法
    override func layoutSubviews() {
        super.layoutSubviews()
        print(" TestConstraintView 的 \(#function) 方法")
        print(" TestConstraintView frame: \(self.frame)")
        for cons in self.constraints {
            print("TestConstraintView constraints 约束 : \(cons)")
//            self.removeConstraint(cons)
        }
//        self.snp.makeConstraints { make in
////            make.width.height.equalTo(150)
//            make.center.equalTo(CGPoint.init(x: 200, y: 200))
//        }

    }

    //MARK:
    override func removeFromSuperview(){
        super.removeFromSuperview()
        print(" TestConstraintView \(#function) 方法～")
    }
    override func insertSubview(_ view: UIView, at index: Int) {
        super.insertSubview(view, at: index)
    }
       
    override func exchangeSubview(at index1: Int, withSubviewAt index2: Int) {
        super.exchangeSubview(at: index1, withSubviewAt: index2)
        print(" TestConstraintView \(#function) 方法～")
    }

    override func addSubview(_ view: UIView) {
        super.addSubview(view)
        print(" TestConstraintView \(#function) 方法～")
    }
    override func insertSubview(_ view: UIView, belowSubview siblingSubview: UIView) {
        super.insertSubview(view, belowSubview: siblingSubview)
        print(" TestConstraintView \(#function) ")
    }
    override func insertSubview(_ view: UIView, aboveSubview siblingSubview: UIView) {
        super.insertSubview(view, aboveSubview: siblingSubview)
        print(" TestConstraintView \(#function) 方法～")
    }

    override func bringSubviewToFront(_ view: UIView) {
        super.bringSubviewToFront(view)
        print(" TestConstraintView \(#function) 方法～")
    }
    override func sendSubviewToBack(_ view: UIView) {
        super.sendSubviewToBack(view)
        print(" TestConstraintView \(#function) 方法～")
    }

    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        print(" TestConstraintView \(#function) 方法～")
    }
    override func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)
        print(" TestConstraintView \(#function)  方法～")
    }

    
    

    override func isDescendant(of view: UIView) -> Bool {
        print(" TestConstraintView isDescendant of view:\(view)")
        return super.isDescendant(of: view)
    }
    override func viewWithTag(_ tag: Int) -> UIView? {
        print(" TestConstraintView viewWithTag:\(tag)")
        print(" TestConstraintView super.viewWithTag(tag): \(String(describing: super.viewWithTag(tag)))")
        return super.viewWithTag(tag)
    }// recursive search. includes self

    // Allows you to perform layout before the drawing cycle happens. -layoutIfNeeded forces layout early
    override func setNeedsLayout() {
        super.setNeedsLayout()
        print(" TestConstraintView \(#function) 方法～")
    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        print(" TestConstraintView \(#function) 方法～")
    }
    
    
    override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()
        print(" TestConstraintView \(#function) 方法～")
    }
    
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        print(" TestConstraintView \(#function) 方法～")
    }
}


/**
 问题解答：
 1、约束计算的时机，为什么是1000的宽度？snpkit的影响？transform的影响？
     答：transform不影响任何生命周期，因为旋转的时候，view的位置尺寸都已经确定了，1000的宽度是snpkit的计算问题，snpkit在move to superview之后才去计算尺寸，如果是硬编码确定frame(手写)，那么此时就已经确定了frame。 snpkit是在layoutsubview时才完全计算好尺寸。 同时硬编码和snpkit的话，会调用两次layoutsbview，因为每一次设置frame都会调用layoutsubview，draw的方法，是绘制到屏幕上时才调用，会在layoutsbuview之后，因为有了尺寸，才知道在哪里绘制。
 
 2、Snpkit对layoutsubview的影响？
    答：每次重新通过Snpkit设置布局约束，都会回调layoutsubview方法。重新设置布局的约束是，使用Snpkit的remarkConstraints就不会产生布局冲突，这个方法会移除之前的布局约束，从而重新添加布局的约束。重新计算布局约束意味着subview的frame发生改变，所以会回调layoutsubview。
 
 3、View在transform旋转后，frame会发生变化吗？
    答：会，但是View也多了一个transform属性，没旋转的时候，这个属性为空。所以你可以复原旋转，设置View的transform属性为view.transform = CGAffineTransform.identity
 */
