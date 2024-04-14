//
//  Quartz_View.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/2/16.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试 Quartz 绘制图形的view，在draw方法里绘制图形
// MARK: - 笔记

import UIKit
/**
    1、利用Quartz2D技术绘制图形到view上，也只能绘制到view上。
        绘制view的步骤：
         新建一个类，继承自UIView。
         实现- (void)drawRect:(CGRect)rect方法，然后在这个方法中取得跟当前view相关联的图形上下文(CGContext)。
         在CGContext的语境下，利用贝塞尔曲线等技术类 来绘制相应的图形内容。
         利用CGContext 将绘制的所有内容渲染显示到view上面。
    2、context?.fillPath() 和 context?.strokePath() 这两个方法执行完之后，都会清除掉context的路径。所以你要重新复制路径。
    
    3、如果draw(_ rect: CGRect) 方法是你手动调用的话，draw方法内部不会给你获取到view相关联的上下文，所以必须要系统自动调用才可以。
       所以你可以调用view的setNeedsDisplay()方法，这个方法是在下一个周期更新UI内容，此时系统会自动调用draw(_ rect: CGRect) 方法。
 
    4、UIBezierPath、CGContext、CGRect、UIColor都有fill的方法，只不过UIBezierPath这些的fill方法是封装了获取CGContext、通过CGContext渲染等等的这些步骤。
    
    5、图形上下文可以对它绘制的图形做形变，例如平移，旋转，缩放等等。
 
 */

class Quartz_View: UIView {
    
    enum PaintShape:Int {
        case StraightLine   //直线
        case CurveLine  //曲线
        case Rect   //矩形
        case RoundRect  //圆角矩形
        case OvalInRect //在指定Rect内绘制椭圆
        case Arc    //画弧度
    }
    
    //MARK: - 对外属性
    var drawShape:PaintShape = .StraightLine    //绘制的图形
    var arcProgress:CGFloat = 0.0 { //绘制圆弧的百分比
        didSet{
            self.setNeedsDisplay()  //更新view的UI内容
        }
    }
    var contextTransForm:Int = 0 {
        didSet{
            self.setNeedsDisplay()
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
    
    
    /// 该方法专门用来绘制图形，在图形将要显示的时候，被系统调用。
    /// - Parameter rect: 当前view的bounds
    override func draw(_ rect: CGRect) {
        print("Quartz_View 的 \(#function)方法--\(drawShape)")
        // 画直线
        ///1、在draw(_ rect:)方法中，系统已经默认帮你创建了一个跟当前view相关联的上下文(layer的上下文)，所以你只需要获取该上下文即可。
        /// 绘制步骤：获取上下文 --> 绘制路径 --> 把绘制路径保存到上下文当中 --> 把上下文的内容显示到View上(渲染view的layer)。
        
        /// 1.1、获取上下文(无论是获取，创建上下文，都是以UIgraphics开头)
        // 获取当前的上下文环境。
        let context = UIGraphicsGetCurrentContext()
        
        /// 1.2、绘制路径。
        var bPath = UIBezierPath()
        
        /// 设置上下文的状态
        context?.setLineWidth(5)
        context?.setStrokeColor(UIColor.red.cgColor)
        UIColor.blue.setStroke()    //设置线条颜色的第二种方式。
        UIColor.yellow.setFill()    //设置填充路径包围区域的颜色
        context?.setLineJoin(.round)//设置线的连接方式
        context?.setLineCap(.round) //设置线帽,也就是线的两端是怎样，线顶端
        
        switch drawShape {
        case .StraightLine:
            
            ///绘制路径。
            bPath.move(to: CGPoint.init(x: 50, y: 60))
            bPath.addLine(to: CGPoint.init(x: 60, y: 180))
            bPath.addLine(to: CGPoint.init(x: 80, y: 160))

            /// 1.3、把绘制添加到上下文当中。
            context?.addPath(bPath.cgPath)
            
            /// 1.4、渲染上下文的内容到View的layer上。
            context?.fillPath()
            //这个方法是填充路径所包围的面积，填充的方式也有多种，交叉填充，根据函数填充，全部填充等等。调用该方法时，context的路径也会被清除。
            
            context?.addPath(bPath.cgPath)
            context?.strokePath()   //其实这个方法就是根据路径绘制线条。当调用该方法的时候，context的路径会被清除。
        
        case .CurveLine:
            // 画曲线
            ///用贝塞尔的N次函数来绘制曲线。
            bPath.move(to: CGPoint(x: 20, y: 60))
            bPath.addQuadCurve(to: CGPoint(x: 100, y:60), controlPoint: CGPoint(x: 60, y: 120))    //添加一个贝塞尔控制点
            bPath.addQuadCurve(to: CGPoint(x: 200, y:60), controlPoint: CGPoint(x: 150, y: 10))    //再添加一个贝塞尔控制点
            UIColor.red.setStroke()
            context?.addPath(bPath.cgPath)
            context?.setLineJoin(.round)
            context?.setLineWidth(3)
            context?.strokePath()
            context?.saveGState()   //复制一份当前的上下文状态，把这些状态入栈。例如线宽、颜色、连接样式等等这些状态。
            context?.restoreGState()    //从上下文保存栈里，出栈上下文的状态，赋值到当前的上下文中。
        case .Rect:
            //画矩形
            bPath = UIBezierPath.init(rect: CGRect.init(x: 50, y: 50, width: 30, height: 40))
            context?.addPath(bPath.cgPath)
            context?.setFillColor(UIColor.red.cgColor)
            context?.fillPath() //填充路径的包围面积
            
            context?.addPath(bPath.cgPath)  //因为会清除path，所以需要再一次添加路径
            context?.strokePath()   //用线条绘制路径

            bPath = UIBezierPath.init(rect: CGRect.init(x: 100, y: 60, width: 60, height: 40))
            context?.setStrokeColor(UIColor.cyan.cgColor)
            context?.addPath(bPath.cgPath)
            context?.setFillColor(UIColor.yellow.cgColor)
            
            context?.fillPath()
            
        case .RoundRect:
            //绘制圆角矩形
            /// cornerRadius参数是指圆角的半径
            bPath = UIBezierPath.init(roundedRect: CGRect.init(x: 40, y: 50, width: 40, height: 30), cornerRadius: 5)
            context?.addPath(bPath.cgPath)
            ///对图形上下文进行形变操作，不知道为啥子没有效果
            switch contextTransForm {
            case 0:
                print("context平移(x: 20, y: 40)")
                context?.translateBy(x: 20, y: 40)
            case 1:
                print("context旋转CGFloat.pi / 2")
                context?.rotate(by: CGFloat.pi / 2)
            case 2:
                print("context缩放(x: 1.2, y: 1.5)")
                context?.scaleBy(x: 1.2, y: 1.5)
            default:
                break
            }
            context?.fillPath()
        case .OvalInRect:
            //绘制椭圆
            bPath = UIBezierPath.init(ovalIn:  CGRect(x: 60, y: 50, width: 80, height: 50))
//            bPath.stroke()  //这个方法实际上帮你封装了获取上下文环境这些步骤，更简洁。
            bPath.fill()    //同理这个也是封装了上下文的步骤
        case .Arc:
            /// 角度是以顺时针，坐标系第一象限开始计算的。
            let arcCenter = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
            bPath = UIBezierPath.init(arcCenter: arcCenter, radius: 40, startAngle: 0, endAngle: CGFloat.pi * 2 * 0.25, clockwise: true)
            bPath.addLine(to: arcCenter)
            UIColor.red.setFill()
//            bPath.lineWidth = 3
            bPath.close()   //从路径的终点连线到路径的起点
            bPath.fill()
            if arcProgress > 0.25 {
                bPath = UIBezierPath.init(arcCenter: arcCenter, radius: 40, startAngle: CGFloat.pi * 2 * 0.25, endAngle: CGFloat.pi * 2 * 0.5, clockwise: true)
                bPath.addLine(to: arcCenter)
                UIColor.blue.setFill()
                bPath.close()   //从路径的终点连线到路径的起点
                bPath.fill()
            }
            if arcProgress > 0.5 {
                bPath = UIBezierPath.init(arcCenter: arcCenter, radius: 40, startAngle: CGFloat.pi * 2 * 0.5, endAngle: CGFloat.pi * 2 , clockwise: true)
                bPath.addLine(to: arcCenter)
                UIColor.yellow.setFill()
                bPath.close()   //从路径的终点连线到路径的起点
                bPath.fill()
            }
        }
        

    }
    
    override func layoutSubviews() {
        print("Quartz_View 的 \(#function)方法")
        super.layoutSubviews()
    }
    
    /// 这个方法是唤醒nib文件的时候被调用，但是此时还没有创建view对象，因此不能渲染path到view上(无效)。
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

//MARK: - 设置UI
extension Quartz_View{
    //MARK: 设置初始化的UI
    func initDefaultUI(){
        
    }
}

//MARK: - 逻辑方法
extension Quartz_View{
    
}

//MARK: -
extension Quartz_View{
    
}

//MARK: -
extension Quartz_View{
    
}


