//
//  修改TextField的键盘.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/11/16.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试替换TextField弹起的键盘


class KeyBoardTextField: UITextField {
    //MARK: - 对外属性
    
    
    //MARK: - 内部属性
    private var pickView = UIPickerView()
//    var rowViewArr = [UIView]() //作为pickerView的每一行
         
    

    //MARK: - 复写方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        initDefaultUI()
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let isInside = super.point(inside: point, with: event)
        /// 如果点击的不是自己，则收起键盘
        if !isInside {
            self.resignFirstResponder()
        }
        print("TestTextFileldEvent_View 的  \(#function)方法---\(isInside)")
        return isInside
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - 设置UI
extension KeyBoardTextField{
    //MARK: 设置初始化的UI
    func initDefaultUI(){
        
        
        pickView.layer.borderColor = UIColor.blue.cgColor
        pickView.frame = CGRect.init(x: 0, y: 0, width: 300, height: 320)
        pickView.layer.borderWidth = 1.0
        pickView.delegate = self
        pickView.dataSource = self
        pickView.tintColor = .cyan
        pickView.backgroundColor = .white
        self.inputView = pickView   //替换弹起的键盘
        
        
    }
    
    
}


//MARK: - 遵循UIPickerViewDataSource，UIPickerViewDelegate协议
extension KeyBoardTextField : UIPickerViewDataSource,UIPickerViewDelegate{
    
    //TODO:有多少列
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //TODO:每列有多少行
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 8
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 62
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 300
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("pickerView选中的是：\(component),\(row)")
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let curView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 300, height: 60))
        curView.layer.borderWidth = 1.0
        curView.layer.borderColor = UIColor.red.cgColor
        curView.tag = 1000 + row
        /// 文本
        let label = UILabel()
        label.text = "蜡笔\(row)"
        label.textAlignment = .center
        label.textColor = .black
        label.frame = CGRect.init(x: 0, y: 0, width: 100, height: 60)
        curView.addSubview(label)
        
        let imgView = UIImageView()
        imgView.image = UIImage(named: "ha\(row)")
        imgView.contentMode = .scaleAspectFit
        imgView.frame = CGRect.init(x: 120, y: 0, width: 180, height: 60)
        curView.addSubview(imgView)
        return curView
    }
    
}

//MARK: - 工具方法，制造UI小组件
extension KeyBoardTextField{
    
}

// MARK: - 笔记
/**
    1、赋值textfield的inputView属性，可以更改弹出的键盘。
    2、通过plist文件加载模型。
 
    问题：
        1、在设置row的显示为view，为什么键盘的pickerView中间会有一个蒙版，然后显示不出来图片？
            :是view的赋值问题，但是我还没找到问题出现在哪里。我不知道为什么view一定要是在viewForRow代理方法中新建，而不能暂存在数组里面，暂存的话，会显示不出来。
             所以一般的操作是，你在viewForRow代理方法中新建自定义view，但是你的自定义view的数据则用数组缓存起来。不可以暂存view。
 */

 
