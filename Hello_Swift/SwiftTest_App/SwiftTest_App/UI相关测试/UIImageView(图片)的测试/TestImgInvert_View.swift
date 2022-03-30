//
//  TestImgInvert_View.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/3/1.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试图片倒影的ImageView

class TestImgInvert_View: UIView {
    //MARK: - 对外属性
    
    
    //MARK: - 内部属性
    let imgView = UIImageView()

    //MARK: - 复写方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        initDefaultUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 更换换View的根Layer
    override class var layerClass: AnyClass{
        return CAReplicatorLayer.self   //复制因子的layer
    }
}

//MARK: - 设置UI
extension TestImgInvert_View{
    //MARK: 设置初始化的UI
    func initDefaultUI(){
        self.addSubview(imgView)
        imgView.image = UIImage(named: "labi01")
        imgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
            make.top.equalToSuperview()
        }
    }
}

//MARK: -
extension TestImgInvert_View{
    
}

//MARK: -
extension TestImgInvert_View{
    
}

// MARK: - 笔记
/**
 
 */
