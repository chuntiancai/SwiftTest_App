//
//  自定义测试字体渐变色的label.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/12/27.
//  Copyright © 2021 com.mathew. All rights reserved.
//

class GradientFontTestLabel: UILabel {
    //MARK: - 对外属性
    var name:String = "产品名称"{    //个股名称
        didSet{
            self.text = name
        }
    }
    
    var colorArr:[CGColor] = [UIColor(red: 0.97, green: 0.83, blue: 0.64, alpha: 1).cgColor, UIColor(red: 0.9, green: 0.66, blue: 0.45, alpha: 1).cgColor] {  //设置字体的渐变色
        didSet{
            gradientLayer.colors = colorArr
        }
    }
    
    //MARK: - 内部属性
    let gradientLayer = CAGradientLayer()   //渐变色绘制的layer
    private let gradientLayerView = UIView()  //容纳名字的渐变颜色layer的view

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
//        gradientLayerView.mask = self
        print("\n字体渐变色 在layoutSubviews中label的frame：\(self.frame)")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        print("\n字体渐变色 在draw方法中的rect：\(rect)")
        if let context = UIGraphicsGetCurrentContext() {
            self.textColor.set()
            let attStr = NSAttributedString.init(string: self.text ?? "", attributes: [NSAttributedString.Key.font:self.font ?? UIFont.systemFont(ofSize: 18)])
            attStr.draw(with: self.bounds, options: .usesLineFragmentOrigin, context: nil)
            let fontRect = attStr.size()
            
            // 坐标(只对设置后的画到 context 起作用, 之前画的文字不起作用),为什么坐标系要镜像反转？
            // 因为：Quartz中默认的坐标系统是：沿着x轴从左到右坐标值逐渐增大；沿着y轴从下到上坐标值逐渐增大。
            context.translateBy(x: 0.0, y: rect.size.height - (rect.size.height - fontRect.height) / 2);   //修改坐标原点
            context.scaleBy(x: 1.0, y: -1.0);   //坐标反转
            
            if let alphaMask = context.makeImage() {
                
                context.clear(rect); // 清除之前画的文字
                 // 设置mask
                context.clip(to: rect, mask: alphaMask);
            }
           
            
            
            // 画渐变色
            let colorSpace = CGColorSpaceCreateDeviceRGB();
            if let gradient = CGGradient(colorsSpace: colorSpace, colors: self.colorArr as CFArray, locations: nil){
                let startPoint = CGPoint(x: 0, y: 0)
                let endPoint = CGPoint(x: rect.maxX, y:rect.maxY)
                context.drawLinearGradient(gradient, start: startPoint, end: endPoint,options: [.drawsBeforeStartLocation,.drawsAfterEndLocation]);
            }
            

        }

        
    }
    
}

//MARK: - 设置UI
extension GradientFontTestLabel{
    //MARK: 设置初始化的UI
    func initDefaultUI(){
        ///名称文字的渐变颜色
//        namegradientLayerView.frame = CGRect(x: 25, y: 30, width: 250, height: 80)
        colorArr = [UIColor(red: 0.97, green: 0.83, blue: 0.64, alpha: 1).cgColor, UIColor(red: 0.9, green: 0.66, blue: 0.45, alpha: 1).cgColor]
//        gradientLayer.colors = colorArr
//        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
//        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
////        gradientLayer.frame = self.contentView.bounds
//        gradientLayerView.layer.addSublayer(gradientLayer)
//        self.addSubview(gradientLayerView)
//        gradientLayerView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
    }
}

//MARK: -
extension GradientFontTestLabel{
    
}

//MARK: -
extension GradientFontTestLabel{
    
}

//MARK: -
extension GradientFontTestLabel{
    
}

// MARK: - 笔记
/**
 
 */


