//
//  CollectionView的datasource.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/12/1.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试流布局CollectionView的数据源代理datasource

import UIKit


class TestCollViewDataSource: NSObject,UICollectionViewDataSource {
    
    //TODO:设置section的数量
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    //TODO:设置每个section中item的数量
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    //TODO:设置每个section中的item的UI
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlowCollectionView_Cell_ID", for: indexPath) as? TestFlowCollectionView_Cell else {
            print("没有转换成 TestFlowCollectionView_Cell")
            return UICollectionViewCell()
        }
        cell.nameLabel.text = "\(indexPath.section)-\(indexPath.row)"
        cell.bgImageView.image = UIImage(named: "labi0\(indexPath.row)")
        return cell
    }
    
    
    
}
