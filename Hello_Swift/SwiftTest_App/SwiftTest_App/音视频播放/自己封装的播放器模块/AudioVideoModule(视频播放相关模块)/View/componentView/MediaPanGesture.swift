//
//  MediaPanGesture.swift
//  SwiftTest_App
//
//  Created by mathew on 2023/3/8.
//  Copyright © 2023 com.mathew. All rights reserved.
//
// 音视频手势控制 的滑动手势识别器
// MARK: - 笔记
/**
    1、手势识别成功之后，默认会去调用所在view的touchesCancelled方法，取消view的默认手势识别，继续当前自己的手势识别，识别是一个持续的过程。
    2、要识别当前手势是左右滑动，还是上下滑动，还得监听当前设备的方向。根据方位来确定坐标系，因为旋转后，坐标系的方向也会发生改变。
 */
/// 开始手势的状态，就是手势一开始的时候，是往哪里滑动的，一开始的滑动方向。
enum mediaGestureStartDirection{
    case none;  //初始是没有方向的。
    case up;
    case dowm;
    case left;
    case right;
}


class MediaPanGesture: UIPanGestureRecognizer {
    
    var startDirection:mediaGestureStartDirection{
        get{
            return innerStartDirection
        }
    }
    private var innerStartDirection:mediaGestureStartDirection = .none
    private var trackedTouch: UITouch?  /// 当前手势跟踪的touch
    private var touchedPoints = [CGPoint]() /// 记录touch所更新的坐标点。
    
    /**
     1、设定该手势是单指手势，如果是多点的触摸，那么当前手势继续识别，直接置为failed状态。
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        print("MediaPanGesture 的 \(#function) 方法～")
        if let touch = touches.first {
            let prePoint = touch.previousLocation(in: touch.view?.window)
            let curPoint = touch.location(in: touch.view?.window)
            print("触摸点前后所在位置：\(prePoint)--\(curPoint)")
        }
        
        trackedTouch = trackedTouch ?? touches.first
        if let touch = touches.first, touch != trackedTouch! {
            print("触摸点不是第一个触摸点，忽视这些触摸点")
            ignore(touch, for: event)
            return
        }
        
        
    }
    
    /**
     Gathering the touched points. Ignore the pending touches if the state has already failed.
     */
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        if self.innerStartDirection == .none {
            guard let touch = touches.first, let window = view?.window else {
                fatalError("Failed to unwrap `touches.first` and `view?.window`!")
            }
            /// 设置滑动的开始方向
            touchedPoints.append(touch.location(in: window))
            if touchedPoints.count >= 2
            {
                let firstPoint = touchedPoints[0]
                let secondPoint = touchedPoints[1]
                let deltaX = firstPoint.x - secondPoint.x
                let absX = abs(deltaX)
                let deltaY = firstPoint.y - secondPoint.y
                let absY = abs(deltaY)
                print("开始滑动的打点：\(firstPoint) -- \(secondPoint)")
                if absX > absY {
                    self.innerStartDirection = deltaX > 0 ? .right : .left
                    print("手势开始的时候是左右滑动")
                }else{
                    self.innerStartDirection = deltaY > 0 ? .up : .dowm
                    print("手势开始的时候是上下滑动")
                }
            }
        }
        
    }
    
    /**
     Check if the touched points fit the custom gesture, and change the state accordingly.
     */
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        print("MediaPanGesture 的 \(#function) 方法")
    }
    
    
    
    
    /**
     Clear the touched points and set the state to .possible.
     */
    override func reset() {
        super.reset()
        print("MediaPanGesture 的 \(#function) 方法")
        trackedTouch = nil
        innerStartDirection = .none
        touchedPoints.removeAll()
    }

    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        print("MediaPanGesture 的 \(#function) 方法")
    }
    
    /**
     Count the horizontal turnings for the touched points and return the number.
     
     This sample determines a horizontal turning by calculating the horizontal distances between every two points and checking their signs.
     If a finger goes right and then turns left (or vice versa), the path will have a turning point. The horizontal distance from the point to its
     previous neighbor must be larger than 0, and from the next neighbor to the point must be smaller than 0.
     
     This sample filters out the points that have a same x value because they can't be a horizontal turning, but doesn't go further to eliminate
     the other noises or check the segment distances in the path. Real apps might consider doing that to improve the gesture recognition
     accuracy and avoid recognizing false positive gestures.
     */
    private func countHorizontalTurning(touchedPoints: [CGPoint]) -> Int {
        var distances = [CGFloat]()
        var turningCount = 0
        /**
         Calculate the horizontal distances between every two points.
         Ignore the points that have a same x value because they can't be a horizontal turning.
         */
        guard !touchedPoints.isEmpty else { return 0 }
        _ = touchedPoints.reduce(touchedPoints[0]) { point1, point2 in
            if point2.x != point1.x {
                distances.append(point2.x - point1.x)
            }
            return point2
        }
        /**
         Determine the horizontal turning points by checking the sign of the neighbor distance values.
         */
        guard !distances.isEmpty else { return 0 }
        _ = distances.reduce(distances[0]) { distance1, distance2 in
            if (distance1 > 0 && distance2 < 0) || (distance1 < 0 && distance2 > 0) {
                turningCount += 1
            }
            return distance2
        }
        return turningCount
    }
}
