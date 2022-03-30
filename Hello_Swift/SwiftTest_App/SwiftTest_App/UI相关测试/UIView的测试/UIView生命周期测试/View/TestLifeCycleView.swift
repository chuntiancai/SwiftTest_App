//
//  TestLifeCycleView.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/7/23.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试生命周期的View

import UIKit

class TestLifeCycleView: UIView {

    //MARK: - 添加一个View的顺序
    //MARK: 添加顺序：1、即将添加到window上
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        print(" TestLifeCycleView willMove toWindow:\(String(describing: newWindow))")
    }
    
    //MARK: 添加顺序：2、即将添加的父view上
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        print(" TestLifeCycleView willMove toSuperview:\(String(describing: newSuperview))")
    }
    
    //MARK: 添加顺序：3、已经添加到window上
    override func didMoveToWindow() {
        super.didMoveToWindow()
        print(" TestLifeCycleView didMoveToWindow")
    }
    
    //MARK: 添加顺序：4、已经添加到父view上
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        print(" TestLifeCycleView didMoveToSuperview")
    }
    
    //MARK: 添加顺序：5 或 6，它与layoutSubviews是异步的，在不同的情况下被调用。draw是绘制内容，layoutSubviews是计算布局尺寸。
    /// 有时候你内容没变，但是位置变了，就只调用layoutSubviews。有时候你内容变了，尺寸没变，就调用draw。
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        print(" TestLifeCycleView draw rect: \(rect)")
    }
    
    //MARK: 添加顺序：6，子View的布局多次发生变化，这里就会多次被调用。这里已经计算完布局约束了。
    override func layoutSubviews() {
        super.layoutSubviews()
        print(" TestLifeCycleView layoutSubviews")
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
        print(" TestLifeCycleView viewWithTag:\(tag)")
        print(" TestLifeCycleView super.viewWithTag(tag): \(String(describing: super.viewWithTag(tag)))")
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
//MARK: - 笔记
/**
 
 
 
 */
