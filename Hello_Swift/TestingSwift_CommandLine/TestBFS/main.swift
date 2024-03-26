//
//  main.swift
//  TestBFS
//
//  Created by ctch on 2024/2/29.
//  Copyright © 2024 com.fendaTeamIOS. All rights reserved.
//

import Foundation

print("Hello, World!")



struct Point {
    var x: Int
    var y: Int
      
    func moveBy(dx: Int, dy: Int) {
        print("我的x值是：",self.x)
    }
}


var point = Point(x: 1, y: 2)
point.moveBy(dx: 5, dy: 10)
print(point.x) // 输出 5
print(point.y) // 输出 10
