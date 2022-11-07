//
//  Sqlite_Student.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/11/7.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试数据库的学生对象。
//MARK: - 笔记
/**
    1、一般直接在model里面就封装相应的sql语句，方便操作。
 */

class Sqlite_Student: NSObject {

    var name: String = ""
    var score: String = ""

    override init() {

    }

    init(name: String, score: String) {
        self.name = name
        self.score = score
    }


    // 插入一个学生对象
    func insertStudent() {

        if  SqliteTestTool.shareInstance.insert(tableName: "t_student", columnNameArray: ["name", "score"], valueArray: [self.name, self.score])
      {
        print("插入成功")
      }else
      {
        print("插入失败")
      }
        
    }


}
