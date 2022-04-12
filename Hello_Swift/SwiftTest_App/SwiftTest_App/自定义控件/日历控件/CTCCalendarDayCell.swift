//
//  CTCCalendarDayCell.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/4/11.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 日历的天的cell

// MARK: - 每一天
class CTCCalendarDayCell: UICollectionViewCell {

    fileprivate var dayLabel: UILabel!        // 公历
    fileprivate var dayChineseLabel: UILabel! // 农历
    var selectView: UIView!                   // 选中
    
    var dayModel: CTCCalendarDayModel? {
        didSet {
            if let model = dayModel {
        
                if model.day == 1 {
                    dayLabel.text = "\(model.month)月"
                } else {
                    dayLabel.text = "\(model.day)"
                }
                
                if model.chineseDay == "初一" {
                    dayChineseLabel.text = model.chineseMonth
                } else {
                    dayChineseLabel.text = model.chineseDay
                }
                
                // 当前天颜色
                    
                // 上月和下月颜色
            } else {
                dayLabel.text = ""
                dayChineseLabel.text = ""
            }
        }
    }
    
    /// 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        selectView.isHidden = true
        self.contentView.addSubview(selectView)
        
        self.contentView.addSubview(dayLabel)
        self.contentView.addSubview(dayChineseLabel)
        
        selectView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        }
        
        dayLabel.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 40, height: 20))
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-8)
        }
        
        dayChineseLabel.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 40, height: 20))
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(8)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

