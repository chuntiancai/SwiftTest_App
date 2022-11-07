//
//  SqliteTestTool.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/11/7.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 测试Sqlite的工具类，是一个单例。
//MARK: - 笔记
/**
    1、一个app对应一个数据库就好，实在不行，你至少一个单例对应一个数据库。
    2、在该数据库单例设计你的表结构和sql语句的封装。
 */

class SqliteTestTool: NSObject {

    private var db: OpaquePointer? = nil
    private var dbPath:String = ""

    static let shareInstance: SqliteTestTool = SqliteTestTool()
    
    convenience init(_ dbPath:String) {
        self.init()
        self.dbPath = dbPath
        // 1. 打开数据库
        /**
        *  sqlite3_open 使用这个函数打开一个数据库
        *  参数一: 需要打开的数据库文件路径
        *  参数二: 一个指向SQlite3数据结构的指针, 到时候操作数据库都需要使用这个对象
        *  功能作用: 如果需要打开数据库文件路径不存在, 就会创建该文件;如果存在, 就直接打开; 可通过返回值, 查看是否打开成功
        */
        if sqlite3_open(dbPath, &db) != SQLITE_OK {
            print("打开数据库失败")
        }else {
            print("打开数据库成功")
            if createTable() {  print("创建表成功")  }else {    print("创建表失败")  }
        }
        
    }

    override init() {
        super.init()

       

    }


    //TODO: 创建表的sql语句
    private func createTable() -> Bool {
        let sql = "CREATE TABLE IF NOT EXISTS t_student(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, score REAL)"

        // 如果语句执行失败, 可以print下sql语句, 然后拷贝到Navicat工具中执行, 查看是否执行成功
        return (sqlite3_exec(db, sql, nil, nil, nil) == SQLITE_OK)

    }

    //TODO: Sql的插入语句。
    func insert(tableName: String, columnNameArray: [String], valueArray: [String]) -> Bool {

        // 1. 创建SQL语句
        let tempColumnNameArray = columnNameArray as NSArray
        let columnNames = tempColumnNameArray.componentsJoined(by: ",")

        let tempValueArray = valueArray as NSArray
        let values:String = tempValueArray.componentsJoined(by: "\',\'")

        let sql = "INSERT INTO \(tableName)(\(columnNames)) values (\'\(values)\')"

        // 2. 执行SQL语句
        return (sqlite3_exec(db, sql, nil, nil, nil) == SQLITE_OK)

    }




}
