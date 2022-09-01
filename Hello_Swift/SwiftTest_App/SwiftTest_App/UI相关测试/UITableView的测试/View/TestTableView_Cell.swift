//
//  TestTableView_Cell.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/8/16.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试tableView的CELL
//MARK: - 笔记
/**
    1、可以通过修改frame的属性，实现cell的悬浮效果。而且frame里面的内容会按约束收缩。
 */

class TestTableView_Cell: UITableViewCell {
    
    //MARK: - 对外属性
    /// 标题
    var title:String?{
        didSet{
            titleLab.text = title
        }
    }
    
    let  baseAudioView = UIView()   //承载音频播放器
    
    //MARK: - 内部属性
    private var titleLab: UILabel = {
        let lab = UILabel()
        lab.textColor = .gray
        lab.font = UIFont.systemFont(ofSize: 16)
        return lab
    }()
    

    //MARK: - 复写方法
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        clipsToBounds = true
        createUI()
    }
    
    //TODO: 修改frame，实现悬浮效果。
    override var frame: CGRect {
        get{
            return super.frame
        }
        set{
            var curFrame = newValue
            curFrame.origin.x += 20
            curFrame.size.width -= 60
            curFrame.size.height -= 10
            super.frame = curFrame
        }
    }
    
    override func draw(_ rect: CGRect) {
//        print("TestTableView_Cell 的 \(#function)方法")
        /**
            1、设置cell的backgroundColor是无效的，只能通过contentView来操作。
         */
        self.contentView.backgroundColor = .yellow
        
        /// 1.2、绘制路径。
        let  bPath = UIBezierPath()
        
        // 画曲线
        ///用贝塞尔的N次函数来绘制曲线。
        bPath.move(to: CGPoint(x: 20, y: 60))
        bPath.addQuadCurve(to: CGPoint(x: 100, y:60), controlPoint: CGPoint(x: 60, y: 120))    //添加一个贝塞尔控制点
        bPath.addQuadCurve(to: CGPoint(x: 200, y:60), controlPoint: CGPoint(x: 150, y: 10))    //再添加一个贝塞尔控制点
        bPath.addLine(to: CGPoint(x: rect.maxX, y: 60))
        
        let layer = CAShapeLayer()
        layer.path = bPath.cgPath
        layer.strokeColor = UIColor.red.cgColor
        layer.fillColor = UIColor.cyan.cgColor
        self.contentView.layer.insertSublayer(layer, at: 0)
        
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
    }
    
    ///cell准备被复用的时候
    override func prepareForReuse() {
        super.prepareForReuse()
        for subV in baseAudioView.subviews {
            subV.removeFromSuperview()
        }
    }
    deinit {
        print("TestTableView_Cell 测试tableView的cell 销毁了～")
    }
    
    //MARK: 设置UI
    // 对外方法
    /// - Parameter subView: 被添加的音频View
    func addAudioView(subView:UIView?){
        if let subV = subView {
            for tempSubV in baseAudioView.subviews {
                tempSubV.removeFromSuperview()
            }
            if subV.superview != nil {
                subV.removeFromSuperview()
            }
            baseAudioView.addSubview(subV)
            subV.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            bringSubviewToFront(baseAudioView)
        }
    }
    
    // 对内方法
    private func createUI() {
        
        contentView.addSubview(titleLab)
        titleLab.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(19)
            make.leading.equalTo(UIScreen.main.bounds.width * (20/375.0))
        }
        
        contentView.addSubview(baseAudioView)
        baseAudioView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(43)
            make.height.equalTo(40)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
    }

}

