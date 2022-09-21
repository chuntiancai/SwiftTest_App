//
//  TestMap_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/9/14.
//  Copyright © 2022 com.mathew. All rights reserved.
//
//测试地图的VC
// MARK: - 笔记

import CoreLocation
import MapKit
/**
    1、CoreLocation(着重功能实现)：用于地理定位，
                                地理编码，将街道信息编码成代码。反地理编码就是将编码 解码成 街道信息。
                                区域监听等，区域监听就是手机是否进入了某地理区域。
       MapKit (着重界面展示)：用于地图展示，例如大头针，路线、覆盖层展示等。是基于CoreLocation的封装。

       两个热门专业术语
            LBS ：Location Based Service , 当前的位置有什么城市服务。
            SoLoMo ：Social Local Mobile（索罗门），给社交app的位置服务。
 
    2、获取位置权限：
        info.plist -> 添加Privacy - Location * 权限描述（有前台、后台几种） -> 写”请问允许前台位置服务之类的描述“    （请求权限）
        project -> target -> Singing&Capabilities -> 左上角“+” -> Background Modes -> Location updates（位置更新）
        project -> target -> Singing&Capabilities -> 左上角“+” -> Maps （城市服务，可选）

    3、Cannot form weak reference to instance  of class 报错，在deinit方法中第一次使用lazy var的属性，且属性的lazy block 中又使用了self，
        因为deinit方法中已经释放了self，而你第一使用lazy var的时候，block又使用了self，相当于使用了释放了的self，所以就报错。
 
    4、可以自己去github上面找第三方框架，搜索LocationManager。
 
 */

class TestMap_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    let bgView = UIView()   //测试的view可以放在这里面
    
    //MARK: 测试组件
    private lazy var locationM : CLLocationManager = {  //创建实用位置管理者
        let manager = CLLocationManager()
        manager.delegate = self  //设置代理者
        return manager
    }()
    let compassView = UIImageView(image: UIImage(named: "bg_compasspointer"))   //指南针图片
    
    let geoCoder : CLGeocoder = {   //地理编码与反编码的类。
        //需要联网，geo是地理英文的缩写。
        return CLGeocoder()
    }()
    
    lazy var mapView: MKMapView = { //展示地图的View
        let map = MKMapView()
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试地图的VC"
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }
    
    deinit {
        print("\(self)销毁了")
    }
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestMap_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("TestMap_VC 点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、测试CoreLocation的基本使用。
            /**
                前提是要在info.plist 和 project中配置权限。
             
                1、创建实用位置管理者 -> 设置代理者 -> 请求权限 -> 开启实时获取位置的服务。
                    // 小经验: 如果以后实用位置管理者这个对象, 实现某个服务, 那么可以以startXX 开始某个服务  以 stopXX停止某个服务
                    // 开始更新位置信息 ing, 意味着, 一旦调用了这个方法, 就会不断的刷新用户位置, 然后告诉外界
                2、
             */
            
            print("     (@@ 0、测试CoreLocation的基本使用。")
            let _ = self.bgView.subviews.map { $0.removeFromSuperview() }
            
//            locationM.requestWhenInUseAuthorization()  //请求前台位置权限的弹窗。app切换到后台时，会有蓝色的弹窗显示正在使用定位。
            locationM.requestAlwaysAuthorization() //请求前后台位置权限的弹窗。
            
            // 请求后台更新位置的服务，必须先在项目的target配置中，设置 Background Modes -> Location updates
            locationM.allowsBackgroundLocationUpdates = true
            
            locationM.startUpdatingLocation()  //开启监听位置更新的服务。定位: 标准定位服务，准确度高 (gps/wifi/蓝牙/基站)
            
            // 显著位置变化的服务(根据通信基站进行定位, 电话模块。例如城市之间，大范围的定位，准确度较低，耗电低)
            // locationM.startMonitoringSignificantLocationChanges()
            
            //请求一次性的定位服务。在有效时间内，返回定位精度最高的那个定位位置。不能与startUpdatingLocation()同时使用，且必须实现定位失败的代理方法。
//            locationM.requestLocation()
            
            locationM.distanceFilter = 100 //每移动100米更新一下位置服务。
            
            /**
               定位精确度:
                kCLLocationAccuracyBestForNavigation // 最适合导航
                kCLLocationAccuracyBest; // 最好的
                kCLLocationAccuracyNearestTenMeters; // 附近10米
                kCLLocationAccuracyHundredMeters; // 附近100米
                kCLLocationAccuracyKilometer; // 附近1000米
                kCLLocationAccuracyThreeKilometers; // 附近3000米
                经验: 如果定位的精确度越高, 那么越耗电, 而且定位时间越长
             */
            locationM.desiredAccuracy = kCLLocationAccuracyBest
            
//            locationM.stopUpdatingLocation()   //停止定位更新服务。
            
            
        case 1:
            //TODO: 1、实现指南针效果。
            /**
             */
            print("     (@@ 1、实现指南针效果。")
            
            // 1、使用位置管理者, 获取当前设备朝向
            if CLLocationManager.headingAvailable() {
                locationM.startUpdatingHeading()   //"磁力计"传感器
            }else {
                print("当前磁力计设备损坏")
            }
            let _ = self.bgView.subviews.map { $0.removeFromSuperview() }
            self.bgView.addSubview(compassView)
            compassView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.height.width.equalTo(200)
            }
            
            
        case 2:
            //TODO: 2、测试区域监听。
            print("     (@@ 2、测试区域监听。")
            let _ = self.bgView.subviews.map { $0.removeFromSuperview() }
            
            //1.判断描述当前区域的类是否可以被监听。
            if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
                
                // 2. 创建区域
                let center = CLLocationCoordinate2DMake(21.123, 121.345)
                var distance: CLLocationDistance = 1000
                if distance > locationM.maximumRegionMonitoringDistance {
                    distance = locationM.maximumRegionMonitoringDistance
                }
                let region  = CLCircularRegion(center: center, radius: distance, identifier: "春天菜")
                
                // 3. 监听区域
                locationM.startMonitoring(for: region)
                
                // 3.1 请求某个区域的状态
                locationM.requestState(for: region)
            }
            
            
            
        case 3:
            //TODO: 3、测试地理编码与反编码。
            /**
                1、地理编码就是把经纬度那些转换为街道信息之类的，反编码就是把街道信息转换为经纬度。
             */
            print("     (@@ 3、测试地理编码与反编码。")
            
            // 地理编码
            geoCoder.geocodeAddressString("深圳") { (pls:[CLPlacemark]?, err:Error?) -> Void in
                if err == nil {
                    print("地理编码成功：")

                    guard let plsResult = pls else {return}

                    // CLPlacemark: 地标对象
                    // location            : CLLocation 类型, 位置对象信息, 里面包含经纬度, 海拔等等
                    // region              : CLRegion 类型, 地标对象对应的区域
                    // addressDictionary  : NSDictionary 类型, 存放街道,省市等信息
                    // name                : NSString 类型, 地址全称
                    // thoroughfare        : NSString 类型, 街道名称
                    // locality            : NSString 类型, 城市名称
                    // administrativeArea : NSString 类型, 省名称
                    // country             : NSString 类型, 国家名称
                    
                    let firstPL = plsResult.first
                    let adName = firstPL?.name ?? ""
                    let latitude = "\((firstPL?.location?.coordinate.latitude)!)"
                    let longitude = "\((firstPL?.location?.coordinate.longitude)!)"

                    print("街道名：\(adName) -- 维度：\(latitude)  -- 经度：\(longitude)")

                }else {
                    print("地理编码失败：\(String(describing: err))")
                }
            }
            
            // 地理编码解码需要时间执行。
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                // 反地理编码
                let location = CLLocation(latitude: 21.123, longitude: 116.345)
                self.geoCoder.reverseGeocodeLocation(location) {(pls:[CLPlacemark]?, err:Error?) -> Void in
                    if err == nil {
                        print("反地理编码成功：")
                        guard let plsResult = pls else {return}
                        let firstPL = plsResult.first
                        let adName = firstPL?.name ?? ""
                        let latitude = "\((firstPL?.location?.coordinate.latitude)!)"
                        let longitude = "\((firstPL?.location?.coordinate.longitude)!)"
                        
                        print("街道名：\(adName) -- 维度：\(latitude)  -- 经度：\(longitude)")
                    }else{
                        print("反地理编码失败：\(String(describing: err))")
                    }
                }
            }
            
            
            
            
        case 4:
            //TODO: 4、测试地图的展示
            /**
                1、Mapkit框架有一个专门用于展示地图的类：MKMapView
             */
            print("     (@@ 4、测试地图的展示")
            let _ = self.bgView.subviews.map { $0.removeFromSuperview() }
            self.bgView.addSubview(mapView)
            mapView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            //MKMapViewd的基本属性
            /**
             MKMapTypeStandard     标准地图
             MKMapTypeSatellite     卫星地图
             MKMapTypeHybrid     混合模式(标准+卫星)
             MKMapTypeSatelliteFlyover     3D立体卫星
             MKMapTypeHybridFlyover     3D立体混合
             */
            mapView.mapType = .standard
            
            // 设置地图的控制项
    //        mapView.scrollEnabled = false
    //        mapView.rotateEnabled = false
    //        mapView.zoomEnabled = false
            
            
            // 设置地图的显示项
            mapView.showsBuildings = true   // 建筑物
            mapView.showsCompass = true // 指南针
            mapView.showsScale = true   // 比例尺
            mapView.showsTraffic = true // 交通状况
            mapView.showsPointsOfInterest = true    // poi兴趣点
           
            
            // 1. 显示用户位置
            _ = locationM
            // 显示一个蓝点, 在地图上面标示用户的位置信息
            // 但是, 不会自动放大地图, 并且当用户 位置移动时, 地图不会自动跟着跑
            mapView.showsUserLocation = true
            
            // 2. 用户的追踪模式
            // 显示一个蓝点, 在地图上面标示用户的位置信息
            // 会自动放大地图, 并且当用户 位置移动时, 地图会自动跟着跑
            // 不灵光
    //        mapView.userTrackingMode = MKUserTrackingMode.FollowWithHeading
            
            // 设置地图代理
            mapView.delegate = self
            
        case 5:
            //TODO: 5、
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
//MARK: - 遵循地图协议,MKMapViewDelegate
extension TestMap_VC: MKMapViewDelegate {
    
    //TODO: 当地图更新用户位置信息时, 调用的方法
    // 蓝点: 大头针"视图"  大头针"数据模型"
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        
        
        // MKUserLocation: 大头针数据模型
        // location : 这就是大头针的位置信息(经纬度)
        // heading: 设备朝向对象
        // title: 弹框标题
        // subtitle: 弹框子标题
        userLocation.title = "弹框标题"
        userLocation.subtitle = "弹框子标题"
        
        // 移动地图的中心,显示在当前用户所在的位置
        mapView.setCenter((userLocation.location?.coordinate)!, animated: true)
        
        // 设置地图显示区域
//        let center = (userLocation.location?.coordinate)!
//        let span = MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.010)    //显示的跨度
//        let region: MKCoordinateRegion = MKCoordinateRegion(center: center, span: span)
//        mapView.setRegion(region, animated: true)
        
    }
    
    
    //TODO: 显示的地图区域改变的时候调用。区域是指当前的屏幕显示了多少经纬度的跨度。
    //注意地球是椭圆的，经纬度也是椭圆的。
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("变化的纬度跨度：",mapView.region.span.latitudeDelta, "变化的经度跨度：",mapView.region.span.longitudeDelta)
    }
    
}




//MARK: - 遵循定位协议,CLLocationManagerDelegate
extension TestMap_VC: CLLocationManagerDelegate {
    
    //TODO: 进入区域时调用。
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("进入区域时调用：\(region.identifier)")
    }
    //TODO: 离开区域时调用。
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("离开区域时调用：\(region.identifier)")
    }
    
    //TODO: 请求某个区域状态的时候调用,(在区域内、外、未知)
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        
        print("请求的区域状态：\(state.rawValue)")
        if region.identifier == "春天菜" {
            switch state {
            case .inside:
                print("在春天菜区域里面")
            case .outside:
                print("在春天菜区域外面")
            case .unknown:
                print("在春天菜未知区域")
            }
        }
        
    }
    
    //TODO: 更新磁力方向时调用
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        print("已经更新了磁力指向：\(String(describing: newHeading)) ")
        // 1. 拿到当前设备朝向
        /// 0- 359.9 角度(正北，顺时针)
        
        let angle = newHeading.magneticHeading
        
        // 1.1 把角度转换成为弧度
        let hudu = CGFloat(angle / 180 * Double.pi)
        
        
        // 2. 反向旋转图片(弧度)
        UIView.animate(withDuration: 0.5) {
            self.compassView.transform = CGAffineTransform(rotationAngle: -hudu)
        }
        
    }
    
    //TODO: 更新位置时调用
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        /**
            1、locations数组里的对象是按照时间顺序排序的，越新越后面
              CLLocation对象的属性
                coordinate: 经纬度信息
                altitude: 海拔信息
                horizontalAccuracy: 如果整个数字是负数, 就代表位置数据无效
                verticalAccuracy:  如果整个数字是负数, 就代表海拔数据无效
                course: 航向，路线（取值范围是0.0° ~ 359.9°（顺时针），0.0°代表真北方向）
                speed: 速度（单位是m/s）
                distanceFromLocation方法: 计算两个经纬度坐标之间的物理指向距离
         */
        let newLocation = locations.last
        print("已经更新了位置：\(String(describing: newLocation)) ")
    }
    
    //TODO: 定位失败时调用
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("定位失败时调用的：\(#function)方法 -- \(String(describing: error)) ")
    }
    
    //TODO: 授权状态发生改变时调用
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        var status:CLAuthorizationStatus!
        if #available(iOS 14.0, *) {
            status = manager.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }
        
        print("授权状态发生改变时：\(#function)方法，-- \(String(describing: status.rawValue))")
        switch status {
        case .notDetermined:
            print("权限状态：用户没有决定")
        case .restricted:
            print("权限状态：受限制")
        case .authorizedWhenInUse:
            print("权限状态：前台定位授权")
        case .authorizedAlways:
            print("权限状态：前后台定位授权")
        case .denied:
            print("权限状态：拒绝")
            // 判断当前设备是否支持定位, 并且定位服务是否开启
            if CLLocationManager.locationServicesEnabled() {
                print("权限状态：真正被拒绝")
                // 手动通过代码, 来跳转到设置界面
                let url = URL(string: UIApplication.openSettingsURLString)
                if UIApplication.shared.canOpenURL(url!) { UIApplication.shared.open(url!) }
            }else {
                // 当我们在app内部想要访问用户位置, 但是当前的定位服务是关闭状态, 那么系统会自动弹出一个窗口, 快捷跳转到设置界面, 让用户设置
                print("定位服务应该打开")
            }
        default:
            print("none")
        }
    }
    
    
}


//MARK: - 测试的方法
extension TestMap_VC{
   
    //MARK: 0、
    func test0(){
        
    }
    
}


//MARK: - 设置测试的UI
extension TestMap_VC{
    
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
extension TestMap_VC {
    
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
extension TestMap_VC: UICollectionViewDelegate {
    
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

