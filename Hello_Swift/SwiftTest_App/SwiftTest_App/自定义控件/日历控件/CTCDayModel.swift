//
//  CTCDayModel.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/4/8.
//  Copyright © 2022 com.mathew. All rights reserved.
//
//  日历的天的model

// MARK: - 当月的天 枚举
enum CTCDayType:Int {
    case current = 0
    case last
    case next
}

// MARK: - 数据
public struct CTCDayModel {
    /// 公历
    var year: Int = 1970
    var month: Int = 1
    var day: Int = 1
    var week: Int = 1
    
    /// 农历
    var chineseYear: String = ""
    var chineseMonth: String = ""
    var chineseDay: String = ""
    
    /// indexPath
    var indexPath: IndexPath = IndexPath.init(item: 0, section: 0)
    
    /// 当月的天枚举，默认当天
    var dayType: CTCDayType = .current
    
    
    //TODO: 根据日期获取CTCDayModel
    /// - Parameters:
    ///   - date: Date
    ///   - index: 天数索引
    ///   - dayType: 属于当月
    /// - Returns: CTCDayModel
    static func getDayModel(date: Date, index: Int, dayType: CTCDayType) -> CTCDayModel {
        var model = CTCDayModel()
        // 公历
        model.day = index + 1
        model.year = CTCDateTool.currentYear(date: date)
        model.month = CTCDateTool.currentMonth(date: date)
        
        // 农历
        let currentDate = CTCDateTool.dateStringToDate("\(model.year)-\(model.month)-\(model.day)")
        model.chineseDay = CTCDateTool.currentChineseDay(date: currentDate)
        model.chineseYear = CTCDateTool.currentChineseYear(date: currentDate)
        model.chineseMonth = CTCDateTool.currentChineseMonth(date: currentDate)
        
        // 星期
        model.week = CTCDateTool.currentWeekDay(date: currentDate)
        
        // 类型
        model.dayType = dayType
        
        return model
    }
    
    //TODO: 获取（分页）日历数据
    /// - Parameters:
    ///   - startYear: 开始年份
    ///   - endYear: 结束年份
    /// - Returns: 数据模型数组
    static func getDatePageList(startYear:Int? = nil,endYear:Int? = nil) -> [[CTCDayModel?]] {
        var monthArray: [[CTCDayModel?]] = []
        var dayArray: [CTCDayModel?] = []
        
        var curStartYear = startYear != nil ? startYear! : CTCDateTool.currentYear()
        var curEndYear = endYear != nil ? endYear! : CTCDateTool.currentYear()
        
        var currentDate = CTCDateTool.dateStringToDate("\(curStartYear)-01-01")
        
        while CTCDateTool.currentYear(date: currentDate) <= curEndYear {
            
            dayArray.removeAll() // 移除上月数据
            
            // 当月第一天是星期几
            let dayInWeek = CTCDateTool.firstWeekDayInCurrentMonth(date: currentDate)
            // 当月天数
            let days = CTCDateTool.countOfDaysInCurrentMonth(date: currentDate)
            // 上月天数
            let lastMonth = CTCDateTool.lastMonth(date: currentDate)
            let lastDays = CTCDateTool.countOfDaysInCurrentMonth(date: lastMonth)
            // 下月天数
            let nextMonth = CTCDateTool.nextMonth(date: currentDate)
            //let nextDays = CTCDateTool.countOfDaysInCurrentMonth(date: nextMonth)
            
            // 上月
            for j in 0..<dayInWeek {
                var model = getDayModel(date: lastMonth, index: lastDays - dayInWeek + j, dayType: .last)
                model.indexPath = IndexPath.init(item: dayArray.count, section: 0)
                dayArray.append(model)
            }

            // 当月
            for i in 0..<days {
                var model = getDayModel(date: currentDate, index: i, dayType: .current)
                model.indexPath = IndexPath.init(item: dayArray.count, section: 0)
                dayArray.append(model)
            }
            
            // 下月
            for k in 0..<(42 - days - dayInWeek) {
                var model = getDayModel(date: nextMonth, index: k, dayType: .next)
                model.indexPath = IndexPath.init(item: dayArray.count, section: 0)
                dayArray.append(model)
            }
            
            // 拼接数据
            monthArray.append(dayArray)
            
            // 继续获取下月数据
            currentDate = CTCDateTool.nextMonth(date: currentDate)
        }
        return monthArray
    }

}
