--------
day01
----------------------------------------------
### UI元素一般被叫做控件，也被常叫做组件、视图
### 所有的控件最终都是集成UIView，所以UIView包含了所有控件的共性

## UIVIew的常见属性：
### UIView的subviews方法，当View使用安全区safe area 自动布局时，会多两个UILayoutGuide子控件，用于自动布局，可以在sb中的file面板中去掉勾从而去掉这两个自动布局控件。
### ◆ 偶尔要使用UIView的tag属性，调用UIView的viewWithTag可以快速定位到你的这个tag的子View。
### IB上的view会加载到VC中，即便IB上的控件没有连线到VC的属性上，IB的控件是弱引用，是编译器加载到VC上的。

## UIKit的坐标系
### UIView的 frame的CGRect、bounds的CGRect、center的CGPoint都是结构体
    @property(nonatomic) CGRect frame;
    控件矩形框在父控件中的位置和尺寸(以父控件的左上角为坐标原点)，参考在父控件中的坐标系

    @property(nonatomic) CGRect bounds;
    控件自身矩形框的位置和尺寸(以自己左上角为坐标原点，所以bounds的x、y一般为0)，参考自身的坐标系，也就是自身的坐标系

    @property(nonatomic) CGPoint center;
    控件中点的位置(以父控件的左上角为坐标原点)，自身坐标系的中点 在父控件坐标系中的位置。
    
### UIView的bounds修改原点没有作用，修改大小的话，会以中心点为基点向四周收缩或者扩大。

## ➽ 注意点：在ios中，结构体是值传递，所以对象的属性是结构体的话，不能只修改结构体里面的部分成员，要整个赋值。所以frame要传递整个CGRect，而不能只修改其中的x或者y坐标。


## VC的loadView方法先于Viewdidload方法被调用
### 一旦在VC中重写-loadView方法，就说明你要自定义view给VC的view，也就是你要在方法体里设置self.view
#### 一般VC的背景就是一张图片时，或者是webView时，就可以重写loadview方法设置self.view为UIImageView，节省内存。

## VC的viewDidLoad方法是View加载完成之后才被调用，是懒加载
## VC的didReceiveMemoryWarning方法内存过高时被警告时才被调用
    1. 系统调用
    2. 当控制器接收到内存警告调用
    3. 去除一些不必要的内存,去除耗时的内存

### VC的view在appear出来时，是添加到window上的，所以，最底层vc的view的父控件是window。
### VC的view可以在appear出来后移除，因为只要有父控件都可以移除掉子控件，没有父控件则调用removeFromSuperview也无效。


### 如果一个UI控件不能接收事件，那么它的子控件也不能接收事件。
### 如果一个UI控件是透明的(alpha=0)，那么它是不可以接收事件。颜色是透明色，并不等同于控件是透明。
#### VC自身的View的颜色是透明色，但是VC自身的View并不是透明的。
### [window makeKeyAndVisible] 方法，当窗口显示时，就把根VC的View添加到window上。

### VC自身的view是懒加载的，用到的时候才会去创建：
#### 当首次使用VC的view时，会先去执行VC的loadview方法，然后是viewdidload方法。

--------
day02
-------------------------------------
## 必须熟练的四大控件：UIScrollView  滚动的控件、UITableView  表格、UICollectionView 九宫格、UIWebView 网页显示控件。
### 需要大概知道下面这些控件是干什么用的
    UIButton 按钮                 UIPageControl  分页控件
    UILabel 文本标签                    UITextView  能滚动的文字显示控件
    UITextField 文本输入框                   UIActivityIndicator 圈圈
    UIImageView 图片显示                    UISwitch 开关
    UIScrollView  滚动的控件                 UIActionSheet 底部弹框
    UITableView  表格                 UIDatePicker 日期选择器
    UICollectionView 九宫格                    UIToolbar  工具条
    UIWebView 网页显示控件                    UIProgressView 进度条
    UIAlertView  对话框（中间弹框）                  UISlider 滑块
    UINavigationBar导航条                  UISegmentControl 选项卡
    UIPickerView 选择器
    
#### UIToolbar  工具条，一般显示在底部或者键盘顶部，里面有几个小按钮
#### UINavigationBar导航条，显示在顶部的条

## 小技巧：不懂得UI控件属性的作用的话，直接在sb中调，很直观。默认值也可以直接在sb中查看。
#### label的baseline是要不要截断字母换行
#### Label的shadow的偏移值用CGSize结构体来表示，宽、高分别代表阴影相对主体水平、垂直方向的偏移，左上是负，右下是正，和坐标系一样。

### UILabel的常用属性：
    // 1.3 设置背景颜色
    label.backgroundColor = [UIColor redColor];
    
    // 1.4 设置文字
    label.text = @"da shen 11期最牛逼!!!!da shen da shen da shen da shen da shen ";
    
    // 1.5 居中
    label.textAlignment = NSTextAlignmentCenter;
    
    // 1.6 设置字体大小
    label.font = [UIFont italicSystemFontOfSize:20.f];
    
    // 1.7 设置文字的颜色
    label.textColor = [UIColor whiteColor];
    
    // 1.8 设置阴影(默认是有值)
    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(-2, 1);
    
    // 1.9 设置行数(0:自动换行)
    label.numberOfLines = 1;
    
    // 1.10 显示模式
    label.lineBreakMode =  NSLineBreakByTruncatingHead;

## VC中的addsubview会有一个强指针指向subview，VC的属性也可以有一个强指针指向subview，所以可以属性用weak
### UIImageView的contentmode的值，带scale的会缩放(有变形，也有不变形aspect)，不带scale的不会缩放（默认也不裁剪）。  

### 利用UIToolbar的barStyle属性给父view添加毛玻璃效果：
    // 6.1 创建UIToolBar对象
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    // 6.2 设置toolBar的frame
    toolBar.frame = imageView.bounds;
    // 6.3 设置毛玻璃的样式
    toolBar.barStyle = UIBarStyleBlack;
    toolBar.alpha = 0.98;
    // 6.4 加到imageView中
    [imageView addSubview:toolBar];

## 改变UIView的frame，那么该View的bounds也会被相应缩小，bounds影响到的子view也会同步变化。 
### UIImage对象也有size属性，size属性也有宽高，可以直接调用。
    // 方式一
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"1"];
         
    //    imageView.frame = CGRectMake(100, 100, 267, 400);
    //    imageView.frame = (CGRect){{100, 100},{267, 400}};
        
    // 方式二
    UIImageView *imageView = [[UIImageView alloc] init];
    // 创建一个UIImage对象
    UIImage *image = [UIImage imageNamed:@"1"];
    // 设置frame
    imageView.frame = CGRectMake(100, 10, image.size.width, image.size.height);
    // 设置图片
    imageView.image = image;
### CGRect也可以用这种方式创建(CGRect){{100, 100},{267, 400}};
### UIImage创建时就会有一个默认的尺寸size，是系统根据图片的像素生成的，但是没有frame，所以不可以拿Image对象的size当作frame来使用。 此时可以通过设置UIImageView的center来改变位置。
    // 方式四
    // 创建一个UIimageview对象
    // 注意: initWithImage 默认就有尺寸--->图片的尺寸
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1"]];
    
    // 改变位置
    //    imageView.center = CGPointMake(200, 150);
    imageView.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.5);

### UIImageView的animationImages属性可以通过多张图片实现帧动画效果
    // 1.1 加载所有的图片
    NSMutableArray<UIImage *> *imageArr = [NSMutableArray array];
    for (int i=0; i<20; i++) {
        // 获取图片的名称
        NSString *imageName = [NSString stringWithFormat:@"%d", i+1];
        // 创建UIImage对象
        UIImage *image = [UIImage imageNamed:imageName];
        // 加入数组
        [imageArr addObject:image];
    }
    // 设置动画图片
    self.imageView.animationImages = imageArr;
    
    // 设置动画的播放次数
    self.imageView.animationRepeatCount = 0;
    
    // 设置播放时长
    // 1秒30帧, 一张图片的时间 = 1/30 = 0.03333 20 * 0.0333
    self.imageView.animationDuration = 1.0;
    
    // 开始动画
    [self.imageView startAnimating];
    
    #pragma mark - 结束动画
    - (IBAction)overAnimation {
        [self.imageView stopAnimating];
    }
    
## iOS中图片等资源存放的路径问题，存放方式：
    App上的所有资源最终都是打包进ipa包中。在命令行打印 NSHomeDirectory(), 上一层文件夹就可以看到你的App被打包成ipa文件前的文件夹， 对应的图片、plist等资源文件都在这个文件夹里面(要显示包内容)，bundle文件夹就是资源的意思(翻译是桶，用来装东西的)。
    /Users/caitianchun/Library/Developer/CoreSimulator/Devices/8080FFE2-0D4B-4C9B-9248-40B318C3510D/data/Containers/Data/Application/002197E7-A71D-4999-BF9C-7AE9C90264EC
    Base.lproj文件夹用来装sb的。要了解这些文件目录的层级关系，存放关系、构成关系。

###  NSBundle是app文件系统下的存放资源的文件夹，例如图片、plist、sb文件等等资源都存放在这里。
    NSBundle表示的是当前的工程目录，相对路径的开头也是这个。
    NSBundle 在虚拟机中的路径 ： /Users/caitianchun/Library/Developer/CoreSimulator/Devices/8080FFE2-0D4B-4C9B-9248-40B318C3510D/data/Containers/Bundle/Application/20114E30-F902-4EBF-8A62-5EC608B2EA1E
#### Assets.car在NSBundle文件夹下，是一个用于管理图片资源的专属包，不可以获取其路径，专门为用图片名字生成UIimage而设计的。 
    NSString *path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"png"];
    self.imageView.image = [UIImage imageWithContentsOfFile:path];
    
    1. 加载Assets.xcassets这里面的图片:
       1> 打包后变成Assets.car
       2> 拿不到路径
       3> 只能通过imageNamed:来加载图片
       4> 不能通过imageWithContentsOfFile:来加载图片
    
    2. 放到项目中的图片:
       1> 可以拿到路径
       2> 能通过imageNamed:来加载图片
       3> 也能通过imageWithContentsOfFile:来加载图片

### 理解本质，App本来就是一个ipa包，iOS手机解压这个包，根据里面的代码和信息生成相应的文件夹啊、app这一个应用啊之类， 
### 然后就有了沙盒，Bundle这些文件夹，分别用于不同的用途，这个机制就是ios的机制。

### Xcode小技巧：以前的xocde右键创建文件夹，Create Group是创建虚拟文件夹(路径只是给看看，实际都是放在一堆地方)， Create Folder Reference是创建真实的文件夹路径 。
### Xcode项目中的文件夹，代码中的路径，它们的相对路径，都是相对于当前项目的文件夹的，也就是/XX/YY.jpg，第一个/表示的就是当前项目目录 

### VC中的performSelector方法很常用，是一个方法执行器，用于给方法发送消息，也就是我们说的执行方法，后者说第三者调用方法。
    // Selector 方法
    // Object 参数
    // afterDelay 时间
    //    NSSelectorFromString(NSString * _Nonnull aSelectorName ) 相当于@selector(stand)，效果一样
    [self performSelector:@selector(stand) withObject:nil afterDelay:self.imageView.animationDuration];
    
### @selector(方法名) 其实是一个编译器指令，实际代码是NSSelectorFromString(NSString * _Nonnull aSelectorName )

### 图片的缓存在内存中，是因为还有强指针指向图片资源，没有释放。 
    图片的两种加载方式:
    1> imageNamed:
         a. 就算指向它的指针被销毁,该资源也不会被从内存中干掉
         b. 放到Assets.xcassets的图片,默认就有缓存
         c. 图片经常被使用
    
    2> imageWithContentsOfFile:
         a. 指向它的指针被销毁,该资源会被从内存中干掉
         b. 放到项目中的图片就不由缓存
         c. 不经常用,大批量的图片
        
        
        
### 通过AVFoundation播放 NSBundle里的音乐文件：
    // 5.创建播放器
    NSString *path = [[NSBundle mainBundle] pathForResource:@"mySong1.mp3" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    // 资源的URL地址
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"mySong1.mp3" withExtension:nil];
    // 创建播放器曲目
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:url];
    // 创建播放器
    self.player = [[AVPlayer alloc] initWithPlayerItem:playerItem];


--------
day05---------（未完）
-------------------
kvo与kvc
### KVC: Key Value Coding(键值编码)：用于忽略访问控制，外部可以访问修改私有属性，对象的每一个属性都有一个key-value的对应关系。
#### KVC很方便与字典与模型之间的转换、数组与模型之间的转换、模型与集合间的转换。
#### KVC的方法开头是以setValue开头的，找不到对象属性中对应的key-value就会报错。kvc会进行类型赋值value时会进行类型转换，但是很机械。
     ■ KVC的赋值：
    XMGPerson *person = [[XMGPerson alloc] init];
    person.dog = [[XMGDog alloc] init];
    //        person.dog.name = @"旺财";
    
    // 常规赋值
    person.name = @"张三";
    person.age = 18;
       
    // KVC赋值
    [person setValue:@"王五" forKey:@"name"];
    [person setValue:@"19" forKeyPath:@"money"]; // 自动类型转换
    
    // KVC赋值
     forKey和forKeyPath方法的使用
     1>forKeyPath 包含了所有 forKey 的功能
     2>forKeyPath 进行内部的点语法,层层访问内部的属性
     3>注意: key值一定要在属性中找到
    [person.dog setValue:@"阿黄" forKey:@"name"]; //kvc的forky方法
    [person setValue:@"旺财" forKeyPath:@"dog.name"]; //kvc的forKeyPath方法
    
    
    /**
     作用: 字典转模型
     开发中是不建议使用setValuesForKeysWithDictionary:
     1> 字典中的key必须在模型的属性中找到
     2> 如果模型中带有模型,setValuesForKeysWithDictionary不好使，只是简单机械地将aboject转为字典
     应用场景: 简单的字典转模型 ---> 框架 (MJExtention)
     */
    void test4(){
        NSDictionary *dict = @{
                               @"name" :@"lurry",
                               @"money" : @189.88,
                               @"dog" : @{
                                       @"name" : @"wangcai",
                                       @"price" : @8
                                       },
                               @"books": @[
                                       @{@"name" :@"iOS快速开发", @"price" : @1999},
                                       @{@"name" :@"iOS快速发", @"price" : @199},
                                       @{@"name" :@"iOS快开发", @"price" : @99}
                                       ]
                               };
        XMGPerson *person = [[XMGPerson alloc] initWithDict:dict];
        NSLog(@"%@", person.dog.class);
        
        [person setValue: @{
                            @"name" : @"wangcai",
                            @"price" : @8
                            } forKeyPath:@"dog"];
    }
    
    ■ KVC的取值：
    XMGPerson *person = [[XMGPerson alloc] init];
    person.name = @"张三";
    person.money = 12332;
    
    // 利用kvc取值
    NSLog(@"%@ --- %.2f", [person valueForKeyPath:@"name"], [[person valueForKey:@"money"] floatValue]);

     ■ KVC模型与集合间的转换：
    *  把模型转成字典
    XMGPerson *person = [[XMGPerson alloc] init];
    person.name = @"lurry";
    person.money = 21.21;
    NSDictionary *dict = [person dictionaryWithValuesForKeys:@[@"name", @"money"]];
    NSLog(@"%@", dict);

    *   取出数组中所有模型的某个属性值
    XMGPerson *person1 = [[XMGPerson alloc] init];
    person1.name = @"zhangsan";
    person1.money = 12.99;
    
    XMGPerson *person2 = [[XMGPerson alloc] init];
    person2.name = @"zhangsi";
    person2.money = 22.99;
    
    XMGPerson *person3 = [[XMGPerson alloc] init];
    person3.name = @"wangwu";
    person3.money = 122.99;
    
    NSArray *allPersons = @[person1, person2, person3];
    NSArray *allPersonName = [allPersons valueForKeyPath:@"name"];

### KVO: Key Value Observing (键值监听)--->当某个对象的属性值发生改变的时候(用KVO来监听KVC的变化)
### 原理是利用一个第三者对象作为观察者(往往是自己是自己的观察者)，来监听目标对象的某个属性的变化，观察者模式的使用。
    - (void)viewDidLoad {
        [super viewDidLoad];
        XMGPerson *person = [[XMGPerson alloc] init];
        person.name = @"zs";
        
        /*
         作用:给对象绑定一个监听器(观察者)
         - Observer 观察者
         - KeyPath 要监听的属性
         - options 选项(方法方法中拿到属性值，新值或旧值或都要)
         */
        [person addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        
        person.name = @"ls";
        person.name = @"ww";
        
        // 移除监听
        [person removeObserver:self forKeyPath:@"name"];
    }

    /**
     *  当监听的属性值发生改变，观察者被调用的方法，即观察者用于监听到时执行的方法
     *  @param keyPath 要改变的属性
     *  @param object  要改变的属性所属的对象
     *  @param change  改变的内容
     *  @param context 上下文
     */
    - (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
        NSLog(@"%@------%@------%@", keyPath, object, change);
    }

----------------
day08-------------（未完）
-----------------------------
UItableview的性能优化
### UITableView的优化，其实就是cell的复用池，其实可以自己利scrollview的contentoffset和数组来自己造一个复用池，tableview可以注册多个cell类型。
### 在方法里调用dequeueReusableCellWithIdentifier方法，会直接注册该cell，如果要注册多种类型的cell，则需要在外部调用tableview的registerClass方法来注册cell。
    /**
     *  每当一个cell要进入视野范围就会调用这个方法
     */
    - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
        // 1.定义一个重用标识，static只占用一份内存，在这里只影响作用域，不影响生命周期
        static NSString *ID = @"wine";
        // 2.去缓存池取可循环利用的cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        // 3.缓存池如果没有可循环利用的cell,自己创建
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            // 建议:所有cell都一样的设置,写在这个大括号中;所有cell不都一样的设置写在外面
           cell.backgroundColor = [UIColor redColor];

        }
        // 4.设置数据
        cell.textLabel.text = [NSString stringWithFormat:@"第%zd行数据",indexPath.row];
        
        if (indexPath.row % 2 == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    }
#### 小技巧：避免复用cell时数据的错乱，所以有if就要有else
### tableview的registerClass方法设置不了cell的样式，因为时系统为你创建的，默认是默认的样式，所以registerClass一般用于自定义的cell。
### 不是通过dequeueReusableCellWithIdentifier方法取出的cell，不会被放到复用池内，还是会被销毁。一般是先从复用池拿，拿不到再从注册里拿。
