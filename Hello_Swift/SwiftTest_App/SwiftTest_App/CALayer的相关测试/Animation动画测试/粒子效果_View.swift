//
//  粒子效果_View.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/3/1.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试粒子效果的View

class GrainAnimate_View: UIView {
    //MARK: - 对外属性
    
    
    //MARK: - 内部属性
    let path:UIBezierPath = UIBezierPath()  //粒子路径
    let dotLayer:CALayer = CALayer()
    let repL:CAReplicatorLayer = CAReplicatorLayer()    //用于复制粒子layer

    //MARK: - 复写方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        initDefaultUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 配合setNeedsDisplay方法使用
    override func draw(_ rect: CGRect) {
        path.stroke()   //绘制出路径
    }
    
    override func layoutSubviews() {
        repL.frame = self.bounds
    }
    
}

//MARK: - 设置UI
extension GrainAnimate_View{
    //MARK: 设置初始化的UI
    func initDefaultUI(){
        
        self.layer.addSublayer(repL)
        repL.frame = self.bounds
        repL.instanceCount = 17
        repL.instanceDelay = 0.7
        
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(grainMoveAction(_:)))
        self.addGestureRecognizer(pan)
        
        // 添加粒子layer
        dotLayer.frame = CGRect.init(x: 0, y: 0, width: 10, height: 10)
        dotLayer.cornerRadius = 5
        dotLayer.backgroundColor = UIColor.red.cgColor
        repL.addSublayer(dotLayer)
        
    }
    
    func startMove(){
        /// 关键路径动画
        let keyAnim = CAKeyframeAnimation()
        keyAnim.duration = 5
        keyAnim.repeatCount = MAXFLOAT
        keyAnim.keyPath = "position"
        keyAnim.path = self.path.cgPath
        keyAnim.autoreverses = true
        keyAnim.calculationMode = .paced
        dotLayer.add(keyAnim, forKey: nil)
    }
    
    func stopMove(){
        
    }
    
    func cancelMove(){
        dotLayer.removeAllAnimations()
        path.removeAllPoints()
    }
}

//MARK: - 动作方法
@objc extension GrainAnimate_View{
    
    //MARK: 粒子运动的动作方法
    func grainMoveAction(_ sender: UIPanGestureRecognizer){
        
        let curPoint = sender.location(in: sender.view)
        if sender.state == .began {
            self.cancelMove()
            path.removeAllPoints()
            path.move(to: curPoint)
            
        }else if sender.state == .changed {
            
            path.addLine(to: curPoint)
            self.setNeedsDisplay()
            
        }else if sender.state == .ended {
            self.startMove()
        }
    }
    
    
}

//MARK: -
extension GrainAnimate_View{
    
}

// MARK: - 笔记
/**
 
 */
