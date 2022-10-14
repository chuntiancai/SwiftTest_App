## App版本管理(Xcode配置)
    1、在xcode上设置的Bundle identifier是app的唯一标识，用于在app store和手机上区分和别的app。
    2、version是设置app的版本号，用于迭代版本上传到app store。Build选项是制定改版本的第几次打包，可以理解为version的子集。(你可以设置Build自增，具体百度)
    3、launch screen的优先级 > launch image （现在都是用launch screen来设置启动图了，这是一个storyboard文件，你可以设置imageView）
    
    1、Deployment info 终端信息：
        也就是你的app要安装到那种手机上的信息。
        Main Interface: 程序入口，如果设计了，就会从story board中寻找入口页面。
        status bar style: 这里的只能影响启动页面时的状态栏。
        
    2、如果是通过launch image 来设置app的启动图片，那么整个app的可视范围由图片的大小决定，也就是以后的布局view的大小都被这个图片的大小约束了。
        launch screen 是story board文件，可以自动识别真机的大小，底层就是把launch screen 截屏，然后作为启动页面。
    

## Framwork文件：
    1、当你使用UIKit等framework时，Xcode会自动帮你引入这些框架，和第三方框架是一样的，只是隐含地导入而已。
    
## LaunchScreen文件：
    1、用于设置启动图片，启动页面。没有设置时，当年默认是4s的尺寸大小。
    2、该文件底层是将view生成一张图片。


## info.Plist文件：
    1、用于设置应用程序的配置信息，它就是一个字典。例如：app的名字，app的唯一标识，app的权限，推送，app版本，app的打包版本等等。
        Bundle name ： app的名字

    

## PCH文件(OC用得多)：
    1、很久以前的文件，现在xcode已经不自动生成了，要用到的话，就自己手动生成。
    2、用于存放公共的宏，全局宏。是一个app的全局宏文件，预编译文件，也就是预先于app主逻辑代码被编译。因此要在项目的building setting-->prefix header中设置该文件的信息。
    3、导入公共的头文件，也就是在主逻辑代码编译前，已经预先全局导入了一些头文件。
    4、原理：是在编译过程中，把PCH文件的所有内容都copy到当前工程中的所有文件的头部，然后开始编译。所以很大，编译很耗时，运行不耗时。二进制代码是会去掉很多重复的代码的，编译会优化掉。
    
## Scheme文件：
    1、其实就是App的二进制执行方案，你可以edit scheme（切换发布和debug运行环境），也可以切换scheme，也就是选择一个工作空间内的不同app来执行。
    
## projext.pbxproj文件： 
    1、projext.pbxproj文件 是xcode文件目录结构的配置文件，记录了xcode的文件结构状态。


## __OBJC__ 宏：
    1、每一个OC的源文件，xcode都隐式为它在头部定义了一个宏，这个宏就是 __OBJC__ ，所以可以在PCH文件的头部加上宏判断语句，也就是不是OC文件(例如兼容c文件)， 就不要把PCH的内容copy到当前文件中了。 宏判断语句： #ifdef __OBJC__  //内容//  #endif
    

## 开发者账户：
    apple developer账户中的Certificates, Identifiers & Profiles选项分别是限制电脑，限制人，限制app和真机的。
    1、Certificates 限制了当前apple账号可以在那台电脑进行开发。电脑需要安装证书，apple服务器通过验证电脑上的证书来允许该电脑是否可以开发。
    2、Identifiers 限制了当前apple账号可以开发哪个app，这里是app的BundleID。
    3、Devices 限制了哪台真机可以调试当前app代码，苹果开发者账号绑定的设备数量，每种平台(Platform)上限是100台。
              满了就不能添加新设备了，也无法自行移除不需要的设备，因为只有在每年账号续费时，才会有一次清理设备的机会。可以联系人工客服。
              xcode -->window -->  devices and simulator --> 查看真机的identifiers (即UUID)
    4、Profiles 账号绑定的电脑证书、app、真机等的描述信息的文件(上述的各个选项)。用于在电脑没有联网的时候，也可以通过Profiles文件中获取权限来调试app的代码。
                (Profiles文件在apple developer下载下来后双击即可安装到电脑上)。
                project --> target --> bulding setting --> code signing --> 这里可以手动添加你的Profiles文件和cer证书。
                
    总结：必须要有Certificates证书(或者p12文件)和Profiles文件才能开发。
    
    xcode7之后：
        1、一个免费的apple账户 --> join the apple developer program (加入到公司的(或个人)开发者账户中)
        2、xode --> preference --> account --> 添加 免费的 apple账户 --> download manual Profiles --> 即可自动化生成cer证书和Profiles文件，并且绑定到电脑和当前xcode中。
        
    ### p12文件：
        1、p12文件其实就是Certificates证书的导出文件，也就是个人信息交换文件。相当于cer证书的复印件。

        
## app打包测试：
    1、在apple developer账户的Certificates设置发布(Distribution)的证书(之前是开发development的证书)，Ad Hoc是临时的发布证书的意思。 然后就是同样的创建安装cer证书的步骤。
    2、在xcode安装cer证书和Profiles文件。
    3、xcode --> Product --> Archive --> export --> Ad Hoc 
    4、记得重新下载过期的证书。(如果证书无效，可以搜一下看是不是已经过期了，是的话重新下载)
    
    

## 发布App：
    1、在xcode打包好可以发布的ipa包，然后也可以在xcode直接联网上传到app store账号中，这时的打包就是构建版本。
    2、在apple developer上填写app的相关信息，上传，等待审核，然后发布。
    3、info.plist中的Bundle version string (short)上的版本号，必须和apple developer网页上的版本号一致。
       info.plist中的Bundle version可以作为内部版本号测试用，也可以作为Bundle version string (short)缺省时的值。

## TestFlight是app的beta测试版本：
    1、TestFlight本来是一个测试分发平台，在2014年被苹果收购了，用于beta测试流水化。就是发布内测版本。
    2、测试者提供邮箱。
       开发者登陆iTunes connect，给测试者发送邮箱邀请。
       测试者通过TestFlight软件下载app。
       不需要证书、不需要手动发ipa包、不需要真机uuid，但是有人数限制，外部人员2000，内部人员25人。
       
    3、TestFlight也是在iTunes connect网页上的，你可以选择在这里上传构建版本：
        在这里上传构建版本、添加测试人员。
        
## App里的内购：
    1、如果用户要购买App相关的功能服务，必须通过苹果内购的方式购买，例如qq会员。
    2、内购的话，苹果会收取开发商提成，4:6.
    3、也是iTunes connect网页上配置内购选项，代码上要用到StoreKit框架。
    4、配置内购选项要处理税务问题，配置税务信息。
    5、广告也是从苹果那里来的，分成是3:7。广告之后要调用iAd框架的方法。


## 推送通知：
    1、远程推送服务，又称为APNs（Apple Push Notification Services）
