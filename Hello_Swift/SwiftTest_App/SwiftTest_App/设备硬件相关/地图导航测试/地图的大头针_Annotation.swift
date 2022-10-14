//
//  地图的大头针_Annotation.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/9/26.
//  Copyright © 2022 com.mathew. All rights reserved.
//

import MapKit

class MyAnnotation: NSObject,MKAnnotation {
    
    // 确定大头针砸在哪个位置
     var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    
    // Title and subtitle for use by selection UI.
    // 弹框的标题
     var title: String?
    
    // 弹框的子标题
     var subtitle: String?
    
}
