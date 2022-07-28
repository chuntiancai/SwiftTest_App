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
    
    //TODO: 1、collectionView 第一次布局 或者 刷新 的时候调用。
    /**
      作用:计算cell的布局,条件:cell的位置(IndexPath)是固定不变
     */
    override func prepare() {
        super.prepare()
        print("∑∑∑∑∑∑∑ TestUICollectionViewFlowLayout的\(#function)方法～")
        contentBounds = CGRect.init(x: 0, y: 0, width: 500, height: 900)
    }
    
    //TODO: 2、返回collection view的内容尺寸。
    override var collectionViewContentSize: CGSize {
        print("∆∆∆∆ 这是TestUICollectionViewFlowLayout的\(#function)计算属性～")
        return contentBounds.size
    }
    
    
    //TODO: 3、你要返回这个rect中所有cell的attribute特征数组，滑动collection view的时候被调用。
    /**
        1、你可以根据父类传递下来的数组，获取到当前rect中的所有cell得特征数组。
        2、其实rect只是指示可见范围而已，还是回返回所有的cell的attribute数组，你可以返回指定rect的attribute数组，也可以返回所有cell的attribute数组。
           但是要注意，attribute是根据indexpath来定位的，不是根据rect来定位的。
        3、所以你可以写一个缓存attribute数组的属性，提高查找性能，完全自己控制。
     */
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        print("∆∆∆∆ 这是TestUICollectionViewFlowLayout的\(#function)方法～")
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
//        print("∆∆∆∆ 这是TestUICollectionViewFlowLayout的\(#function)方法 -- \(newBounds)～")
        guard let collectionView = self.collectionView else { return false }
        return !newBounds.size.equalTo(collectionView.bounds.size)
    }
    
    //TODO: 5、用户手指一松开就会调用，确定最终偏移量。
    /**
        1、proposedContentOffset:建议停止时的位移。
           targetContentOffset方法的返回值：你要求collectionView的最终偏移量。
           self.collectionView?.contentOffset: 手指松开时的位移。
     */
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let targetP = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        print("手指：\(proposedContentOffset) -- \(velocity) - 最终偏移量: \(targetP) --contentOffset:\(self.collectionView?.contentOffset)")
        
        return targetP
    }
    
    //TODO: 工具：手动调用获取每一个item的布局特征，目的是根据indexPath获取item特征数组里面的指定的元素。
    /**
        1、默认返回的是 根据indexPath获取item特征数组里面的元素，但是修改UICollectionViewLayoutAttributes的属性之后，就是copy之后的对象了，并不会对数组的元素造成影响。
        2、所以你要改变数组里面的元素的话，还是得重新赋值给数组。
        3、所以就是一个工具方法，根据indexpath获取item的特征对象，没有其它作用了。相当于一个工具而已。
     */
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        print("∆∆∆∆ 这是TestUICollectionViewFlowLayout的\(#function)方法～")
        let itemAttribute = super.layoutAttributesForItem(at: indexPath)
//        if indexPath.row == 0 {
//            itemAttribute!.size = CGSize.init(width: 300, height: 120)
//        }else{
//            itemAttribute!.size = CGSize.init(width: 150, height: 80)
//        }
        return itemAttribute
    }
    
    
    
    
}



