//
//  ThirdPartyLibraryTest_MainVC.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/9/9.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 第三方库测试的功能主VC

import UIKit
import Charts

class ThirdPartyLibraryTest_MainVC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    let chartBgView =  UIView() //图表的背景图
    
    //MARK: 测试的组件
    private var aaChartView:AAChartView?
    private var chartModel = AAChartModel()
    
    /// ios-chart
    private var lineChartView = IOSChartView()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1.0)
        self.title = "第三方库测试的功能主VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }


}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension ThirdPartyLibraryTest_MainVC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、测试AAInfographics第三方库
            print("     (@@  测试AAInfographics第三方库")
            testAAInfographics()
            break
        case 1:
            //TODO: 1、更新AA图表的数据内容
            print("     (@@ 更新AA图表的数据内容")
            refreshAA_ChartData()
        case 2:
            //TODO: 2、测试ios-chart
            print("     (@@ 测试ios-chart")
            test_iosChart()
        case 3:
            //TODO: 3、更新ios-chart的图表数据
            print("     (@@ ")
            refresh_iosChartData()
        case 4:
            print("     (@@")
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
        case 13:
            print("     (@@")
        case 14:
            print("     (@@")
        case 15:
            print("     (@@")
        case 16:
            print("     (@@")
        case 17:
            print("     (@@")
        case 18:
            print("     (@@")
        case 19:
            print("     (@@")
        case 20:
            print("     (@@")
        case 21:
            print("     (@@")
        case 22:
            print("     (@@")
        case 23:
            print("     (@@")
        case 24:
            print("     (@@")
        default:
            break
        }
    }
    
}
//MARK: - 测试的方法
extension ThirdPartyLibraryTest_MainVC{
   
    //MARK: 0、测试AAInfographics第三方库
    func testAAInfographics(){
        /// 初始化AAInfographics的图表
        aaChartView = AAChartView()
        // 设置 aaChartView 的内容高度(content height)
         aaChartView?.contentHeight = 320
    
        chartBgView.addSubview(aaChartView!)
        aaChartView?.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
         chartModel = AAChartModel()
            .chartType(.area)//图表类型
            .title("城市天气变化")//图表主标题
            .subtitle("2020年09月18日")//图表副标题
            .inverted(false)//是否翻转图形
            .yAxisTitle("摄氏度")// Y 轴标题
//            .legendEnabled(true)//是否启用图表的图例(图表底部的可点击的小圆点)
            .tooltipValueSuffix("摄氏度")//浮动提示框单位后缀
            .categories(["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                         "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"])
            .colorsTheme(["#fe117c","#ffc069","#06caf4","#7dffc0"])//主题颜色数组
            .series([
                AASeriesElement()
                    .name("北京")
                    .data([7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 100, 23.3, 18.3, 13.9, 9.6, 21.5, 25.2, 100, 23.3, 18.3, 13.9, 9.6, 21.5, 25.2, 100, 23.3, 18.3, 13.9]),
            ])
        chartModel.zoomType = .x
        chartModel.animationDuration = 0
        aaChartView?.scrollEnabled = false
        /*图表视图对象调用图表模型对象,绘制最终图形*/
        aaChartView?.aa_drawChartWithChartModel(chartModel)
    }
    
    //MARK: 1、更新AA——chart的数据
    func refreshAA_ChartData(){
        print("     ©更新图表的数据内容©")
        var numArr = [7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 100, 23.3, 18.3, 13.9, 9.6, 21.5, 25.2, 100, 23.3, 18.3, 13.9, 9.6, 21.5, 25.2, 100, 23.3, 18.3, 13.9];
        for _ in 0...2000 {
            let ranInt = arc4random_uniform(10000)
            let ranDouble = Double(ranInt) / 100.0
            numArr.append(ranDouble)
        }
        
        chartModel.series = [
            AASeriesElement()
                .name("上海")
                .data(numArr)]
        aaChartView?.aa_drawChartWithChartModel(chartModel)
    }
    
    
    
    //MARK: 2、测试ios-chart
    func test_iosChart(){
        chartBgView.addSubview(lineChartView)
        lineChartView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: 3、更新ios-chart的图表数据
    func refresh_iosChartData(){
        var entries = [ChartDataEntry]()
        for i in 0...2 {
            let entry = ChartDataEntry(x: Double(i), y: 0.0)
            entries.append(entry)
        }
        lineChartView.updateChartData(entries:entries)
    }
    //MARK: 4、
    func test4(){
        
    }
    //MARK: 5、
    func test5(){
        
    }
}


//MARK: - 工具方法
extension ThirdPartyLibraryTest_MainVC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
        chartBgView.tag = 10086
        chartBgView.layer.borderColor = UIColor.gray.cgColor
        chartBgView.layer.borderWidth = 1.0
        chartBgView.backgroundColor = UIColor.init(red: 225/255.0, green: 252/255.0, blue: 252/255.0, alpha: 1.0)
        self.view.addSubview(chartBgView)
        chartBgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(60)
            make.width.equalToSuperview()
            make.height.equalTo(360)
        }
        
        
        
    }
    
    
    
}
//MARK: - 遵循ios-chart的代理方法
extension ThirdPartyLibraryTest_MainVC {
    
}

//MARK: - 设计UI
extension ThirdPartyLibraryTest_MainVC {
    
    /// 设置导航栏的UI
    private func setNavigationBarUI(){
        
        ///布局从导航栏下方开始
        self.edgesForExtendedLayout = .bottom
        
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
        
        baseCollView.backgroundColor = UIColor.cyan
        baseCollView.contentSize = CGSize.init(width: UIScreen.main.bounds.size.width * 2, height: UIScreen.main.bounds.size.height)
        baseCollView.showsVerticalScrollIndicator = true
        baseCollView.alwaysBounceVertical = true
        baseCollView.delegate = self
        baseCollView.dataSource = self
        baseCollView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionView_Cell_ID")
        
        self.view.addSubview(baseCollView)
        
    }
}

//MARK: - 遵循委托协议,UICollectionViewDelegate
extension ThirdPartyLibraryTest_MainVC: UICollectionViewDelegate {
    
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
