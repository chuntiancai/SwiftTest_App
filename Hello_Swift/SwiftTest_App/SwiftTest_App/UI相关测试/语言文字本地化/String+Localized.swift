//
//  String+Localized.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/9/13.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 添加String本地化的拓展函数

extension String{
    
    // 本地化语言。
    func localized() -> String {
        
        // 如果不传入本地化文件，默认就会去加载Localizable.strings文件。其实Localizable.strings是一个文件夹。
        let reStr = NSLocalizedString(self, comment: "本地化字符串：\(self)")
        
        // 传入自定义的本地化文件String file。其实也是一个文件夹。
        let resStr2 = NSLocalizedString(self, tableName: "TestLocalizable", bundle: .main, value: self, comment: "本地化字符串")
        print("本地化：\(self) -- retrun: \(reStr) -- restrs:\(resStr2)")
        return resStr2
    }
    
}
