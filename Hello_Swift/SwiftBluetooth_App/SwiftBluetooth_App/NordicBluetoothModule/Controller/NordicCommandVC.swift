//
//  NordicCommandVC.swift
//  SwiftBluetooth_App
//
//  Created by Mathew Cai on 2021/2/3.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// nordic设备的命令交互的VC

import UIKit

class NordicCommandVC: UIViewController {
    
    //MARK: 对外属性
    
    //MARK: 内部属性
    ///UI组件
    private var cmdTextField: UITextField = UITextField() //命令文本
    private var deleteBtn:UIButton = UIButton() //删除文本按钮
    private var sendCmdBtn:UIButton = UIButton()  //发送命令按钮
    
    //MARK: 复写父类的方法
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        setTopLogViewUI()
        setTextFiledUI()
        setBtnViewUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NordicCommon.sharedLogView.appendText = "Welcome to NordicCommandVC ！"
    }
    
}

//MARK: - 设置UI
extension NordicCommandVC {
    
    /// 设计顶部的打印log的UI
    private func setTopLogViewUI(){
        if NordicCommon.sharedLogView.superview != nil {
            NordicCommon.sharedLogView.removeFromSuperview()
        }
        NordicCommon.sharedLogView.frame = CGRect(x:10, y:0, width:SCREEN_WIDTH - 20,height:220)
        NordicCommon.sharedLogView.layer.cornerRadius = 10.0
        self.view.addSubview(NordicCommon.sharedLogView)
    }
    
    /// 设置文本的UI
    private func setTextFiledUI(){
        cmdTextField.delegate = self
        cmdTextField.borderStyle = .roundedRect
        cmdTextField.textAlignment = .left
        self.view.addSubview(cmdTextField)
        cmdTextField.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(230)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(60)
        }
    }
        
    /// 设置两个按钮的UI
    private func setBtnViewUI(){
        ///删除文本按钮
        deleteBtn.setTitle("取消", for: .normal)
        deleteBtn.addTarget(self, action: #selector(deleteTextAction), for: .touchUpInside)
        deleteBtn.backgroundColor = .gray
        deleteBtn.layer.cornerRadius = 10
        self.view.addSubview(deleteBtn)
        deleteBtn.snp.makeConstraints { (make) in
            make.top.equalTo(cmdTextField.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(40)
            make.height.equalTo(60)
            make.width.equalTo(100)
        }
        
        ///发送命令按钮
        sendCmdBtn.setTitle("发送", for: .normal)
        sendCmdBtn.addTarget(self, action: #selector(sendCmdAction), for: .touchUpInside)
        sendCmdBtn.backgroundColor = .gray
        sendCmdBtn.layer.cornerRadius = 10
        self.view.addSubview(sendCmdBtn)
        sendCmdBtn.snp.makeConstraints { (make) in
            make.top.equalTo(deleteBtn.snp.top)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(60)
            make.width.equalTo(100)
        }
    }
}


//MARK: - 动作方法
@objc extension NordicCommandVC {
    ///  取消按钮的动作方法
    private func deleteTextAction(){
        print("点击了删除文本按钮")
        self.cmdTextField.text = nil
    }
    
    ///  重新搜索按钮的动作方法
    private func sendCmdAction(){
        print("textfield的内容是：\(String(describing: cmdTextField.text))")
        if cmdTextField.text != nil {
          NordicCommon.sharedLogView.appendText = "   @@发送命令：\(cmdTextField.text!)"
        }
        
    }
}



//MARK: - 遵循text委托协议，
extension NordicCommandVC: UITextFieldDelegate {
    
    ///允许复制粘贴功能
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return true
        }
        if action == #selector(UIResponderStandardEditActions.select(_:)) {
            return true
        }
        if action == #selector(UIResponderStandardEditActions.selectAll(_:)) {
            return true
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()    //辞去第一响应者，收回键盘
        return true
    }
    
}
