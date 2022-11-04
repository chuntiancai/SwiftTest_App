//
//  测试文字的自适应高度.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/3/31.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试 label 的自适应高度。

class TestAdaptSize_Label: UILabel {
    //MARK: - 对外属性
    var name:String = "" {
        didSet{
            self.text = name
//            self.sizeToFit()
            let bsetSize = self.sizeThatFits(CGSize(width: 100, height: 60))
//            self.layoutIfNeeded()
//            self.setNeedsLayout()
            print("最合适尺寸sizeThatFits：\(bsetSize)")
            print("改变label的文字，此时label还没有在屏幕上:\(self.intrinsicContentSize)")
            
            //TODO:计算文字自适应高度
            var nameHeight:CGFloat = 18.0
            let attrStr = NSAttributedString.init(string: name, attributes: [.font:UIFont.systemFont(ofSize: 20)])
            let nameSize = attrStr.boundingRect(with: CGSize(width: UIScreen.main.bounds.width * 250 / 375.0, height: 812), options: .usesLineFragmentOrigin, context: nil)
            nameHeight = nameSize.height
            print("通过NSAttributedString计算文字的自适应高度：\(nameHeight)")
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("TestAdaptSize_Label 的 \(#function) 方法～")
    }
    
    override var intrinsicContentSize: CGSize{
        get{
            print("TestAdaptSize_Label 的 \(#function):\(super.intrinsicContentSize) 属性～")
            return super.intrinsicContentSize
        }
    }
    
}

//MARK: - 设置UI
extension TestAdaptSize_Label{
    //MARK: 设置初始化的UI
    func initDefaultUI(){
        
    }
}

//MARK: - 动作方法
@objc extension TestAdaptSize_Label{
    
}

//MARK: -
extension TestAdaptSize_Label{
    
}

// MARK: - 笔记
/**
    1、调用layoutIfNeeded()方法，立马更新布局约束，不等下一个周期里面更新UI，这和直接设置frame的效果是一样的。
    2、调用setNeedsLayout()方法，则表示当前修改的约束还没应用到frame上，也就是frame的值还是之前的， 要等到下一个UI周期才会应用到frame上。在layoutSubview时更新？
    3、调用sizeToFit()方法，只针对特定的View起作用，例如label一开始你没有设置frame，然后就添加到view上去了，然后你这时候调用label的sizeToFit()方法， 就可以计算出这个label的位置和尺寸了，这个方法只是为没有设置frame的view计算最适合的尺寸，然后放到位置上，没什么卵用。
    
    5、intrinsicContentSize属性，只与Label的font有关，与其他因素无关，因为它的定义就是去掉所有其他影响(frame,bounds)时，的自然尺寸是多少。
        设置了label的text之后，马上就会去计算intrinsicContentSize的大小。但是只计算一行的大小，不考虑换行的情况。考虑换行则用sizeThatFits(_:CGSize)方法。
    4、调用sizeThatFits(_:CGSize)方法，根据文字的内容来计算最适合label的尺寸，只是返回最适合的尺寸，但是不改变label的尺寸。
        sizeThatFits(_:CGSize)方法，如果你想固定宽度，那就传很大的高度。如果你想固定高度，那就传很大的宽度。
    
    5、NSAttributedString的boundingRect(_:,...)方法,可以计算文字的自适应高度，类似sizeThatFits(_:CGSize)的效果。
 
 */
