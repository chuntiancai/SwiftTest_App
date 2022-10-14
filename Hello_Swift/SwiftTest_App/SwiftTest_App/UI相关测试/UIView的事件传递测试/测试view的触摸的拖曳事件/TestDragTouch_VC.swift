//
//  TestDragTouch_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/2/11.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试拖曳事件的VC
// MARK: - 笔记
/**
 
 */

class TestDragTouch_VC: UIViewController {
    
    //MARK: 测试组件
    var redView = DragTouch_View()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试拖曳事件的VC"
        
        setNavigationBarUI()
        initTestViewUI()
    }


}

//MARK: - 设置测试的UI
extension TestDragTouch_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        redView.backgroundColor = .red
        self.view.addSubview(redView)
        redView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(50)
        }
    }
    
}

//MARK: - 测试的方法
extension TestDragTouch_VC{
   
    //MARK: 0、
    func test0(){
        
    }
    //MARK: 1、
    func test1(){
        
    }
    //MARK: 2、
    func test2(){
        
    }
    
}





//MARK: - 设计UI
extension TestDragTouch_VC {
    
    /// 设置导航栏的UI
    private func setNavigationBarUI(){
        
        ///布局从导航栏下方开始
        self.edgesForExtendedLayout = .bottom
        
        //设置子页面的navigation bar的返回按钮样式
        let backItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = .black
    }
    
}



