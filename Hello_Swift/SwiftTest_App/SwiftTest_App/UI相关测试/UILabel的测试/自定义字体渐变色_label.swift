//
//  自定义测试字体渐变色的label.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/12/27.
//  Copyright © 2021 com.mathew. All rights reserved.
//
//MARK: - 笔记
/**
    1、draw(_ rect:)方法里的rect是参考自身的坐标系。rect是一块画布，坐标系是坐标系，是把画布放在坐标系上。
        UIKit的坐标系是以rect画布的左上角开始定义坐标系的，也就是以rect的左上角为原点，向右绘制x轴，向下绘制y轴。
        Quartz的坐标系是以rect画布的左下角开始定义坐标系的，也就是以rect的左上角为原点，向右绘制x轴，向上绘制y轴。
        所以，如果要转化坐标系，则需要移动rect画布，因为坐标系一旦定义了，就不可以改变了，也是rect画布只是在初始化的时候定义了坐标系位置，之后坐标系再也不变。
        注意：
            如果draw(rect:)方法的起始点是(-5,-6)就说明当前rect画布的左上角在坐标系的(-5,-6)处，如果需要原点对应左上角，则需要移动画布。
            同时，说明了context是在(-5,-6)处就开始绘制了的。
        
    2、在draw(_ rect:)方法里都是参考UIKit的坐标系，只是context.makeImage()生成图片时，会机械地转化Quartz的坐标系。（特例方法）
        所以，你需要在context.makeImage()之前，先逆转换成Quartz的坐标系，然后再被makeImage()机械地转换成Quartz的坐标系，很绕。
        要注意context的绘制起点，相应的转化也要找到对应的起点。也是如果rect画布的起点是(-5,-6)，那么Quartz转换前要移动到(-5,rect.maxY-6)，然后再反转。
        UIKit坐标系提前转换为Quartz的坐标系：
                注意：context.translateBy(x: y:)方法是移动坐标系的原点。
            1.先找到draw(_ rect: CGRect)方法中，rect画布的左上角，所在坐标系的坐标，也就是rect.origin。
            2.把画布绘制起点设置到对应的左下角，而且要保持与draw(_ rect:)在UIkit坐标系的绘制起点相对应。也就是(-5,height-6)。
                把画布的左下角移动到坐标系的原点中。也可以理解为把坐标系原点移动到画布的左上角。
 
                context.translateBy(x: rect.minX, y: rect.maxY + rect.minY)   //把坐标原点移动到画布的左下角，且绘制起点要对应。
                                            //因为rect.maxY是画本左下角偏离坐标原点的距离。也就是左下角对应起点要与左上角对应的起点称中心Y对称。
                
            3.此时，画布仍然是在UIKit的坐标系下。但是已经是在右上方的象限中了。y轴坐标向下。
            4.对画布的坐标系进行Y轴反转，反转之后，画布依然是在坐标系右上方的象限中，只不过y轴的坐标系统是和Quartz的坐标系统一样的了，也就是y轴坐标向上。
                context.scaleBy(x: 1.0, y: -1.0);   //坐标反转
 
            5.此时如果是在UIKit坐标系的视角下，那么绘制出的文字就是上下颠倒，镜像对称。
                但是调用context.makeImage()方法生成的图像，刚好再次地颠倒回来，也就是恢复正常了。
 
        3、一句话终结：
            你可以理解为画布是无限大的，然后坐标系是用来定位画布的位置和制定范围的。
            context.makeImage()调用之前，context会把文字绘制在rect=(-5,-6,100,50)的矩形内，方向是UIKit的坐标系统，y轴向下。
            context.makeImage()调用之后，context会截取在rect=(-5,-6,100,50)的矩形内的图像，但是方向是Quartz的坐标系统，y轴向上。
            所以，你需要在context.makeImage()调用之前，把UIKit坐标系下的绘制的内容移动到Quartz的坐标系统截取的位置和范围。
            也就是所谓的坐标系转换，其实就是把坐标系从新标志了一下已绘制的那疙搭。
 
            然后又因为UIKit的画笔是从左到右，从上到下绘制的。而Quartz的画笔是从左到右，从下到上绘制的。所以同样的方法两者绘制出来的画像是呈上下镜像对称的。
            所以，你在UIKit绘制的图像，需要镜像颠倒之后，再被Quartz截取，这样Quartz截取到的画像就和UIKit视觉下的一样了。
            因iOS封装了从Quartz到UIkit的转换，但是没有封装UIKit到Quartz的转换，所以这么麻烦，吗了个鸡。
            
            为什么坐标系转换之后，不用还原就可以直接调用context.clip(to: rect）方法？
            
 */

class GradientFontTestLabel: UILabel {
    //MARK: - 对外属性
    var name:String = "产品名称"{    //个股名称
        didSet{
            self.text = name
        }
    }
    
    var colorArr:[CGColor] = [UIColor(red: 0.97, green: 0.83, blue: 0.64, alpha: 0.5).cgColor, UIColor(red: 0.9, green: 0.66, blue: 0.45, alpha: 0.5).cgColor] {  //设置字体的渐变色
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
        print("\n字体渐变色Label 在layoutSubviews中label的frame：\(self.frame)")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        print("\n字体渐变色Label 在draw方法中的rect：\(rect)")
        if let context = UIGraphicsGetCurrentContext() {
            self.textColor.set()
//            let attStr = NSAttributedString.init(string: self.text ?? "", attributes: [NSAttributedString.Key.font:self.font ?? UIFont.systemFont(ofSize: 18)])
//            attStr.draw(with: self.bounds, options: .usesLineFragmentOrigin, context: nil)
//            let fontRect = attStr.size()
//            attStr.draw(in: CGRect(x: 0, y: 0, width: rect.width, height: rect.height))
            // 坐标(只对设置后的画到 context 起作用, 之前画的文字不起作用),为什么坐标系要镜像反转？
            // 因为：Quartz中默认的坐标系统是：沿着x轴从左到右坐标值逐渐增大；沿着y轴从下到上坐标值逐渐增大。
//            context.translateBy(x: 0.0, y: rect.size.height - (rect.size.height - fontRect.height) / 2);   //修改坐标原点
            context.translateBy(x: -rect.minX, y: rect.maxY + rect.minY)
            context.scaleBy(x: 1.0, y: -1.0);   //坐标反转
            print("context的文字位置：\(context.textPosition)")
            if let alphaMask = context.makeImage() {

                context.clear(rect); // 清除之前画的文字
                context.clip(to: rect, mask: alphaMask);// 设置mask
            }

            
            
            // 画渐变色
            let colorSpace = CGColorSpaceCreateDeviceRGB();
            if let gradient = CGGradient(colorsSpace: colorSpace, colors: self.colorArr as CFArray, locations: nil){
                let startPoint = CGPoint(x: 0, y: 0)
                let endPoint = CGPoint(x: rect.width, y:rect.height)
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


