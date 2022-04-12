//
//  CTCCalendarPageView.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/4/11.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 设计思路是两个collectionView，一个 “月-天” 的的二位数组，第一个collectionView是月，第二个collectionView是在第一个collectionView的cell里面，是天。

// MARK: -  日历控件-翻页
class  CTCCalendarPageView: UIView {
    
    //MARK: - UI属性
    private let bigDayLabel:UILabel = UILabel()     //大数字 天 label
    private let descriLabel = UILabel()     //描述事项的label，多少个基金
    private let detailDayLabel = UILabel()  //具体天的日期 的label
    private let todayBtn = UIButton()   //今天的按钮
    private let screenWidth = UIScreen.main.bounds.width
    
    /// collectionView
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: CGRect(x: 0, y: 50, width: self.bounds.width, height: self.bounds.height - 50), collectionViewLayout: layout)
        collection.backgroundColor = UIColor.white
        collection.delegate = self
        collection.dataSource = self
        collection.isPagingEnabled = true
        collection.showsHorizontalScrollIndicator = false
        collection.bounces = false
        collection.register(CTCCalendarMonthCell.self, forCellWithReuseIdentifier: "CTCCalendarMonthCell")
        return collection
    }()
    
    /// 数据源
    fileprivate var monthModels: [[CTCCalendarDayModel?]] = CTCCalendarDayModel.getDatePageList(startYear: 2020, endYear: nil)
    
    /// 星期数组
    fileprivate var dayTitleArr: [String] = [ "一", "二", "三", "四", "五", "六","日"]
    
    /// 滚动到当月
    var nowMonIndexPath: IndexPath = IndexPath.init(item: 0, section: 0)
    /// 滚动到当天
    var nowDayIndexPath: IndexPath = IndexPath.init(item: 0, section: 0)

    /// 偏移量-判断滚动方向
    fileprivate var lastOffsetX: CGFloat = 0
    
    /// 日期回调
    var dateSelectChangeBlock: ((CTCCalendarDayModel) -> ())?

    /// 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        if self.frame == .zero {
            self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        }
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.brown.cgColor
        initDefalutUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("CTCCalendarPageView-delloc")
    }
    
}
// MARK: - 设置UI
extension CTCCalendarPageView {
    
    /// 初始化默认UI
    func initDefalutUI(){
        
        /// 天的数字的label
        bigDayLabel.text = "17"
        bigDayLabel.textColor = UIColor.black
        bigDayLabel.font = .systemFont(ofSize: 68, weight: .medium)
        self.addSubview(bigDayLabel)
        bigDayLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(screenWidth * 20 / 375.0)
            make.top.equalToSuperview()
            make.height.equalTo(screenWidth * 82 / 375.0)
            make.width.equalTo(screenWidth * 62 / 375.0)
        }
        
        /// 描述当天事项的label
        descriLabel.textColor = UIColor.black
        descriLabel.font = .systemFont(ofSize: 68, weight: .medium)
        self.addSubview(descriLabel)
        descriLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(screenWidth * 20 / 375.0)
            make.top.equalToSuperview()
            make.height.equalTo(screenWidth * 82 / 375.0)
            make.width.equalTo(screenWidth * 62 / 375.0)
        }
        
    }
    
}

// MARK: - 逻辑处理
extension CTCCalendarPageView {
    
    /// 更新显示
    func refreshDayLabel() {
       
    }
    
    /// 向左滚动
    func scrollToLast(_ dayModel: CTCCalendarDayModel? = nil, isScroll: Bool = true) {
        
    }
    
    /// 向右滚动
    func scrollToNext(_ dayModel: CTCCalendarDayModel? = nil, isScroll: Bool = true) {
        
        CATransaction.setDisableActions(true)
        collectionView.reloadData()
        CATransaction.commit()
        
    }
    
}

// MARK: - Action，动作方法
@objc extension CTCCalendarPageView {
    
    
    /// 点击了今天按钮
    @objc func clickTodayBtnAction(_ button: UIButton?) {
        
       
    }
    
    
}

// MARK: - UIScrollViewDelegate
extension CTCCalendarPageView: UIScrollViewDelegate {
    
    /// 开始拖拽
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastOffsetX = scrollView.contentOffset.x
    }

    /// 结束减速
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        // 向右滑动
        if scrollView.contentOffset.x > lastOffsetX {
           
        // 向左滑动
        } else if scrollView.contentOffset.x < lastOffsetX {
            
        }
        
        // 更新lastOffsetX
        lastOffsetX = scrollView.contentOffset.x
    }
    
}

// MARK: - UICollectionViewDelegate
extension CTCCalendarPageView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // 返回cell个数 1970~至今~未来
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthModels.count
    }
    
    // 返回cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CTCCalendarMonthCell", for: indexPath) as! CTCCalendarMonthCell
        let dayModels = self.monthModels[indexPath.item]
        cell.dayModels = dayModels
        
        cell.clickCellBlock = {[weak self] (dayModel) in
            guard let self = self else { return }
            if dayModel.dayType == .last {
                self.scrollToLast(dayModel)
            } else if dayModel.dayType == .next {
                self.scrollToNext(dayModel)
            } else if dayModel.dayType == .current {
                self.refreshDayLabel()
                // 日期回调
                if let dateSelectChangeBlock = self.dateSelectChangeBlock {
                    
                }
            }
        }
        return cell
    }

    // 定义每个Cell的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.bounds.width, height: self.bounds.height - 50)
    }
    
    // 定义每个Section的四边间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    // 这个是两行cell之间的间距（上下行cell的间距）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // 两个cell之间的间距（同一行的cell的间距）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}



