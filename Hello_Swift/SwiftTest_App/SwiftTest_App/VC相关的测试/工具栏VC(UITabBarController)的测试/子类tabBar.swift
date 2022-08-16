//
//  继承tabBar.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/8/1.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 继承UITabBar，自定义自己的UITabBar，但是同时使用系统的UITabBar功能。
// MARK: - 笔记
/**
    1、需要在系统的tabBarButton添加到UITabBar上之前，把自己的SubTabBar替换成系统的UITabBar。
    2、系统的tabBarButton是在UITabBarController的viewWillAppear方法中添加的。
    3、UITabBarButton是系统私有的类，没有暴露给用户使用。
    4、自定义的UI控件不应该承受业务逻辑，而是自己的事情自己做，通知，代理，闭包。
 */

class SubTabBar:UITabBar{
    
    /// 为了展示高亮状态
    private let myBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "tab_vedio"), for: .normal)
        btn.setImage(UIImage(named: "labi03"), for: .highlighted)
        return btn
    }()
    
    private var preBarBtn:UIControl?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(myBtn)
        myBtn.addTarget(self, action: #selector(clickBarBtnAction), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("SubTabBar 布局之前的子View：\(self.subviews)")
        /// 在中间添加一个按钮。
        
        /// 自定义的btn并不会加入到self.items里面
        let btnCount = (self.items?.count ?? 0) + 1
        let btnW = self.bounds.width / CGFloat(btnCount)
        var btnH = self.bounds.height
        
        
        //FIXME: UITabBarButton重新创建的bug，subviews顺序不正确的bug。
        /**
            1、移动UITabBarButton的位置，UITabBarButton是私有类，用户不可见。
            2、这里有一个bug，就是UITabBarButton的顺序不是从左到右。而且遇到naviVC好像UITabBarButton会被销毁切换(待验证)。
            3、因为subviews中的顺序不确定，所以要通过X的值来计算顺序.
         */
        
        if let orgCount = self.items?.count {
            if orgCount > 0 {
                let orgWidth = self.bounds.width / CGFloat(orgCount)
                for view in self.subviews {
                    if !view.isKind(of: NSClassFromString("UITabBarButton")!){ continue  }
                    /// 因为subviews中的顺序不确定，所以要通过X的值来计算顺序
                    let orgX = view.frame.minX
                    var index:Int = Int(orgX / orgWidth)
                    if index >= orgCount / 2 { index += 1 }     //空出中间的位置。
                    if let barBtn = view as? UIControl {
                        barBtn.addTarget(self, action: #selector(clickBarBtnAction), for: .touchUpInside)
                    }
                    view.tag = 1000 + index
                    btnH = view.bounds.height
                    view.frame = CGRect(x: btnW * CGFloat(index), y: 0, width: btnW, height: view.bounds.height)
                    view.layer.borderColor = UIColor.blue.cgColor
                    view.layer.borderWidth = 1.0
                }
                /// 设置自定义的中间按钮
                myBtn.tag = 1000 + orgCount / 2
                myBtn.frame = CGRect(x: btnW * CGFloat(orgCount / 2), y: 0, width: btnW, height: btnH)
            }
        }
        
        
        print("SubTabBar 布局之后的子View：\(self.subviews)")
    }
}

//MARK: - 动作方法
@objc extension SubTabBar{
  
    /// 处理重复点击
    func clickBarBtnAction(_ sender: UIButton){
        print("点击了myBtn方法: \(sender.tag)")
        if sender == preBarBtn {
            print("重复点击了barBtn")
            /// 发布重复点击的通知
            NotificationCenter.default.post(name: NSNotification.Name("ClickRepeatBarBtn"), object: ["tag":sender.tag])
        }
        preBarBtn = sender
        
    }
    
}
