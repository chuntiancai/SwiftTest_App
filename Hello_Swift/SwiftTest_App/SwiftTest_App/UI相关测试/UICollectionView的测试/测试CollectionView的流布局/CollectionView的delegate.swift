//
//  CollectionView的delegate.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/12/1.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试CollectionView的delegate 和 流布局delegate 

//MARK: - 笔记
/**
    1、如果Collection View有Delegate对象，那么如果layout对象的布局和Delegate协议的布局重复的话，以Delegate的设置为主。
    2、如果实现了UICollectionViewFlowLayout的targetContentOffset方法，那么scrollViewDidEndDecelerating必然会被调用。
 */

class TestFlowCollViewDelegate: NSObject,UICollectionViewDelegate {
    
    var isInfinite:Bool = false //是否无限滑动,测试无限滑动
    
    //TODO: scrollView已经滑动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("TestFlowCollViewDelegate的\(#function)方法，\(scrollView.contentOffset.x)")
        
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        print("TestFlowCollViewDelegate的\(#function)方法,开始加速，\(scrollView.contentOffset.x),bounds:\(scrollView.bounds.width)")
    }
    
    //TODO: scrollView已经停止加速
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("TestFlowCollViewDelegate的\(#function)方法,结束减速，\(scrollView.contentOffset.x)")
        //TODO: 测试无限滑动
        if isInfinite{
            //计算无限轮播，滚动到第一个item或者最后一个item。
            if let collView = scrollView as? UICollectionView {
                guard let flowLayout = collView.collectionViewLayout as? UICollectionViewFlowLayout else{ return }
                print("计算无限轮播，滚动到第一个item或者最后一个item:\(collView.contentOffset.x)")
                let itemCount:Int = 10
                let itemWidth:CGFloat = flowLayout.itemSize.width + flowLayout.minimumLineSpacing
                let page = (collView.contentOffset.x + collView.bounds.width * 0.5 - flowLayout.sectionInset.left) / itemWidth
                let row = Int(page) % itemCount + itemCount
                collView.scrollToItem(at: IndexPath(row: row, section: 0), at: .centeredHorizontally, animated: false)
            }
        }
    }
    
    //TODO: 设置section 的 header的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return .zero
        }
        return CGSize(width: 10, height: 10)
    }
    
}

//MARK:- 流布局的代理方法，当流布局对象不足以满足布局约束时，用于补充设置布局约束
extension TestFlowCollViewDelegate: UICollectionViewDelegateFlowLayout {
    
    //TODO: 设置section 的内边距
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        print("TestFlowCollViewDelegate 的 \(#function) 方法～")
//        return UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
//    }
    
}



