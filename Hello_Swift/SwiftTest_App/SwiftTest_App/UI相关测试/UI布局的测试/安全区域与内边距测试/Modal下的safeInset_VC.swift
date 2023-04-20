//
//  测试Modal下的safeInset_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2023/4/20.
//  Copyright © 2023 com.mathew. All rights reserved.
//
// 测试模态下展示的VC的安全内边距
//MARK: - 笔记
/**
 
 */

class TestSafeInset_ModalVC: UIViewController {
    
    //MARK: 对外属性

    ///UI组件
    
    //MARK: 测试组件
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        self.title = "测试Modal内边距的子VC"
        initTestViewUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("TestSafeInset_ModalVC 的 \(#function) 方法～")
    }
    
    override func viewSafeAreaInsetsDidChange() {
        print("TestSafeInset_ModalVC 的 \(#function) 方法～")
    }
    
    override func viewWillLayoutSubviews() {
        print("TestSafeInset_ModalVC的\(#function)方法")
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        print("TestSafeInset_ModalVC的\(#function)方法")
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("TestSafeInset_ModalVC的\(#function)方法")
        super.viewDidAppear(animated)
    }
    
    
    
}



//MARK: - 测试的方法
extension TestSafeInset_ModalVC{
   
    //MARK: 0、
    func test0(){
        
    }
    
}


//MARK: - 设置测试的UI
extension TestSafeInset_ModalVC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
    }
    
}
