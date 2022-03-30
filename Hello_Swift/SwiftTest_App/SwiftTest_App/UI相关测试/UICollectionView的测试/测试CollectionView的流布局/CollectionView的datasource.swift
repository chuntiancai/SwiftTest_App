//
//  CollectionView的datasource.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/12/1.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试流布局CollectionView的数据源代理datasource


class TestCollViewDataSource: NSObject,UICollectionViewDataSource {
    
    //TODO:设置section的数量
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    //TODO:设置每个section中的item的UI
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlowCollectionView_Cell_ID", for: indexPath)
        return cell
    }
    
    
}
