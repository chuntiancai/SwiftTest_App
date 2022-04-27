//
//  FSCalendar_SB_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/4/19.
//  Copyright © 2022 com.mathew. All rights reserved.
//

import FSCalendar

class FSCalendar_SB_VC: UIViewController,FSCalendarDelegate,FSCalendarDataSource {
    
    @IBOutlet weak var calendar: FSCalendar!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "测试FSCalendar的SB_VC"
        self.calendar.select(Date())
        self.calendar.scope = .week

    }
    

 

}
