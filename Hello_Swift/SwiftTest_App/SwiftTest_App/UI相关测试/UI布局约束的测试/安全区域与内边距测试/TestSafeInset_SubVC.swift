//
//  TestSafeInset_SubVC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/5/11.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试安全内边距的子VC

class TestSafeInset_SubVC: UIViewController {
    
    //MARK: 对外属性

    ///UI组件
    
    //MARK: 测试组件
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        self.title = "测试安全内边距的子VC"
        initTestViewUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("TestSafeInset_SubVC 的 \(#function) 方法")
    }
    
    override func viewSafeAreaInsetsDidChange() {
        print("TestSafeInset_SubVC 的 \(#function) 方法")
    }
    
    override func viewWillLayoutSubviews() {
        print("TestSafeInset_SubVC的\(#function)方法")
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        print("TestSafeInset_SubVC的\(#function)方法")
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("TestSafeInset_SubVC的\(#function)方法")
        super.viewDidAppear(animated)
    }
    
    
    
}



//MARK: - 测试的方法
extension TestSafeInset_SubVC{
   
    //MARK: 0、
    func test0(){
        
    }
    
}


//MARK: - 设置测试的UI
extension TestSafeInset_SubVC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
    }
    
}




// MARK: - 笔记
/**
    1、
 
 */
