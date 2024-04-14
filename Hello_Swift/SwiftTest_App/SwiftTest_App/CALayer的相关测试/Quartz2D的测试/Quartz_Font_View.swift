//
//  Quartz_Font_View.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/2/17.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 利用quartz技术绘制文字的View
// MARK: - 笔记
/**
    1、NSString，NSAttributedString都有绘制文字的draw方法，String没有。
    2、关于NSAttributedString.Key的类型，你要看注释文档，注释文档里有说这对应着什么类型。一般是NSNumber之类的。
    3、NSShadow的shadowColor属性是UIColor，不是CGColor。
 */

class Quartz_Font_View: UIView {
    //MARK: - 对外属性
    
    
    //MARK: - 内部属性

    //MARK: - 复写方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        initDefaultUI()
    }
    
    override func draw(_ rect: CGRect) {
        /// 1、设置字体的样式
        let fontStr = NSMutableAttributedString(string: "蜡笔小新———蜡笔小新———蜡笔小新———蜡笔小新———蜡笔小新———蜡笔小新")
        var attDict = [NSAttributedString.Key:Any]()
        attDict[NSAttributedString.Key.font] = UIFont.systemFont(ofSize:30)
//        attDict[NSAttributedString.Key.foregroundColor] = UIColor.yellow.cgColor
        /// 字体描边，看注释文档，strokeColor默认跟随foregroundColor，你要设置strokeWidth时strokeColor才有效，这是字体的描边，也就是字体中空。
        attDict[NSAttributedString.Key.strokeColor] = UIColor.blue.cgColor
        attDict[NSAttributedString.Key.strokeWidth] = 2
        
        ///设置字体的阴影
        let fontShadow = NSShadow.init()
        fontShadow.shadowColor = UIColor.purple //设置阴影的颜色
        fontShadow.shadowOffset = CGSize.init(width: 5, height: 2) //设置阴影的偏移
        fontShadow.shadowBlurRadius = 5 //设置阴影的模糊度，模糊程度是以模糊半径来计算的。
        
        attDict[NSAttributedString.Key.shadow] = fontShadow
        
        fontStr.addAttributes(attDict, range: NSRange.init(location: 0, length: fontStr.string.count))
        
        
        
        /// 2、绘制到view的坐标系上
//        fontStr.draw(at: .zero) //这个不会自动换行绘制。
        fontStr.draw(in: rect)  //这个会自动换行绘制。
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - 设置UI
extension Quartz_Font_View{
    //MARK: 设置初始化的UI
    func initDefaultUI(){
        
    }
}

//MARK: -
extension Quartz_Font_View{
    
}

//MARK: -
extension Quartz_Font_View{
    
}


