//
//  TestLabelInCell.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/11/15.
//  Copyright © 2021 com.mathew. All rights reserved.
//

class TestLabelInCell: UITableViewCell {
    
    //MARK: - 对外属性
    var productName:String = "产品名称"{    //个股名称
        didSet{
            /**
             自适应高度没有变化是因为snpkit的相关联约束重复冲突，所以影响了label的自适应高度，其他组件关联到label的约束出问题，也会影响
             */
            nameLabel.text = productName
//            nameLabel.layoutIfNeeded()
            nameLabel.sizeToFit()
//            nameGradientView.frame = nameLabel.frame
            let fitSize = nameLabel.sizeThatFits(CGSize.init(width: 250, height: 900))
            nameLabel.frame = CGRect.init(x: nameLabel.frame.minX, y: nameLabel.frame.minY, width: fitSize.width, height: fitSize.height)
//            nameGradientView.frame = CGRect.init(x: nameLabel.frame.minX, y: nameLabel.frame.minY, width: fitSize.width, height: fitSize.height)
            print("计算之前：name是：\(productName)\n nameLabel的内尺寸是：\(nameLabel.intrinsicContentSize)\n nameLabel的frame是：\(nameLabel.frame)\n nameGradientView的尺寸是：\(nameGradientView.frame)\n 计算出的size是：\(fitSize)")
//            nameGradientView.frame = nameLabel.frame
            gradient.frame = nameLabel.frame
//            gradient.frame = CGRect.init(x: 0, y: 0, width: nameLabel.frame.width, height: nameLabel.frame.height)
//            nameGradientView.snp.makeConstraints { make in
//                make.edges.equalTo(nameLabel)
//            }
            
//            nameGradientView.mask = nameLabel
            
            print("\n渐变layer的view的frame是：\(nameGradientView.frame)")
            print("\n渐变layer的frame是：\(gradient.frame)\n")

            print("计算之后：\n nameLabel的frame是：\(nameLabel.frame)\n nameGradientView的尺寸是：\(nameGradientView.frame)\n gradient的frame是：\(gradient.frame)")
//            nameLabel.snp.remakeConstraints { make in
//                make.top.equalToSuperview().offset(30)
//                make.left.equalToSuperview().offset(25)
//                make.width.equalTo(250)
//            }
            
            
        }
    }
    var tagTitleArr:[String] = [String](){  //标签的数组，价值投资，股票多头的这些
        didSet{
            if !tagTitleLabelViewArr.isEmpty {  //非空则移除原来的所有label
                for curView in tagTitleLabelViewArr {
                    curView.removeFromSuperview()
                }
                tagTitleLabelViewArr.removeAll()
            }
            for index in 0 ..< tagTitleArr.count {
                let view = UIView() //作为label的背景
                let label = UILabel()
                label.tag = 1001
                label.text = tagTitleArr[index] //设置标签名称
                label.font = .systemFont(ofSize: 10)
                view.addSubview(label)
                tagTitleLabelViewArr.append(view)
            }
            setTagTitleLabelUI()
        }
    }
    var clickDetailBtnAction:(()->Void)?   //点击了详情按钮的动作方法

    /// 标志器
    
    
    //MARK: - 内部属性
    private let nameLabel = GradientFontTestLabel()
    let gradient = CAGradientLayer()
    private let nameGradientView = UIView()  //名字的渐变颜色
    private var tagTitleLabelViewArr = [UIView]()   //为了给label一个渐变颜色的背景
    private let detailBtn = UIButton()
    let redView = UIView()      //用于测试label变化时，snpkit的在底部的移动
    

    //MARK: - 复写方法
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initDefaultUI()
        selectionStyle = .none
        clipsToBounds = true
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        print("\n在layoutSubviews中label的frame：\(nameLabel.frame)")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        print("\n在draw方法中label的frame：\(nameLabel.frame)")
    }
    
    ///cell准备被复用的时候
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    deinit {
        print("JFZHoldOneStockTitleCell 测试tableView的cell 销毁了～")
    }
    
    //MARK: 设置UI
    // 对内方法
    /// 初始化默认的UI
    func initDefaultUI(){
        
        self.contentView.backgroundColor = UIColor.init(red: 22/255.0, green: 27/255.0, blue: 80/255.0, alpha: 1.0)
        
        ///名称文字的渐变颜色
//        nameGradientView.frame = CGRect(x: 25, y: 30, width: 250, height: 80)
        
//        gradient.colors = [UIColor(red: 0.97, green: 0.83, blue: 0.64, alpha: 1).cgColor, UIColor(red: 0.9, green: 0.66, blue: 0.45, alpha: 1).cgColor]
//        gradient.startPoint = CGPoint(x: 0.5, y: 0)
//        gradient.endPoint = CGPoint(x: 0.5, y: 1)
//        gradient.frame = self.contentView.bounds
//        contentView.layer.addSublayer(gradient)
//        self.contentView.addSubview(nameGradientView)
        
        ///个股名称
        nameLabel.numberOfLines = 0
        nameLabel.layer.borderColor = UIColor.red.cgColor
        nameLabel.layer.borderWidth = 1.0
        nameLabel.text = productName
        nameLabel.textColor = UIColor.cyan
        nameLabel.textAlignment = .left
        nameLabel.font = .systemFont(ofSize: 20)
        self.contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.left.equalToSuperview().offset(25)
            make.width.equalTo(250)
        }
        
//        nameGradientView.mask = nameLabel
        
        
        redView.backgroundColor = UIColor.red
        self.contentView.addSubview(redView)
        redView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.width.equalTo(60)
            make.height.equalTo(10)
            make.centerX.equalToSuperview()
        }
        
         /// 详情按钮，左文右图
         detailBtn.setTitle("详情", for: .normal)
         detailBtn.setTitleColor(UIColor(red: 0.49, green: 0.51, blue: 0.64, alpha: 1), for: .normal)
         detailBtn.setImage(UIImage(named: "OneStockHold_rightArrow"), for: .normal)
         detailBtn.titleLabel?.font = .systemFont(ofSize: 14)
         detailBtn.titleLabel?.textAlignment = .center
         detailBtn.addTarget(self, action: #selector(detailBtnClickAction(sender:)), for: .touchUpInside)
         self.contentView.addSubview(detailBtn)
         detailBtn.snp.makeConstraints { make in
             make.right.equalToSuperview().offset(-23)
             make.top.equalToSuperview().offset(30)
             make.width.equalTo(60)
             make.height.equalTo(18)
//            make.centerY.equalTo(nameLabel.snp.centerY)   //这句话的约束重复冲突，所以影响了label的自适应高度
         }
         
         ///设置按钮的图片在右，标题在左
         let imageWidth:CGFloat = detailBtn.imageView?.intrinsicContentSize.width ?? 5
         let labelWidth:CGFloat = detailBtn.titleLabel?.intrinsicContentSize.width ?? 40
         detailBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: (labelWidth + 10), bottom: 0, right: -(labelWidth + 10))
         detailBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: 0, right: imageWidth)
        
        
        
    }
    
    ///设置产品标签的label的UI
    func setTagTitleLabelUI(){
        if tagTitleLabelViewArr.isEmpty {
            print("没有title")
            return
        }
        var preView = tagTitleLabelViewArr[0]
        var leftMargin:CGFloat = 25  //左边距
        for index in 0 ..< tagTitleLabelViewArr.count {
            guard let label:UILabel = tagTitleLabelViewArr[index].viewWithTag(1001) as? UILabel else {
                print("JFZHoldOneStockTitleCell 取出来的不是label")
                return
            }
            label.textColor = UIColor(red: 0.33, green: 0.18, blue: 0.08, alpha: 1)
            label.textAlignment = .center
            let labelHeight:CGFloat = label.intrinsicContentSize.height + 5
            let labelWidth:CGFloat = label.intrinsicContentSize.width + 10
            
            /// 渐变颜色的背景layer
            let bgLayer1 = CAGradientLayer()
            bgLayer1.colors = [UIColor(red: 0.95, green: 0.76, blue: 0.64, alpha: 1).cgColor,
                               UIColor(red: 0.98, green: 0.89, blue: 0.82, alpha: 1).cgColor,
                               UIColor(red: 0.95, green: 0.75, blue: 0.63, alpha: 1).cgColor]
            bgLayer1.locations = [0, 0.48, 1]
            bgLayer1.frame = CGRect.init(x: 0, y: 0, width: labelWidth, height: labelHeight)
            bgLayer1.startPoint = CGPoint(x: 0, y: 0.5)
            bgLayer1.endPoint = CGPoint(x: 1, y: 0.5)
            bgLayer1.cornerRadius = 2
            
            tagTitleLabelViewArr[index].layer.insertSublayer(bgLayer1, at: 0)
            
            
            self.contentView.addSubview(tagTitleLabelViewArr[index])
            tagTitleLabelViewArr[index].snp.makeConstraints { make in
                make.left.equalToSuperview().offset(leftMargin)
                make.top.equalTo(nameLabel).offset(10)
                make.height.equalTo(labelHeight)
                make.width.equalTo(labelWidth)
            }
            label.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            leftMargin = leftMargin + labelWidth + 10   //设置左边距
            preView = tagTitleLabelViewArr[index]
        }
    }
    
    // 对外方法

}

//MARK: 对外方法
@objc extension TestLabelInCell{
    
  
    
}

//MARK: 动作方法，action
@objc extension TestLabelInCell{
    /// 点击了详情按钮的动作方法
    func detailBtnClickAction(sender:UIButton){
        print("点击了详情按钮～")
        if clickDetailBtnAction != nil {
            clickDetailBtnAction!()
        }
    }
}

//MARK: 工具方法
extension TestLabelInCell{
    
    
}

