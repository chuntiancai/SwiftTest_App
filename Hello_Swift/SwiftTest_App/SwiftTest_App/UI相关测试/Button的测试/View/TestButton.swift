//
//  TestButton.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/9/13.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试上图下文按钮的view

class TestButton: UIButton {
    //MARK: - 对外属性
    
    
    //MARK: - 内部属性

    //MARK: - 复写方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        initDefaultUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 扩大Button的点击范围
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        super.point(inside: point, with: event)
        var bounds = self.bounds
        let x: CGFloat = -10
        let y: CGFloat = -10
        let width: CGFloat = bounds.width + 20
        let height: CGFloat = bounds.height + 20
        bounds = CGRect(x: x, y: y, width: width, height: height) //负值是方法响应范围
        return bounds.contains(point)
    }
    
    //MARK: 复写父类方法实现上图下文。
    /**
        1、复写方法中的contentRect，会根据外界的设置发生变化。
        2、在系统调用这些方法的时候，label和imageView还没创建，所以不可以访问。
        3、在layoutSubviews中设置label和imageView的frame
     */
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        print("按钮标题复写方法中的内容坐标是：\(contentRect)")
        return CGRect.init(x: 0, y: 0, width: contentRect.width, height: contentRect.height / 2)
    }
    
    //TODO: 设置按钮的图片默认的Frame
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        print("按钮图片复写方法中的内容坐标是：\(contentRect)")
        let midY = contentRect.midY
        return CGRect.init(x: 0, y: midY, width: contentRect.width, height: contentRect.height / 2)
    }
    override func layoutSubviews() {
        self.titleLabel?.frame = CGRect.init(x: 0, y: 0, width: 40, height: 20)
        self.imageView?.frame = CGRect.init(x: 20, y: 25, width: 20, height: 40)
    }
    
}

//MARK: - 设置UI
extension TestButton{
    
    //MARK: 初始化默认的UI
    func initDefaultUI(){
        setUpImageDownText()
    }
    
}

//MARK: - 测试的方法
extension TestButton{
    
    //MARK: 通过内边距，设置上图下文
    func setUpImageDownText(){
        /// 收益明细
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
        self.addTarget(self, action: #selector(tapBtnAction(sender:)), for: .touchUpInside)
        self.setTitle("收益明细", for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 12)
        self.setTitleColor(.black, for: .normal)
        self.setImage(UIImage(named: "sec_账单"), for: .normal)
        
        self.imageView?.layer.borderColor = UIColor.orange.cgColor
        self.imageView?.layer.borderWidth = 1.0
        
        self.titleLabel?.layer.borderColor = UIColor.brown.cgColor
        self.titleLabel?.layer.borderWidth = 1.0
        ///设置按钮的图片居中，标题在下,是相对于过去的内边距偏移,默认是图左文右,还有一点点误差。左偏移之后，右边也必须负偏移，不然会有计算误差。
        let imageWidth = self.imageView?.intrinsicContentSize.width
        let imageHeight = self.imageView?.intrinsicContentSize.height
        let labelHeight = self.titleLabel?.intrinsicContentSize.height
        let labelWidth = self.titleLabel?.intrinsicContentSize.width
        self.imageEdgeInsets = UIEdgeInsets(top: -labelHeight!, left: (labelWidth!/2 - imageWidth!/2) + imageWidth!/2, bottom: labelHeight!, right: ( imageWidth!/2 - labelWidth!/2))
        self.titleEdgeInsets = UIEdgeInsets(top: imageHeight!, left: -imageWidth! + imageWidth!/2, bottom: -imageHeight!, right: imageWidth!)
        
    }
    
    
}

//MARK: - 动作方法
@objc extension TestButton{
    /// 点击了按钮的动作方法
    func tapBtnAction(sender:UIButton){
        print("点击了TestButton按钮的动作方法")
    }
}

//MARK: -
extension TestButton{
    
}

// MARK: - 笔记
/**
    1、可以通过修改内边距,设置按钮上图下文。
    2、可以通过复写父类的方法设置上图下文，要注意此时还没有可以访问里面的label和imageView，因为是先给尺寸，然后才有对象创建。
    3、也可以在layoutSubview方法中，赋值给label和imageView的frame。
 */
