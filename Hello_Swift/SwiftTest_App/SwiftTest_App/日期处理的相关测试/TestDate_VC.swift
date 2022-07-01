//
//  TestDate_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/11/3.
//  Copyright © 2021 com.mathew. All rights reserved.
//
//测试日期的VC

import UIKit

class TestDate_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    /// 测试工具
    lazy var dayFormatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy-MM-dd"
        return formatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试日期的VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }


}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestDate_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、获取今年第一天零点的时间戳
            print("     (@@  获取今年第一天零点的时间戳")
            let years = Calendar.current.dateComponents([.year], from: Date()).year!  //今年
            let dateComponent = DateComponents.init(calendar: Calendar.current, year: years, month: 1, day: 1, hour: 0, minute: 0, second: 0)
            let yearTime = dateComponent.date!.timeIntervalSince1970
            print("当前的时间戳：\(String(describing: yearTime))")
            
            print("     (@@  获取去年今天零点时间")
            let today = Date()
            var component = Calendar.current.dateComponents([.year, .month, .day], from: today)
            component.year = component.year! - 1
            let zeroDate = Calendar.current.date(from: component)
            
            
            
            print("   today的输出:\(today)\n --zeroDate的输出:\(String(describing: zeroDate))")
            
            
            print("     @@ 获取这个月第一天的日期")
            var comp0 = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            comp0.day = 1
            let monFirstDay = Calendar.current.date(from: comp0)!
            print("     @@ 月第一天：\(dayFormatter.string(from: monFirstDay))")
            
            print("     @@ 获取这个月最后一天的日期")
            comp0.month! += 1   ///内部已经处理月=13天的情况，是下一年的一月
            comp0.day = 0
            let monLastDay = Calendar.current.date(from: comp0)!
            print("     @@ 月最后一天：\(dayFormatter.string(from: monLastDay))")
            
            break
        case 1:
            //TODO: 1、计算日期的加减
            print("     (@@ ")
            let calendar = Calendar.current
            var components = DateComponents()
            components.month = 0
            components.day = -31
            let startDate = calendar.date(byAdding: components, to: Date())
            
            components.day = 31
            let endDate = calendar.date(byAdding: components, to: Date())
            print("开始日期：\(String(describing: startDate)) ------- 结束日期:\(String(describing: endDate))")
            
            var comp0 = DateComponents()
            print("日期工具：\(comp0)")
        case 2:
            //TODO: 2、
            print("     (@@ ")
        case 3:
            //TODO: 3、
            print("     (@@ ")
        case 5:
            print("     (@@")
        case 6:
            print("     (@@")
        case 7:
            print("     (@@")
        case 8:
            print("     (@@")
        case 9:
            print("     (@@")
        case 10:
            print("     (@@")
        case 11:
            print("     (@@")
        case 12:
            print("     (@@")
        default:
            break
        }
    }
    
}
//MARK: - 测试的方法
extension TestDate_VC{
   
    //MARK: 0、
    func test0(){
        
    }
}


//MARK: - 设置测试的UI
extension TestDate_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
        
    }
    
}


//MARK: - 设计UI
extension TestDate_VC {
    
    /// 设置导航栏的UI
    private func setNavigationBarUI(){
        
        //设置子页面的navigation bar的返回按钮样式
        let backItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    /// 设置collection view的UI
    private func setCollectionViewUI(){
        
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: 80, height: 40)
        
        baseCollView = UICollectionView.init(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width,height:200),
                                             collectionViewLayout: layout)
        
        baseCollView.backgroundColor = UIColor.cyan.withAlphaComponent(0.8)
        baseCollView.contentSize = CGSize.init(width: UIScreen.main.bounds.size.width * 2, height: UIScreen.main.bounds.size.height)
        baseCollView.showsVerticalScrollIndicator = true
        baseCollView.alwaysBounceVertical = true
        baseCollView.layer.borderWidth = 1.0
        baseCollView.layer.borderColor = UIColor.gray.cgColor
        baseCollView.delegate = self
        baseCollView.dataSource = self
        baseCollView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionView_Cell_ID")
        
        self.view.addSubview(baseCollView)
        
    }
}

//MARK: - 遵循委托协议,UICollectionViewDelegate
extension TestDate_VC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collDataArr.count
    }
    ///设置cell的UI
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionView_Cell_ID", for: indexPath)
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        cell.backgroundColor = .lightGray
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: cell.frame.size.width-20, height: cell.frame.size.height));
        label.numberOfLines = 0
        label.textColor = .white
        cell.layer.cornerRadius = 8
        label.text = collDataArr[indexPath.row];
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        cell.contentView.addSubview(label)
        
        return cell
    }
    ///一旦入栈，就隐藏入栈vc的tabBar，底部工具栏
    private func pushNext(viewController: UIViewController) {
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
}

// MARK: - 笔记
/**
 
 */

