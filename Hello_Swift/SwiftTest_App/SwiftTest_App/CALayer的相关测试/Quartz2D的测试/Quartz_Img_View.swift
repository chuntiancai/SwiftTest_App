//
//  Quartz_Img_View.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/2/17.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试利用quartz技术在draw方法里绘制图片。

class Quartz_Img_View: UIView {
    //MARK: - 对外属性
    var isStopDiapaly:Bool = false {
        didSet{
            if isStopDiapaly {
                link?.invalidate()
            }else{
                link = CADisplayLink.init(target: self, selector: #selector(displayLinkAction(sender:)))
                link?.add(to: RunLoop.main, forMode: .default)
            }
        }
    }
    
    //MARK: - 内部属性
    /// CADisplayLink必须添加到主循环当中
    private var link:CADisplayLink?
    private var changeY:CGFloat = 0.0

    //MARK: - 复写方法
    override func draw(_ rect: CGRect) {
        let img = UIImage(named: "cache_ic_delete")
//        let img = UIImage(named: "labi07")

        /// 裁剪矩形，传入一个矩形与当前上下文的矩形相交，取相交的部分，如果相交部分小于0，则该函数无效。(并没有改变之前的矩形，只是限制了绘制的范围)
        /// 裁剪一定要在绘制之前执行。
//        UIRectClip(CGRect.init(x: 20, y: 20, width: 100, height: 100))
        
        img!.draw(at: CGPoint.init(x: 10, y: changeY))  //移动图片的时候使用
//        img?.drawAsPattern(in: rect)  //平铺填满整个rect，铺瓷砖那样。
//        img?.draw(in: rect)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initDefaultUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

//MARK: - 设置UI
extension Quartz_Img_View{
    //MARK: 设置初始化的UI
    func initDefaultUI(){
        
    }
}

//MARK: - 动作方法
@objc extension Quartz_Img_View{
    /// 定时器的动作方法
    func displayLinkAction(sender:CADisplayLink){
        print("Quartz_Img_View 的 \(#function) 方法")
        changeY += 10
        if changeY > self.bounds.height {
            changeY = 0.0
        }
        self.setNeedsDisplay()
    }
    
}

//MARK: -
extension Quartz_Img_View{
    
}

// MARK: - 笔记
/**
    1、UIImage也有draw方法，所以你可以在view的上下文中，绘制UIImage到view上。
    2、CADisplayLink定时器的刷新频率更高，是屏幕每刷新一次，就调用Action方法一次。屏幕每一秒至少刷新60次，看你的手机性能。
 */

