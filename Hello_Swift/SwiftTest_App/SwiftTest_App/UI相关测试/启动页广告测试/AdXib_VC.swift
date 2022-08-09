//
//  AdXib_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/8/4.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 广告启动页的VC
//MARK: - 笔记
/**
    1、storyboard是通过代码的方式建立起与vc的关系
    2、xib是通过连线建立起与 vc的view 的关系。
    3、在启动完成的时候，才去加广告页面的（展示了启动图片）
        1、程序一启动就进入广告页面，窗口的根控制器直接设置为广告控制器。
        2、直接在窗口再上加一个广告界面，等几秒中过去了，再从窗口中去掉广告界面。

    4、launch screen不可以绑定自定义的VC，只能默认VC。
    5、展示完广告的vc之后，切换window的rootvc为主项目的vc。
 */
class AdXib_VC: UIViewController {

    
    @IBOutlet weak var containerView: UIView!   /// 广告图片
    @IBOutlet weak var imgView: UIImageView!    /// 默认占位图
    @IBOutlet weak var skipBtn: UIButton!
    
    //MARK: 工具属性
    private var adTimer: Timer?
    private var timeCount:Int = 10   /// 计时
    private var adImgView = UIImageView()
        
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        print("AdXib_VC的\(#function)方法")
        
    }
    
   override class func awakeFromNib() {
        super.awakeFromNib()
        print("AdXib_VC的\(#function)方法")
    }
    
    required init?(coder: NSCoder) {
        print("AdXib_VC的\(#function)方法")
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "启动页广告Xib的VC"
        
        /// 添加广告跳转手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickJumpAction))
        self.containerView.addGestureRecognizer(tapGesture)
        
        /// 启动定时器
        adTimer = Timer(fireAt: .distantPast, interval: 1.0, target: self, selector: #selector(adTimerCountAction), userInfo: nil, repeats: true)
        RunLoop.current.add(adTimer!, forMode: .common)
        
        /// 加载广告
        self.containerView.addSubview(adImgView)
        self.containerView.alpha = 1.0
        self.adImgView.alpha = 1.0
        adImgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        let myUrl  = URL.init(string: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fi.qqkou.com%2Fi%2F0a404548537x2815430900b26.jpg&refer=http%3A%2F%2Fi.qqkou.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1653555587&t=dcc5b600a9121d59752918e4a8c08d22")
        if let imgData = try? Data(contentsOf: myUrl!){
            adImgView.image  = UIImage(data: imgData)
        }
        
    }
    
    @IBAction func skipBtnAciton(_ sender: UIButton) {
        print("点击了跳过按钮")
        guard let app = UIApplication.shared.delegate as? AppDelegate else { print("AdXib_VC 没找到app"); return  }
        if app.firstWindow.rootViewController == self {
            let testVC = TestAd_VC()
            app.firstWindow.rootViewController = testVC
        }
    }
}

//MARK: - 动作方法
@objc extension AdXib_VC {
    
    /// 跳转广告的方法
    func clickJumpAction(){
        print("点击了广告，去openUrl")
        /// 销毁定时器
    }
    
    /// 定时器计时方法
    func adTimerCountAction(){
        print("定时器计时动作")
        timeCount -= 1;
        skipBtn.setTitle("跳过(\(timeCount))", for: .normal)
        
        if timeCount == 5 {
            let myUrl  = URL.init(string: "https://pic2.zhimg.com/v2-b1c88b18f652e83e28237c47fca2320d_r.jpg")
            if let imgData = try? Data(contentsOf: myUrl!){
                adImgView.image  = UIImage(data: imgData)
            }
        }
        if timeCount == 0 {
            if adTimer != nil {
                print("AdXib_VC 销毁定时器了～")
                adTimer?.invalidate()
                adTimer = nil
                skipBtnAciton(skipBtn)
            }
        }
        
    }
    
}
