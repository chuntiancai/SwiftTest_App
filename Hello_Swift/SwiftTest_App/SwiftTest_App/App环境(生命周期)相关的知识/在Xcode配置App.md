## 去掉SceneDelegate
    1、直接在plist文件中删除关于scene这一项即可。
    2、然后要在class AppDelegate前加上@UIApplicationMain注解，要自己写window，然后让window成为主键。
        self.window?.makeKeyAndVisible()  //如果info.plist中有指定，则可以不调用这个方法，系统默认替你调用
    
## 指定info.plist文件的加载路径
    1、在工程配置-->Targets-->building setting --> 搜索info.plist ,然后你就知道是在packaging中修改info.plist 文件的路径了。 

