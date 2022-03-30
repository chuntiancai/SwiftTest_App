//
//  Bugly_Error.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/2/21.
//  Copyright © 2022 com.mathew. All rights reserved.
//

class Bugly_Error:NSObject,Error {
    var msg:String = ""
    override var description: String {
            return "Test Atuo Report Bugly_Error "
    }
    init(msg: String) {
        super.init()
        self.msg = msg
    }
}
