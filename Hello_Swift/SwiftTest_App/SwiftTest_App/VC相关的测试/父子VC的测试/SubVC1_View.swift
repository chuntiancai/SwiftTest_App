//
//  SubVC1_View.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/8/19.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 被测试作为VC的View

import UIKit

class SubVC1_View: UIView {

    //MARK: - 添加一个View的顺序
    //MARK: 添加顺序：1 、即将添加到window上
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        print(" © SubVC1_View willMove toWindow:\(String(describing: newWindow))")
    }
    
    //MARK: 添加顺序：2
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        print(" © SubVC1_View willMove toSuperview:\(String(describing: newSuperview))")
    }
    
    //MARK: 添加顺序：3
    override func didMoveToWindow() {
        super.didMoveToWindow()
        print(" © SubVC1_View didMoveToWindow")
    }
    
    //MARK: 添加顺序：4
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        print(" © SubVC1_View didMoveToSuperview")
    }
    
    //MARK: 添加顺序：5 或 6，它与layoutSubviews是异步的，在不同的情况下被调用
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        print(" © SubVC1_View draw rect: \(rect)")
    }
    
    //MARK: 添加顺序：6，子View的布局多次发生变化，这里就会多次被调用。这里已经计算完布局约束了。
    override func layoutSubviews() {
        super.layoutSubviews()
        print(" © SubVC1_View layoutSubviews")
        print(" © SubVC1_View frame: \(self.frame)")
        for cons in self.constraints {
            print("SubVC1_View constraints : \(cons)")
//            self.removeConstraint(cons)
        }
//        self.snp.makeConstraints { make in
////            make.width.height.equalTo(150)
//            make.center.equalTo(CGPoint.init(x: 200, y: 200))
//        }

    }
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let isInside = super.point(inside: point, with: event)
        print(" © SubVC1_View 的 point(inside 方法，在这里:\(isInside)")
        return isInside
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print("SubVC1_View hitTest")
        return super.hitTest(point, with: event)
    }

    //MARK:
    override func removeFromSuperview(){
        super.removeFromSuperview()
        print(" © SubVC1_View removeFromSuperview")
    }
    override func insertSubview(_ view: UIView, at index: Int) {
        super.insertSubview(view, at: index)
    }
       
    override func exchangeSubview(at index1: Int, withSubviewAt index2: Int) {
        super.exchangeSubview(at: index1, withSubviewAt: index2)
        print(" © SubVC1_View exchangeSubview")
    }

    override func addSubview(_ view: UIView) {
        super.addSubview(view)
        print(" © SubVC1_View addSubview")
    }
    override func insertSubview(_ view: UIView, belowSubview siblingSubview: UIView) {
        super.insertSubview(view, belowSubview: siblingSubview)
        print(" © SubVC1_View insertSubview")
    }
    override func insertSubview(_ view: UIView, aboveSubview siblingSubview: UIView) {
        super.insertSubview(view, aboveSubview: siblingSubview)
        print(" © SubVC1_View insertSubview")
    }

    override func bringSubviewToFront(_ view: UIView) {
        super.bringSubviewToFront(view)
        print(" © SubVC1_View bringSubviewToFront")
    }
    override func sendSubviewToBack(_ view: UIView) {
        super.sendSubviewToBack(view)
        print(" © SubVC1_View sendSubviewToBack")
    }

    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        print(" © SubVC1_View didAddSubview")
    }
    override func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)
        print(" © SubVC1_View willRemoveSubview ")
    }

    
    

    override func isDescendant(of view: UIView) -> Bool {
        print(" © SubVC1_View isDescendant of view:")
        return super.isDescendant(of: view)
    }
    override func viewWithTag(_ tag: Int) -> UIView? {
        print(" © SubVC1_View viewWithTag:\(tag)")
        print(" © SubVC1_View super.viewWithTag(tag): \(String(describing: super.viewWithTag(tag)))")
        return super.viewWithTag(tag)
    }// recursive search. includes self

    // Allows you to perform layout before the drawing cycle happens. -layoutIfNeeded forces layout early
    override func setNeedsLayout() {
        super.setNeedsLayout()
        print(" © SubVC1_View setNeedsLayout")
    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        print(" © SubVC1_View layoutIfNeeded")
    }
    
    
    override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()
        print(" © SubVC1_View layoutMarginsDidChange")
    }
    
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        print(" © SubVC1_View safeAreaInsetsDidChange")
    }
}
