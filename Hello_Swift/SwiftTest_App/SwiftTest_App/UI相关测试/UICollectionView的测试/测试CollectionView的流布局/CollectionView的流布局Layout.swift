//
//  CollectionView的流布局Layout.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/11/30.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// CollectionView的流布局Layout对象
// MARK: - 笔记
/**
    1、如果collection view的delegate对象有遵循UICollectionViewDelegateFlowLayout协议，那么Collection View就会从该协议的实现方法中获取和更新UI布局。
       如果CollectionView的delegate对象没有遵循UICollectionViewDelegateFlowLayout协议，那么CollectionView就可以初始化时传入UICollectionViewFlowLayout对象，
       然后CollectionView就会从UICollectionViewFlowLayout对象的属性中获取相关的UI尺寸信息，所以你要赋值给UICollectionViewFlowLayout对象的属性。
 
    2、在从UICollectionViewFlowLayout对象中获取布局信息的顺序是：
        2.1、首先调用prepare()，所以你要重写prepare()方法，在里面设置好UICollectionViewFlowLayout对象的属性， 提供给CollectionView参考。
        2.2、UICollectionView对象也会作为UICollectionViewFlowLayout对象的一个内含绑定属性(默认的)。
    
    3、流水布局的意思是：如果当前你给的cell的尺寸比手机屏幕要宽，那么久自动把这个cell往下挪。
 
    4、UICollectionViewLayoutAttributes是每一个item的详细的位置尺寸信息，用于告知UIkit怎么详细布局一个item。
 */


class TestUICollectionViewFlowLayout: UICollectionViewFlowLayout {
    //MARK: - 对外属性
    
    
    //MARK: - 内部属性
    var contentBounds = CGRect.zero       //内容的size
    var cachedAttributes = [UICollectionViewLayoutAttributes]()        /// 缓存每一个item的布局特征

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
        
//        self.sectionInset = UIEdgeInsets.init(top: 0, left: 50, bottom: 0, right: 50)
    }
}

//MARK: - 复写计算属性和方法
extension TestUICollectionViewFlowLayout{
    
    //TODO: 返回collection view的内容尺寸。
    override var collectionViewContentSize: CGSize {
//        print("∆∆∆∆ 这是TestUICollectionViewFlowLayout的\(#function)计算属性～")
        return contentBounds.size
    }
    
    //TODO: 当collectionview的bounds发生改变时，是否要更新布局。
    /**
        1、其实就是移动collectview的内容时调用，因为bounds 就是 当前可视范围 在 自身坐标系的位置和尺寸。
        2、这里的目的是bounds的尺寸发生变化时，去更新布局。
     */
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
//        print("∆∆∆∆ 这是TestUICollectionViewFlowLayout的\(#function)方法 -- \(newBounds)～")
        guard let collectionView = self.collectionView else { return false }
        return !newBounds.size.equalTo(collectionView.bounds.size)
    }
    
    //TODO: 设置每一个item的布局特征
    /**
        1、
     */
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        print("∆∆∆∆ 这是TestUICollectionViewFlowLayout的\(#function)方法～")
        let itemAttribute = UICollectionViewLayoutAttributes()
        if indexPath.row == 0 {
            itemAttribute.size = CGSize.init(width: 300, height: 120)
        }else{
            itemAttribute.size = CGSize.init(width: 150, height: 80)
        }
        return itemAttribute
    }
    
    
    
    //TODO: 指定rect中的所有cell的attribute，可用于更新被顶部遮挡住的卡片的布局。
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        print("∆∆∆∆ 这是TestUICollectionViewFlowLayout的\(#function)方法～")
        return super.layoutAttributesForElements(in: rect)
    }
}



