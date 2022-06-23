## 去掉SceneDelegate
    1、直接在plist文件中删除关于scene这一项即可。
    2、然后要在class AppDelegate前加上@UIApplicationMain注解，要自己写window，然后让window成为主键。
        self.window?.makeKeyAndVisible()  //如果info.plist中有指定，则可以不调用这个方法，系统默认替你调用
    
## 指定info.plist文件的加载路径
    1、在工程配置-->Targets-->building setting --> 搜索info.plist ,然后你就知道是在packaging中修改info.plist 文件的路径了。 

## projext.pbxproj文件： 
    1、projext.pbxproj文件 是xcode文件目录结构的配置文件，记录了xcode的文件结构状态。

## 配置SVN或者Git
    Source Control --> commit
    Xcode --> preferences --> Accounts --> + --> Xcode Sever    (Xcode10之后就不再自带svn了)
    
## OC情况下，LLDB不能打印view的bounds时
    在命令行输入：expr @import UIKit

## building for iOS Simulator, but linking in dylib built for iOS, 报错
    因为苹果M1芯片用的是arm64的架构，而之前的mac是用的英特尔芯片。
    所以要在 TARGET -> Architectures -> Excluded Architectures -> 添加arm64
    同时在 pod项目里，也要 PROJECT -> Architectures -> Excluded Architectures -> 添加arm64
    之前一直没解决是因为没有在pod项目里也添加arm64
