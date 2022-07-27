//
//  自定义tabar_View.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/3/3.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试替换为自定义的底部工具栏TabBar

class TestBtmTabBar_View: UIView {
    
    //MARK: - 对外属性
    var tabCount:Int = 1 {  //标签的个数，就是底部按钮的个数
        didSet{
            
        }
    }
    var itemArr:[UITabBarItem] = [UITabBarItem](){  //维护工具栏的barItem，用这个为自己定义的button提供数据。
        didSet{
            for btn in btnArr {
                if btn.superview != nil { btn.removeFromSuperview() }
            }
            btnArr.removeAll()
            
            for index in 0 ..< itemArr.count {
                let item = itemArr[index]
                let btn = UIButton()
                btn.tag = 1000 + index
                btn.setBackgroundImage(item.image, for: .normal)
                btn.setBackgroundImage(item.selectedImage, for: .selected)
                btnArr.append(btn)
            }
        }
        
    }
    
    //MARK: - 内部属性
    private var btnArr:[UIButton] = [UIButton]()    //按钮数组
    

    //MARK: - 复写方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        initDefaultUI()
    }
    
    ///TODO: 在这里布局子控件，因为在这里snpkit已经计算出来尺寸了
    override func layoutSubviews() {
        if btnArr.count > 0 {
            let btnW = self.bounds.width / CGFloat(btnArr.count)
            for index in 0 ..< btnArr.count {
                let btn = btnArr[index]
                self.addSubview(btn)
                btn.snp.remakeConstraints { make in
                    make.left.equalToSuperview().offset(btnW * CGFloat(index))
                    make.width.equalTo(btnW)
                    make.centerY.equalToSuperview()
                    make.height.equalToSuperview()
                }
            }
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - 设置UI
extension TestBtmTabBar_View{
    //MARK: 设置初始化的UI
    func initDefaultUI(){
        
    }
}

//MARK: - 动作方法
@objc extension TestBtmTabBar_View{
    
    /// 点击按钮的动作方法
    func btnClickAction(_ sender: UIButton){
        
    }
    
}

//MARK: -
extension TestBtmTabBar_View{
    
}

// MARK: - 笔记
/**
 
 */
