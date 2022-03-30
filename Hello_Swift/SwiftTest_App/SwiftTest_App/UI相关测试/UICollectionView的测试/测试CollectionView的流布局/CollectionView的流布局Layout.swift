//
//  CollectionView的流布局Layout.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/11/30.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// CollectionView的流布局Layout对象

import UIKit

class TestUICollectionViewFlowLayout: UICollectionViewFlowLayout {
    //MARK: - 对外属性
    
    
    //MARK: - 内部属性
    var contentBounds = CGRect.zero       //内容的size
    var cachedAttributes = [UICollectionViewLayoutAttributes]()        //缓存每一个cell的布局特征

    //MARK: - 复写方法
    override func prepare() {
        super.prepare()
        print("∑∑∑∑∑∑∑ TestUICollectionViewFlowLayout的\(#function)方法～")
        contentBounds = CGRect.init(x: 0, y: 0, width: 400, height: 900)
    }
    
}

//MARK: - 设置UI
extension TestUICollectionViewFlowLayout{
    //MARK: 设置初始化的UI
    func initDefaultUI(){
        self.minimumLineSpacing = 20    //横间距
        self.minimumInteritemSpacing = 30   //竖间距
        
//        self.sectionInset = UIEdgeInsets.init(top: 0, left: 50, bottom: 0, right: 50)
    }
}

//MARK: - 复写计算属性和方法
extension TestUICollectionViewFlowLayout{
    
    // - Tag: CollectionViewContentSize 返回collection view的内容尺寸。
    override var collectionViewContentSize: CGSize {
        print("∆∆∆∆ 这是TestUICollectionViewFlowLayout的\(#function)属性～")
        return contentBounds.size
    }
    
    // - Tag: ShouldInvalidateLayout，什么时候应该无效化布局，也就是更新布局
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        return !newBounds.size.equalTo(collectionView.bounds.size)
    }
    
    // - Tag: LayoutAttributesForItem,设置每一个item的布局特征
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let itemAttribute = UICollectionViewLayoutAttributes()
        if indexPath.row == 0 {
            itemAttribute.size = CGSize.init(width: 300, height: 120)
        }else{
            itemAttribute.size = CGSize.init(width: 150, height: 80)
        }
        return itemAttribute
    }
    
    
    
    // - Tag: LayoutAttributesForElements，指定rect中的所有cell的attribute，可用于更新被顶部遮挡住的卡片的布局。
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return super.layoutAttributesForElements(in: rect)
    }
}

//MARK: -
extension TestUICollectionViewFlowLayout{
    
}

//MARK: -
extension TestUICollectionViewFlowLayout{
    
}

// MARK: - 笔记
/**
    1、如果collection view的delegate对象有遵循UICollectionViewDelegateFlowLayout协议，那么Collection View就会从该协议的实现方法中获取和更新UI布局。
      如果CollectionView的delegate对象没有遵循UICollectionViewDelegateFlowLayout协议，那么CollectionView就可以初始化时传入UICollectionViewFlowLayout对象，
      然后CollectionView就会从UICollectionViewFlowLayout对象的属性中获取相关的UI尺寸信息，所以你要赋值给UICollectionViewFlowLayout对象的属性。
    2、在从UICollectionViewFlowLayout对象中获取布局信息的顺序是：
        2.1、首先调用prepare()，所以你要重写prepare()方法，在里面设置好UICollectionViewFlowLayout对象的属性， 提供给CollectionView参考。
        2.2、UICollectionViewFlowLayout对象也会作为UICollectionViewFlowLayout对象的一个内含绑定属性(默认的)。
 */

