
----------------------
day01
----------------
## xcode小知识：Xode5之前是有个framework文件夹的，也就是foundation这些框架都要手动引入，现在都不用了，xcode编译完成之后，自动为你引入。

## xcode小知识：可以在TARGET的App icon中设置启动图片， 启动页，还有启动sb。 都没有的话，默认的屏幕大小是4s的屏幕大小，现在不知道还是不是
### LaunchScreen.storyboard的底层原理是根据view在沙盒中(cache文件夹中)生成一张图片作为启动图。 

## xcode小知识：没有了PCH文件，

## 配置小知识：Info.plist文件用于设置App的配置信息，它是一个字典，本质是一个XML文件。
    
    Bundle name ---> 程序安装后在界面上显示的名称。应用程序名字限制在10-12个字符，如果超出限制，将被显示缩写名称
    Bundle indentifier ---> App唯一标识字符串，发布App，推送都需要这个Bundle indentifier
    Bundle versions string, short ---> 用于设置App软件的版本号
    Bundle version ---> 应用程序打包的版本号，每次部署应用程序的一个新版本时，应该增加这个编号，app store审核需要用
    
    Localization native development region ---> 本地化相关数据，如果用户没有响应的语言资源，则默认使用这个key的value
    Executable file ---> 程序安装包的名称
    InfoDictionary version ---> Info.plist格式的版本信息
    Bundle OS Type code ---> 程序安装包的名称 (暂时不知道是啥作用)
    Bundle creator OS Type code ---> (暂时不知道是啥作用)
    Application require iPhone environment ---> 用于指示程序包是否只能运行在iPhone OS 系统上。默认是YES，即只能安装在Iphone OS系统上
    Launch screen interface file base name ---> 程序启动时的所加载的启动画面，主要成xib文件中加载，这里的值为LaunchScreen，说明从LaunchScreen.storyboard中加载
    Mian storyboard file base name --->程序的启动时的主画面，此文件中的视图将作为程序启动后的主画面
    Supported interface orientations ---> 程序默认支持的方向
    Required device capabilities ---> 应用程序运行所需的设备限制

## PCH(precompile prefix file) 文件是xcode5以前用于统一存放宏定义的地方，宏定义在PCH文件中先于其他文件， 全局通用。可以在项目PROJECT的building setting中配置可用。

    存放公共的宏。
    导入公共的头文件。（虽然我觉得很重复）
    自定义log。宏定义的使用。#ifdef DEBUG 调试的时候才打印
    原理：会把PCH文件引入到每一个文件当中，相当于引入头文件一样。，编译器编译时会再优化的。所以编译时的拷贝有点耗时，所以xcode去掉了


## UIApplication 代表整个App，是单例，一个ios程序启动后创建的第一个对象就是UIApplication对象， 一般用于应用级别的操作。
### UIApplication 通过类方法[UIApplication sharedApplication]获取该单例
## UIApplication的常用场景(属性)：
###    1> 设置图标右上角的红色提示数字
    app.applicationIconBadgeNumber = 10;    //以前需要先注册通知registerUserNotificationSettings

###    2> 设置状态栏的样式
    app.statusBarStyle = UIStatusBarStyleBlackOpaque;

###    3> 设置状态栏的显示和隐藏
    app.statusBarHidden = YES;

###    4> 显示状态栏上面的圈圈
    app.networkActivityIndicatorVisible = YES;

###    5> 打开外部资源，打开网页、打电话、发短信
    * 打开网页
    [app openURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    * 打电话
    [app openURL:[NSURL URLWithString:@"tel://10086"]];
    * 发短信
    [app openURL:[NSURL URLWithString:@"sms://10086"]];

###    6> 代理属性（当应用程序发生了一些系统级别的事件，就会通知代理，交给代理去处理）
    @property(nonatomic,assign) id<UIApplicationDelegate> delegate;

## NSObject的+load方法会先于main方法执行，因为load是类代码加载进内存中就执行，main是程序执行起来才运行。
### 重写类方法+alloc实现单例一调用alloc方法时就抛出运行时异常，UIApplication就是这样。

## 编程小技巧：寻找工厂类方法来创建对象，工厂类方法的名字开头一般时驼峰命名法的名字开头。 例如UIUserNotificationSettings，就尝试User、noti..、setting 开头的类方法。

## VC和UIApplication都可以管理状态栏。VC是通过实现代理的方法，通过返回值设置状态栏。UIApplication管理状态栏需要配置info.plist文件，禁止VC来管理。

## AppDelegate是UIApplication的代理对象，AppDelegate代理UIApplication处理一些系统事件，通过代理方法。 
###    程序加载完毕（启动完毕）就会调用一次
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions

###     应用程序失去焦点的时候调用(一个app如果失去焦点，就不能跟用户进行交互)，进入后台之前
    - (void)applicationWillResignActive:(UIApplication *)application
    
###     应用程序获得焦点的时候调用(一个app只有获得焦点之后才能跟用户进行交互)，进入前台之后
     - (void)applicationDidBecomeActive:(UIApplication *)application     
     
###    程序进入后台就会调用
    - (void)applicationDidEnterBackground:(UIApplication *)application

###     程序即将进入前台的时候调用
    - (void)applicationWillEnterForeground:(UIApplication *)application

###    程序即将被关闭的时候可能会被调用
    - (void)applicationWillTerminate:(UIApplication *)application
    
###    程序接收到内存警告都会调用
    - (void)applicationDidReceiveMemoryWarning:(UIApplication *)application

## 一、App的启动原理，启动流程：
### 1、执行main函数
### 2、执行UIApplicationMain方法，创建UIApplication对象，并设置UIApplication的代理AppDelegate，该方法四个参数的含义(可看API文档)：
    //main函数的参数一
    //main函数的参数二
    //默认是UIApplication字符串，或者你传入UIApplication的子类的名字字符串。
    //UIApplication的代理的类的名字的字符串。NSStringFromClass方法是把类对象转换成字符串。
    return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
### 3、然后就开启了一个事件循环。(主运行循环，死循环，一直在执行。main event loop)
### 4、去加载info.plist文件。(判断info.plist文件中有没有Main，有则去加载Main.storyboard)
### 5、应用程序启动完毕。(通知AppDelegate对应的方法didFinishLaunchingWithOptions)，即便没有Main.storyboard， 也会去通知启动完毕的代理方法。

## 二、App启动完毕后，创建的第一个UI控件就是UIWindow，接着创建VC的View，接着View添加到UIWindow上。 
### 6、如果有Main，则去加载Main.storyboard。（可以手动在AppDelegate的didFinishLaunchingWithOptions手动创建方法，不要Main.sb）
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        // Override point for customization after application launch.
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
        
        self.window.rootViewController = [ViewController new];
        return YES;
    }
### 7、先创建一个窗口(UIWindow)
### 8、把Main.storyboard指向的VC设置为UIWindow的根VC
### 9、显示窗口(把窗口的根VC的view添加到窗口)

## UIWindow的主要方法：
### makeKeyWindow方法 ：将当前 UIWindow 设置成应用程序的主窗口。
### makeKeyAndVisible方法 ：将当前 UIWindow 设置成应用的 key window，并使得 UIWindow 可见；你也可以使用 UIView 的 hidden 属性来显示或者隐藏一个 UIWindow。
### lastObject方法：获取最上面的window
    UIWindow *window =[ [UIApplication sharedApplication].windows lastObject];
### keyWindow属性 ： BOOL 类型，只读，用于判断是否是当前应用的 key window (key window 是指可接收到键盘输入及其他非触摸事件的 UIWindow，一次只能有一个 key window)
### rootViewController属性 ：UIViewController 类型，iOS 4.0新增属性，设置此属性后，rootViewController 所包含的 view 将被添加到 UIWindow 中，iOS 4.0之前版本可采用 addSubview: 方法达到同样的效果，因为 UIWindow 类本身就是 UIView 的子类。
### windowLevel 属性：UIWindowLevel 类型，多个 UIWindow 的显示顺序是按照 windowLevel 从高到低排列的，windowLevel 最高的显示在最前面。比如：windowLevel 较高的 UIAlertView 警告窗口会显示在一般窗口的前面。

## 键盘，状态栏其实都是window，自身就是是window，不是属于主window。
### 从ios9之后，添加多个window会默认把状态栏隐藏掉，所以你要把状态栏显示出来。
### window的级别会影响window的显示等级，所以window不见了，要留意是不是windowLevel的设置问题。

## 三、window创建完之后，创建对应的VC
## 通过代码获取Storyboard，通过Storyboard加载VC，获取sb绑定的VC：
    //要在AppDelegate的didFinishLaunchingWithOptions方法中，获取这些对象，就是加载了。
    //获取sb对象
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"main" bundle:nil];
    //通过sb获取绑定的VC
    UIViewController * sbVC = [sb instantiateInitialViewController];

### 通过xib加载VC，VC的底层init方法会自动调用initWithNibName方法。
    //如果initWithNibName赋值为nil，则去加载和MyViewController同名的VC。（MyViewController.xib）
    //如果赋值的名字找不到，则去寻找加载（MyView.xib）
    MyViewController * xibVC = [[ViewController alloc]initWithNibName:@"myxib" bundle:nil];

### VC创建对应的View，-loadView方法，创建VC自身的View，当自身的view第一次被使用时，就会调用VC的loadView方法
### loadView方法会判断VC的view是不是从sb中创建，然后设置为当前的VC自身的view。同理xib也是。如果都不是，则创建空白View。
### 一旦重写了VC的loadView方法，也就意味着你要自己创建VC的View，所以你要在loadView方法了设置VC的view。
    
    ### 一旦在VC中重写-loadView方法，就说明你要自定义view给VC的view，也就是你要在方法体里设置self.view
    #### 一般VC的背景就是一张图片时，或者是webView时，就可以重写loadview方法设置self.view为UIImageView，节省内存。
    ### 如果一个UI控件不能接收事件，那么它的子控件也不能接收事件。
    ### 如果一个UI控件是透明的(alpha=0)，那么它是不可以接收事件。颜色是透明色，并不等同于控件是透明。
    #### VC自身的View的颜色是透明色，但是VC自身的View并不是透明的。
    ### [window makeKeyAndVisible] 方法，当窗口显示时，就把根VC的View添加到window上。

    ### VC自身的view是懒加载的，用到的时候才会去创建：
    #### 当首次使用VC的view时，会先去执行VC的loadview方法，然后是viewdidload方法。
