//
//  PDFResourceModel.swift
//  SwiftNote_App
//
//  Created by 蔡天春 on 2021/6/27.
//  Copyright © 2021 com.mathew. All rights reserved.
//

import Foundation


/// 资源类型
enum PDFResType {
    case Image
    case PDF
}

protocol ReadBaseModelProtocal {
    var fileName:String {get set }
    var type:PDFResType {get set}
}

/// pdf资源model
struct PDFResourceModel:ReadBaseModelProtocal {
    var fileName: String
    var type: PDFResType
    var url:URL     //一个pdf文件的url
}

/// 图片资源model
struct ImgResModel:ReadBaseModelProtocal {
    var fileName: String
    var type: PDFResType
    var urlArr:[URL]    //多张图片的url
}

