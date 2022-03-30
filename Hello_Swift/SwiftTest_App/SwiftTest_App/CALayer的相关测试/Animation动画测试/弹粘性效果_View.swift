//
//  弹粘性效果_View.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/3/1.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试一个点粘弹着消失的效果,Spring是弹簧的意思。

class SpringAnimate_View: UIView {
    //MARK: - 对外属性
    
    
    //MARK: - 内部属性
    let orgDotV = UIView() //停留在原地的点
    let moveDotV = UIView()    //移动的点
    let shapeLayer = CAShapeLayer() //曲线路径的填充layer

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
extension SpringAnimate_View{
    //MARK: 设置初始化的UI
    func initDefaultUI(){
        
//        self.translatesAutoresizingMaskIntoConstraints = false //禁止自动计算布局约束？
        
        self.addSubview(moveDotV)
        moveDotV.frame = CGRect.init(x: 50, y: 50, width: 30, height: 30)
        moveDotV.layer.cornerRadius = 15
        moveDotV.backgroundColor = UIColor.red
        
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(dotMoveAction(_:)))
        moveDotV.addGestureRecognizer(pan)
        
        orgDotV.frame = CGRect.init(x: 50, y: 50, width: 30, height: 30)
        orgDotV.layer.cornerRadius = 15
        orgDotV.backgroundColor = UIColor.green
        self.insertSubview(orgDotV, belowSubview: moveDotV)
        
        /// 设置shapeLayer来填充路径
        self.layer.insertSublayer(shapeLayer, at: 0)
        shapeLayer.fillColor = UIColor.red.cgColor
        
    }
}



//MARK: - 动作方法
@objc extension SpringAnimate_View{
    
    func dotMoveAction(_ sender:UIPanGestureRecognizer){
        
        
        let curP = sender.translation(in: sender.view) //相对于最开始移动的距离，用点来表示。用来找出偏移的点。
        var center = moveDotV.center
        center.x += curP.x
        center.y += curP.y
        moveDotV.center = center
        
//        moveDotV.transform = moveDotV.transform.translatedBy(x: curP.x, y: curP.y)  //这里不用transform，直接用center
        sender.setTranslation(.zero, in: self)  //设置过渡的原始点是零点。达到过渡复位的效果。
        
        //找出两点之间的距离
        let distance = distanceBetween(orgDotV, moveDotV)
        var orgR:CGFloat = moveDotV.bounds.width / 2 //原始点的半径
        orgR -= distance / 10   //不断地缩小原来点的半径
        orgDotV.layer.cornerRadius = orgR
        orgDotV.bounds = CGRect.init(x: 0, y: 0, width: orgR * 2, height: orgR * 2)
        
        let path = pathBetweenCircle(orgDotV, moveDotV)
        
        shapeLayer.path = path.cgPath
        shapeLayer.isHidden = orgDotV.isHidden
        
        //距离大于100就消失，小于100就复位
        if distance > 100 {
            orgDotV.isHidden = true
//            shapeLayer.isHidden = true  //自定义的layer层会有默认的0.25秒的隐式动画
            shapeLayer.removeFromSuperlayer()
        }
        
        if sender.state == .ended {
            /// 大于100消失，小于100复位
            if distance < 100 {
//                shapeLayer.removeFromSuperlayer()
                shapeLayer.isHidden = true
                moveDotV.center = orgDotV.center
                orgDotV.isHidden = false
            }else{
                /// 消失，播放一个动画消失
                let imgView = UIImageView.init(frame: CGRect.init(origin: .zero, size: moveDotV.bounds.size))   //直接这样会因为自动布局约束的原因导致imgView的布局不正确，因为有了动画。
                let imgArr = [UIImage(named: "labi01")!,UIImage(named: "labi02")!,UIImage(named: "labi03")!,UIImage(named: "labi04")!]
                imgView.animationImages = imgArr
                imgView.animationDuration = 2
                imgView.startAnimating()
//                imgView.center = moveDotV.center
                moveDotV.addSubview(imgView)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    [weak self] in
                    self?.moveDotV.isHidden = true
                    imgView.removeFromSuperview()
                }
                
            }
            
        }
        
//        print("dot的位置：\(moveDotV.layer.position)")
        
    }
    
}

//MARK: - 工具方法
extension SpringAnimate_View{
    
    //TODO: 求两个view中心之间的距离
    func distanceBetween(_ view1:UIView, _ view2:UIView) -> CGFloat{
        
        let offsetX = view1.center.x - view2.center.x
        let offsetY = view1.center.y - view2.center.y
        
        return sqrt(offsetX * offsetX + offsetY * offsetY)
    }
    
    //TODO: 求两个圆之间的曲线路径
    /**
        1、取小圆的直径为长方形的宽，小圆心到大圆心的距离为长方形的长，连接两个圆的直径，组成一个长方形，然后长方形两边的边上中点作为贝塞尔的控制点，就可以画出曲线路径了。
     */
    func pathBetweenCircle(_ smallView:UIView, _ bigView:UIView) -> UIBezierPath{
        
        let x1 = smallView.center.x
        let y1 = smallView.center.y
        
        let x2 = bigView.center.x
        let y2 = bigView.center.y

        let distance = distanceBetween(smallView, bigView)
        
        let cosθ:CGFloat = (y2 - y1) / distance
        let sinθ:CGFloat = (x2 - x1) / distance
        
        let r1 = smallView.bounds.width / 2
        let r2 = bigView.bounds.width / 2

        //小圆直径的两个点A、B、点
        let pA = CGPoint.init(x: x1 - r1 * cosθ, y: y1 + r1 * sinθ)
        let pB = CGPoint.init(x: x1 + r1 * cosθ, y: y1 - r1 * sinθ)
        //大圆直径的两个点C、D点
        let pC = CGPoint.init(x: x2 + r2 * cosθ, y: y2 - r2 * sinθ)
        let pD = CGPoint.init(x: x2 - r2 * cosθ, y: y2 + r2 * sinθ)
        //长方形上下边的两个中心点O、E点
        let pO = CGPoint.init(x: pA.x + distance / 2 * sinθ, y: pA.y + distance / 2 * cosθ) //长方形上边的中心点
        let pE = CGPoint.init(x: pB.x + distance / 2 * sinθ, y: pB.y + distance / 2 * cosθ) //长方形下边的中心点

        let path = UIBezierPath()
        //AB
        path.move(to: pA)
        path.addLine(to: pB)
        //BC（曲线）
        path.addQuadCurve(to: pC, controlPoint: pE)
        //CD
        path.addLine(to: pD)
        //DA（曲线）
        path.addQuadCurve(to: pA, controlPoint: pO)
        
        return path
    }
}

// MARK: - 笔记
/**
    1、transform并不改变view的center，而是改变了view的frame。 CATransition()是平移(过渡)动画效果，位移过渡只是其中一个功能而已，可以是颜色过渡。
 
 */
