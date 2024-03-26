## UIApplication 这个对象象征了整个app程序。
    1、UIApplication是一个单例，通过 UIApplication.shared 获取到该单例。不可自己创建。
    2、iOS应用启动后创建的第一个对象就是UIApplication对象。（手机系统为你创建的）
    3、UIApplication可用于设置app的右上角图标、状态栏的网络可见状态、状态栏的设置(默认优先级低于VC)、可以通过info.plist文件辞去VC管理状态栏的职务、 openUrl跳转到的app(或资源)功能、


## 复写NSObject 的 load类方法
    1、load的方法会先于程序的main方法执行，因为load的方法是当该类被加载到内存中的时候就执行，也就是该类的对象还没开始创建，还没开始运行的时候就执行了，仅仅是描绘该类的二进制代码被加载进内存时(已经加载进去)，就执行该方法了。
    
## NSException 对象可以让 app执行崩溃

## UIApplicationDelegate 用于接收手机系统传递给app的系统事件。
    手机系统发给你的系统事件，包括app启动了的通知事件，app进入后台了的通知事件等等。。。
    1、app获取焦点的意思是：能否与用户进行交互，能则是获取到了焦点，否则是失去了焦点。并不是点击view之后才是有焦点，而是view或者app是否已经拥有了交互的能力才是焦点。
    2、如果手机系统给app发送多次内存警告，app仍不处理的话，手机系统会强制杀死app。

## main函数，app启动后会先执行main函数。
    1、swift已经隐藏掉main函数，用@UIApplicationMain标志来隐式调用main函数。
    2、main函数里调用的UIApplicationMain的四个参数：第三个参数(nil时默认)是UIApplication类的字符串名称，或者是UIApplication子类的字符串名称。
                                               第四个参数是NSStringFromClass方法 将 类信息[AppDelegate class] 转化成 类的字符串名字。

## app启动时，调用的函数的顺序：
    1、执行main函数
    2、在main函数的代码里，执行UIApplicationMain方法，创建UIApplication对象，并设置UIApplication对象的代理。
    3、开启一个事件循环。（主运行循环，死循环；保证应用程序不退出）
    4、去加载info.plist文件。根据info.plist里的配置信息去向手机系统请求权限，设置app的性质。
      （判断info.plist里有没有Main的key配置，有的话，就根据main的key的value去加载Main.storyboard文件）
    5、app启动完毕。（通知UIApplicationDelegate，应用程序启动完毕）


## UIWindow是app启动完毕后，第一个创建的视图控件。
    1、UIWindow是一个特殊的view，但本质也是view，每个app至少要有一个UIwindow。
    2、app启动后，如果有Main.storyboard文件，那么UIKit默认就会创建一个UIwindow来承载Main.storyboard。
       其实没有Main.storyboard，也要你创建一个UIwindow来承载你在代码中指定的View。
    3、所以没有指定Main.storyboard文件时，你要在UIApplicationDelegate的代理方法中， 指定作为根VC的view，然后把该view添加到你创建的UIWindow上。
        调用window的[window makeKeyAndVisible];方法，使该window成为主window，然后启动完成后就显示该window
    4、键盘，状态栏其实都是UIWindow对象。ios9之后，如果添加了多个窗口，那么VC默认会把状态栏隐藏掉。你可以选择把状态栏交给info.plist来管理。
    5、可以设置UIWindow的等级来显示窗口。
    6、xcode默认会为你创建一个Main.storyboard和一个默认的ViewController。 你可以定义一个window，然后绑定默认的ViewController（ 好像你改名这个默认的VC,也还是可以定位到）。如果你想删了Main.storyboard，那么你就必须要调用window?.makeKeyAndVisible()方法来显示window。
    7、调用了[window makeKeyAndVisible]的方法之后，window才把vc的view添加到自己的图层上。
    

## 手机系统加载完window后，就会去显示window绑定的VC。
        加载完window，不是显示出来window。
    1、UIKit加载完VC后，就会调用VC的loadView方法，loadView方法里的代码赋值给VC的默认的View。（xib中的View可以设置为VC默认的View）
    2、如果你想替换VC的默认的View，那么你就需要重写loadView方法。
    3、重写loadView的方法时，你需要赋值给vc的默认的view，因为这里的时候，vc的默认的view还没初始化，如果你不重写，那么父类本了就是在这个方法中初始化默认的view的。
      也就是相当于VC本身只是声明了一个 let view! ，还没有赋值。
    4、设置VC默认的View（设置VC的View），的使用场景一般是，本来背景就是一个图片，或者是webView。
    5、viewDidLoad方法是加载完毕View的时候被调用，加载完是指在内存上加载完，而不是在屏幕上显示完。而调用到VC默认的View时，就回去加载view。这个viewDidLoad中的view其实就是VC默认的view。
    6、如果一个控件是透明的，那么该控件不能接收事件。但是如果控件的颜色时透明，则还是可以接收事件的。


## 加载完VC后，就回去加载VC的View，VC的View是在LoadView方法中初始化的。
    1、所有你可以复写LoadView方法，重新赋值给VC的View。
    2、如果一个控件是透明的，那么该控件不能接收事件。但是如果控件的颜色时透明，则还是可以接收事件的。也就意味着可以通过设置View的透明来屏蔽事件。
