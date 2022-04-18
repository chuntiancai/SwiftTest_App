//
//  TestFSCalendar_View.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/4/18.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试FSCalendar的view


import FSCalendar

class  TestFSCalendar_View: UIView {
    
    //MARK: - UI属性
    private let bigDayLabel:UILabel = UILabel()     //大数字 天 label
    private let descriLabel = UILabel()     //描述事项的label，多少个基金
    private let detailDayLabel = UILabel()  //具体天的日期 的label
    private let todayBtn = UIButton()   //今天的按钮
    private let screenWidth = UIScreen.main.bounds.width
    
    private let calendarView = FSCalendar.init()    //日历的View
    
    /// 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        if self.frame == .zero {
            self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        }
        self.backgroundColor = UIColor.clear
        initDefalutUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("TestFSCalendar_View-delloc 析构啦～")
    }
    
}
// MARK: - 设置UI
extension TestFSCalendar_View {
    
    /// 初始化默认UI
    func initDefalutUI(){
        
        /// 天的数字的label
        bigDayLabel.text = "28"
        bigDayLabel.textColor = UIColor.black
        bigDayLabel.textAlignment = .center
        bigDayLabel.font = .systemFont(ofSize: 68, weight: .medium)
        self.addSubview(bigDayLabel)
        bigDayLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(screenWidth * 20 / 375.0)
            make.top.equalToSuperview()
            make.height.equalTo(screenWidth * 82 / 375.0)
        }
        
        /// 描述当天事项的label
        descriLabel.textColor = UIColor(red: 0.55, green: 0.35, blue: 0.07, alpha: 1)
        descriLabel.text = "今日在售基金**个"
        descriLabel.lineBreakMode = .byTruncatingTail
        descriLabel.font = .systemFont(ofSize: 14, weight: .regular)
        self.addSubview(descriLabel)
        descriLabel.snp.makeConstraints { make in
            make.left.equalTo(bigDayLabel.snp.right).offset(14)
            make.top.equalToSuperview().offset(screenWidth * 29 / 375.0)
            make.height.equalTo(screenWidth * 20 / 375.0)
            make.width.equalTo(screenWidth * 235 / 375.0)
        }
        
        /// 具体日期的显示
        detailDayLabel.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        detailDayLabel.text = "2020/08 星期日"
        detailDayLabel.lineBreakMode = .byTruncatingTail
        detailDayLabel.font = .systemFont(ofSize: 14, weight: .medium)
        self.addSubview(detailDayLabel)
        detailDayLabel.snp.makeConstraints { make in
            make.left.equalTo(bigDayLabel.snp.right).offset(14)
            make.top.equalTo(descriLabel.snp.bottom).offset(4)
            make.height.equalTo(screenWidth * 20 / 375.0)
            make.width.equalTo(screenWidth * 235 / 375.0)
        }
        
        /// 今天按钮
        todayBtn.addTarget(self, action: #selector(clickTodayBtnAction(_:)), for: .touchUpInside)
        todayBtn.layer.borderWidth = 1.0
        todayBtn.setTitle("今", for: .normal)
        todayBtn.setTitleColor(UIColor(red: 0.61, green: 0.42, blue: 0.15, alpha: 1), for: .normal)
        todayBtn.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        todayBtn.layer.borderColor = UIColor(red: 0.61, green: 0.42, blue: 0.15, alpha: 1).cgColor
        todayBtn.layer.cornerRadius = 14
        self.addSubview(todayBtn)
        todayBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(screenWidth * 45 / 375.0)
            make.right.equalToSuperview().offset(-20)
            make.height.width.equalTo(28)
        }
        
        
        /// 日历的View
        calendarView.layer.borderWidth = 1.0
        calendarView.layer.borderColor = UIColor.red.cgColor
        calendarView.dataSource = self
        calendarView.delegate = self
        self.addSubview(calendarView)
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(bigDayLabel.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.785)
            make.centerX.equalToSuperview()
        }
        
    }
    
}

// MARK: - 逻辑处理
extension TestFSCalendar_View {
    
    /// 更新显示
    func refreshDayLabel() {
       
    }
    
    /// 向左滚动
    func scrollToLast(_ dayModel: CTCCalendarDayModel? = nil, isScroll: Bool = true) {
        
    }
    
    /// 向右滚动
    func scrollToNext(_ dayModel: CTCCalendarDayModel? = nil, isScroll: Bool = true) {
        
        
    }
    
}

// MARK: - Action，动作方法
@objc extension TestFSCalendar_View {
    
    
    /// 点击了今天按钮
    @objc func clickTodayBtnAction(_ button: UIButton?) {
        print("点击了今天按钮 \(#function)")
       
    }
    
    
}

// MARK: - UIScrollViewDelegate
extension TestFSCalendar_View: UIScrollViewDelegate {
    
    /// 开始拖拽
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    }

    /// 结束减速
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    }
    
}

// MARK: - 遵循FSCalendar的协议
extension TestFSCalendar_View: FSCalendarDataSource, FSCalendarDelegate{
    
}
