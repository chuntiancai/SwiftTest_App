//
//  无限滑动Layout.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/8/30.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// CollectionView的无限滑动布局Layout对象
// MARK: - 笔记
/**
    1、
 */


class Infinite_FlowLayout: UICollectionViewFlowLayout {
    //MARK: - 对外属性
    
    
    //MARK: - 内部属性
    var contentBounds = CGRect.zero       //内容的size

    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - 复写计算属性和方法
extension Infinite_FlowLayout{
    
    //TODO: 1、collectionView 第一次布局 或者 刷新 的时候调用。
    /**
      作用:计算cell的布局,条件:cell的位置(IndexPath)是固定不变
     */
    override func prepare() {
        super.prepare()
        print("∑∑∑∑∑∑∑ Infinite_FlowLayout的\(#function)方法～")
    }
    
    //TODO: 2、返回collection view的内容尺寸。
    override var collectionViewContentSize: CGSize {
        if let collView = collectionView {
            if collView.numberOfSections == 1 {
                let itemCount = collView.numberOfItems(inSection: 0)
                let itemWidth = (self.itemSize.width + self.minimumLineSpacing) * CGFloat(itemCount)
                let itemHeight = self.itemSize.height + self.minimumInteritemSpacing
                let contentWidth = itemWidth + self.minimumLineSpacing + self.sectionInset.left + self.sectionInset.right
                contentBounds = CGRect(x: 0, y: 0, width: contentWidth, height: itemHeight)
            }
        }
        
        print("∆∆∆∆ 这是Infinite_FlowLayout的\(#function)计算属性～")
        return contentBounds.size
    }
    
    
    //TODO: 3、你要返回这个rect中所有cell的attribute特征数组，滑动collection view的时候被调用。
    /**
        1、你可以根据父类传递下来的数组，获取到当前rect中的所有cell得特征数组。
        2、其实rect只是指示可见范围而已，还是回返回所有的cell的attribute数组，你可以返回指定rect的attribute数组，也可以返回所有cell的attribute数组。
           但是要注意，attribute是根据indexpath来定位的，不是根据rect来定位的。
        3、所以你可以写一个缓存attribute数组的属性，提高查找性能，完全自己控制。
        4、其实这个rect就是collection view 的bounds，因为bounds是可见范围在自身坐标系的位置。
     */
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        print("∆∆∆∆ 这是Infinite_FlowLayout的\(#function)方法～")
        if let superArr = super.layoutAttributesForElements(in: rect){
            for attribute in superArr {
                if attribute.indexPath.row == 0 {
//                    print("rect中的attribute：\(attribute.indexPath)")
//                    print("获取到的layoutAttributesForItem的：\(String(describing: layoutAttributesForItem(at: attribute.indexPath)))")
                }
                
            }
        }
        return super.layoutAttributesForElements(in: rect)
    }
    
    //TODO: 4、当collectionview的bounds发生改变时，即在滚动的时候是否允许刷新布局。
    /**
        1、其实就是移动collectview的内容时调用，因为bounds 就是 当前可视范围 在 自身坐标系的位置和尺寸。
        2、这里的目的是bounds的尺寸发生变化时，去更新布局。
     */
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
//        print("∆∆∆∆ 这是Infinite_FlowLayout的\(#function)方法 -- \(newBounds)～")
        guard let collectionView = self.collectionView else { return false }
        return !newBounds.size.equalTo(collectionView.bounds.size)
    }
    
    //TODO: 5、用户手指一松开就会调用，确定最终偏移量。
    /**
        1、proposedContentOffset:建议停止时的位移。
           targetContentOffset方法的返回值：你要求collectionView的最终偏移量。
           self.collectionView?.contentOffset: 手指松开时的位移。
     
        2、滚动速度，我也不知道怎么算的，正着走为正数，负着走为负数，不需要加速则为零。
     
        3、你重新赋值之后，滑动结束后会调用CollViewDelegate的scrollViewDidEndDecelerating(_:)方法
     */
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        // 拖动比较快 最终偏移量 不等于 手指离开时偏移量
        let boundsWidth = self.collectionView!.bounds.size.width;
        
        print("滚动速度：\(velocity) -- \(self.collectionView!.decelerationRate)")
        // 最终偏移量
        var targetP = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        
        // 0.获取最终显示的区域
        let targetRect = CGRect(x: targetP.x, y: 0, width: boundsWidth, height: CGFloat(MAXFLOAT))
        
         // 1.获取最终显示的rect内的所有cell的attribute
        guard let attrs = super.layoutAttributesForElements(in: targetRect) else { return .zero}
        
        // 找出最小间距
        var minDelta = CGFloat(MAXFLOAT)
        var targetAttr:UICollectionViewLayoutAttributes?
        for attr in attrs {
            // 获取距离中心点距离:注意:应该用最终的x
            let delta = (attr.center.x - targetP.x) - boundsWidth * 0.5;
            
            if (abs(delta) < abs(minDelta)) {
                minDelta = delta;
                targetAttr = attr
            }
        }
        

        // 设置移动间距
        targetP.x += minDelta
        
        if (targetP.x < 0) { targetP.x = 0;  }
        
        if targetAttr != nil {
            var indexPath = targetAttr!.indexPath
            var finalAttr : UICollectionViewLayoutAttributes?
            
            if indexPath.row == 0 {
                indexPath.row = self.collectionView!.numberOfItems(inSection: 0) - 2
                finalAttr = self.layoutAttributesForItem(at: indexPath)
                self.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            }else if indexPath.row == self.collectionView!.numberOfItems(inSection: 0) - 1 {
                indexPath.row = 1
                finalAttr = self.layoutAttributesForItem(at: indexPath)
                self.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            }
            print("目标attr：\(indexPath)")
            print("最终attr：\(finalAttr)")
            if let attr = finalAttr {
                targetP.x = attr.center.x - boundsWidth * 0.5
            }
        }
        return targetP;
    }
    
    //TODO: 工具：手动调用获取每一个item的布局特征，目的是根据indexPath获取item特征数组里面的指定的元素。
    /**
        1、默认返回的是 根据indexPath获取item特征数组里面的元素，但是修改UICollectionViewLayoutAttributes的属性之后，就是copy之后的对象了，并不会对数组的元素造成影响。
        2、所以你要改变数组里面的元素的话，还是得重新赋值给数组。
        3、所以就是一个工具方法，根据indexpath获取item的特征对象，没有其它作用了。相当于一个工具而已。
     */
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        print("∆∆∆∆ 这是Infinite_FlowLayout的\(#function)方法～")
        let itemAttribute = super.layoutAttributesForItem(at: indexPath)
        
//        if indexPath.row == 0 {
//            itemAttribute!.size = CGSize.init(width: 300, height: 120)
//        }else{
//            itemAttribute!.size = CGSize.init(width: 150, height: 80)
//        }
        return itemAttribute
    }
    
}
