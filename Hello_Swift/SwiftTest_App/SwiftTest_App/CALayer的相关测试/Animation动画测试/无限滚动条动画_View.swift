//
//  无限滚动条动画_View.swift
//  SwiftTest_App
//
//  Created by mathew on 2023/8/4.
//  Copyright © 2023 com.mathew. All rights reserved.
//
// 无限滚动条的View

class InfinityLoop_View: UIView {
    

    //MARK: - 对外属性
    var cellColor:UIColor = UIColor(red: 255/255.0, green: 167/255.0, blue: 47/255.0, alpha: 1.0)
    
    
    //MARK: - 内部属性
    private var timer:Timer?
    private var beginX:CGFloat = 0
    private var cellGap:CGFloat = 20
    

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
        print("InfinityLoop_View 的 \(#function)方法")

        let context = UIGraphicsGetCurrentContext()
        
        context?.saveGState()   //保存当前上下文的状态
        
        // 设置上下文的状态
        var startX = beginX
        while (startX - cellGap) < rect.width {
            context?.setLineJoin(.miter)//设置线的连接方式
            context?.setLineCap(.square) //设置线帽,也就是线的两端是怎样，线顶端
            context?.move(to: CGPoint(x: startX - cellGap, y: rect.size.height))
            context?.addLine(to: CGPoint(x: startX - 10, y: 0))
            context?.addLine(to: CGPoint(x: startX , y: 0))
            context?.addLine(to: CGPoint(x: startX - 10, y: rect.size.height))
            context?.addLine(to: CGPoint(x: startX - cellGap, y: rect.size.height))
            UIColor(red: 255/255.0, green: 167/255.0, blue: 47/255.0, alpha: 0.25 + (startX / rect.width)).setFill()    //设置填充路径包围区域的颜色
            context?.fillPath() //填充路径的包围面积
            startX += (cellGap > 0 ? cellGap : 20)
        }
        
        if self.beginX >= cellGap {
            beginX = 0
        }
        
        
        context?.restoreGState()    //保存先前上下文的状态

    }
    
    
    deinit{
        print("InfinityLoop_View 销毁了～")
        timer?.invalidate()
        timer = nil
    }
    
}

//MARK: - 设置UI
extension InfinityLoop_View{
    
    //MARK: 设置初始化的UI
    func initDefaultUI(){
        
        self.backgroundColor = UIColor(red: 1, green: 0.82, blue: 0.59, alpha: 1)
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: {
            [weak self] timer in
            self?.beginX += 1
            self?.setNeedsDisplay()
            print("beginX += 1")
        })
       
    }
}



