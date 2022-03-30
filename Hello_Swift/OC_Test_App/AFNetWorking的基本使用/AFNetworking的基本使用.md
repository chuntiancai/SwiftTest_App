
## 基本安装步骤：
### 1、从github中下载下来。在github中看简介中的Architecture章节，可以了解框架的基本架构，会使用到的类。
### 2、解压后，直接把AFNetworking文件夹拖到工程目录，copy到target打勾，该文件夹下有很多.h和.m文件，这些就是源码。
### 3、然后就可以直接在自己的源文件中#import了

## 基本使用步骤：
### 1、创建会话管理者AFHTTPSessionManager，因为AFNetworking就是对URLSession的封装。
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
### 2、发送GET\POST请求，无论是GET还是POST请求，URL中都不带参数。参数用字典封装起来了，作为发送请求的方法的参数。
    NSDictionary *paramDict = @{
                                @"username":@"520it",
                                @"pwd":@"520it",
                                @"type":@"JSON"
                                };
    //2.发送GET请求
    /*
     第一个参数:请求路径(不包含参数).NSString
     第二个参数:字典(发送给服务器的数据~参数)
     第三个参数:progress 进度回调
     第四个参数:success 成功回调
                task:请求任务
                responseObject:响应体信息(JSON--->OC对象)
     第五个参数:failure 失败回调
                error:错误信息
     响应头:task.response，是task的成员变量
     */
    [manager GET:@"http://120.25.226.186:32812/login" parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@---%@",[responseObject class],responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
    }];
### 3、发送POST请求和发送GET请求的方法是一样的参数列表，只需要将GET改为POST就可以了，这就是方便之处。[manager GET : ... ]与[manager POST : ... ]
### 4、★ 一定要自己封装一个工具类，用来调用AFNetworking，这样以后换第三方框架也方便。

## AFNetworking下载文件：
### 1、创建会话管理者AFHTTPSessionManager，使用它的downloadTaskWithRequest方法。先拼接方法的request参数。
    //1.创建会话管理者
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/resources/videos/minion_01.mp4"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
### 2、★ 执行AFHTTPSessionManager的downloadTaskWithRequest方法，拼接成网络下载的任务，通过参数闭包监听下载进度。
    //2.下载文件
    /*
     第一个参数:请求对象
     第二个参数:progress 进度回调 downloadProgress
     第三个参数:destination 回调(目标位置)
                有返回值
                targetPath:临时文件路径
                response:响应头信息
     第四个参数:completionHandler 下载完成之后的回调
                filePath:最终的文件路径，AFN会自动完成拼接已下载文件的处理。
     */
    NSURLSessionDownloadTask *download = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //监听下载进度
        //completedUnitCount 已经下载的数据大小
        //totalUnitCount     文件数据的中大小
        NSLog(@"%f",1.0 *downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        
        NSLog(@"targetPath:%@",targetPath);
        NSLog(@"fullPath:%@",fullPath);
        
        return [NSURL fileURLWithPath:fullPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        NSLog(@"%@",filePath);
    }];
### 3、执行下载的任务。[downloadTask resume];
    //3.执行Task
    [download resume];

## AFNetworking上传文件：
### 1、创建会话管理者，创建网络上传任务，可以使用和URLSession一样的步骤去拼接request的http报文段请求体，但是不推荐。
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
### 2、使用[manager POST: parameters: constructingBodyWithBlock:]方法构建网络上传任务，直接把上传的Data对象当作参数。
    //    NSDictionary *dictM = @{}
    //2.发送post请求上传文件
    /*
        第一个参数: 请求路径
        第二个参数parameters: 字典(非文件参数)
        第三个参数constructingBodyWithBlock: 处理要上传的文件数据，遵循AFMultipartFormData协议来拼接上传的数据
        第四个参数progress: 进度回调
        第五个参数success: 成功回调 responseObject:响应体信息
        第六个参数failure: 失败回调
        */
    [manager POST:@"http://120.25.226.186:32812/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        UIImage *image = [UIImage imageNamed:@"Snip20160227_128"];
        NSData *imageData = UIImagePNGRepresentation(image);    //遵循AFMultipartFormData协议来拼接上传的数据。
        
        //使用formData来拼接数据
        /*
            第一个参数:二进制数据 要上传的文件参数
            第二个参数:服务器规定的
            第三个参数:该文件上传到服务器以什么名称保存
            */
        //[formData appendPartWithFileData:imageData name:@"file" fileName:@"xxxx.png" mimeType:@"image/png"];
        
        //[formData appendPartWithFileURL:[NSURL fileURLWithPath:@"/Users/xiaomage/Desktop/Snip20160227_128.png"] name:@"file" fileName:@"123.png" mimeType:@"image/png"error:nil];
        
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"/Users/xiaomage/Desktop/Snip20160227_128.png"] name:@"file" error:nil];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"%f",1.0 * uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传成功---%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败---%@",error);
    }];
### 3、不需要像下载那样再执行上传任务， [manager POST: ...] 方法自动执行上传任务。

## AFNetworking序列化 (例如把字典存进沙盒)：
### 1、AFNetworking默认以JSON格式来解析网络数据。
### 2、★ 设置网络返回数据的解析器manager.responseSerializer，设置为XML解析器或者JSON解析器。默认是JSON。都会转换为参数闭包的responseObject。
### 3、遵循解析器的代理协议，在代理方法中获取解析后的数据。如，NSXMLParserDelegate协议。
    //返回的是JSON数据
    -(void)json
    {
        //1.创建会话管理者
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        //http://120.25.226.186:32812/login?username=123&pwd=122&type=JSON
        
        NSDictionary *paramDict = @{
                                    @"username":@"520it",
                                    @"pwd":@"520it",
                                    @"type":@"JSON"
                                    };
        //注意:如果返回的是xml数据,那么应该修改AFN的解析方案
        // manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
        
        //2.发送GET请求
        /*
         第一个参数:请求路径(不包含参数).NSString
         第二个参数:字典(发送给服务器的数据~参数)
         第三个参数:progress 进度回调
         第四个参数:success 成功回调
         task:请求任务
         responseObject:响应体信息(JSON--->OC对象)
         第五个参数:failure 失败回调
         error:错误信息
         响应头:task.response
         */
        [manager GET:@"http://120.25.226.186:32812/login" parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            //NSXMLParser *parser =(NSXMLParser *)responseObject;   //如果返回的是xml，则用NSXMLParser解析器。
            // parser.delegate = self; //设置代理 
            // [parser parse]; //开始解析
            
            NSLog(@"%@---%@",[responseObject class],responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败--%@",error);
        }];
    }
    
    //遵循的代理协议
    #pragma mark NSXMLParserDelegate
    -(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict
    {
        NSLog(@"%@--%@",elementName,attributeDict);
    }
### 4、处理其他的网络返回数据，要修改manager.responseSerializer为AFHTTPResponseSerializer
    //返回的二进制数据
    -(void)httpData
    {
        //1.创建会话管理者
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        //注意:如果返回的是xml数据,那么应该修改AFN的解析方案AFXMLParserResponseSerializer
        //注意:如果返回的数据既不是xml也不是json那么应该修改解析方案为:
        //manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        //2.发送GET请求
        [manager GET:@"http://120.25.226.186:32812/resources/images/minion_01.png" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task,id  _Nullable responseObject) {
            NSLog(@"%@-",[responseObject class]);
            
            //UIImage *image = [UIImage imageWithData:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败--%@",error);
        }];
    }

    -(void)httpData2
    {
        //1.创建会话管理者
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        //注意:如果返回的是xml数据,那么应该修改AFN的解析方案AFXMLParserResponseSerializer
        //注意:如果返回的数据既不是xml也不是json那么应该修改解析方案为:
        //manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
       
        //告诉AFN能够接受text/html类型的数据
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        //2.发送GET请求
        [manager GET:@"http://www.baidu.com" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task,id  _Nullable responseObject) {
            NSLog(@"%@-%@",[responseObject class],[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
            
            //UIImage *image = [UIImage imageWithData:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败--%@",error);
        }];
    }

## AFNetworking监测网络状态：
### 1、可以使用AFN框架中的AFNetworkReachabilityManager来监听网络状态的改变，也可以利用苹果提供的Reachability来监听。建议在开发中直接使用AFN框架处理。
### 2、调用AFNetworkReachabilityManager的setReachabilityStatusChangeBlock设置监听的闭包。
### 3、执行开始监听[manager startMonitoring];
### 4、苹果原生的检测网络状态的框架是Reachability，用通知来监听网络状态，还要自己手动创建监听对象，很麻烦。
    /*
    说明：可以使用AFN框架中的AFNetworkReachabilityManager来监听网络状态的改变，也可以利用苹果提供的Reachability来监听。建议在开发中直接使用AFN框架处理。
     */
    //使用AFN框架来检测网络状态的改变
    -(void)AFNReachability
    {
        //1.创建网络监听管理者
        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];

        //2.监听网络状态的改变
        /*
         AFNetworkReachabilityStatusUnknown          = 未知
         AFNetworkReachabilityStatusNotReachable     = 没有网络
         AFNetworkReachabilityStatusReachableViaWWAN = 3G
         AFNetworkReachabilityStatusReachableViaWiFi = WIFI
         */
        [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    NSLog(@"未知");
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    NSLog(@"没有网络");
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    NSLog(@"3G");
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    NSLog(@"WIFI");
                    break;

                default:
                    break;
            }
        }];

        //3.开始监听
        [manager startMonitoring];
    }

    ------------------------------------------------------------
    //使用苹果提供的Reachability来检测网络状态，如果要持续监听网络状态的概念，需要结合通知一起使用。
    //提供下载地址：https://developer.apple.com/library/ios/samplecode/Reachability/Reachability.zip

    -(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
    {
        //1.注册一个通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChange) name:kReachabilityChangedNotification object:nil];

        //2.拿到一个对象，然后调用开始监听方法
        Reachability *r = [Reachability reachabilityForInternetConnection];
        [r startNotifier];

        //持有该对象，不要让该对象释放掉
        self.r = r;
    }

    //当控制器释放的时候，移除通知的监听
    -(void)dealloc
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }

    -(void)networkChange
    {
        //获取当前网络的状态
       if ([Reachability reachabilityForInternetConnection].currentReachabilityStatus == ReachableViaWWAN)
        {
            NSLog(@"当前网络状态为3G");
            return;
        }

        if ([Reachability reachabilityForLocalWiFi].currentReachabilityStatus == ReachableViaWiFi)
        {
            NSLog(@"当前网络状态为wifi");
            return;
        }

        NSLog(@"当前没有网络");
    }

