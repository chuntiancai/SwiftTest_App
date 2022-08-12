//
//  Test_UITestFied.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/8/12.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试UITestFied的UITestFied
// MARK: - 笔记
/**
    1、 监听文本框编辑: 1.代理 2.通知 3.target
        原则:不要自己成为自己代理,优先用target模式。
            代理的本义是自己的事情让别人去做，而且代理只能一个，所以不要让自己成为代理。
 
 */


class Test_UITestFied: UITextField {
    //MARK: - 对外属性
    
    
    //MARK: - 内部属性
    //TODO: kvc设置占位文字的颜色
    var myPlaceHolderColor:UIColor {
        set{
            /**
             1、快速设置占位文字颜色 => 文本框占位文字可能是label => 验证占位文字是label => 拿到label => 查看label属性名(1.runtime 2.断点)
                可以通过断点获取到系统的私有属性的名字，声明一个UITextField，然后断点到声明语句，查看内部属性。
                let textField = UITextField()
             2、但是通过KVC设置的占位文字的label必须要在设置label的文字时才可以获取到，runtime是延时加载。
             */
           
            if let label:UILabel = self.value(forKey: "placeholderLabel") as? UILabel {
                print("set获取到的label：\(label)")
                label.textColor = newValue
            }
        }
        get{
            if let label:UILabel = self.value(forKey: "placeholderLabel") as? UILabel {
                print("get获取到的label：\(label)")
                return label.textColor
            }else{  return .clear  }
        }
    }
    

    //MARK: - 复写方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        initDefaultUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - 设置UI
extension Test_UITestFied{
    //MARK: 设置初始化的UI
    func initDefaultUI(){
        
        //TODO: 设置属性
        self.tintColor = .red   /// 设置光标的颜色
        
        ///监听文本框编辑
        self.addTarget(self, action: #selector(textBeginAction), for: .editingDidBegin)
        self.addTarget(self, action: #selector(textEndAction), for: .editingDidEnd)
        
        
        
    }
    
    
}


//MARK: - 动作方法
@objc extension Test_UITestFied{
    
    func textBeginAction(){
        print("开始编辑：\(#function)")
    }
    
    func textEndAction(){
        print("结束编辑：\(#function)")
    }
    
}

//MARK: - 工具方法，制造UI小组件
extension Test_UITestFied{
    
}
