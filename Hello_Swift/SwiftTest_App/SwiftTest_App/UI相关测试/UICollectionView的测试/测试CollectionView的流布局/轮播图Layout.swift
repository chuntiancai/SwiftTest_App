//
//  轮播图Layout.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/7/29.
//  Copyright © 2022 com.mathew. All rights reserved.
//

import CoreGraphics

// CollectionView的轮播图布局Layout对象
// MARK: - 笔记
/**
    
 */


class CollectionViewRoungImage_Layout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


//MARK: - 复写计算属性和方法
extension CollectionViewRoungImage_Layout{
    
    //TODO: 1、collectionView 第一次布局 或者 刷新 的时候调用。
    /**
      作用:计算cell的布局,条件:cell的索引(IndexPath)是固定不变
     */
    override func prepare() {
        super.prepare()
    }
    
    //TODO: 2、返回collection view的内容尺寸。
    override var collectionViewContentSize: CGSize {
        /// 默认会根据cell的个数进行计算
        return super.collectionViewContentSize
    }
    
    
    //TODO: 3、你要返回这个rect中所有cell的attribute特征数组，滑动collection view的时候被调用。
    /**
        1、设置cell尺寸 => UICollectionViewLayoutAttributes
        2、越靠近中心点,距离越小,缩放越大
        3、求cell与中心点距离
     */
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let superArr = super.layoutAttributesForElements(in: rect) else { return nil  }
        for attri in superArr {
            /// 计算cell的中心点与bounds中心点的距离
            let delta:CGFloat = abs((attri.center.x - collectionView!.contentOffset.x) - (collectionView!.bounds.width / 2))
            
            /// 计算缩放比例,越靠近中点，比例越大。
            let scale:CGFloat = 1 -  delta / (collectionView!.bounds.width / 2) * 0.35
            attri.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        return superArr
    }
    
    //TODO: 4、当collectionview的bounds发生改变时，即在滚动的时候是否允许刷新布局。
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    //TODO: 5、用户手指一松开就会调用，确定最终偏移量，定位到中点。
    /**
        1、proposedContentOffset:建议停止时的位移。
           targetContentOffset方法的返回值：你要求collectionView的最终偏移量。
           self.collectionView?.contentOffset: 手指松开时的位移。
     */
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        // 拖动比较快 最终偏移量 不等于 手指离开时偏移量
        let boundsWidth = self.collectionView!.bounds.size.width;
        
        // 最终偏移量
        var targetP = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        
        // 0.获取最终显示的区域
        let targetRect = CGRect(x: targetP.x, y: 0, width: boundsWidth, height: CGFloat(MAXFLOAT))
        
         // 1.获取最终显示的rect内的所有cell的attribute
        guard let attrs = super.layoutAttributesForElements(in: targetRect) else { return .zero}
        
        // 找出最小间距
        var minDelta = CGFloat(MAXFLOAT)
        for attr in attrs {
            // 获取距离中心点距离:注意:应该用最终的x
            let delta = (attr.center.x - targetP.x) - boundsWidth * 0.5;
            
            if (abs(delta) < abs(minDelta)) {
                minDelta = delta;
            }
        }

        // 设置移动间距
        targetP.x += minDelta
        
        if (targetP.x < 0) {
            targetP.x = 0;
        }
        return targetP;
    }
    
}




