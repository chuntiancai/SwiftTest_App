---------------
day05:
--------------------
## JSON解析为OC对象（反序列化）
### 1、使用[NSJSONSerialization JSONObjectWithData: : :] 方法转换为集合类型的OC对象。
#### 1.1、方法的参数options决定了解析成OC对象的类型，是集合类型，还是字符串、数字。
    -(void)jsonToOC
    {
        //1.确定url
        NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login?username=123&pwd=456&type=JSON"];
        
        //2.创建请求对象
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        //3.发送异步请求
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            //data---->本质上是一个json字符串（是响应体）
            //4.解析数据
            //NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
            
            //JSON--->oc对象 反序列化
            /*
             第一个参数:JSON的二进制数据
             第二个参数:
                        NSJSONReadingMutableContainers = (1UL << 0), 可变字典和数组
                        NSJSONReadingMutableLeaves = (1UL << 1),      内部所有的字符串都是可变的 ios7之后又问题  一般不用
                        NSJSONReadingAllowFragments = (1UL << 2)   既不是字典也不是数组,则必须使用该枚举值
             第三个参数:错误信息
             */
            NSString *strM = @"\"wendingding\"";
            //        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]; //kNilOptions就是0，枚举中的默认选项，第一项
            id obj = [NSJSONSerialization JSONObjectWithData:[strM dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"%@---%@",[obj class],obj);
            
        }];
        
        
        //NSString *strM = @"{\"error\":\"用户名不存在\"}";       //解析为字典
        //NSString *strM = @"[\"error\",\"用户名不存在\"]";   //解析为数组
        //NSString *strM = @"\"wendingding\"";      //解析为字符串
        //NSString *strM = @"false";        //解析为NSNumber
        //NSString *strM = @"true";     //解析为NSNumber
        NSString *strM = @"null";       //解析为NSNumber
        
        id obj = [NSJSONSerialization JSONObjectWithData:[strM dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:0];
        NSLog(@"%@---%@",[obj class],obj);
        
        /*
         JOSN   OC
         {}     @{}
         []     @[]
         ""     @""
         false  NSNumber 0
         true   NSNumber 1
         null      NSNull为空
         */
        
        //nil
        [NSNull null];   //该方法获得的是一个单粒,表示为空,可以用在字典或者是数组中

    }
    
## OC对象转换为JSON（序列化）
### 1、使用[NSJSONSerialization dataWithJSONObject: options: error:]方法将OC对象转换为JSON。
#### 1.1、并非所有的对象都能转换为json，可以用[NSJSONSerialization isValidJSONObject:];判断该OC对象是否可以转换。
#### 1.1.1、最外层必须是 NSArray or NSDictionary。
#### 1.1.2、所有的元素必须是 NSString, NSNumber, NSArray, NSDictionary, or NSNull。
#### 1.1.3、字典中所有的key都必须是 NSStrings类型的，NSNumbers不能是无穷大。
    NSDictionary *dictM = @{@"name":@"dasheng11",
                            @"age": @3 };
    NSArray *arrayM = @[@"123",@"456"];
    
    //注意:并不是所有的OC对象都能转换为JSON
    /*
     - 最外层必须是 NSArray or NSDictionary
     - 所有的元素必须是 NSString, NSNumber, NSArray, NSDictionary, or NSNull
     - 字典中所有的key都必须是 NSStrings类型的
     - NSNumbers不能死无穷大
     */
    NSString *strM = @"WENIDNGDING";
    
    BOOL isValid = [NSJSONSerialization isValidJSONObject:strM];
    if (!isValid) {
        NSLog(@"%zd",isValid);
        return;
    }
    
    //OC--->json
    /*
     第一个参数:要转换的OC对象
     第二个参数:选项NSJSONWritingPrettyPrinted 排版 美观
     */
    NSData *data = [NSJSONSerialization dataWithJSONObject:strM options:NSJSONWritingPrettyPrinted error:nil];
    
    NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);


#### 1.2、数组对象转换为JSON文件格式，不能直接调用write方法，这样会转换为xml文件的格式，要先转换为data，再write磁盘中。
    NSArray *arrayM = [NSArray arrayWithContentsOfFile:@"/Users/xiaomage/Desktop/课堂共享/11大神班上课资料/05-多线程网络/0225/资料/apps.plist"];
    NSLog(@"%@",arrayM);
    
    //[arrayM writeToFile:@"/Users/xiaomage/Desktop/123.json" atomically:YES];  //这样会是xml格式。
    
    //OC--->JSON
    NSData *data =  [NSJSONSerialization dataWithJSONObject:arrayM options:NSJSONWritingPrettyPrinted error:0];
    [data writeToFile:@"/Users/xiaomage/Desktop/123.json" atomically:YES];

#### ◆ 1.3、一般在子线程去请求网络json数据，所以要记得转回到主线程刷新UI。


### 2、面向模型开发去解析JSON为OC对象。主要是字典转模型。
#### 2.1、要自定义一个类，属性就是json的元素，你设计的这个类就叫做模型。然后把json中的元素赋值给模型类的属性。
##### 2.1.1、先将json转换为字典或者数组类型的对象，然后取值填充你设计的模型对象，然后用一个数据存放你的模型对象。
    //4.解析数据，将json转换为字典。
    NSDictionary *dictM = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:0];
    
    //复杂JOSN 1)在线格式化 2)write
    //http://tool.oschina.net/codeformat/json
    //[dictM writeToFile:@"/Users/xiaomage/Desktop/video.plist" atomically:YES];
    
    NSLog(@"%@",dictM);
    
    //        self.videos = dictM[@"videos"];
    
    //字典数组--->模型数组
    for (NSDictionary *dict in dictM[@"videos"]) {
        [self.videos addObject:[XMGVideo videoWithDict:dict]];  
    }

##### 2.1.2、NSObject提供了setValuesForKeysWithDictionary方法，用于用字典初始化属性，只要属性的名字与字典的key名字对应即可，这就是KVC编程。
    .h文件中：
    @interface XMGVideo : NSObject

    /*
     "id": 1,
     "image": "resources/images/minion_01.png",
     "length": 10,
     "name": "小黄人 第01部",
     "url": "resources/videos/minion_01.mp4"
     */

    /** ID */
    @property (nonatomic, strong) NSString *id; //关键字冲突
    /** 图片地址 */
    @property (nonatomic, strong) NSString *image;
    /** 播放时间 */
    @property (nonatomic, strong) NSString *length;
    /** 标题*/
    @property (nonatomic, strong) NSString *name;
    /** 视频的url */
    @property (nonatomic, strong) NSString *url;

    //字典转模型处理
    +(instancetype)videoWithDict:(NSDictionary *)dict;
    @end
    
    .m文件中：
    @implementation XMGVideo
    +(instancetype)videoWithDict:(NSDictionary *)dict
    {
        XMGVideo *video = [[XMGVideo alloc]init];
        //KVC
        [video setValuesForKeysWithDictionary:dict];
        //    video.name = dict[@"name"]; //也可以自己手动一个一个转，很低效。
        return video;
    }
    @end

## JSON解析的第三方框架MJExtension
### 1、还是要自己设计模型类，但是解释json转换为OC模型对象的时候，一句代码搞定了。
#### 1.1、是扩展了NSObject，直接调用mj_objectArrayWithKeyValuesArray方法就可以了。就可以将json数据转换为你的模型对象了。
    //3.发送异步请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            return ;
        }
        //4.解析数据
        NSDictionary *dictM = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:0];

        //字典转模型
        self.videos = [XMGVideo mj_objectArrayWithKeyValuesArray:dictM[@"videos"]];     //只需要这一句代码。
        
        //5.更新UI
        [self.tableView reloadData];
    }];
#### 1.2、在模型中重写mj_replacedKeyFromPropertyName方法可以替换 模型的属性名字 与 json中的名字，然后进行解析json。
#### 1.3、也可以在直接转换前调用mj_setupReplacedKeyFromPropertyName，而不需要重写mj_replacedKeyFromPropertyName，均可。
    //重写方法替换。
    +(NSDictionary *)mj_replacedKeyFromPropertyName
    {
        return @{@"ID":@"id"};
    }
    
    //json解析前调用该方法，替换
    [XMGVideo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID":@"id"
                 };
    }];
    
## 选第三方框架小技巧：侵入性、易用性、扩展性
    a.侵入性，是否太难分离这个框架，侵入性太强
    b.易用性，是否容易上手
    c.扩展性，很容易给这个框架增加新的功能

## XML的解析
### 1、XML要注意两个标签里面的换行符和制表符都算是内容。
#### 1.1、标签里面那些叫做属性。
    <videos>        //<videos>和</videos>分别叫做开始标签和结束标签，这两个标签中间的东西，叫做内容。
        <video name="小黄人 第01部" length="30" />       //标签尖括号里面的东西叫做属性，属性等号后面的叫做属性的值。
        <video name="小黄人 第02部" length="19" />       //标签里的子标签，叫做该标签的元素。
        <video name="小黄人 第03部" length="33" />
    </videos>

### 2、XML的解析方式有两种，DOM解析和SAX解析。
    DOM：一次性将整个XML文档加载进内存，比较适合解析小文件
    SAX：从根元素开始，按顺序一个元素一个元素往下解析，比较适合解析大文件

### 3、苹果原生的解析XML框架是NSXMLParser，使用SAX方式解析，使用简单
#### 3.1、第三方框架解析XML的有libxml2、GDataXML
    libxml2：纯C语言，默认包含在iOS SDK中，同时支持DOM和SAX方式解析
    GDataXML：DOM方式解析，由Google开发，基于libxml2

    XML解析方式的选择建议
    大文件：NSXMLParser、libxml2
    小文件：GDataXML、NSXMLParser、libxml2

#### 3.2、NSXMLParser的使用，假设网络返回的是XML格式数据。(我们一般叫做XML文档)
##### 3.2.1、创建XML解析器，遵循代理NSXMLParserDelegate，实现代理方法。是在代理方法里面返回解析的结果的。
    //4.解析数据
    //4.1 创建XML解析器:SAX
    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
    
    //4.2 设置代理
    parser.delegate = self;
    
    //4.3 开始解析,会阻塞当前线程
    [parser parse];

#### 3.2.2、常用的NSXMLParserDelegate代理方法
    #pragma mark NSXMLParserDelegate
    //1.开始解析XML文档的时候
    -(void)parserDidStartDocument:(NSXMLParser *)parser
    {
          NSLog(@"%s",__func__);
    }

    //2.开始解析某个元素
    -(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict
    {
        NSLog(@"开始解析%@---%@",elementName,attributeDict);
        //过滤根元素
        if ([elementName isEqualToString:@"videos"]) {
            return;
        }
        
        //字典转模型
        [self.videos addObject:[XMGVideo mj_objectWithKeyValues:attributeDict]];
    }

    //3.某个元素解析完毕
    -(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
    {
        NSLog(@"结束解析%@",elementName);
    }

    //4.结束解析
    -(void)parserDidEndDocument:(NSXMLParser *)parser
    {
        NSLog(@"%s",__func__);
    }
#### 3.2.3、 [parser parse];解析xml的方法会阻塞当前线程，解析完之后才会去执行下一行代码。



## xcode配置小技巧，配置头文件搜索路径：因为是xcode主要用于编译，所以是在TARGET --> Building Setting --> Header Search Paths。
## xcode配置小技巧，配置库文件连接：TARGET --> Building Setting --> Other Linker Flags。（符号连接）
## xcode小技巧：自动转换MRC为ARC：Xcode --> Edit --> Convert --> To Objective-C ARC...
## xcode小技巧：编译阶段Building Pharse选择非ARC方式编译某个源文件：TARGET --> Building Pharse --> Compile Sources --> 设置指令-fno-objc-arc.
    因为ARC只是编译器特性，并不是垃圾回收机制，所以只需要修改编译器配置即可。

### 4、解析网络json数据时，转义中文“打印输出”问题，加上@就可以了，可以扩展系统NSDictionary类，重写descriptionWithLocale方法，但是记得要保留原来的功能。
    @implementation NSDictionary (Log)

    //重写系统的方法控制输出
    -(NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
    {
        //    return @"你大爷是你大姐";
        NSMutableString *string = [NSMutableString string];
        
        //{}
        [string appendString:@"{"];
        
        //拼接key--value
        [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [string appendFormat:@"%@:",key];   //加上@就可以了，再输出就可以了
            [string appendFormat:@"%@,",obj];
            
        }];
        [string appendString:@"}"];
        
        //删除逗号
        //从后往前搜索 得到的是搜索到的第一个符号的位置
        NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
        if (range.location != NSNotFound) {
            [string deleteCharactersInRange:range];
        }
        
        return string;
    }

    @end

    //重写数组的打印输出方法
    @implementation NSArray (Log)

    //重写系统的方法控制输出
    -(NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
    {
        //    return @"你大爷是你大姐";
        NSMutableString *string = [NSMutableString string];
        
        //{}
        [string appendString:@"["];
        
        //拼接obj
        [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [string appendFormat:@"%@,\n",obj];
        }];

        [string appendString:@"]"];
        
        //删除逗号
        //从后往前搜索 得到的是搜索到的第一个符号的位置
        NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
        if (range.location != NSNotFound) {
            [string deleteCharactersInRange:range];
        }

        return string;
    }

    @end

## 网络下载小文件
### 1、使用NSData的方法，[NSData dataWithContentsOfURL:url]，耗时操作。
    //1.url
    NSURL *url = [NSURL URLWithString:@"http://img5.imgtn.bdimg.com/it/u=1915764121,2488815998&fm=21&gp=0.jpg"];
    
    //2.下载二进制数据
    NSData *data = [NSData dataWithContentsOfURL:url];

    //3.转换
    UIImage *image = [UIImage imageWithData:data];
### 2、使用NSURLConnection(过时)发送网络请求下载文件，无法监听进度，内存飙升。
    /1.url
    // NSURL *url = [NSURL URLWithString:@"http://imgsrc.baidu.com/forum/w%3D580/sign=54a8cc6f728b4710ce2ffdc4f3cec3b2/d143ad4bd11373f06c0b5bd1a40f4bfbfbed0443.jpg"];
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/resources/videos/minion_01.mp4"];
    
    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
       
        //4.转换
        //        UIImage *image = [UIImage imageWithData:data];
        //        self.imageView.image = image;
        //NSLog(@"%@",connectionError);
        
        //4.写数据到沙盒中
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"123.mp4"];
        [data writeToFile:fullPath atomically:YES];
    }];

### 3、使用NSURLConnection发送网络请求下载文件，并设置代理对象，遵循NSURLConnectionDataDelegate的代理方法，监听下载进度。（NSURLConnection-delegate）,内存飙升。
    //1.url
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/resources/videos/minion_01.mp4"];
    
    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.发送请求
    [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    #pragma mark NSURLConnectionDataDelegate，遵循代理方法。
    //当接收到服务器响应的时候调用，该方法只会调用一次
    -(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
    {
        NSLog(@"didReceiveResponse");
        //得到文件的总大小(本次请求的文件数据的总大小)
        self.totalSize = response.expectedContentLength;
    }

    //当接收到服务器返回的数据时会调用，该方法可能会被调用多次。
    -(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
    {
       // NSLog(@"%zd",data.length);
        [self.fileData appendData:data];
        
        //进度=已经下载/文件的总大小
        NSLog(@"%f",1.0 * self.fileData.length /self.totalSize);
    }
    
    //当请求失败的时候调用该方法
    -(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
    {
    }

    //当网络请求结束之后调用
    -(void)connectionDidFinishLoading:(NSURLConnection *)connection
    {
        NSLog(@"connectionDidFinishLoading");
        //4.写数据到沙盒中
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"123.mp4"];
        
        [self.fileData writeToFile:fullPath atomically:YES];
        NSLog(@"%@",fullPath);
    }

## 网络下载大文件：
### 1、边接收数据边写文件以解决内存越来越大的问题。（也是NSURLConnection-delegate，但是优化，写到沙盒里面去，而不是使用数组暂存内存），在代理方法-(void)connection: didReceiveData:中处理。
    //当接收到服务器响应的时候调用，该方法只会调用一次
    -(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
    {
        //0.获得当前要下载文件的总大小（通过响应头得到）
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
        self.totalLength = res.expectedContentLength;
        NSLog(@"%zd",self.totalLength);

        //创建一个新的文件，用来当接收到服务器返回数据的时候往该文件中写入数据
        //1.获取文件管理者
        NSFileManager *manager = [NSFileManager defaultManager];

        //2.拼接文件的全路径
        //caches文件夹路径
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];

        NSString *fullPath = [caches stringByAppendingPathComponent:res.suggestedFilename];
        self.fullPath  = fullPath;
        //3.创建一个空的文件
        [manager createFileAtPath:fullPath contents:nil attributes:nil];

    }
    //当接收到服务器返回的数据时会调用
    //该方法可能会被调用多次
    -(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
    {

        //1.创建一个用来向文件中写数据的文件句柄
        //注意当下载完成之后，该文件句柄需要关闭，调用closeFile方法
        NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:self.fullPath];

        //2.设置写数据的位置(追加)
        [handle seekToEndOfFile];

        //3.写数据
        [handle writeData:data];

        //4.计算当前文件的下载进度
        self.currentLength += data.length;

        NSLog(@"%f",1.0* self.currentLength/self.totalLength);
        self.progressView.progress = 1.0* self.currentLength/self.totalLength;
    }
### 2、(断点下载)在下载文件的时候不再是整块的从头开始下载，而是看当前文件已经下载到哪个地方，然后从该地方接着往后面下载。可以通过在请求对象中设置请求头实现。（也是NSURLConnection-delegate）
#### 2.1、（设置请求头）

    [self.connect cancel]; //取消连接
    //2.创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    //2.1 设置下载文件的某一部分
    // 只要设置HTTP请求头的Range属性, 就可以实现从指定位置开始下载
    /*
     表示头500个字节：Range: bytes=0-499
     表示第二个500字节：Range: bytes=500-999
     表示最后500个字节：Range: bytes=-500
     表示500字节以后的范围：Range: bytes=500-
     */
    NSString *range = [NSString stringWithFormat:@"bytes=%zd-",self.currentLength];
    [request setValue:range forHTTPHeaderField:@"Range"];

#### 2.2、（下载进度并判断是否需要重新创建文件）
    //获得当前要下载文件的总大小（通过响应头得到）
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;

    //注意点：res.expectedContentLength获得是本次请求要下载的文件的大小（并非是完整的文件的大小）
    //因此：文件的总大小 == 本次要下载的文件大小+已经下载的文件的大小
    self.totalLength = response.expectedContentLength + self.currentLength;

    NSLog(@"----------------------------%zd",self.totalLength);

    //0 判断当前是否已经下载过，如果当前文件已经存在，那么直接返回
    if (self.currentLength >0) {
        return;
    }

## 输出流NSOutputStream：代替文件句柄NSFileHandle来写入文件
    //1.创建一个数据输出流
    /*
     第一个参数：二进制的流数据要写入到哪里
     第二个参数：采用什么样的方式写入流数据，如果YES则表示追加，如果是NO则表示覆盖
     */
    NSOutputStream *stream = [NSOutputStream outputStreamToFileAtPath:fullPath append:YES];

    //只要调用了该方法就会往文件中写数据
    //如果文件不存在，那么会自动的创建一个
    [stream open];
    self.stream = stream;

    //2.当接收到数据的时候写数据
    //使用输出流写数据
    /*
     第一个参数：要写入的二进制数据
     第二个参数：要写入的数据的大小
     */
    [self.stream write:data.bytes maxLength:data.length];

    //3.当文件下载完毕的时候关闭输出流
    //关闭输出流
    [self.stream close];
    self.stream = nil;

## 文件上传网络：
### 1、文件上传步骤：（原生拼接请求报文）
#### 1.1、确定请求路径，根据URL创建一个可变的请求对象。
#### 1.2、设置请求对象，修改请求方式为POST。
#### 1.3、设置请求头，告诉服务器我们将要上传文件（Content-Type）。
#### 1.4、设置请求体（在请求体中按照既定的格式拼接要上传的文件参数和非文件参数等数据）
    001 拼接文件参数
    002 拼接非文件参数
    003 添加结尾标记
    文件上传设置请求体的数据格式：

    //请求体拼接格式
    //分隔符：----WebKitFormBoundaryhBDKBUWBHnAgvz9c

    //01.文件参数拼接格式

     --分隔符
     Content-Disposition:参数
     Content-Type:参数
     空行
     文件参数

    //02.非文件拼接参数
     --分隔符
     Content-Disposition:参数
     空行
     非文件的二进制数据

    //03.结尾标识
    --分隔符--

#### 1.5、使用NSURLConnection sendAsync发送异步请求上传文件
#### 1.6、解析服务器返回的数据
    #define Kboundary @"----WebKitFormBoundaryjv0UfA04ED44AhWx"
    #define KNewLine [@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]
    -(void)upload
    {
        //1.确定请求路径
        NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/upload"];
        
        //2.创建可变的请求对象
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        //3.设置请求方法
        request.HTTPMethod = @"POST";
        
        //4.设置请求头信息
        //Content-Type:multipart/form-data; boundary=----WebKitFormBoundaryjv0UfA04ED44AhWx
        [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",Kboundary] forHTTPHeaderField:@"Content-Type"];
        
        //5.拼接请求体数据
        NSMutableData *fileData = [NSMutableData data];
        //5.1 文件参数
        /*
         --分隔符
         Content-Disposition: form-data; name="file"; filename="Snip20160225_341.png"
         Content-Type: image/png(MIMEType:大类型/小类型)
         空行
         文件参数
         */
        [fileData appendData:[[NSString stringWithFormat:@"--%@",Kboundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [fileData appendData:KNewLine];
        
        //name:file 服务器规定的参数
        //filename:Snip20160225_341.png 文件保存到服务器上面的名称
        //Content-Type:文件的类型
        [fileData appendData:[@"Content-Disposition: form-data; name=\"file\"; filename=\"Snip20160225_341.png\"" dataUsingEncoding:NSUTF8StringEncoding]];
        [fileData appendData:KNewLine];
        [fileData appendData:[@"Content-Type: image/png" dataUsingEncoding:NSUTF8StringEncoding]];
        [fileData appendData:KNewLine];
        [fileData appendData:KNewLine];
        
        UIImage *image = [UIImage imageNamed:@"Snip20160225_341"];
        //UIImage --->NSData
        NSData *imageData = UIImagePNGRepresentation(image);
        [fileData appendData:imageData];
        [fileData appendData:KNewLine];
        
        //5.2 非文件参数
        /*
         --分隔符
         Content-Disposition: form-data; name="username"
         空行
         123456
         */
        [fileData appendData:[[NSString stringWithFormat:@"--%@",Kboundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [fileData appendData:KNewLine];
        [fileData appendData:[@"Content-Disposition: form-data; name=\"username\"" dataUsingEncoding:NSUTF8StringEncoding]];
        [fileData appendData:KNewLine];
        [fileData appendData:KNewLine];
        [fileData appendData:[@"123456" dataUsingEncoding:NSUTF8StringEncoding]];
        [fileData appendData:KNewLine];
        
        //5.3 结尾标识
        /*
         --分隔符--
         */
        [fileData appendData:[[NSString stringWithFormat:@"--%@--",Kboundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //6.设置请求体
        request.HTTPBody = fileData;
        
        //7.发送请求
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
           
            //8.解析数据
            NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        }];
    }
   

### 2、如何获得你上传的文件的MIMEType类型
    //1.发送请求,可以响应头(内部有MIMEType)
    //2.百度
    //3.调用C语言的API
    //4.application/octet-stream 任意的二进制数据类型
#### 2.1、（1）直接对该对象发送一个异步网络请求，在响应头中通过response.MIMEType拿到文件的MIMEType类型。
    //如果想要及时拿到该数据，那么可以发送一个同步请求
    - (NSString *)getMIMEType
    {
        NSString *filePath = @"/Users/文顶顶/Desktop/备课/其它/swift.md";

        NSURLResponse *response = nil;
        [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]] returningResponse:&response error:nil];
        return response.MIMEType;
    }

    //对该文件发送一个异步请求，拿到文件的MIMEType
    - (void)MIMEType
    {

        //    NSString *file = @"file:///Users/文顶顶/Desktop/test.png";

        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:@"/Users/文顶顶/Desktop/test.png"]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * __nullable response, NSData * __nullable data, NSError * __nullable connectionError) {
            //       response.MIMEType
            NSLog(@"%@",response.MIMEType);

        }];
    }
#### 2.2、（2）通过UTTypeCopyPreferredTagWithClass方法。需要依赖于框架MobileCoreServices
    //注意：需要依赖于框架MobileCoreServices
    - (NSString *)mimeTypeForFileAtPath:(NSString *)path
    {
        if (![[[NSFileManager alloc] init] fileExistsAtPath:path]) {
            return nil;
        }

        CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[path pathExtension], NULL);
        CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
        CFRelease(UTI);
        if (!MIMEType) {
            return @"application/octet-stream";
        }
        return (__bridge NSString *)(MIMEType);
    }


---------------
day06:
--------------------
## 使用多线程下载文件思路:
### 01 开启多条线程，每条线程都只下载文件的一部分（通过设置请求头中的Range来实现）
### 02 创建一个和需要下载文件大小一致的文件，判断当前是那个线程，根据当前的线程来判断下载的数据应该写入到文件中的哪个位置。
    （假设开5条线程来下载10M的文件，那么线程1下载0-2M，线程2下载2-4M一次类推，当接收到服务器返回的数据之后应该先判断当前线程是哪个线程， 假如当前线程是线程2，那么在写数据的时候就从文件的2M位置开始写入）
### 03 代码相关：使用NSFileHandle这个类的seekToFileOfSet方法，来向文件中特定的位置写入数据。
### 04 技术相关：a.每个线程通过设置请求头下载文件中的某一个部分。b.通过NSFileHandle向文件中的指定位置写数据
    
## ◆ 常规导入第三方框架的步骤：（不用cocoapod）
### 1、先去github下载第三方框架压缩包，然后解压，然后选择你要的文件夹，拖到xcode的工程目录里面去。
### 2、编译肯定会缺少库，然后去Xcode --> TARGET --> Build Phases ->link binary with libraries --> 点击+号，添加你需要的库（一般是系统的库）
### 3、压缩解压缩第三方框架ZipArchive的使用：
    //压缩文件：
    SArray *arrayM = @[
                        @"/Users/xiaomage/Desktop/Snip20160226_2.png",
                        @"/Users/xiaomage/Desktop/Snip20160226_6.png"
                        ];
    /*
     第一个参数:压缩文件的存放位置
     第二个参数:要压缩哪些文件(路径)
     */
    //[SSZipArchive createZipFileAtPath:@"/Users/xiaomage/Desktop/Test.zip" withFilesAtPaths:arrayM];
    [SSZipArchive createZipFileAtPath:@"/Users/xiaomage/Desktop/Test.zip" withFilesAtPaths:arrayM withPassword:@"123456"];
    
    //解压缩文件：
    /*
     第一个参数:要解压的文件在哪里
     第二个参数:文件应该解压到什么地方
     */
    //[SSZipArchive unzipFileAtPath:@"/Users/xiaomage/Desktop/demo.zip" toDestination:@"/Users/xiaomage/Desktop/xx"];
    
    [SSZipArchive unzipFileAtPath:@"/Users/xiaomage/Desktop/demo.zip" toDestination:@"/Users/xiaomage/Desktop/xx" progressHandler:^(NSString *entry, unz_file_info zipInfo, long entryNumber, long total) {
        NSLog(@"%zd---%zd",entryNumber,total);
        
    } completionHandler:^(NSString *path, BOOL succeeded, NSError *error) {
        
        NSLog(@"%@",path);
    }];


## ❶ NSURLConnection和Runloop设置在哪个线程执行代理方法的问题：
### 1、两种为NSURLConnection设置代理方式的区别
#### 1.1、通过NSURLConnection的 initWithRequest: delegate:方法设置代理，会自动的发送请求
    // [[NSURLConnection alloc]initWithRequest:request delegate:self];

#### 1.2、通过NSURLConnection的 initWithRequest: delegate: startImmediately:方法设置代理，startImmediately为NO的时候，该方法不会自动发送请求，要调用start方法发送。
    NSURLConnection *connect = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:NO];
    //手动通过代码的方式来发送请求
    //注意该方法内部会自动的把connect添加到当前线程的RunLoop中在默认模式下执行
    [connect start];
    
### 2、设置代理方法在哪个线程中执行：（默认情况下，代理方法会在主线程中进行调用，所以不能显式设置主队列）
#### 2.1、通过NSURLConnection的setDelegateQueue设置 执行代理方法 的线程。
    //说明：默认情况下，代理方法会在主线程中进行调用（为了方便开发者拿到数据后处理一些刷新UI的操作不需要考虑到线程间通信）
    //设置代理方法的执行队列
    [connect setDelegateQueue:[[NSOperationQueue alloc]init]];

### 3、开子线程发送网络请求的注意点，适用于自动发送网络请求模式
#### 3.1、在子线程中发送网络请求 initWithRequest，调用start方法发送，没有明确指定的话，默认会为当前线程创建一个runloop，connect对象作为一个source，并启动该runloop。
    //在子线程中发送网络请求-调用start方法发送
    -(void)createNewThreadSendConnect1
    {
        //1.创建一个非主队列
        NSOperationQueue *queue = [[NSOperationQueue alloc]init];

        //2.封装操作，并把任务添加到队列中执行
        [queue addOperationWithBlock:^{

            NSLog(@"%@",[NSThread currentThread]);
            //2-1.确定请求路径
            NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login?username=dd&pwd=ww&type=JSON"];

            //2-2.创建请求对象
            NSURLRequest *request = [NSURLRequest requestWithURL:url];

            //2-3.使用NSURLConnection设置代理，发送网络请求
            NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];

            //2-4.设置代理方法在哪个队列中执行，如果是非主队列，那么代理方法将再子线程中执行
            [connection setDelegateQueue:[[NSOperationQueue alloc]init]];

            //2-5.发送网络请求
            //注意：start方法内部会把当前的connect对象作为一个source添加到当前线程对应的runloop中。
            //区别在于，如果调用start方法开发送网络请求，那么再添加source的过程中，如果当前runloop不存在。
            //那么该方法内部会自动创建一个当前线程对应的runloop,并启动。
            [connection start];

        }];
    }

#### 3.2、 在子线程中发送网络请求-自动放在runloop中被发送网络请求，[NSURLConnection connectionWithRequest: delegate:]方法。 需要手动为子线程创建runloop，请求作为runloop的soruce源被执行。
    -(void)createNewThreadSendConnect2
    {
        NSLog(@"-----");
        //1.创建一个非主队列
        NSOperationQueue *queue = [[NSOperationQueue alloc]init];

        //2.封装操作，并把任务添加到队列中执行
        [queue addOperationWithBlock:^{

            //2-1.确定请求路径
            NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login?username=dd&pwd=ww&type=JSON"];

            //2-2.创建请求对象
            NSURLRequest *request = [NSURLRequest requestWithURL:url];

            //2-3.使用NSURLConnection设置代理，发送网络请求
            //注意：该方法内部虽然会把connection添加到runloop,但是如果当前的runloop不存在，那么不会主动创建。runloop指定运行模式为默认.runloop会执行完所有代理方法后，connection对象才会被释放。
            NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];

            //2-4.设置代理方法在哪个队列中执行，如果是非主队列，那么代理方法将在子线程中执行
            [connection setDelegateQueue:[[NSOperationQueue alloc]init]];

            //2-5 创建当前线程对应的runloop,并开启
           [[NSRunLoop currentRunLoop]run];
        }];
    }


## ❷ 使用NSURLSession处理网络请求
### 1、NSURLSession的基本使用：
#### 1.1、使用NSURLSession的实例方法创建task，创建时传入NSURLRequest参数，然后执行task。
#### 1.2、NSURLSession发送get请求网络：
##### 1.2.1、a、dataTaskWithRequest方法，
##### 1.2.2、b、dataTaskWithURL方法内部会自动的将请求路径作为参数创建一个请求对象(GET)。
    -(void)get
    {
        //1.确定URL
        NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login?username=520it&pwd=520it&type=JSON"];
        
        //2.创建请求对象
        NSURLRequest *request =[NSURLRequest requestWithURL:url];
        
        //3.创建会话对象
        NSURLSession *session = [NSURLSession sharedSession];
        
        //4.0、dataTaskWithRequest 创建Task
        /*
         第一个参数:请求对象
         第二个参数:completionHandler 当请求完成之后调用
            data:响应体信息
            response:响应头信息
            error:错误信息当请求失败的时候 error有值
         */
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            //6.解析数据
            NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        }];
        
        //4.1、dataTaskWithURL 创建Task
        /*
         第一个参数:请求路径
         第二个参数:completionHandler 当请求完成之后调用
         data:响应体信息
         response:响应头信息
         error:错误信息当请求失败的时候 error有值
         注意:dataTaskWithURL 内部会自动的将请求路径作为参数创建一个请求对象(GET)
         */
         /*
         NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
             
             //6.解析数据
             NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
         }];
         */
        
        
        //5.执行Task
        [dataTask resume];
    }
#### 1.3、NSURLSession发送POST请求网络(在request中设置post)：dataTaskWithRequest方法，◆ 请求完成后的闭包会在子线程中调用。
    -(void)post
    {
        //1.确定URL
        NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login"];
        
        //2.创建请求对象
        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
        
        //2.1 设置请求方法为post
        request.HTTPMethod = @"POST";
        
        //2.2 设置请求体
        request.HTTPBody = [@"username=520it&pwd=520it&type=JSON" dataUsingEncoding:NSUTF8StringEncoding];
        
        //3.创建会话对象
        NSURLSession *session = [NSURLSession sharedSession];
        
        //4.创建Task
        /*
         第一个参数:请求对象
         第二个参数:completionHandler 当请求完成之后调用 !!! 在子线程中调用
         data:响应体信息
         response:响应头信息
         error:错误信息当请求失败的时候 error有值
         */
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            NSLog(@"%@",[NSThread currentThread]);
            //6.解析数据
            NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        }];
        
        //5.执行Task
        [dataTask resume];
    }
    
#### 1.4、通过类方法sessionWithConfiguration获得NSURLSession对象，并在参数中设置代理对象，并设置代理方法在哪个子线程中执行。
    //3.创建会话对象,设置代理
    /*
     第一个参数:配置信息 [NSURLSessionConfiguration defaultSessionConfiguration]
     第二个参数:代理
     第三个参数:设置代理方法在哪个线程中调用
     */
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]
#### 1.5、★ NSURLSession网络会话对象必须释放，不然会有内存泄漏问题[self.session invalidateAndCancel]，因为是保留了强引用。
    -(void)dealloc
    {
        //清理工作
        //finishTasksAndInvalidate
        [self.session invalidateAndCancel];
    }

### 2、NSURLSession的代理 NSURLSessionDataDelegate 的方法：
#### 2.1、★ - (void)URLSession:(NSURLSession *)session dataTask:didReceiveResponse: completionHandler: 方法，接收到服务器的响应被自动调用，一次请求只响应一次， 它默认会取消该请求，所以你要在completionHandler的闭包中，让系统不要取消。
    /**
     *  1.接收到服务器的响应，它默认会取消该请求，然后就不会继续接受服务器的数据，所以你要禁止它取消请求。
     *
     *  @param session           会话对象
     *  @param dataTask          请求任务
     *  @param response          响应头信息
     *  @param completionHandler 回调 要求我们传给系统的闭包
     */
    -(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
    {
        NSLog(@"%s",__func__);
        
        /*
         NSURLSessionResponseCancel = 0,取消 默认
         NSURLSessionResponseAllow = 1, 接收
         NSURLSessionResponseBecomeDownload = 2, 变成下载任务
         NSURLSessionResponseBecomeStream        变成流
         */
        completionHandler(NSURLSessionResponseAllow);
    }

#### 2.2、-(void)URLSession:dataTask:didReceiveData: 方法，接收到服务器返回的数据时，会被系统调用多次。
    /**
     *  接收到服务器返回的数据 调用多次
     *
     *  @param session           会话对象
     *  @param dataTask          请求任务
     *  @param data              本次下载的数据
     */
    -(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
    {
         NSLog(@"%s",__func__);
        
        //拼接数据
        [self.fileData appendData:data];
    }
#### 2.3、 -(void)URLSession: task: didCompleteWithError:方法，请求结束或者是失败的时候被自动调用。
    /**
     *  请求结束或者是失败的时候调用
     *
     *  @param session           会话对象
     *  @param dataTask          请求任务
     *  @param error             错误信息
     */
    -(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
    {
         NSLog(@"%s",__func__);
        
        //解析数据
        NSLog(@"%@",[[NSString alloc]initWithData:self.fileData encoding:NSUTF8StringEncoding]);
    }

### 3、使用URLSession下载文件：
#### 3.1、使用实例方法downloadTaskWithRequest来创建任务，完成闭包都是在子线程中执行。该方法内部已经实现了边接受数据边写沙盒(tmp)的操作。 
##### 3.1.2、因为是在tmp目录下，所以会立马被删除，所以在完成闭包completionHandler中操作下载了的文件。（所以只适合下载小文件，因为监听不了下载进度）
    //4.创建Task
    /*
     第一个参数:请求对象
     第二个参数:completionHandler 回调
        location:
        response:响应头信息
        error:错误信息
     */
    //该方法内部已经实现了边接受数据边写沙盒(tmp)的操作
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //6.处理数据
        NSLog(@"%@---%@",location,[NSThread currentThread]);
        
        //6.1 拼接文件全路径
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        
        //6.2 剪切文件
        [[NSFileManager defaultManager]moveItemAtURL:location toURL:[NSURL fileURLWithPath:fullPath] error:nil];
        NSLog(@"%@",fullPath);
    }];
    
    //5.执行Task
    [downloadTask resume];
#### 3.2、使用代理对象 NSURLSessionDownloadDelegate 监听下载进度，创建NSURLSession时，参数传入代理对象。
    //1.url
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/resources/images/minion_03.png"];
    
    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.创建session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    //4.创建Task
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request];
    
    //5.执行Task
    [downloadTask resume];
##### 3.2.1、代理方法-(void)URLSession: downloadTask:  didWriteData:  totalBytesWritten:  totalBytesExpectedToWrite: ，正在下载数据时，自动调用的方法 。 
    #pragma mark NSURLSessionDownloadDelegate
    /**
     *  正在下载数据时，调用的方法，写数据
     *
     *  @param session                   会话对象
     *  @param downloadTask              下载任务
     *  @param bytesWritten              本次写入的数据大小
     *  @param totalBytesWritten         下载的数据总大小
     *  @param totalBytesExpectedToWrite  文件的总大小
     */
    -(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
    {
        //1. 获得文件的下载进度
        NSLog(@"%f",1.0 * totalBytesWritten/totalBytesExpectedToWrite);
    }
##### 3.2.2、代理方法-(void)URLSession:  downloadTask: didResumeAtOffset:  expectedTotalBytes: ，当恢复下载的时候自动调用该方法。
    /**
     *  当恢复下载的时候调用该方法
     *
     *  @param fileOffset         从什么地方下载
     *  @param expectedTotalBytes 文件的总大小
     */

    -(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
    {
        NSLog(@"%s",__func__);
    }
 ##### 3.2.3、代理方法 -(void)URLSession: downloadTask: didFinishDownloadingToURL: ，当下载完成的时候自动调用该方法。
    /**
     *  当下载完成的时候调用
     *
     *  @param location     文件的临时存储路径
     */
    -(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
    {
        NSLog(@"%@",location);
        
        //1 拼接文件全路径
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
        
        //2 剪切文件
        [[NSFileManager defaultManager]moveItemAtURL:location toURL:[NSURL fileURLWithPath:fullPath] error:nil];
        NSLog(@"%@",fullPath);
    }
##### 3.2.4、代理方法 -(void)URLSession: task: didCompleteWithError: ，当请求结束时自动调用该方法。
    /**
     *  请求结束
     */
    -(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
    {
        NSLog(@"didCompleteWithError");
    }

#### 3.3、URLSession断点下载，控制的是任务NSURLSessionDownloadTask，而不是会话。
##### 3.3.1、[self.downloadTask suspend];暂停是可以恢复的。
    [self.downloadTask resume];
##### 3.3.2、[self.downloadTask cancel];取消是不可以回复的，会调用代理的请求结束方法，整个任务（甚至请求）都结束了。
##### 3.3.3、- (void)cancelByProducingResumeData:，这个方法的取消是可以恢复的，可以通过该方法的参数闭包 返回的信息对下载的数据进行恢复。
    //恢复下载的数据!=文件数据，resumeData而是记录了下载了的数据信息，位移，大小等，而不是下载的数据本身。
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        self.resumData = resumeData;
    }];
##### 3.3.4、局限性：kill掉App，代码复杂度高，kill掉时未保存已下载数据的话，不可以恢复。
    01 如果用户点击暂停之后退出程序，那么需要把恢复下载的数据写一份到沙盒，代码复杂度很高。
    02 如果用户在下载中途未保存恢复下载数据即退出程序，则不具备可操作性。

#### 3.4、使用NSURLSessionDataTask任务，实现大文件离线断点下载（完整）
##### 3.4.1、一样要设置代理，也还是通过URLSession进行维护任务，在代理方法中获取文件大小，下载进度等等这些信息，关键在与写入沙盒，查询沙盒中已下载文件的大小。
##### 3.4.2、(1)创建NSURLSessionDataTask时，获取已下载的文件大小，作为参数发起任务请求。
    //熟悉使用懒加载，就是if (_dataTask == nil)这种获取_dataTask的形式，一步一步地去获取自己需要的对象，即成员变量。
    if (_dataTask == nil) {
        //1.url
        NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/resources/videos/minion_01.mp4"];
        
        //2.创建请求对象
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        //3 设置请求头信息,告诉服务器请求那一部分数据
        NSDictionary *fileInfoDict = [[NSFileManager defaultManager]attributesOfItemAtPath:self.fullPath error:nil];
        self.currentSize  = [fileInfoDict[@"NSFileSize"] integerValue];     //获得指定文件路径对应文件的数据大小
        NSString *range = [NSString stringWithFormat:@"bytes=%zd-",self.currentSize];
        [request setValue:range forHTTPHeaderField:@"Range"];
        
        //4.创建Task
        _dataTask = [self.session dataTaskWithRequest:request];
    }
##### 3.4.3、(2)在网络第一次响应请求的代理方法 didReceiveResponse 中，使用NSFileHandle创建文件来存放下载的数据（文件）。
###### 3.4.3、(2.1)因为每一次发起网络请求都会有一次响应，所以关键是在这里移动下载文件的指针到末尾。
    -(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
    {
        //获得文件的总大小
        //expectedContentLength 本次请求的数据大小
        self.totalSize = response.expectedContentLength + self.currentSize;
        
        if (self.currentSize == 0) {
            //创建空的文件
            [[NSFileManager defaultManager]createFileAtPath:self.fullPath contents:nil attributes:nil];
            
        }
        //创建文件句柄
        self.handle = [NSFileHandle fileHandleForWritingAtPath:self.fullPath];
        
        //移动指针
        [self.handle seekToEndOfFile];
        
        completionHandler(NSURLSessionResponseAllow);//不取消网络请求，继续接收网络数据
    }

##### 3.4.4、(3)在下载过程中的代理方法 didReceiveData 中，通过成员变量NSFileHandle追加写入数据到指定文件。
    -(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
    {
        
        //写入数据到文件，在第一次响应里就把成员变量NSFileHandle移动到文件末尾，会比在这里移动指针要好很多。
        [self.handle writeData:data];
        
        //计算文件的下载进度
        self.currentSize += data.length;
        NSLog(@"%f",1.0 * self.currentSize / self.totalSize);
        
        self.proessView.progress = 1.0 * self.currentSize / self.totalSize;
    }
      
##### 3.4.5、(4)在请求结束或者是失败的时候，在代理方法didCompleteWithError 中关闭文件句柄 NSFileHandle，做清理操作。
    -(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
    {
        //关闭文件句柄
        [self.handle closeFile];
        self.handle = nil;
    }
    
 ##### 3.4.6、(6) 在析构函数中关闭网络会话，释放网络会话对象[self.session invalidateAndCancel];。
    -(void)dealloc
    {
        //清理工作
        //finishTasksAndInvalidate
        [self.session invalidateAndCancel];
    }

### 4、使用URLSession上传文件：
### (也是在拼接request，按照http协议，但是是作为参数放在api的方法里)
#### 4.1、与NSURLConnection上传文件的步骤类似，也是在request中拼接http协议，然后通过URLSession发送网络上传请求。
    //拼接http协议的报文段，与NSURLConnection拼接步骤类似
    #define Kboundary @"----WebKitFormBoundaryjv0UfA04ED44AhWx" //是拼接报文段的分隔符，并不严格规定，不要是中文字符和特殊字符就可以了，但是拼接时的分隔符必须是一致的。
    -(NSData *)getBodyData
    {
        NSMutableData *fileData = [NSMutableData data];
        //5.1 文件参数
        /*
         --分隔符
         Content-Disposition: form-data; name="file"; filename="Snip20160225_341.png"
         Content-Type: image/png(MIMEType:大类型/小类型)
         空行
         文件参数
         */
        [fileData appendData:[[NSString stringWithFormat:@"--%@",Kboundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [fileData appendData:KNewLine];
        
        //name:file 服务器规定的参数
        //filename:Snip20160225_341.png 文件保存到服务器上面的名称
        //Content-Type:文件的类型
        [fileData appendData:[@"Content-Disposition: form-data; name=\"file\"; filename=\"Sss.png\"" dataUsingEncoding:NSUTF8StringEncoding]];
        [fileData appendData:KNewLine];
        [fileData appendData:[@"Content-Type: image/png" dataUsingEncoding:NSUTF8StringEncoding]];
        [fileData appendData:KNewLine];
        [fileData appendData:KNewLine];
        
        UIImage *image = [UIImage imageNamed:@"Snip20160226_90"];
        //UIImage --->NSData
        NSData *imageData = UIImagePNGRepresentation(image);
        [fileData appendData:imageData];
        [fileData appendData:KNewLine];
        
        //5.2 非文件参数
        /*
         --分隔符
         Content-Disposition: form-data; name="username"
         空行
         123456
         */
        [fileData appendData:[[NSString stringWithFormat:@"--%@",Kboundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [fileData appendData:KNewLine];
        [fileData appendData:[@"Content-Disposition: form-data; name=\"username\"" dataUsingEncoding:NSUTF8StringEncoding]];
        [fileData appendData:KNewLine];
        [fileData appendData:KNewLine];
        [fileData appendData:[@"123456" dataUsingEncoding:NSUTF8StringEncoding]];
        [fileData appendData:KNewLine];
        
        //5.3 结尾标识
        /*
         --分隔符--
         */
        [fileData appendData:[[NSString stringWithFormat:@"--%@--",Kboundary] dataUsingEncoding:NSUTF8StringEncoding]];
        return fileData;
    }
#### 4.2、关键在于设置request的报文字段。但是上传的文件不是放在request的 请求体request.HTTPBody 里面，而是放在 发送请求的调用方法uploadTaskWithRequest 的参数里面。
    -(void)upload2
    {
        //1.url
        NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/upload"];
        
        //2.创建请求对象
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        //2.1 设置请求方法
        request.HTTPMethod = @"POST";
        
        //2.2 设请求头信息
        [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",Kboundary] forHTTPHeaderField:@"Content-Type"];
        
        //3.创建会话对象，提取代码出来了，是self.session的懒加载中获得session对象。
        
        //4.创建上传TASK
        /*
         第一个参数:请求对象
         第二个参数:传递是要上传的数据(请求体)
         */
        NSURLSessionUploadTask *uploadTask = [self.session uploadTaskWithRequest:request fromData:[self getBodyData] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            //6.解析
            NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        }];
        
        //5.执行Task
        [uploadTask resume];
    }
#### 4.3、可以设置URLSession的代理对象，监听上传进度。遵循NSURLSessionDataDelegate代理协议。使用NSURLSessionConfiguration配置URLSession对象。
    -(NSURLSession *)session
    {
        if (_session == nil) {
            NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
            
            //是否运行蜂窝访问
            config.allowsCellularAccess = YES;
            config.timeoutIntervalForRequest = 15;
            
            _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]]; //设置了代理对象。
        }
        return _session;
    }
#### 4.4、NSURLSessionConfiguration的属性用于配置NSURLSession对象，什么超时啊，WIFI啊，蜂窝之类的配置。
    NSURLSessionConfiguration对象用于初始化NSURLSession对象。
    展开请求级别中与NSMutableURLRequest相关的可供选择的方案，我们可以看到NSURLSessionConfiguration对于会话如何产生请求，提供了相当多的控制和灵活性。从网络访问性能，到cookie，安全性，缓存策略，自定义协议，启动事件设置，以及用于移动设备优化的几个新属性，你会发现你一直在寻找的，正是NSURLSessionConfiguration。
    会话在初始化时复制它们的配置，NSURLSession有一个只读的配置属性，使得该配置对象上的变化对这个会话的政策无效。配置在初始化时被读取一次，之后都是不会变化的。

    －构造方法
    NSURLSessionConfiguration有三个类构造函数，这很好地说明了NSURLSession是为不同的用例而设计的。
    + "defaultSessionConfiguration"返回标准配置，这实际上与NSURLConnection的网络协议栈是一样的，具有相同的共享NSHTTPCookieStorage，共享NSURLCache和共享NSURLCredentialStorage。
    + "ephemeralSessionConfiguration"返回一个预设配置，没有持久性存储的缓存，Cookie或证书。这对于实现像"秘密浏览"功能的功能来说，是很理想的。
    + "backgroundSessionConfiguration"：独特之处在于，它会创建一个后台会话。后台会话不同于常规的，普通的会话，它甚至可以在应用程序挂起，退出，崩溃的情况下运行上传和下载任务。初始化时指定的标识符， 被用于向任何可能在进程外恢复后台传输的守护进程提供上下文。

    想要查看更多关于后台会话的信息，可以查看WWDC Session 204: “What’s New with Multitasking”

    －NSURLSessionConfiguration的属性
    NSURLSessionConfiguration拥有20个属性。熟练掌握这些属性的用处，将使应用程序充分利用其网络环境。

    最重要的属性：
    # 替代 request 中的 forHTTPHeaderField 告诉服务器有关客户端的附加信息
    "HTTPAdditionalHeaders"指定了一组默认的可以设置出站请求的数据头。这对于跨会话共享信息，如内容类型，语言，用户代理，身份认证，是很有用的。

    # WebDav的身份验证
    NSString *userPasswordString = [NSString stringWithFormat:@"%@:%@", user, password];
    NSData * userPasswordData = [userPasswordString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64EncodedCredential = [userPasswordData base64EncodedStringWithOptions:0];
    NSString *authString = [NSString stringWithFormat:@"Basic: %@", base64EncodedCredential];

    # 设置客户端类型
    NSString *userAgentString = @"iPhone AppleWebKit";

    configuration.HTTPAdditionalHeaders = @{@"Accept": @"application/json",
                                            @"Accept-Language": @"en",
                                            @"Authorization": authString,
                                            @"User-Agent": userAgentString};

    "networkServiceType（网络服务类型）"对标准的网络流量，网络电话，语音，视频，以及由一个后台进程使用的流量进行了区分。大多数应用程序都不需要设置这个

    "allowsCellularAccess（允许蜂窝访问）"和"discretionary（自行决定）"被用于节省通过蜂窝连接的带宽。建议在使用后台传输的时候，使用discretionary属性，而不是allowsCellularAccess属性，因为它会把WiFi和电源可用性考虑在内

    "timeoutIntervalForRequest"和"timeoutIntervalForResource"指定了请求以及该资源的超时时间间隔。许多开发人员试图使用timeoutInterval去限制发送请求的总时间，但这误会了timeoutInterval的意思：报文之间的时间。timeoutIntervalForResource实际上提供了整体超时的特性，这应该只用于后台传输，而不是用户实际上可能想要等待的任何东西

    "HTTPMaximumConnectionsPerHost"是 Foundation 框架中URL加载系统的一个新的配置选项。它曾经被用于NSURLConnection管理私人连接池。现在有了NSURLSession，开发者可以在需要时限制连接到特定主机的数量

    "HTTPShouldUsePipelining"也出现在NSMutableURLRequest，它可以被用于开启HTTP管道，这可以显着降低请求的加载时间，但是由于没有被服务器广泛支持，默认是禁用的

    "sessionSendsLaunchEvents" 是另一个新的属性，该属性指定该会话是否应该从后台启动

    "connectionProxyDictionary"指定了会话连接中的代理服务器。同样地，大多数面向消费者的应用程序都不需要代理，所以基本上不需要配置这个属性
    关于连接代理的更多信息可以在 CFProxySupport Reference 找到。

    "Cookie Policies"
    －"HTTPCookieStorage" 是被会话使用的cookie存储。默认情况下，NSHTTPCookieShorage的 + sharedHTTPCookieStorage会被使用，这与NSURLConnection是相同的
    －"HTTPCookieAcceptPolicy" 决定了该会话应该接受从服务器发出的cookie的条件
    －"HTTPShouldSetCookies" 指定了请求是否应该使用会话HTTPCookieStorage的cookie

    "Security Policies"
    　　URLCredentialStorage 是会话使用的证书存储。默认情况下，NSURLCredentialStorage 的+ sharedCredentialStorage 会被使用使用，这与NSURLConnection是相同的

    "TLSMaximumSupportedProtocol" 和 "TLSMinimumSupportedProtocol" 确定是否支持SSLProtocol版本的会话

    "Caching Policies"
    URLCache 是会话使用的缓存。默认情况下，NSURLCache 的 + sharedURLCache 会被使用，这与NSURLConnection是相同的
    requestCachePolicy 指定了一个请求的缓存响应应该在什么时候返回。这相当于NSURLRequest 的-cachePolicy方法

    "Custom Protocols"
    protocolClasses是注册NSURLProtocol类的特定会话数组

## UIWebView的基本使用(已抛弃): 
### 1、UIWebView已经被抛弃，有内存泄漏问题，已经禁止上架App更新了，现在使用WKWebView了。
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    //加载网页
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);   //其实是添加网页在scrollview上
    
    //加载本地的文件，例如加载工程目录中的视频、ppt到网页上去，通过网页演示。
    NSURL *url = [NSURL fileURLWithPath:@"/Users/xiaomage/Desktop/07-NSURLSession.pptx"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    //设置网页大小在手机上自适应，缩放
    NSURL *url = [NSURL URLWithString:@"http://www.520it.com/"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    self.webView.scalesPageToFit = YES;
    
    //加载html文件
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"text.html" withExtension:nil];
    
    //加载网页
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    //设置数据识别，识别电话号码、网址之类的。
    self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
    
    #pragma mark UIWebViewDelegate

    //即将加载某个请求的时候调用
    -(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
    {
        NSLog(@"%@",request.URL.absoluteString);
        //简单的请求拦截处理
        NSString *strM = request.URL.absoluteString;
        if ([strM containsString:@"360"]) {
            return NO;
        }
        return YES;
    }

    //1.开始加载网页的时候调用
    -(void)webViewDidStartLoad:(UIWebView *)webView
    {
        NSLog(@"webViewDidStartLoad");
    }

    //2.加载完成的时候调用
    -(void)webViewDidFinishLoad:(UIWebView *)webView
    {
        NSLog(@"webViewDidFinishLoad");
        
        self.goBack.enabled = self.webView.canGoBack;
        self.goForward.enabled = self.webView.canGoForward;
    }

    //3.加载失败的时候调用
    -(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
    {
        NSLog(@"didFailLoadWithError");
    }
    

---------------
day07:
--------------------
## 如何学习第三方框架：
### 1、首先下载框架，可以使用git下载建立一个分支。
### 2、查看框架的简介，看简介中的Architecture章节，可以了解框架的基本架构，使用到的类，在github上面是可以向框架作者提问的，注意要问一些有质量的问题。
### 3、运行示例程序。
### 4、编写属于自己的demo,在使用一个第三方框架之前先不要直接用到项目中，应该先在demo中应用查看是否合适。
### 5、学习大牛的变成思想，理解框架的原理。

## AFNetworking的基本使用(OC语言)：
### 1、查看OC_Test_App里面的笔记，swift中对应的框架是Alamofire。

## 网络中的数据安全：
### 01、攻城利器：Charles（公司中一般都使用该工具来抓包，并做网络测试），青花瓷工具软件，收费很贵，连接上手机，抓取手机上的网络请求。
    注意：Charles在使用中的乱码问题，可以显示包内容，然后打开info.plist文件，找到java目录下面的VMOptions，在后面添加一项：-Dfile.encoding=UTF-8
    是利用Charles作为手机的HTTP代理，然后手机连接上了wifi之后，所有经过HTTP代理的网络请求，都会被Charles抓取，这就是网络代理啊。
 ### 02、MD5消息摘要算法是不可逆的。
 ### 03、数据加密的方式和规范一般公司会有具体的规定，不必多花时间。

## 网络中加密的相关知识：
### 1、加密原则：不用明文
    1. 在网络上"不允许"传输用户隐私数据的"明文"
    2. 在本地"不允许"保存用户隐私数据的"明文"
### 2、加密的基础：base64 编码格式。（类比UTF-8）
    1.Base64简单说明
        描述：Base64可以成为密码学的基石，非常重要。
        特点：可以将任意的二进制数据进行Base64编码
        结果：所有的数据都能被编码为并且只用65个字符就能表示的文本文件。
        65字符：A~Z a~z 0~9 + / =
        对文件进行base64编码后文件数据的变化：编码后的数据~=编码前数据的4/3，会大1/3左右。

    2.命令行进行Base64编码和解码
        编码：base64 123.png -o 123.txt
        解码：base64 123.txt -o test.png -D

    2.Base64编码原理
        1)将所有字符转化为ASCII码；
        2)将ASCII码转化为8位二进制；
        3)将二进制3个归成一组(不足3个在后边补0)共24位，再拆分成4组，每组6位；
        4)统一在6位二进制前补两个0凑足8位；
        5)将补0后的二进制转为十进制；
        6)从Base64编码表获取十进制对应的Base64编码；

    处理过程说明：
        a.转换的时候，将三个byte的数据，先后放入一个24bit的缓冲区中，先来的byte占高位。
        b.数据不足3byte的话，于缓冲区中剩下的bit用0补足。然后，每次取出6个bit，按照其值选择查表选择对应的字符作为编码后的输出。
        c.不断进行，直到全部输入数据转换完成。
        d.如果最后剩下两个输入数据，在编码结果后加1个“=”；
        e.如果最后剩下一个输入数据，编码结果后加2个“=”；
        f.如果没有剩下任何数据，就什么都不要加，这样才可以保证资料还原的正确性。

    3.实现
        a.说明：
            1）从iOS7.0 开始，苹果就提供了base64的编码和解码支持
            2)如果是老项目，则还能看到base64编码和解码的第三方框架，如果当前不再支持iOS7.0以下版本，则建议替换。

        b.相关代码：
        //给定一个字符串，对该字符串进行Base64编码，然后返回编码后的结果
        -(NSString *)base64EncodeString:(NSString *)string
        {
            //1.先把字符串转换为二进制数据
            NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];

            //2.对二进制数据进行base64编码，返回编码后的字符串
            return [data base64EncodedStringWithOptions:0];
        }

        //对base64编码后的字符串进行解码
        -(NSString *)base64DecodeString:(NSString *)string
        {
            //1.将base64编码后的字符串『解码』为二进制数据
            NSData *data = [[NSData alloc]initWithBase64EncodedString:string options:0];

            //2.把二进制数据转换为字符串返回
            return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        }

        c.终端测试命令
            $ echo -n A | base64
            $ echo -n QQ== |base64 -D
### 3、由密码学演化来的RSA加密方式，公密钥加密。
    //密码学演化 "秘密本"-->RSA
    RSA简单说明：加密算法算法是公开的，加密方式如下：

    - "公钥"加密，"私钥"解密
    - "私钥"加密，"公钥"解密

    目前流行的加密方式:
    ---------------
    - 哈希(散列)函数
        - MD5
        - SHA1
        - SHA256

    - 对称加密算法，可以百度相关的算法，有些foundation类里面直接就有。
        - DES
        - 3DES
        - AES(高级密码标准，美国国家安全局使用的)

    - 非对称加密算法(RSA)

    散列函数:
    ---------------
    特点：
        - 算法是公开的
        - "对相同的数据加密，得到的结果是一样的"
        - 对不同的数据加密，得到的结果是定长的，MD5对不同的数据进行加密，得到的结果都是 32 个字符长度的字符串
        - 信息摘要，信息"指纹"，是用来做数据识别的！
        - 不能反算的

    用途：
        - 密码，服务器并不需要知道用户真实的密码！
        - 搜索
            张老师 杨老师 苍老师
            苍老师 张老师 杨老师

            张老师            1bdf605991920db11cbdf8508204c4eb
            杨老师             2d97fbce49977313c2aae15ea77fec0f
            苍老师             692e92669c0ca340eff4fdcef32896ee

            如何判断：对搜索的每个关键字进行三列，得到三个相对应的结果，按位相加结果如果是一样的，那搜索的内容就是一样的！
        - 版权
            版权保护，文件的识别。

    破解：
        - http://www.cmd5.com 记录超过24万亿条，共占用160T硬盘 的密码数据，通过对海量数据的搜索得到的结果！

    提升MD5加密安全性，有两个解决办法
    1. 加"盐"(佐料)
    2. HMAC：给定一个"秘钥"，对明文进行加密，并且做"两次散列"！-> 得到的结果，还是 32 个字符
### 4、苹果原生框架提供的base64编解码api，一般foundation的类都有这个方法：
    //对一个字符串进行base64编码,并且返回
    -(NSString *)base64EncodeString:(NSString *)string
    {
        //1.先转换为二进制数据
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
        
        //2.对二进制数据进行base64编码,完成之后返回字符串
        return [data base64EncodedStringWithOptions:0];
    }

    //对base64编码之后的字符串解码,并且返回
    -(NSString *)base64DecodeString:(NSString *)string
    {
        //注意:该字符串是base64编码后的字符串
        //1.转换为二进制数据(完成了解码的过程)
        NSData *data = [[NSData alloc]initWithBase64EncodedString:string options:0];
        
        //2.把二进制数据再转换为字符串
        return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }
### 5、HTTPS的基本使用，安全的网络地址：
    1.https简单说明
        HTTPS（全称：Hyper Text Transfer Protocol over Secure Socket Layer），是以安全为目标的HTTP通道，简单讲是HTTP的安全版。
        即HTTP下加入SSL层，HTTPS的安全基础是SSL，因此加密的详细内容就需要SSL。 它是一个URI scheme（抽象标识符体系），句法类同http:体系。用于安全的HTTP数据传输。
        https:URL表明它使用了HTTP，但HTTPS存在不同于HTTP的默认端口及一个加密/身份验证层（在HTTP与TCP之间）。

    2.HTTPS和HTTP的区别主要为以下四点：
            一、https协议需要到ca申请证书，一般免费证书很少，需要交费。
            二、http是超文本传输协议，信息是明文传输，https 则是具有安全性的ssl加密传输协议。
            三、http和https使用的是完全不同的连接方式，用的端口也不一样，前者是80，后者是443。
            四、http的连接很简单，是无状态的；HTTPS协议是由SSL+HTTP协议构建的可进行加密传输、身份认证的网络协议，比http协议安全。

    3.简单说明
    1）HTTPS的主要思想是在不安全的网络上创建一安全信道，并可在使用适当的加密包和服务器证书可被验证且可被信任时，对窃听和中间人攻击提供合理的保护。
    2）HTTPS的信任继承基于预先安装在浏览器中的证书颁发机构（如VeriSign、Microsoft等）（意即“我信任 证书颁发机构 告诉我 应该信任的”）即浏览器：这个证书颁发机构说的我就信的意思。
    3）因此，一个到某网站的HTTPS连接可被信任，如果服务器搭建自己的https 也就是说采用自认证的方式来建立https信道，这样一般在客户端是不被信任的。
    4）所以我们一般在浏览器访问一些https站点的时候会有一个提示，问你是否继续。

    4.对开发的影响。
    4.1 如果是自己使用NSURLSession来封装网络请求，涉及代码如下。要设置代理来信任https的证书，也就是接受公钥。
    - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
    {
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];

        NSURLSessionDataTask *task =  [session dataTaskWithURL:[NSURL URLWithString:@"https://www.apple.com"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        }];
        [task resume];
    }
    
    #pragma mark NSURLSessionDataDelegate------------
    /*
     如果请求的地址是HTTPS的, 才会调用这个代理方法，http请求不会调用
     我们需要在该方法中告诉系统, 是否信任服务器返回的证书
     Challenge: 挑战 质问 (包含了受保护的区域)
     protectionSpace : 受保护区域
     NSURLAuthenticationMethodServerTrust : 证书的类型是 服务器信任
     */
    - (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler
    {
        //    NSLog(@"didReceiveChallenge %@", challenge.protectionSpace);
        NSLog(@"调用了最外层");
        // 1.判断服务器返回的证书类型, 是否是服务器信任
        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            NSLog(@"调用了里面这一层是服务器信任的证书");
            
            //NSURLSessionAuthChallengeDisposition 如何处理证书
            /*
             NSURLSessionAuthChallengeUseCredential = 0,                     使用证书
             NSURLSessionAuthChallengePerformDefaultHandling = 1,            忽略证书(默认的处理方式)
             NSURLSessionAuthChallengeCancelAuthenticationChallenge = 2,     忽略书证, 并取消这次请求
             NSURLSessionAuthChallengeRejectProtectionSpace = 3,            拒绝当前这一次, 下一次再询问
             */
    //        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            
            //NSURLCredential 授权信息
            NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential , card);   //接受证书，并传递给系统，授权给浏览器下载证书
        }
    }

    4.2 如果是使用AFN框架，那么我们不需要做任何额外的操作，AFN内部已经做了处理。
    -(void)afn
    {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        //更改解析方式，网页的源码不能用默认的json解析器。
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        //设置对证书的处理方式，因为12306是自签名证书，不是买的证书，afn认为自签名的证书是无效证书，所以你要设置接受无效证书。
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy.validatesDomainName = NO;    //是否域名验证，也要设置为NO
        
        [manager GET:@"https://kyfw.12306.cn/otn" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"success---%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error---%@",error);
        }];
    }
