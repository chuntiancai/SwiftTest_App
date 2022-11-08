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

import SQLite3

class SqliteTestTool: NSObject {
    
    var dbPath:String = ""
    
    static let shareInstance: SqliteTestTool = SqliteTestTool()
    private var db: OpaquePointer?
    
    /// 告诉 SQLite 复制你的字符串。当您的字符串(的缓冲区)在查询执行之前消失时使用此选项。
    private let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    override private init() {
        super.init()
        // 1. 打开数据库
        /**
        *  sqlite3_open 使用这个函数打开一个数据库
        *  参数一: 需要打开的数据库文件路径
        *  参数二: 一个指向SQlite3数据结构的指针, 到时候操作数据库都需要使用这个对象
        *  功能作用: 如果需要打开数据库文件路径不存在, 就会创建该文件;如果存在, 就直接打开; 可通过返回值, 查看是否打开成功
        */
        if dbPath == "" {
            dbPath = "/Users/mathew/Desktop/ctchSqliteTest.sqlite3"
        }
        if sqlite3_open(dbPath, &db) != SQLITE_OK {
            print("打开数据库失败")
        }else {
            print("打开数据库成功")
            if createTable() {  print("创建表成功")  }else {    print("创建表失败")  }
        }
    }
    
    //TODO: 开启事务
    func beginTransaction() -> Bool
    {
        let sql = "BEGIN TRANSACTION"
        return (sqlite3_exec(db, sql, nil, nil, nil) == SQLITE_OK)
    }

    //TODO:  提交事务
    func commitTransaction() -> Bool
    {
        let sql = "COMMIT TRANSACTION"
        return (sqlite3_exec(db, sql, nil, nil, nil) == SQLITE_OK)
    }

    //TODO: 回滚事务
    func rollBackTransaction() -> Bool
    {
        let sql = "ROLLBACK TRANSACTION"
        return (sqlite3_exec(db, sql, nil, nil, nil) == SQLITE_OK)
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
    
    //TODO: swift封装的Sql的准备语句。
    /**
        1、其实就是封装了一个对象，用于管理拼凑sql语句，于是这个对象就叫准备语句对象。
        2、CVarArg... : C语言的可变参数类型。
        3、其实就是sql语句的"?"占位符填入参数。可以用[AnyObject]类型来代替。
     */
    // 绑定参数的
    ///   - columnNameArray: 列名。
    ///   - values: 插入的值。
    func insertPrepareBind(tableName: String, columnNameArray: [String], values: CVarArg...) -> Bool  {

        let tempColumnNameArray = columnNameArray as NSArray
        let columnNames = tempColumnNameArray.componentsJoined(by: ",")


        // 1. 创建需要预编译的SQL语句
        var tempValues: Array = [String]()
        // 创建 "?" 占位符号
        for _ in 0 ..< values.count
        {
            tempValues.append("?")
        }

        let valuesStr = (tempValues as NSArray).componentsJoined(by: ",")
        let prepareSql = "INSERT INTO \(tableName)(\(columnNames)) values (\(valuesStr))"

        var stmt: OpaquePointer? = nil

        /**
         根据sql字符串，创建SQL的预处理语句, 并生成 "语句句柄" , 后续会使用这样的语句句柄绑定数值, 并执行
         参数一：一个打开了的数据库对象。
         参数二：sql语句的字符串
         参数三：需要取出参数二字符串里的长度。"-1":代表自动计算。
         参数四：预处理语句。也就是准备语句对象。
         参数五：根据参数3的长度，取出参数二的长度以后，剩余的参数。
         */
        if sqlite3_prepare_v2(db, prepareSql, -1, &stmt, nil) != SQLITE_OK
        {
            print("预处理失败")
            // 释放语句资源
            sqlite3_finalize(stmt)
            return false
        }

        var index: Int32 = 1

        //2. 绑定sql语句的"?"占位符的实际参数。
        for obj in values {
            if obj is Int  {
                let temp: sqlite_int64 = obj as! sqlite_int64
                /**
                 参数一：准备语句。
                 参数二：绑定值的索引，索引从1开始。
                 参数三：需要绑定的值。
                 */
                sqlite3_bind_int64(stmt, index, temp)
            } else if obj is Double  {
                sqlite3_bind_double(stmt, index, obj as! Double)
            }else if obj is String {
                /**
                 参数一：准备语句。
                 参数二：绑定值的索引，索引从1开始。
                 参数三：需要绑定的值。
                 参数四：取出参数二的多少长度来绑定。 -1：取出所有。
                 参数五：此参数有两个常数，SQLITE_STATIC告诉sqlite3_bind_text函数字符串为常量，可以放心使用；
                                      SQLITE_TRANSIENT会使得sqlite3_bind_text函数对字符串做一份拷贝。
                        一般使用这两个常量参数来调用sqlite3_bind_text。
                        let SQLITE_STATIC = sqlite3_destructor_type(COpaquePointer(bitPattern: 0))
                        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
                 */
                sqlite3_bind_text(stmt, index, obj as! String, -1, SQLITE_TRANSIENT)

            }else {
                continue
            }

            index += 1

        }

        var result: Bool = false
        //3. 执行sql语句，准备语句。
        /**
            1、使用sqlite3_exec()或者sqlite3_step()来执行sql语句，会自动开启一个事务，然后自动提交事务。
            2、如果在函数之前手动开启事务，之后手动提交事务，那么上面两个函数的内部就不会自动开启和提交事务了。
         */
        if sqlite3_step(stmt) == SQLITE_DONE
        {
            print("插入成功")
            result = true
        }else
        {
            print("插入失败")
            result = false

        }

        //4. 将语句复位，此时可以重新绑定参数。
        if sqlite3_reset(stmt) != SQLITE_OK
        {
            print("复位失败")
            result = false
        }

        //5. 释放语句
        sqlite3_finalize(stmt)

        return result


    }



}
