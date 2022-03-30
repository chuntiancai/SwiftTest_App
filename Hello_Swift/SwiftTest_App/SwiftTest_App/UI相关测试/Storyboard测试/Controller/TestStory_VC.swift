//
//  TestStory_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/1/5.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试storyboard的主VC

import UIKit

class TestStory_VC: UIViewController {
    
    @IBOutlet weak var redBtn:UIButton!
    @IBOutlet weak var yellowBtn:UIButton!
    @IBOutlet weak var blueBtn:UIButton!
    @IBOutlet weak var testLabel:UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    var glassEffectBar:UIToolbar = UIToolbar() //用作毛玻璃效果
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "测试storyboard的主VC"
//        self.view.backgroundColor = .cyan
        // Do any additional setup after loading the view.
    }
    
    required init?(coder: NSCoder) {
        print("TestStory_VC的\(#function)方法")
        super.init(coder: coder)
    }
    

}

//MARK: 动作方法
@objc extension TestStory_VC{
    
    @IBAction func clickRedButtonAction(sender:UIButton){
        print("点击了红色的按钮～")
        testLabel.textColor = .red
        // 设置UIImageView的isHighlighted状态
        imgView.isHighlighted = !imgView.isHighlighted
    }
    
    @IBAction func clickYellowButtonAction(sender:UIButton){
        print("点击了黄色的按钮～")
        
        //制作毛玻璃效果
        if glassEffectBar.superview == nil {
            imgView.addSubview(glassEffectBar)
            let image = imgView.image
            imgView.frame = CGRect.init(x: imgView.frame.minX, y: imgView.frame.minY, width: image?.size.width ?? 80, height: image?.size.height ?? 40)
            imgView.center = CGPoint.init(x: self.view.bounds.width / 2, y: 180)
            glassEffectBar.frame = imgView.bounds
            glassEffectBar.barStyle = .blackTranslucent
            glassEffectBar.alpha = 0.8
        }else{
            glassEffectBar.removeFromSuperview()
        }
        testLabel.textColor = .yellow
    }
    
    @IBAction func clickBlueButtonAction(sender:UIButton){
        print("点击了蓝色的按钮～")
        testLabel.textColor = .blue
    }
  
    @IBAction func clickPurpleBtn(sender:UIButton){
        print("点击了紫色的按钮～")
        let storyBoard = UIStoryboard.init(name: "testStory", bundle: nil)
        let storyVC = storyBoard.instantiateViewController(withIdentifier: "TestStory1_ID")
        self.navigationController?.pushViewController(storyVC, animated: true)
    }
    
}

//MARK: - 笔记
/**
    1、 //通过代码加载storyboard，UIStoryboard初始化参数的name是storyboard再在工程目录中的名字，而不是在storyboard文件中的名字。
       //storyboard文件中的名字就是Storyboard ID，这个表示这个Storyboard本身，也是Storyboard绑定的VC的ID，通过这个来初始化Storyboard的VC
            let storyBoard = UIStoryboard.init(name: "mainStoryTest", bundle: nil)
            let mainStoryVC = storyBoard.instantiateViewController(withIdentifier: "TestStory_VC_ID")
 
    2、@IBAction的是方法，跟storyboard中的control控件进行连线，绑定事件的方法。不可以跟View控件连线。
       @IBOutlet的是属性，跟storyboard中的控件进行连线。
 
    3、毛玻璃效果，UIToolbar这个控件本来就有毛玻璃效果，它本来是用来作为底部工具栏的控价，自带毛玻璃效果，所以我们可以直接拿来用。

    4、UIimageView的frame可以通过image的size来设置。这样就可以保持图片原来的大小了。
 
    5、在storyboard页面，按住cmd+opt+鼠标点击，就可以跳转到vc代码页面，且分页显示。
 */
