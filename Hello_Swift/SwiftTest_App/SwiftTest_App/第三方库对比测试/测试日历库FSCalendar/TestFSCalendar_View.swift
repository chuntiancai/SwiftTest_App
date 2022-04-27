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
    let descriLabel = UILabel()     //描述事项的label，多少个基金
    private let detailDayLabel = UILabel()  //具体天的日期 的label
    private let todayBtn = UIButton()   //今天的按钮
    private let screenWidth = UIScreen.main.bounds.width
    
    private let calendarView = FSCalendar.init()    //日历的View
    private let unfoldBtn = UIButton()  //展开按钮
    
    /// 工具组件
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.dateFormat = "yyyy/MM EEEE"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter
    }()
    
    //MARK: - 对外提供属性
    var boundRectWillChangeBlock:((_ preBound:CGRect, _ curBound:CGRect)->Void)?
    
   
    
    /// 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        if self.frame == .zero {
            self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        }
        self.backgroundColor = UIColor(red: 242/255.0, green: 221/255.0, blue: 185/255.0, alpha: 1.0)
        initDefalutUI()
        
        //TODO: 默认进来的是今天
        let curDate = Date()
        calendarView.select(curDate)
        self.configureVisibleCells()
        detailDayLabel.text = self.formatter.string(from: curDate)
        bigDayLabel.text = "\(Calendar.current.component(.day, from: curDate))"
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
            make.centerX.equalTo(screenWidth * 52 / 375.0)
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
            make.left.equalToSuperview().offset(screenWidth * 96 / 375.0)
            make.top.equalToSuperview().offset(screenWidth * 29 / 375.0)
            make.height.equalTo(screenWidth * 20 / 375.0)
            make.width.equalTo(screenWidth * 235 / 375.0)
        }
        
        /// 具体日期的显示
        detailDayLabel.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        detailDayLabel.text = "yyyy/MM EEEE"
        detailDayLabel.lineBreakMode = .byTruncatingTail
        detailDayLabel.font = .systemFont(ofSize: 14, weight: .medium)
        self.addSubview(detailDayLabel)
        detailDayLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(screenWidth * 96 / 375.0)
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
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.today = nil    //隐藏今天默认的圆圈背景
        calendarView.allowsMultipleSelection = false    //不允许选择多个日期
        calendarView.firstWeekday = 2   //从星期一开始
        calendarView.clipsToBounds = true //去掉上下横线
        calendarView.headerHeight = 0   //隐藏头部的月份
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0   //隐藏头部两端的前后月份的显示。
        
        calendarView.locale = Locale.init(identifier: "zh_cn")  //设置日历表头显示中文
        calendarView.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesSingleUpperCase]    //设置显示日、一、二。。，而不是周日周一周二
        calendarView.appearance.weekdayTextColor = UIColor(red: 0.61, green: 0.42, blue: 0.15, alpha: 1)    //设置日历表头日期的颜色
        
        calendarView.appearance.titlePlaceholderColor = UIColor(red: 0.8, green: 0.67, blue: 0.51, alpha: 1)    //填充字体的颜色
        calendarView.appearance.titleFont = .systemFont(ofSize: 20, weight: .medium)    //设置日历数字的字体
        calendarView.appearance.titleSelectionColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)    //选中日期数字的颜色
        calendarView.appearance.selectionColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8) //选中日期数字的背景颜色
        calendarView.placeholderType = .fillSixRows    //一个月显示多少行
        
        calendarView.appearance.eventDefaultColor = UIColor(red: 0.8, green: 0.67, blue: 0.51, alpha: 1)    //小圆点的默认颜色
        calendarView.appearance.eventSelectionColor = UIColor(red: 0.61, green: 0.42, blue: 0.15, alpha: 1)     //小圆点的选中颜色
        calendarView.appearance.eventOffset = CGPoint(x: 0, y: -7)  //小圆点的偏移
        
        
        // 自定义cell
        calendarView.register(TestFSCalendar_Cell.self, forCellReuseIdentifier: "FSCalendar_Cell")
       
        
        self.addSubview(calendarView)
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(bigDayLabel.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(screenWidth * 271/375.0)
            make.centerX.equalToSuperview()
        }
         
        
        /// 展开按钮
        unfoldBtn.addTarget(self, action: #selector(clickUnfoldBtnAction(_:)), for: .touchUpInside)
        unfoldBtn.setTitle("展开", for: .normal)
        unfoldBtn.setTitleColor(UIColor(red: 0.61, green: 0.42, blue: 0.15, alpha: 1), for: .normal)
        unfoldBtn.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
        unfoldBtn.titleLabel?.textAlignment = .center
        unfoldBtn.setImage(UIImage(named: "down_arrow_yellow_icon"), for: .normal)
        self.addSubview(unfoldBtn)
        unfoldBtn.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(18)
            make.width.equalTo(60)
        }
        /// 设置按钮的左文右图
        let imageWidth = unfoldBtn.imageView?.intrinsicContentSize.width ?? 0
        let labelWidth = unfoldBtn.titleLabel?.intrinsicContentSize.width ?? 0
        unfoldBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth + 10, bottom: 0, right: -labelWidth - 10)
        unfoldBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: 0, right: imageWidth)
        
    }
    
}

// MARK: - 逻辑处理
extension TestFSCalendar_View {
    
    /// 配置可见的cell的UI,是否显示白色圆背景
    private func configureVisibleCells() {
        calendarView.visibleCells().forEach { (cell) in
            if let date = calendarView.date(for: cell) {
                if calendarView.selectedDates.contains(date) {
                    (cell as? TestFSCalendar_Cell)?.isShowCircleShape = true
                }else{
                    (cell as? TestFSCalendar_Cell)?.isShowCircleShape = false
                }
            }else{
                (cell as? TestFSCalendar_Cell)?.isShowCircleShape = false
            }
            
        }
    }
    
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
        let curDate = Date()
        calendarView.select(curDate)
        self.configureVisibleCells()
        detailDayLabel.text = self.formatter.string(from: curDate)
        bigDayLabel.text = "\(Calendar.current.component(.day, from: curDate))"
        
        self.configureVisibleCells()
    }
    
    /// 点击了展开按钮
    @objc func clickUnfoldBtnAction(_ button: UIButton?) {
        print("点击了展开按钮 \(#function)")
        if calendarView.scope == .month {
            calendarView.scope = .week
        }else{
            calendarView.scope = .month
        }
        
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
    
    /// 切换周和月的时候，是否需要改变尺寸
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        
        print("是否需要改变尺寸：\(bounds) --- 日历的原来的尺寸：\(calendar.bounds)")
        
        /// 修改view的bounds，但需要在父view修改才会生效
        let heightD_value = bounds.height - calendar.bounds.height
        let preBoundRect = self.bounds
        let boundRect = CGRect(x: 0, y: 0, width: preBoundRect.width, height: preBoundRect.height + heightD_value)
        self.bounds = boundRect
        print("原来的View的尺寸：\(preBoundRect)---修改后：\(boundRect)")
        
        
        calendar.snp.updateConstraints { (make) in
            make.height.equalTo(bounds.height)
        }
        
        ///对外传递bound发生改变的信息
        if boundRectWillChangeBlock != nil {
            boundRectWillChangeBlock!(preBoundRect,boundRect)
        }
        
        self.layoutIfNeeded()
    }
    
    /// 日期数字下是否有小圆点
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 1
    }
    
    /// 提供cell的UI
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "FSCalendar_Cell", for: date, at: position)
        print("FSCalendarDelegate 的 \(#function) 方法,date的值:\(date)， position值：\(position.rawValue)")
        return cell
    }
    
    /// 将要展示的cell
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("FSCalendarDelegate 的 \(#function) 方法,date的值:\(date)， monthPosition值：\(monthPosition.rawValue)")
        /// 选中当前月的第一天
        if  monthPosition == .current {
            if Calendar.current.dateComponents([.day], from: date).day == 1 {
                calendar.select(date)
            }
        }else{
            calendar.deselect(date)
        }
        if calendar.selectedDates.contains(date) {
            (cell as? TestFSCalendar_Cell)?.isShowCircleShape = true
        }else{
            (cell as? TestFSCalendar_Cell)?.isShowCircleShape = false
        }
    }
    
    ///选中的cell
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        print("选中的日期：\(self.formatter.string(from: date))")
        let dateStr = self.formatter.string(from: date)
        bigDayLabel.text = "\(Calendar.current.component(.day, from: date))"
        detailDayLabel.text = dateStr
        if monthPosition != .current {
            calendar.select(date)
        }
        self.configureVisibleCells()
    }
    
    /// 取消选中cell
    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
        self.configureVisibleCells()
    }
    
    
}
