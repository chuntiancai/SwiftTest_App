//
//  CHToast.swift
//  SwiftBluetooth_App
//
//  Created by Mathew Cai on 2021/1/21.
//  Copyright © 2021 com.mathew. All rights reserved.
//

import UIKit

let main_width = UIScreen.main.bounds.size.width
let main_height = UIScreen.main.bounds.size.height



//MARK: - init UI,初始化UI
class CHToast: NSObject {
    
    static let bgView: UIView = {
        
        return UIView()
    }()
    
    
    //MARK: 只带菊花的弹窗
    static var toastIndicatiorView : UIView?
    class func currentToastView() -> UIView {
        objc_sync_enter(self)
        if toastIndicatiorView == nil {
            toastIndicatiorView = UIView.init()
            toastIndicatiorView?.backgroundColor = UIColor.darkGray
            toastIndicatiorView?.layer.masksToBounds = true
            toastIndicatiorView?.layer.cornerRadius = 5.0
            toastIndicatiorView?.alpha = 0
            
            let indicatorView = UIActivityIndicatorView.init()
            indicatorView.tag = 10
            indicatorView.hidesWhenStopped = true
            indicatorView.color = UIColor.white
            toastIndicatiorView?.addSubview(indicatorView)
        }
        objc_sync_exit(self)
        return toastIndicatiorView!
    }
    
     //MARK: 只带文本的弹窗
    static var toastLabel : UILabel?
    class func currentToastLabel() -> UILabel {
        objc_sync_enter(self)
        if toastLabel == nil {
            toastLabel = UILabel.init()
            toastLabel?.backgroundColor = UIColor.darkGray
            toastLabel?.font = UIFont.systemFont(ofSize: 16)
            toastLabel?.textColor = UIColor.white
            toastLabel?.numberOfLines = 0;
            toastLabel?.textAlignment = .center
            toastLabel?.lineBreakMode = .byCharWrapping
            toastLabel?.layer.masksToBounds = true
            toastLabel?.layer.cornerRadius = 5.0
            toastLabel?.alpha = 0;
        }
        objc_sync_exit(self)
        return toastLabel!
    }
    
    //MARK: 带菊花、文本的弹窗
    static var toastViewWithLabel : UIView?
    class func currentToastViewLabel() -> UIView {
        objc_sync_enter(self)
        if toastViewWithLabel == nil {
            toastViewWithLabel = UIView.init()
            toastViewWithLabel?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            toastViewWithLabel?.layer.masksToBounds = true
            toastViewWithLabel?.layer.cornerRadius = 5.0
            toastViewWithLabel?.alpha = 0
            //菊花的背景框图
            let bgView = UIView()
            bgView.backgroundColor = UIColor.black
            bgView.alpha = 1
            bgView.layer.cornerRadius = 10
            bgView.tag = 9
            bgView.frame = CGRect.init(x: 0, y: 0, width: 200, height: 120)
            toastViewWithLabel?.addSubview(bgView)
            bgView.center = CGPoint(x: main_width/2, y: main_height/2)
            
            //菊花图
            let indicatorView = UIActivityIndicatorView.init()
            indicatorView.tag = 10
            indicatorView.hidesWhenStopped = true
            indicatorView.color = UIColor.white
            toastViewWithLabel?.addSubview(indicatorView)
            
            //文本消息label
            let aLabel = UILabel.init()
            aLabel.tag = 11
            aLabel.backgroundColor = UIColor.clear
            aLabel.font = UIFont.systemFont(ofSize: 16)
            aLabel.textColor = UIColor.white
            aLabel.textAlignment = .center
            aLabel.lineBreakMode = .byCharWrapping
            aLabel.layer.masksToBounds = true
            aLabel.layer.cornerRadius = 5.0
            aLabel.numberOfLines = 0;
            toastViewWithLabel?.addSubview(aLabel)
        }
        objc_sync_exit(self)
        return toastViewWithLabel!
    }
    
    
}


//MARK: - 对外提供的方法
extension CHToast {
    
    //MARK: 显示菊花(默认一直显示)
    /// - Parameter aShowTime: 显示的持续时间，如果为nil则一直显示
    class func showIndicator(aShowTime: Double? = nil) {
        if Thread.main.isMainThread {
            toastIndicatiorView = self.currentToastView()
            toastIndicatiorView?.removeFromSuperview()
            let AppDlgt = UIApplication.shared.delegate as! AppDelegate
            AppDlgt.window?.addSubview(toastIndicatiorView!)  //添加到window上
            
            
            let indicatorView = toastIndicatiorView?.viewWithTag(10) as! UIActivityIndicatorView
            indicatorView.center = CGPoint.init(x: 70/2, y: 70/2)
            indicatorView.startAnimating()
            toastIndicatiorView?.frame = CGRect.init(x: (main_width-70)/2, y: (main_height-70)/2, width: 70, height: 70)
            toastIndicatiorView?.alpha = 1
            if aShowTime != nil {
                //如果不为空，就经过aShowTime之后隐藏菊花
                UIView.animate(withDuration: aShowTime!, animations: {
                    toastIndicatiorView?.alpha = 0.98
                }, completion: {
                    (finished:Bool) in
                    //如果真的是因为动画结束才引起执行的completion闭包，那就是true，如果有其他动画插进来引起的completion，就是false
                    if finished {
                        self.hideIndicator()
                    }
                    
                })
            }
            
        }else{
            DispatchQueue.main.async {
                self.showIndicator(aShowTime: aShowTime)
            }
            return
        }
    }
    
    //MARK: 默认显示文本消息-->center，默认显示2秒
    /// 默认显示文本消息-->center，默认显示2秒
    class func showToastLabelAction(message : NSString, aShowTime: TimeInterval = 2.0) {
        self.showToastLabel(message: message, aLocationStr: "center", aShowTime: aShowTime)
    }
    
    //MARK:  显示文本消息,默认一直显示
    /// - Parameters:显示文本消息，默认显示两秒
    ///   - message: 文本内容
    ///   - aLocationStr: 文本位置
    ///   - aShowTime: 文本显示的持续时间，如果为nil则一直显示
    class func showToastLabel(message : NSString?, aLocationStr : NSString?, aShowTime : TimeInterval? = nil) {
        if Thread.current.isMainThread {
            toastLabel = self.currentToastLabel()
            toastLabel?.removeFromSuperview()
            
            let AppDlgt = UIApplication.shared.delegate as! AppDelegate
            AppDlgt.window?.addSubview(toastLabel!)
            
            var width = self.stringText(aText: message, aFont: 16, isHeightFixed: true, fixedValue: 40)
            var height : CGFloat = 0
            if width > (main_width - 20) {
                width = main_width - 20
                height = self.stringText(aText: message, aFont: 16, isHeightFixed: false, fixedValue: width)
            }else{
                height = 40
            }
            
            var labFrame = CGRect.zero
            if aLocationStr != nil, aLocationStr == "top" {
                labFrame = CGRect.init(x: (main_width-width)/2, y: main_height*0.15, width: width, height: height)
            }else if aLocationStr != nil, aLocationStr == "bottom" {
                labFrame = CGRect.init(x: (main_width-width)/2, y: main_height*0.85, width: width, height: height)
            }else{
                //default-->center
                labFrame = CGRect.init(x: (main_width-width)/2, y: main_height*0.5, width: width, height: height)
            }
            toastLabel?.frame = labFrame
            toastLabel?.text = message as String?
            toastLabel?.alpha = 1
           
            //经过aShowTime时间动画结束
            if aShowTime != nil {
                UIView.animate(withDuration: aShowTime!, animations: {
                    toastLabel?.alpha = 0;
                }, completion: {
                    (finished:Bool) in
                })
            }
            
        }else{
            DispatchQueue.main.async {
                self.showToastLabel(message: message, aLocationStr: aLocationStr, aShowTime: aShowTime)
            }
            return
        }
    }
    
    
    
    //MARK: 显示(带菊花的消息)-->default center，默认3秒隐藏
    /// 显示(带菊花的消息)-->default center，默认3秒隐藏
    /// - Parameter message: 显示的信息
    class func showIndicatorToastAction(message : NSString) {
        self.showIndicatorToast(message: message, aShowTime: 3.0)
    }
    
    //MARK: 显示(带菊花的消息)
    /// 显示带有菊花、文本的弹窗，默认一直显示
    /// - Parameters:
    ///   - message: 文本内容
    ///   - aLocationStr: 文本位置，默认文本在下
    ///   - aShowTime: 显示的持续时间，如果为nil则一直显示
    class func showIndicatorToast(message : NSString?, aShowTime : TimeInterval? = nil) {
        if Thread.current.isMainThread {
            toastViewWithLabel = self.currentToastViewLabel()
            let appDlgt = UIApplication.shared.delegate as! AppDelegate
            
            if toastViewWithLabel?.superview !== appDlgt.window {  //如果父view不是winow,则添加到window上
                toastViewWithLabel?.removeFromSuperview()
                appDlgt.window?.addSubview(toastViewWithLabel!)
            }
            
            
            var width = self.stringText(aText: message, aFont: 16, isHeightFixed: true, fixedValue: 40)
            var height : CGFloat = 0
            if width > (main_width - 20) {
                width = main_width - 20
                height = self.stringText(aText: message, aFont: 16, isHeightFixed: false, fixedValue: width)
            }else{
                height = 40
            }
            
            toastViewWithLabel?.frame = UIScreen.main.bounds
            toastViewWithLabel?.isUserInteractionEnabled = true
            toastViewWithLabel?.alpha = 0.5
            
            let indicatorView = toastViewWithLabel?.viewWithTag(10) as! UIActivityIndicatorView
            indicatorView.center = CGPoint.init(x: main_width/2, y: (main_height - height)/2)
            indicatorView.startAnimating()
            
            let aLabel = toastViewWithLabel?.viewWithTag(11) as! UILabel
            aLabel.frame = CGRect.init(x: (main_width - width)/2, y: main_height/2, width: width, height: height)
            aLabel.text = message as String?
            
            //菊花的背景框
            let bgView = toastViewWithLabel?.viewWithTag(9)
            bgView?.frame = CGRect.init(x: 0, y: 0, width: width + 20, height: height + 80)
            bgView?.center = CGPoint.init(x: main_width/2, y: main_height/2)
            
            if aShowTime != nil {
                //经过aShowTime时间动画结束，隐藏弹窗
                UIView.animate(withDuration: aShowTime!, animations: {
                    toastViewWithLabel?.alpha = 0.51    //必须有一些属性变化，不然completion立马执行
                }, completion: {
                    (finished:Bool) in
                    print("动画结束\(finished)")
                     //如果真的是因为动画结束才引起执行的completion闭包，那就是true，如果有其他动画插进来引起的completion，就是false
                    if finished {
                        self.hideIndicatorToast()
                    }
                    
                })
            }
            
        } else {
            DispatchQueue.main.async {
                self.showIndicatorToast(message: message, aShowTime: aShowTime)
            }
            return
        }
    }
    //MARK: 隐藏菊花
    /// 隐藏菊花
    class func hideIndicator() {
        if toastIndicatiorView != nil {
            let indicatorView = toastIndicatiorView?.viewWithTag(10) as! UIActivityIndicatorView
            indicatorView.stopAnimating()
            toastIndicatiorView?.alpha = 0
            toastIndicatiorView?.removeFromSuperview()
        }
    }
    
    
    //MARK: 隐藏(带菊花、文本的弹窗)
    /// 隐藏(带菊花、文本的弹窗)
    class func hideIndicatorToast() {
        if toastViewWithLabel != nil {
            let indicatorView = toastViewWithLabel?.viewWithTag(10) as! UIActivityIndicatorView
            indicatorView.stopAnimating()
            toastViewWithLabel?.alpha = 0
            toastViewWithLabel?.removeFromSuperview()
        }
    }
    
}

//MARK: - config，工具方法
extension CHToast {
    
    //根据字符串长度获取对应的宽度或者高度
    class func stringText(aText : NSString?, aFont : CGFloat, isHeightFixed : Bool, fixedValue : CGFloat) -> CGFloat {
        var size = CGSize.zero
        if isHeightFixed == true {
            size = CGSize.init(width: CGFloat(MAXFLOAT), height: fixedValue)
        }else{
            size = CGSize.init(width: fixedValue, height: CGFloat(MAXFLOAT))
        }
        //返回计算出的size
        let resultSize = aText?.boundingRect(with: size, options: (NSStringDrawingOptions(rawValue: NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue | NSStringDrawingOptions.truncatesLastVisibleLine.rawValue)), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: aFont)], context: nil).size
        if isHeightFixed == true {
            return resultSize!.width + 20 //增加左右20间隔
        } else {
            return resultSize!.height + 20 //增加上下20间隔
        }
    }
}

