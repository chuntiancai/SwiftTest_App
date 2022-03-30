//
//  CollectionView的网格布局Layout.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/12/1.
//  Copyright © 2021 com.mathew. All rights reserved.
//
//   CollectionView的网格布局Layout，也叫马赛克布局
import UIKit

class TestUICollectionViewMosaicLayout: UICollectionViewLayout {

    var contentBounds = CGRect.zero       //内容的size
    var cachedAttributes = [UICollectionViewLayoutAttributes]()        //缓存每一个cell的布局特征
    
    //初始化布局特征数据，例如缓存数组，在collection view 换上新的布局对象之前，UIKit会先调用该方法
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }

        // Reset cached information.重新设置每一cell的布局特征,
        cachedAttributes.removeAll()
        //整个collection view的content的边界范围
        contentBounds = CGRect(origin: .zero, size: collectionView.bounds.size)
        
        
        // 准备每一个item的布局特征，将每一个item的布局特征进缓存数组里
        let count = collectionView.numberOfItems(inSection: 0)
        
        let cvWidth = collectionView.bounds.size.width
        let screenHeight = UIScreen.main.bounds.height
        let leftMargin = cvWidth * (23.0/375.0)
        let itemSpacing = leftMargin * 0.5
        
        //设置第一个item的布局特征存进缓存数组中，现在我只参考屏幕的宽度，而不参考高度
        let firstItemFrame = CGRect(x: leftMargin, y: leftMargin ,
                                    width: cvWidth * (330.0/375.0),height: cvWidth * (208.0/375.0))
        let firstAttributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: 0, section: 0))
        firstAttributes.frame = firstItemFrame
        cachedAttributes.append(firstAttributes)
        
        //记录上一个item的frame位置，前向标志器
        var lastFrame: CGRect = firstItemFrame
        
        //初始化剩余的每一个方片item的布局特征进缓存数组中
        var currentIndex = 1
        while currentIndex < (count - 1) {
            
            //左边方片的frame
            let leftItemFrame = CGRect(x: leftMargin, y: lastFrame.maxY + itemSpacing,
                                       width: cvWidth * (160.0/375.0),height: cvWidth * (200.0/375.0))
            
            let rightItemFrame = CGRect(x: cvWidth * (160.0/375.0) + (itemSpacing * 3), y: lastFrame.maxY + itemSpacing,
                                        width: cvWidth * (160.0/375.0), height: cvWidth * (200.0/375.0))
            
            let segmentRects = [leftItemFrame,rightItemFrame]       //临时矩形储存数组
            // 为上述计算出的frame创建相应的布局特征，并存进布局特征缓存数组
            for rect in segmentRects {
                let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: currentIndex, section: 0))
                attributes.frame = rect
                //存入每一个方片item的布局特征缓存数组
                cachedAttributes.append(attributes)
                contentBounds = contentBounds.union(lastFrame)
                currentIndex += 1
                lastFrame = rect
            }
            
        }
        //最后一个“编辑卡片”label的布局特征
        let finalItemFrame = CGRect(x: leftMargin, y: lastFrame.maxY + itemSpacing,
                                    width: cvWidth * (8.8/10.0),height: screenHeight * (1.2/21.5))
        let finalItemAttributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: (count - 1), section: 0))
        finalItemAttributes.frame = finalItemFrame
        cachedAttributes.append(finalItemAttributes)
        contentBounds = contentBounds.union(finalItemFrame)
        let blankFrame = CGRect(x: leftMargin, y: finalItemFrame.maxY,
                                width: cvWidth * (8.8/10.0),height: itemSpacing)
        contentBounds = contentBounds.union(blankFrame)
        
    }
    
    // - Tag: CollectionViewContentSize
    override var collectionViewContentSize: CGSize {
        return contentBounds.size
    }
    
    // - Tag: ShouldInvalidateLayout，什么时候应该无效化布局，也就是更新布局
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        return !newBounds.size.equalTo(collectionView.bounds.size)
    }
    
    // - Tag: LayoutAttributesForItem,设置每一个item的布局特征
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[indexPath.item]
    }
    
    // - Tag: LayoutAttributesForElements，指定rect中的所有cell的attribute
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesArray = [UICollectionViewLayoutAttributes]()
        
        // Find any cell that sits within the query rect.
        guard let lastIndex = cachedAttributes.indices.last,
              let firstMatchIndex = binSearch(rect, start: 0, end: lastIndex) else { return attributesArray }
        
        // Starting from the match, loop up and down through the array until all the attributes
        // have been added within the query rect.找出第一个匹配的cell，然后翻转数组，从零到当前也就成了从当前到零了。找出顶部被遮住的部分
        for attributes in cachedAttributes[..<firstMatchIndex].reversed() {
            guard attributes.frame.maxY >= rect.minY else { break }
            attributesArray.append(attributes)
        }
        
        for attributes in cachedAttributes[firstMatchIndex...] {
            guard attributes.frame.minY <= rect.maxY else { break }
            attributesArray.append(attributes)
        }
        
        return attributesArray
    }
    
    // Perform a binary search on the cached attributes array.二分查找，找出第一个匹配的cell的index
    func binSearch(_ rect: CGRect, start: Int, end: Int) -> Int? {
        if end < start { return nil }
        
        let mid = (start + end) / 2
        let attr = cachedAttributes[mid]
        
        if attr.frame.intersects(rect) {
            return mid
        } else {
            if attr.frame.maxY < rect.minY {
                return binSearch(rect, start: (mid + 1), end: end)
            } else {
                return binSearch(rect, start: start, end: (mid - 1))
            }
        }
    }
    
}

