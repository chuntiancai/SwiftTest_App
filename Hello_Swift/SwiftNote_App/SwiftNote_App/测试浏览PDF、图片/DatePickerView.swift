//
//  DatePickerView.swift
//  SwiftNote_App
//
//  Created by chuntiancai on 2021/7/1.
//  Copyright © 2021 com.mathew. All rights reserved.
//

import UIKit

class DatePickerView: UIControl {
    
    //MARK: - 对外属性
    var howManyYear:Int = 10{   //显示多少年
        didSet{
            if  howManyYear < 1{
                howManyYear = 1
                return
            }
            
        }
    }
    var okAction : ((NSInteger,NSInteger,NSInteger) -> Void)?//点击确定后的block回调
    
    //MARK: - 内部属性
    private var pickDate = Date()   //选中的日期
    private var curDateComponets = Calendar.current.dateComponents([Calendar.Component.year,
                                                                 Calendar.Component.month,
                                                                 Calendar.Component.day],
                                                                from: Date())   //当前的日历组件
    fileprivate lazy var pickerView : UIPickerView = {
        let pickerView = UIPickerView.init(frame: self.bounds)
        pickerView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        pickerView.layer.cornerRadius = 10
        pickerView.layer.shadowColor = UIColor.gray.cgColor
        pickerView.layer.shadowOffset = CGSize.init(width: 10, height: 10)
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    private var pickedYear:Int! //选中的年份
    private var pickedMonth:Int!  //选中的月份
    private var pickedDay:Int! //选中的天
    var index1 = 0
    var index2 = 0

    //MARK: - 复写方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        if frame == .zero {
            self.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.width)
        }
        pickedYear = curDateComponets.year
        pickedMonth = curDateComponets.month
        pickedDay = curDateComponets.day
        self.setUpGlobalViews()
    }
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if !pickerView.layer.contains(point) {
            print("回调参数：\(pickedYear)--\(pickedMonth)--\(pickedDay)")
            if okAction != nil {
                okAction!(self.pickedYear,self.pickedMonth,self.pickedDay)
            }
            self.removeFromSuperview()
        }
        return super.hitTest(point, with: event)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
}

//MARK: - 设置UI
extension DatePickerView{
    
    func setUpGlobalViews() {
        
        self.addSubview(self.pickerView)
        //月和日从1计算，因此索引要减去1
        self.pickerView.selectRow(howManyYear - 1, inComponent: 0, animated: false)
        self.pickerView.selectRow(curDateComponets.month! - 1, inComponent: 1, animated: false)
        self.pickerView.selectRow(curDateComponets.day! - 1, inComponent: 2, animated: false)

    }
    
}


//MARK: - 遵循UIPickerViewDelegate,UIPickerViewDataSource协议
extension DatePickerView : UIPickerViewDelegate,UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    ///每个组件有多少行
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return howManyYear
        case 1:
            if (self.pickedYear == curDateComponets.year){
                print("当前有多少个月:\(curDateComponets.month)")
                return curDateComponets.month ?? 12
            }
            return 12
        case 2:
            if (self.pickedMonth >= curDateComponets.month!) && (self.pickedYear == curDateComponets.year){
                print("当前有多少天：\(curDateComponets.day)")
                self.pickedMonth = curDateComponets.month
                self.pickedDay = curDateComponets.day
                return curDateComponets.day ?? 1
            }
            return dayCountInYearAndMonth(year: self.pickedYear, month: self.pickedMonth)
        default:
            return 0
        }
    }
    
    ///设置列宽
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.width / 3
    }
    ///设置行高
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    ///设置每个row的view
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let lbl = UILabel(frame:CGRect(x:0, y:0, width:pickerView.frame.width / 3, height:60))
        lbl.textColor = UIColor.black
        lbl.textAlignment = .center
        let beginYear = curDateComponets.year! - howManyYear + 1    //开始年份
        switch component {
        case 0:
            lbl.text = "\(row + beginYear)年"
        case 1:
            lbl.text = "\(row + 1)月"
        case 2:
            lbl.text = "\(row + 1)日"
        default:
            lbl.text = ""
        }
        
        return lbl
    }
    
    ///选中的行
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("选中了某行: \(component)---\(row)")
        let beginYear = curDateComponets.year! - howManyYear + 1    //开始年份
        switch component {
        case 0:
            self.pickedYear = beginYear + row
            print("选择的年份是:\(beginYear + row)")
            break
        case 1:
            self.pickedMonth = row + 1
            break
        case 2:
            self.pickedDay = row + 1
            break
        default:
            break
        }
        self.pickerView.reloadAllComponents()
        
    }
    
    
}

//MARK: - 内部工具方法
extension DatePickerView{
    
    /// 设置当前显示的年月日
    /// - Parameters:
    ///   - year: 年
    ///   - month: 月
    ///   - day: 日
    func setSelectRow(year:NSInteger,month:NSInteger,day:NSInteger)  {
        let yearEerliest = year - howManyYear
        self.pickerView.selectRow(year - yearEerliest - 1, inComponent: 0, animated: false)
        self.pickerView.selectRow(month - 1, inComponent: 1, animated: false)
        self.pickerView.selectRow(day-1, inComponent: 2, animated: false)
    }
    
    ///查找当前月有多少天
    func dayCountInYearAndMonth(year:NSInteger, month:NSInteger) -> Int{
        switch month {
        case 1,3,5,7,8,10,12:
            return 31
        case 4,6,9,11:
            return 30
        case 2:
            if year % 400 == 0 || (year % 100 != 0 && year % 4 == 0){
                return 29
            }else{
                return 28
            }
        default:
            return 0
        }
    }
    
}
