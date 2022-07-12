//
//  TestSubVC_SubVC3.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/3/31.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试VC的初始化方法
//MARK: - 笔记
/**
    1、重写构造器，必须在构造器内调用父类的指定构造器，VC有指定构造器是init(nibName: nil, bundle: nil)。
 
 */

class TestSubVC_SubVC3: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "重写构造器的VC"
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    init() {
        print("初始化子VC--\(#function)")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

