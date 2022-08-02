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
 */

class SubTabBar:UITabBar{
    
    /// 为了展示高亮状态
    let myBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "tab_vedio"), for: .normal)
        btn.setImage(UIImage(named: "labi03"), for: .highlighted)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(myBtn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("UITabBar的子View：\(self.subviews)")
        /// 在中间添加一个按钮。
        
        /// 自定义的btn并不会加入到self.items里面
        let btnCount = (self.items?.count ?? 0) + 1
        let btnW = self.bounds.width / CGFloat(btnCount)
        let btnH = self.bounds.height
        var i = 0
        
        //FIXME: UITabBarButton重新创建的bug
        /// 移动UITabBarButton的位置，UITabBarButton是私有类，用户不可见。
        /// 这里有一个bug，就是UITabBarButton的顺序不是从左到右，而且UITabBarButton会被销毁切换。
        for view in self.subviews {
            if !view.isKind(of: NSClassFromString("UITabBarButton")!){
                continue
            }
            if i == 2 { i += 1 }    ///放在中间的位置。
            view.frame = CGRect(x: btnW * CGFloat(i), y: 0, width: btnW, height: btnH)
            i += 1
            print("当前的view：\(view)")
        }
        myBtn.frame = CGRect(x: btnW * 2, y: 0, width: btnW, height: btnH)
       
        
    }
    
    
}
