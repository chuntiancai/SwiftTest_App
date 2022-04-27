//
//  IOSChartView.swift
//  SwiftTest_App
//
//  Created by mathew on 2021/9/18.
//  Copyright © 2021 com.mathew. All rights reserved.
//
// 测试

import UIKit
import Charts

class IOSChartView: UIView {
    //MARK: - 对外属性
    
    
    //MARK: - 内部属性
    private let whiteBgView = UIView()  //白色背景图
    /// ios-chart
    private var lineChartView = LineChartView()
    
    

    
    //TODO: UI小零件
    private var buyIcon: UIImage{   //买入图标
        get{
            let buyLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
            buyLabel.backgroundColor = UIColor(red: 0.98, green: 0.23, blue: 0.02, alpha: 1)
            buyLabel.text = "买"
            buyLabel.textAlignment = .center
            buyLabel.font = .systemFont(ofSize: 10)
            buyLabel.textColor = .white
            buyLabel.layer.cornerRadius = 9
            buyLabel.layer.masksToBounds = true
            
            UIGraphicsBeginImageContextWithOptions(buyLabel.layer.bounds.size, false, UIScreen.main.scale)
            let context = UIGraphicsGetCurrentContext()
            buyLabel.layer.render(in: context!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image!
        }
    }
    private var soldIcon: UIImage{  //卖出图标
        get{
            let soldLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
            soldLabel.backgroundColor = UIColor(red: 0.12, green: 0.7, blue: 0.38, alpha: 1)
            soldLabel.text = "卖"
            soldLabel.textAlignment = .center
            soldLabel.font = .systemFont(ofSize: 10)
            soldLabel.textColor = .white
            soldLabel.layer.cornerRadius = 9
            soldLabel.layer.masksToBounds = true
            
            UIGraphicsBeginImageContextWithOptions(soldLabel.layer.bounds.size, false, UIScreen.main.scale)
            let context = UIGraphicsGetCurrentContext()
            soldLabel.layer.render(in: context!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image!
        }
    }
    
    //MARK: - 复写方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        initDefaultUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - 设置UI
extension IOSChartView{
    //MARK: 设置UI
    // 对内方法
    func  initDefaultUI() {
        self.backgroundColor = .clear
        let screenWidth = UIScreen.main.bounds.width
        
        whiteBgView.backgroundColor = .white
        whiteBgView.layer.cornerRadius = 12
        self.addSubview(whiteBgView)
        whiteBgView.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(15)
            make.width.equalTo(screenWidth * 118.4 / 125.0)
            make.height.equalTo(screenWidth * 99 / 125.0)
        }
        initChartUI()
        
    }
    /// 初始化chart的UI
    func initChartUI(){
        whiteBgView.addSubview(lineChartView)
        lineChartView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
       
        //TODO: 图表配置的设置
        lineChartView.scaleYEnabled = false     //取消y轴缩放
//        lineChartView.setScaleMinima(2.0, scaleY: 1.5)  //设置最小的缩放倍数，也就是双指捏合后的图像，最小能是原来的多少倍
        
        lineChartView.gridBackgroundColor = .clear
        lineChartView.borderColor = .clear
        lineChartView.minOffset = 23    //设置图表的内边距，可以让x轴的标签完整显示出来
        lineChartView.delegate = self
        lineChartView.maxVisibleCount = 999999  //设置chart绘制时的可见点，少的话，会影响折线上设置的icon，所以要设置大一些
        lineChartView.noDataText = "暂无数据"   //无数据时显示的文本
        
        //TODO: x横轴
        let xAxis =  lineChartView.xAxis
        
        xAxis.axisRange = 36    //x轴有多少个坐标值
        lineChartView.setVisibleXRangeMinimum(6)    //设置每屏最少显示多少个x轴的点，点要比x轴的label多一个，不然label的数组下标不好计算
        xAxis.labelCount = 5    //设置x轴标签label的个数
        
        xAxis.labelPosition = .bottom //设置x坐标轴标签在下方
        xAxis.drawGridLinesEnabled = false    //设置不画x轴对应的网格线，也就是竖起来的直线
        xAxis.drawAxisLineEnabled = false
        
        //X轴上面需要显示的数据,设置x轴的标签为字符串
        /// 设置x轴标签显示字符串
        let xFormatter = xAxis.valueFormatter as! DefaultAxisValueFormatter
        xFormatter.block = {
            (_ value: Double,_ axis: AxisBase?) -> String in
            
            let index = lround(value)
//            print("参数value的值是：\(value) --- 转换的下标值是：\(index) ---字符串是：x-\(index)")
//            print("参数axis的值是：",axis as Any)
            return "x-\(index)"

        }
        
        
        //TODO: 左侧纵轴
        let leftAxis =  lineChartView.leftAxis
        leftAxis.gridLineDashLengths = [3.0,3.0]  //设置横虚线
        leftAxis.drawZeroLineEnabled = true //设置0的x轴线由左纵轴开始绘制
        
        
        let rightAxis =  lineChartView.rightAxis //右侧纵轴
        rightAxis.drawGridLinesEnabled = false    //去掉右侧纵轴产生的横线
        rightAxis.drawAxisLineEnabled = false //去掉右侧纵轴的线
        rightAxis.drawLabelsEnabled = false   //去掉右侧纵轴的标签文本
        
        
        //TODO:需要填充的数据
        var pointColorsArr = [UIColor]()    //每个点的颜色，买卖点就红绿色，普通就透明色
        ///对应Y轴上面需要显示的数据，设置数据的属性，决定折线的格式
        var entries = [ChartDataEntry]()
        for i in 0...2000 {
            var entry = ChartDataEntry(x: Double(i), y: Double(arc4random_uniform(50)))
            
            if i > 50 && i < 62{
                /// 卖点
                entry = ChartDataEntry(x: Double(i), y: Double(arc4random_uniform(50)),icon: soldIcon)
                pointColorsArr.append(UIColor(red: 0.12, green: 0.7, blue: 0.38, alpha: 1))
            }else if i > 100 && i < 123{
                
                /// 买点
                entry = ChartDataEntry(x: Double(i), y: Double(arc4random_uniform(50)),icon: buyIcon)
                pointColorsArr.append(UIColor(red: 0.98, green: 0.23, blue: 0.02, alpha: 1))
            }else{
                pointColorsArr.append(UIColor.clear)
            }
            entries.append(entry)
        }
        
        
        let yValsSet = LineChartDataSet(entries: entries, label: "图例")  //填充的数据
        yValsSet.label = "hahah"    //去掉底部的label描述
        
        //TODO:设置数据点的样式
        yValsSet.drawCirclesEnabled = true //绘制数据小圆点
        yValsSet.circleRadius = 3
        yValsSet.circleColors = pointColorsArr
        yValsSet.drawValuesEnabled = false  //不在小圆点上面显示数值
        
        //MARK: 设置折线的样式
        yValsSet.lineWidth = 1.0    //折线的线宽度
//        yValsSet.colors = [UIColor.blue,UIColor.brown]    //折线的颜色，可以设置每一段都是不同颜色，花里胡俏
        yValsSet.setColor(UIColor(red: 0.98, green: 0.23, blue: 0.02, alpha: 1)) //设置线条颜色
        
        yValsSet.drawFilledEnabled = true   //允许填充颜色
//        yValsSet.fillColor = UIColor.brown  //线条包围区域的填充颜色
        //填充渐变颜色
        let  gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors:
                                            [UIColor.init(red: 255/255.0, green: 239/255.0, blue: 219/255.0, alpha: 1.0).cgColor,
                                             UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.5).cgColor] as CFArray,
                                            locations: [1,0])
        yValsSet.fillAlpha = 1.0
        yValsSet.fill = Fill.init(linearGradient: gradient!,angle: 90.0)
        
        //MARK:  十字线
        yValsSet.highlightEnabled = true    //是否允许十字线
        yValsSet.highlightColor = .gray //线颜色
        yValsSet.highlightLineWidth = 0.5   //线宽
//        yValsSet.highlightLineDashLengths = [3,3]   //虚线
        
        let dataSet = LineChartData.init(dataSet: yValsSet)

        lineChartView.data = dataSet
        
        
    }
}

//MARK: - 对外方法
extension IOSChartView{
    
    /// 更新图表数据
    func updateChartData(entries:[ChartDataEntry]){
        let yValsSet = LineChartDataSet(entries: entries, label: "图例")  //填充的数据
        yValsSet.label = "hahah"    //去掉底部的label描述
        
        //TODO:设置数据点的样式
        yValsSet.drawCirclesEnabled = false //绘制数据小圆点
        yValsSet.circleRadius = 3
        yValsSet.circleColors = [UIColor.red]
        yValsSet.drawValuesEnabled = false  //不在小圆点上面显示数值
        
        //MARK: 设置折线的样式
        yValsSet.lineWidth = 1.0    //折线的线宽度
//        yValsSet.colors = [UIColor.blue,UIColor.brown]    //折线的颜色，可以设置每一段都是不同颜色，花里胡俏
        yValsSet.setColor(UIColor(red: 0.98, green: 0.23, blue: 0.02, alpha: 1)) //设置线条颜色
        
        yValsSet.drawFilledEnabled = true   //允许填充颜色
//        yValsSet.fillColor = UIColor.brown  //线条包围区域的填充颜色
        //填充渐变颜色
        let  gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors:
                                            [UIColor.init(red: 255/255.0, green: 239/255.0, blue: 219/255.0, alpha: 1.0).cgColor,
                                             UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.5).cgColor] as CFArray,
                                            locations: [1,0])
        yValsSet.fillAlpha = 1.0
        yValsSet.fill = Fill.init(linearGradient: gradient!,angle: 90.0)
        
        //MARK:  十字线
        yValsSet.highlightEnabled = true    //是否允许十字线
        yValsSet.highlightColor = .gray //线颜色
        yValsSet.highlightLineWidth = 0.5   //线宽
//        yValsSet.highlightLineDashLengths = [3,3]   //虚线
        
        let dataSet = LineChartData.init(dataSet: yValsSet)

        lineChartView.data = dataSet
    }
    
}

//MARK: -遵循ChartViewDelegate协议
extension IOSChartView: ChartViewDelegate{
    
}

//MARK: -
extension IOSChartView{
    
}

// MARK: - 笔记
/**
 
 */

