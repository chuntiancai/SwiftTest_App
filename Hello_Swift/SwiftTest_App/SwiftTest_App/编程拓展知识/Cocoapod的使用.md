
## 自己制作的cocoapod私有库：
       1、首先你要配置安装好cocoapod的环境，然后就可以使用cocoapod命令了。
       
       2、通过命令创建cocoapod私有库：
           $ cd 合适的目录（最好是空文件夹）
           $ pod lib create yourLibName（库名字）//这里会生成一系列必要文件，包括yourLibName.podspec文件，熟悉之后可以手动生成添加。
       
       3、描述信息：在yourLibName.podspec文件中，描述你的库的信息、xcode工程信息等。例如它们的github地址、编译文件、依赖关系等等。
       
       4、上传文件：将yourLibName.podspe和xcode项目工程文件一同上传到yourLibName.podspe中描述的仓库地址上，并打上tag。
                 （tag 和yourLibName.podspec中s.version 的保持一致）
                 
                 
                 
## podspec语法：
    1、podspec是cocoapod库的描述文件，cocoapod通过读取podspec文件里的信息，对路径中的文件进行加载，处理，包装成framework来使用。
    2、示例：
示列文件：
    
    # 校验本文件，使用 `pod lib lint test_sh.podspec'
    # 详细语法 https://guides.cocoapods.org/syntax/podspec.html

    Pod::Spec.new do |s|
    s.name             = 'test_sh' #库名字
    s.version          = '0.1.0'  #版本号 遵循semantic versioning
    s.summary          = '简短摘要'
    s.description      = <<-DESC
                    在这里写一些关于这个cocoapod库的介绍
                        DESC
    s.homepage         = 'https://xxx.yyy.zzz/test_sh' #主页
    s.license          = { :type => 'MIT', :file => 'LICENSE' }  #法律协议
    s.author           = { 'zxs.zl' => 'zxs.zl@unknown.com' } #作者和联系方式
    s.source           = { :git => 'https://abc.efg/test_sh.git', :tag => s.version.to_s } #仓库地址
    
    s.ios.deployment_target = '8.0' #ios版本
    
    s.source_files = 'test_sh/Classes/**/*'  #参与编译的文件  **表示递归查找
    #资源文件
    # s.resource_bundles = {
    #   'test_sh' => ['test_sh/Assets/*.png']
    # }
    # s.public_header_files = 'Pod/Classes/**/*.h'  #需要公开的头文件
    # s.frameworks = 'UIKit', 'MapKit'  #依赖的ios系统库
    # s.dependency 'AFNetworking', '~> 2.3'  #依赖的三方库
    # s.vendored_libraries = 'test_sh/Classes/*.a'   #lpod库含有lib库时使用，即.a文件。
    # s.vendored_frameworks = 'test_sh/Classes/*.framework'  # pod库含有framework库时使用
    end

    

                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 

