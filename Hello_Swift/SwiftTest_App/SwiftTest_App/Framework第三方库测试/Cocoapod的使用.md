
## 自己制作的cocoapod私有库：
       1、首先你要配置安装好cocoapod的环境，然后就可以使用cocoapod命令了。
       
       2、通过命令创建cocoapod私有库：
           $ cd 合适的目录（最好是空文件夹）
           $ pod lib create yourLibName（库名字）//这里会生成一系列必要文件，包括yourLibName.podspec文件，熟悉之后可以手动生成添加。
       
       3、描述信息：在yourLibName.podspec文件中，描述你的库的信息、xcode工程信息等。例如它们的github地址、编译文件、依赖关系等等。
       
       4、pod lib lint yourLibName.podspec   //本地验证你的podspec文件
          pod spec lint  //网络校验你的podspec文件。

       5、上传文件：将yourLibName.podspe和xcode项目工程文件一同上传到yourLibName.podspe中描述的仓库地址上，并打上tag。
                 （tag 和yourLibName.podspec中s.version 的保持一致）
                 
## pod命令
    pod update ：这个命令会检查podfile.lock文件中的pod依赖库的版本，并进行更新，会重新生成一个podfile.lock文件。
    pod update 库名 --verbose --no-repo-update:  只更新指定的库，其它库忽略
    
    pod install : 会根据podfile.lock文件中指定的pod依赖库的版本去拉去项目的pod依赖库。在首次执行pod install命令时，
                  如果不存在podfile.lock文件会生成，podfile.lock文件，并且同时生成xcworkspace文件和pods文件夹。
                  
    pod install --verbose --no-repo-update : 只想给项目添加新的第三方，不更新本地已经存在的第三方，根据podfile.lock文件限制第三方库的版本。
    
    pod search ：用来搜索可以使用的pod依赖库，搜索结果中会向我们展示怎么在pod中使用该依赖库
    pod repo add NAME URL[branch] : 使用自己的pod仓库，会有更快的pod依赖库的操作速度。
    
    pod list ：列出所有项目依赖仓库中的pod依赖库。
    pod repo ：用来管理pod依赖仓库的地址。
    pod spec ：管理pod规范。
    pod init ：在当前目录下创建一个podfile文件，我们可以通过将需要的pod依赖库添加到podfile文件中，实现在项目中添加依赖。
    pod env ：来打印出pod的环境，一般是podfile文件中的内容。
    pod cache ：管理cocoapod的缓存：可以用来清空内存，也可以用来查看每个pod库的缓存。
    pod outdate ：展示出可更新版本的pod依赖库。

作者：pokerface_max
链接：https://www.jianshu.com/p/fb533c4a6a5d
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
                 
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
    
---- 
官网语法：
	Pod::Spec.new do |spec|
	  spec.name          = 'Reachability'
	  spec.version       = '3.1.0'
	  spec.license       = { :type => 'BSD' }
	  spec.homepage      = 'https://github.com/tonymillion/Reachability'
	  spec.authors       = { 'Tony Million' => 'tonymillion@gmail.com' }
	  spec.summary       = 'ARC and GCD Compatible Reachability Class for iOS and OS X.'
	  spec.source        = { :git => 'https://github.com/tonymillion/Reachability.git', :tag => 'v3.1.0' }
	  spec.module_name   = 'Rich'
	  spec.swift_version = '4.0'
	
	  spec.ios.deployment_target  = '9.0'
	  spec.osx.deployment_target  = '10.10'
	
	  spec.source_files       = 'Reachability/common/*.swift'
	  spec.ios.source_files   = 'Reachability/ios/*.swift', 'Reachability/extensions/*.swift'
	  spec.osx.source_files   = 'Reachability/osx/*.swift'
	
	  spec.framework      = 'SystemConfiguration'
	  spec.ios.framework  = 'UIKit'
	  spec.osx.framework  = 'AppKit'
	
	  spec.dependency 'SomeOtherPod'
	end
    
### podspec的vendored_libraries属性，引入.a文件时，必须把.a文件重命名为lib开头，cocoapod才可以识别出这是.a文件。 

##CocoaPods的post_install 和 pre_install

    有时候我们想在pod install/update时做一些除了第三方库安装以外的事情，比如关闭所有target的Bitcode功能。(Bitcode是LLVM的中间代码，无用，但默认嵌入了二进制文件中)
    这时就要用到CocoaPods中的钩子(Hooks),关于钩子(Hooks)的官方介绍在这里:https://guides.cocoapods.org/syntax/podfile.html#group_hooks
       
        post_install block接收一个"installer"参数，通过对"installer"修改来完成我们想要执行的特殊操作。
        还有另一个Hooks叫做"pre_install"，它的作用是允许你在Pods被下载后但是还未安装前对Pods做一些改变。写法和post_install一样。

    
        # 实现post_install Hooks
        post_install do |installer|
        
            # 1. 遍历项目中所有target
            installer.pods_project.targets.each do |target|
            
                # 2. 遍历build_configurations
                target.build_configurations.each do |config|
                
                    # 3. 修改build_settings中的ENABLE_BITCODE
                    config.build_settings['ENABLE_BITCODE'] = 'NO'
                end
            end
        end

        在上面的Podfile使用了一个 "post_install" Hooks，这个Hooks允许你在生成的Xcode project写入硬盘或者其他你想执行的操作前做最后的改动。
    
    
        CocoaPods是用Ruby开发的，其实Podfile就是一个Ruby代码文件，从Ruby的角度来看"post_install"这个Hooks，其实它就是一个Ruby中的Block。
            再来一点Ruby简单知识：
            每个Ruby对象都有"public_methods"方法，这个方法返回对象公开方法名列表；
            每个Ruby对象都有"instance_variables"方法，这个方法返回对象的属性名列表；
            每个Ruby对象都有"instance.instance_variable_get"方法，调用这个方法并传入属性名，就可以得到属性名称对应的对象；
            Array类型类似OC中的NSArray；Hash类型类似OC中的NSDictionary；Array和Hash对象可以使用each方法来遍历；
            puts 是ruby中的打印方法


        post_install do |installer|
            # puts 为在终端打印方法
            puts "##### post_install start #####"
        
            # 为了打印的日志方便查看，使用╟符号修饰
            puts "╟ installer"
            # 获取属性名称列表，并遍历
            installer.instance_variables.each do |variableName|
                # 打印属性名称
                puts "  ╟ #{variableName}"
            end
        
            puts "  ╟ installer.public_methods"
            # 获取方法名称列表，并遍历
            installer.public_methods.each do |method|
                # 打印方法名称
                puts "    ┣ #{method}"
            end
            puts "##### post_install end #####"
        end

    

                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 

