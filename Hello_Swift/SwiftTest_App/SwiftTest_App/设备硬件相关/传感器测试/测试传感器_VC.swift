//
//  测试传感器_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/10/13.
//  Copyright © 2022 com.mathew. All rights reserved.
//
//测试传感器的VC
// MARK: - 笔记
/**
    1、陀螺仪(gyroscope)：用于检测设备x,y,z轴的角速度，可以用于判断你当前是怎么握着手机的，朝上、下、左、右。
       环境光传感器    感应周边环境光线的强弱（自动调节屏幕亮度）
       距离传感器    感应是否有其他物体靠近设备屏幕（打电话自动锁屏）
       磁力计传感器    感应周边的磁场（合盖锁屏）
       内部温度传感器    感应设备内部的温度（提醒用户降温，防止损伤设备）
       湿度传感器    感应设备是否进水（方便维修人员）
       陀螺仪    感应设备的持握方式（赛车类游戏）
       加速计(运动传感器)    感应设备的运动、加速度（摇一摇、计步器）
       CoreMotionFramework封装了陀螺仪和加速计两者的硬件功能。
 
    2、CMMotionManager 运动传感器管理类，包含了磁力、加速、陀螺仪的检测。
 
    3、苹果本身封装了计步器，CMPedometer。
 
 */
import CoreMotion

class TestSensor_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    let bgView = UIView()   //测试的view可以放在这里面
    
    //MARK: 测试组件
    let motionMgr = CMMotionManager()    //运动传感管理者。
    let stepCounter = CMPedometer() //计步器。
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试传感器_VC"
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }
    deinit {
        //TODO:记得移除对传感器的监听。
        NotificationCenter.default.removeObserver(self)
        motionMgr.stopDeviceMotionUpdates() //关闭运动传感器采样。
        stepCounter.stopUpdates()   //关闭计步器采样。
    }
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestSensor_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("TestSensor_VC 点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、开启距离传感器。
            print("     (@@ 0、开启距离传感器")
            let _ = self.bgView.subviews.map { $0.removeFromSuperview() }
            UIDevice.current.isProximityMonitoringEnabled = true
            NotificationCenter.default.addObserver(self, selector: #selector(distanceSensorChange), name: UIDevice.proximityStateDidChangeNotification, object: nil)
            
        case 1:
            //TODO: 1、测试运动传感框架(加速计和陀螺仪)。
            print("     (@@ 1、测试运动传感框架(加速计和陀螺仪)。")
            
            // 获取磁力计传感器的值
            // 1.判断磁力计是否可用
            if (!self.motionMgr.isMagnetometerAvailable) {
                print("运动传感器不可用！")
                return;
            }
            
            // 2.设置采样间隔，一秒钟采样5次。
            self.motionMgr.magnetometerUpdateInterval = 1 / 5.0;
            
            // 3.开始采样
            
            
            /**
             // 3.1、你可以通过闭包的方式获取采样，也可以通过开启采样后，读取成员变量的方式获取采样数据。
                    闭包的方式会持续调用闭包。
             motionMgr.startMagnetometerUpdates(to: OperationQueue.main) { (motionData:CMMagnetometerData?, err:Error?) -> Void in
                 if err != nil {
                     print("运动传感器采样失败：\(String(describing: err))")
                     return
                 }
                 let field:CMMagneticField = motionData!.magneticField;
                 print("磁力采样的数据：x:\(field.x) y:\(field.x) z:\(field.x)")
             }
             */
            
            motionMgr.startMagnetometerUpdates()
            motionMgr.startAccelerometerUpdates()
            motionMgr.startGyroUpdates()
            
            
        case 2:
            //TODO: 2、通过运动管理者的成员变量 打印运动传感器的采样数据。
            /**
                1、必须分别开启磁力、加速、陀螺仪的采样动作。
             */
            print("     (@@ 2、打印运动传感器的采样数据。")
            if let magnetData = motionMgr.magnetometerData {
                let mageField = magnetData.magneticField
                print("磁力采样的数据：x:\(mageField.x) y:\(mageField.x) z:\(mageField.x)")
            }
            if let acceData = motionMgr.accelerometerData {
                let acceleration = acceData.acceleration
                print("加速采样的数据：x:\(acceleration.x) y:\(acceleration.x) z:\(acceleration.x)")
            }
            if let gyroData = motionMgr.gyroData {
                let gyroRate = gyroData.rotationRate
                print("陀螺仪采样的数据：x:\(gyroRate.x) y:\(gyroRate.x) z:\(gyroRate.x)")
            }
            
        case 3:
            //TODO: 3、测试计步器。
            /**
                1、计步功能需要申请手机权限。在Info.plist文件中填写NSMotionUsageDescription的描述。
             */
            print("     (@@ 3、测试计步器。")
            if !CMPedometer.isStepCountingAvailable() {
                print("当前设备不支持计步器功能。")
                return
            }
            stepCounter.startUpdates(from: Date()) { (pedData:CMPedometerData?, err:Error?) -> () in
                if err != nil {
                    print("计步错误：\(String(describing: err))")
                }
                print("计步数据：\(String(describing: pedData))")
                
            }
            
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
        default:
            break
        }
    }
    
}
//MARK: - 接受传感器回调的方法
@objc extension TestSensor_VC{
   
    //MARK: 0、距离传感器的动作方法。
    func distanceSensorChange(){
        print("手机距离发生改变：\(UIDevice.current.proximityState)")
    }
    
}


//MARK: - 设置测试的UI
extension TestSensor_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        /// 内容背景View，测试的子view这里面
        self.view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.top.equalTo(baseCollView.snp.bottom)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
    }
    
}


//MARK: - 设计UI
extension TestSensor_VC {
    
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
        layout.sectionInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 0, right: 5)
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
extension TestSensor_VC: UICollectionViewDelegate {
    
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



