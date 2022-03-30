//
//  TextField的点击测试(键盘弹起).swift
//  SwiftTest_App
//
//  Created by mathew on 2021/12/13.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试TextField的点击事件(键盘弹起)，第一响应者

import UIKit

class TestTextFileldEvent_View: UIView {
    //MARK: - 对外属性
    
    //MARK: - 内部属性
    let textField = UITextField()   //作为子view的UITextField

    //MARK: - 复写方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        initDefaultUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print("TestTextFileldEvent_View 的  \(#function)  方法")
        return super.hitTest(point, with: event)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let isInside = super.point(inside: point, with: event)
        /// 如果点击的不是自己，则收起键盘
        if !isInside {
            self.textField.resignFirstResponder()
        }
        print("TestTextFileldEvent_View 的  \(#function)方法---\(isInside)")
        return isInside
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("TestTextFileldEvent_View 的 \(#function) 方法")
        super.touchesBegan(touches, with: event)
    }
}

//MARK: - 设置UI
extension TestTextFileldEvent_View{
    //MARK: 设置初始化的UI
    func initDefaultUI(){
        textField.keyboardType = .numberPad
        textField.returnKeyType = .done
        textField.font = .systemFont(ofSize: 16)
        textField.textColor = .gray
        textField.delegate = self
        textField.placeholder = "请输入你的文字"
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.gray.cgColor
        //输入框尾部是否需要清除按钮
        textField.clearButtonMode = .whileEditing
        //是否密码输入模式
        textField.isSecureTextEntry = true
        self.addSubview(textField)
        textField.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.height.equalTo(50)
        }
        
        textField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
}



//MARK: - textField的动作事件
@objc extension TestTextFileldEvent_View{
    /// 编辑发生了变化时的动作事件
    func editingChanged(_sender:UITextField){
        print("TestTextFileldEvent_View 监听到的textField事件：\(#function)")
    }
}

//MARK: -
extension TestTextFileldEvent_View{
    
}

//MARK: - 遵循协议-UITextFieldDelegate
extension TestTextFileldEvent_View:UITextFieldDelegate{
    
    // return NO to disallow editing.
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        print("UITextFieldDelegate 的 \(#function) 代理方法")
        return true
    }
    
    // became first responder
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("UITextFieldDelegate 的 \(#function) 代理方法")
    }
    
    // 这个代理必须返回true才能结束UITextField的编辑状态，不然一直收不回键盘
    // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("UITextFieldDelegate 的 \(#function) 代理方法")
        return true
    }
    
    // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("UITextFieldDelegate 的 \(#function) 代理方法")
        
    }
    
    // if implemented, called in place of textFieldDidEndEditing:
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        print("UITextFieldDelegate 的 \(#function) 代理方法")
        
    }
    
    /// return NO to not change text；replacementString是：点击了键盘上的按钮，是否把该按钮的字符输入到textfield当中。
    ///shouldChangeCharactersIn是指当前按钮字符将要输入的位置。或者将要删除的字符的位置。
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("UITextFieldDelegate 的\(#function)代理方法")
        return true
    }
    
    
    /// textField的输入光标发生了移动，就会调用该方法。
    func textFieldDidChangeSelection(_ textField: UITextField){
        print("UITextFieldDelegate 的 \(#function) 代理方法")
    }
    
    /// 当textField的清除按钮被点击的时候，是否清除textField的内容。结合textField的clearButtonMode属性使用。
    // called when clear button pressed. return NO to ignore (no notifications)
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("UITextFieldDelegate 的 \(#function) 代理方法")
        return true
    }
    
    // 点击了键盘上的 'return' 按钮，通过返回值确定是否收起键盘。
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("UITextFieldDelegate 的 \(#function) 代理方法")
        return false
    }
}

// MARK: - 笔记
/**
    1、UITextField会拦截VC的touchBegan方法，所以可以直接在VC的touchBegan方法中收起键盘（辞去第一响应者）。
 
    2、为什么textFied作为自定义view的子view时，textField.resignFirstResponder()不起作用，不会收起键盘？
        ：这是因为你在textFieldShouldEndEditing代理方法中返回false，阻止了它辞去第一响应者，前后矛盾了，它以代理方法的判断为主。
 */
