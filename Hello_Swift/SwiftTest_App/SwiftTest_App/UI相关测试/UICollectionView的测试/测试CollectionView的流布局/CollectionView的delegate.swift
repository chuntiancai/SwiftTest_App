//
//  CollectionView的delegate.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/12/1.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试流布局CollectionView的代理对象delegate

class TestFlowCollViewDelegate: NSObject,UICollectionViewDelegate {
    
}

//MARK:- 流布局的代理方法，当流布局对象足以满足布局约束时，用于补充设置布局约束
extension TestFlowCollViewDelegate: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 24, bottom: 0, right: 24)
    }
    
}


//MARK: - 笔记
/**
    1、如果Collection View有Delegate对象，那么如果layout对象的布局和Delegate协议的布局重复的话，以Delegate的设置为主。
 
 */
