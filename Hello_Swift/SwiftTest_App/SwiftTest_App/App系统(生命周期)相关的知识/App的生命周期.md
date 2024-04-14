## UIApplication 这个对象象征了整个app程序。
    1、UIApplication是一个单例，通过 UIApplication.shared 获取到该单例。不可自己创建。
    2、iOS应用启动后创建的第一个对象就是UIApplication对象。（手机系统为你创建的）
    3、UIApplication可用于设置app的右上角图标、状态栏的网络可见状态、状态栏的设置(默认优先级低于VC)、可以通过info.plist文件辞去VC管理状态栏的职务、 openUrl跳转到的app(或资源)功能、


## 复写NSObject 的 load类方法
    1、load的方法会先于程序的main方法执行，因为load的方法是当该类被加载到内存中的时候就执行，也就是该类的对象还没开始创建，
        还没开始运行的时候就执行了，仅仅是描绘该类的二进制代码被加载进内存时(已经加载进去)，就执行该方法了。
    
## NSException 对象可以让 app执行崩溃

## UIApplicationDelegate 用于接收手机系统传递给app的系统事件。
    手机系统发给你的系统事件，包括app启动了的通知事件，app进入后台了的通知事件等等。。。
    1、app获取焦点的意思是：能否与用户进行交互，能则是获取到了焦点，否则是失去了焦点。并不是点击view之后才是有焦点，而是view或者app是否已经拥有了交互的能力才是焦点。
    2、如果手机系统给app发送多次内存警告，app仍不处理的话，手机系统会强制杀死app。

## main函数，app启动后会先执行main函数。
    1、swift已经隐藏掉main函数，用@UIApplicationMain标志来隐式调用main函数。
    2、main函数里调用的UIApplicationMain的四个参数：
            第一第二个参数：是C语言的命令行参数，用于指定命令行参数的个数和参数的数组，ios的app不是通过命令行启动，所以一般不会用到。
            第三个参数：(nil时默认)是 UIApplication类 的字符串名称，或者是UIApplication子类的字符串名称，用于初始化UIApplication对象。
                        nil的时候，就默认去创建UIApplication类的实例对象。
            第四个参数：是delegateClassName参数，用于指定生命周期delegate对象的类。
                      是NSStringFromClass方法， 将 类信息[AppDelegate class] 转化成 类的字符串名字。

## app启动时，调用的函数的顺序：
    1、执行main函数
    2、在main函数的代码里，执行UIApplicationMain方法，创建UIApplication对象，并设置UIApplication对象的代理。
    3、开启一个事件循环。（主运行循环，死循环；保证应用程序不退出）
    4、去加载info.plist文件。根据info.plist里的配置信息去向手机系统请求权限，设置app的性质。
      （判断info.plist里有没有Main的key配置，有的话，就根据main的key的value去加载Main.storyboard文件）
    5、app启动完毕。（通知UIApplicationDelegate，回调UIApplicationDelegate相关的周期方法，应用程序启动完毕）


## UIWindow是app启动完毕后，第一个创建的视图控件。
    1、UIWindow是一个特殊的view，但本质也是view，每个app至少要有一个UIwindow。
    2、app启动后，如果有Main.storyboard文件，那么UIKit默认就会创建一个UIwindow来承载Main.storyboard。
       其实没有Main.storyboard，也要你创建一个UIwindow来承载你在代码中指定的View。
    3、所以没有指定Main.storyboard文件时，你要在UIApplicationDelegate的代理方法中， 指定作为根VC的view，然后把该view添加到你创建的UIWindow上。
        调用window的[window makeKeyAndVisible];方法，使该window成为主window，然后启动完成后就显示该window
    4、键盘，状态栏其实都是UIWindow对象。ios9之后，如果添加了多个窗口，那么VC默认会把状态栏隐藏掉。你可以选择把状态栏交给info.plist来管理。
    5、可以设置UIWindow的等级来显示窗口。
    6、xcode默认会为你创建一个Main.storyboard和一个默认的ViewController。 你可以定义一个window，然后绑定默认的ViewController（ 好像你改名这个默认的VC,也还是可以定位到）。如果你想删了Main.storyboard，那么你就必须要调用window?.makeKeyAndVisible()方法 来显示window。
    7、调用了[window makeKeyAndVisible]的方法之后，window才把vc的view添加到自己的图层上。
    

## 手机系统加载完window后，就会去显示window绑定的VC。
        加载完window，不是显示出来window。
    1、UIKit加载完VC后，就会调用VC的loadView方法，loadView方法里的代码赋值给VC的默认的View。（xib中的View可以设置为VC默认的View）
    2、如果你想替换VC的默认的View，那么你就需要重写loadView方法。
    3、重写loadView的方法时，你需要赋值给vc的默认的view，因为在这里的时候，vc的默认的view还没初始化，如果你不重写，那么本来就是在这个loadview方法中初始化默认的view的。
      也就是相当于VC本身只是声明了一个 let view! ，还没有赋值。
    4、设置VC默认的View（设置VC的View），的使用场景一般是，本来背景就是一个图片，或者是webView。
    5、viewDidLoad方法是加载完毕View的时候被调用，加载完是指在内存上加载完，也就是loadview之后就会去调用viewDidLoad方法。
        而不是在屏幕上显示完。而调用到VC默认的View时，就会去加载view。这个viewDidLoad中的view其实就是VC默认的view。
        loadview是去加载view(第一次访问view的时候执行)，viewDidLoad是view加载完成之后的一个回调。
    6、如果一个控件是透明的，那么该控件不能接收事件。但是如果控件的颜色时透明，则还是可以接收事件的。


## 加载完VC后，就会去加载VC的View，VC的View是在LoadView方法中初始化的。
    1、所以你可以复写LoadView方法，重新赋值给VC的View。
    2、如果一个控件是透明的，那么该控件不能接收事件。但是如果控件的颜色时透明，则还是可以接收事件的。也就意味着可以通过设置View的透明来屏蔽事件。
    3、viewDidUnload是一个回调方法，当收到didReceiveMemoryWarning警告的时候，iOS6之后已经丢弃了。
        就会回调这个方法，你可以复写这个方法，在里面释放你不要的资源。

## VC的生命周期方法
    1、+load: 
            程序启动后，在系统的main函数调用之前，系统就会加载所有的load方法，提前进行一些资源包的配置或者hook。
            这个方法与VC的生命周期关系不大，而是所有类的二进制代码加载进内存时，首先执行该方法。
 
    2、+initialize: 当前类或者其子类未被初始化过时会首次调用，若以后当前类或者子类再多次初始化时不会再调用，一般提前为初始化做一些工作。
                    初始化类对象结构体。
 
    3、+alloc: 系统为当前类的实例对象分配内存时调用，在C语言中就是malloc这一步。
 
    4、-initWithCoder: 通过storyBoard方式实例化的vc，需要经过反序列化，这个方法会被调用。
 
    5、-initWithNibName:bundle: 通过xib文件或者init方法实例化的vc，这个方法都会被调用，其实init方法最终都会走该方法。
 
    6、-init: 通过纯代码实例化Vc会调用，其最终会调用initWithNibName:bundle:方法。
 
    7、-loadView: 实例化Vc后，可以加载一些系统常规的View。这里是初始化vc绑定的view。
 
    8、-viewDidLoad: 一般加载自定义的view或者初始化属性，视图加载完毕后会调用。这里是view已经初始化完成之后，用于添加子view。
 
    9、-viewWillAppear: 视图即将出现会调用。
 
    10、-viewWillDisappear: 视图即将消失会调用。
 
    11、-viewWillLayoutSubviews: 视图加载完毕后即将要布局。
 
    12、-viewDidLayoutSubviews: 视图加载完毕后布局也完成了。
 
    13、-didReceiveMemoryWarning: 加载视图时，内存消耗太大，出现内存警告，会调用。
 
    14、-dealloc: 实例化被销毁，进行内存的回收会调用。


