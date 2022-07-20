//
//  TestBounds_View.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/7/20.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试bounds的View
// MARK: - 笔记
/**
    1、
 */
class TestBounds_View: UIView {
    
    //MARK: - 对外属性、
    var isChangeBoundsSize:Bool = false {   /// 是否改变bounds的尺寸
        didSet{
//            self.frame.size = CGSize(width: self.bounds.size.width + 5,height: self.bounds.size.height + 10)
            let frame = self.frame
            self.frame = CGRect.init(x: frame.minX, y: frame.minY, width: self.bounds.size.width + 5, height: self.bounds.size.height + 10)
        }
    }
    
    
    //MARK: - 内部属性

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
extension TestBounds_View{
    //MARK: 设置初始化的UI
    func initDefaultUI(){
        
    }
}

//MARK: - 动作方法
@objc extension TestBounds_View{
    
}

//MARK: -
extension TestBounds_View{
    
    func setBoundSize(){
        let bounds = self.bounds
        self.bounds = CGRect(x: bounds.minX, y: bounds.minY, width: bounds.size.width + 5, height: bounds.size.height + 10)
        print("设置后的bounds：\(self.bounds)")
    }
    
}

// MARK: - 笔记
/**
 
 */

