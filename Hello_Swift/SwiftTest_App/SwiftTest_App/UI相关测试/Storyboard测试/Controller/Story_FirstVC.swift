//
//  Story_FirstVC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/2/8.
//  Copyright © 2022 com.mathew. All rights reserved.
//
//MARK: - 笔记
/**
    1、连线的话，要先绑定VC才可以连线，要么就是按住ctrl键，要么就是按住command键，要么就是不用按键。
    2、我也不知道为什么连线绑定按钮，和动作方法不管用，不知道是不是使用了第二window的问题。
        ：我也不知道是什么问题，之前是没有调用viewDidLoad方法，现在又好了，可能是xcode傻不拉几的原因。
 
 */

class Story_FirstVC: UIViewController {
    
    @IBOutlet weak var resignBtn:UIButton!  //辞去主key window的按钮
    @IBOutlet weak var nextBtn:UIButton!    //点击跳转下一个VC的按钮
    
    let testBtn = UIButton()

    override func viewDidLoad() {
        print("Story_FirstVC的\(#function)方法")
        self.title = "测试StoryBoard的导航FirstVC"
    }
    
    required init?(coder: NSCoder) {
        print("Story_FirstVC的\(#function)方法")
        super.init(coder: coder)
    }
    
}

@objc extension Story_FirstVC {
    
    func clickTestBtn(_ sender:UIButton){
        print("点击了测试的按钮")
    }
    
    @IBAction func clickResignBtn(_ sender:UIButton){
        print("点击了辞去key window的按钮")
        let app = UIApplication.shared.delegate as! AppDelegate
        app.firstWindow.resignKey()
        app.window?.makeKeyAndVisible()
        
    }
    
    @IBAction func clickNextBtn(_ sender:UIButton){
        // 点击了跳转下一个VC的按钮
        print("点击了跳转下一个VC的按钮")
    }
}


