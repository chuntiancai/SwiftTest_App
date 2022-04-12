//
//  CTCCalendarMonthCell.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/4/11.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 这是月的cell，既是 月 的cell，同时也是一个天的collectionView

// MARK: -  日历控件
class CTCCalendarMonthCell: UICollectionViewCell {
    
    /// collectionView
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collection.backgroundColor = UIColor.white
        collection.delegate = self
        collection.dataSource = self
        collection.register(CTCCalendarDayCell.self, forCellWithReuseIdentifier: "CTCCalendarDayCell")
        return collection
    }()

    /// 数据源
    var dayModels: [CTCCalendarDayModel?] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    /// 点击事件回调
    var clickCellBlock: ((CTCCalendarDayModel) -> ())?
    
    /// 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UICollectionViewDelegate
extension CTCCalendarMonthCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // 返回cell个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dayModels.count
    }
    
    // 返回cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CTCCalendarDayCell", for: indexPath) as! CTCCalendarDayCell
        cell.dayModel = dayModels[indexPath.item]
        return cell
    }
    
    // 点击cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // 数据空
        guard let dayModel = self.dayModels[indexPath.item] else { return }
        
        // 全局唯一
        
        // 刷新
        CATransaction.setDisableActions(true)
        collectionView.reloadData()
        CATransaction.commit()
        
        // 点击回调
        if let clickCellBlock = clickCellBlock {
            clickCellBlock(dayModel)
        }
    }
    
    // 定义每个Cell的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
    
    // 定义每个Section的四边间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    // 这个是两行cell之间的间距（上下行cell的间距）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    // 两个cell之间的间距（同一行的cell的间距）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

