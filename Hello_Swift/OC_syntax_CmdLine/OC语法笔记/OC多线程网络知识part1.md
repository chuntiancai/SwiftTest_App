-------------
day01&day02-------------
-----------------
## ios线程占用的资源有：内核数据结构（大约1KB）、栈空间，创建线程大约需要90毫秒的创建时间.
    iOS下主要成本包括：内核数据结构（大约1KB）、栈空间（子线程512KB、主线程1MB，也可以使用-setStackSize:设置，但必须是4K的倍数，而且最小是16K），创建线程大约需要90毫秒的创建时间.
### 一个iOS程序运行后，默认会开启1条线程，称为“主线程”或“UI线程”，作用如下：
    显示\刷新UI界面
    处理UI事件（比如点击事件、滚动事件、拖拽事件等）

    //1.获得主线程
    NSThread *mainThread = [NSThread mainThread];
    
    //2.获得当前线程
    NSThread *currentThread  = [NSThread currentThread];
    
    //3.判断主线程
    //3.1 number  == 1
    //3.2 类方法
    BOOL isMainThreadA = [NSThread isMainThread];
    //3.3 对象方法
    BOOL isMainThreadB = [currentThread isMainThread];
    NSLog(@"%zd---%zd",isMainThreadA,isMainThreadB);

## iOS中提供的多线程技术：pthread、NSThread、GCD、NSOperation
### pthread：是沿用C语言的，很古老，几乎不用。程序员管理。
    //1.创建线程对象
    pthread_t thread;
    
    //2.创建线程
    //第一个参数:线程对象 传递地址
    //第二个参数:线程的属性 NULL
    //第三个参数:指向函数的指针
    //第四个参数:函数需要接受的参数
    pthread_create(&thread, NULL, task, NULL);
    
### NSThread：是OC刚出来的时候设计的(面向对象)，现在都不直接使用了，偶尔使用，而是使用了对它二次封装的技术。程序员管理。
#### 根据NSThread的number属性的值来区分是否是同一条线程。
#### NSThread的优先级的值越大，优先级就越高。threadPriority属性。
#### 线程一启动就会去执行task方法，线程的生命周期:当任务执行完毕之后就被释放掉。
    //1.创建线程
    /*
    第一个参数:目标对象  self
    第二个参数:方法选择器 调用的方法
    第三个参数:前面调用方法需要传递的参数 nil
    */
    NSThread *threadA = [[XMGThread alloc]initWithTarget:self selector:@selector(run:) object:@"ABC"];
    
    //设置属性
    threadA.name = @"线程A";
    //设置优先级  取值范围 0.0 ~ 1.0 之间 最高是1.0 默认优先级是0.5
    threadA.threadPriority = 1.0;
    
    //2.启动线程
    [threadA start];
    
    //二、创建线程的第二种方法：分离子线程,会自动启动线程，不需要手动启动，没办法拿到线程的对象。
    [NSThread detachNewThreadSelector:@selector(run:) toTarget:self withObject:@"分离子线程"];

    //三、开启一条后台线程，自动启动线程。没有返回值
    [self performSelectorInBackground:@selector(run:) withObject:@"开启后台线程"];

    -(void)run:(NSString *)param
    {
    //    NSLog(@"---run----%@---%@",[NSThread currentThread].name,param);
        for (NSInteger i = 0; i<10000; i++) {
            NSLog(@"%zd----%@",i,[NSThread currentThread].name);
        }
    }
#### 线程的状态：新建-->就绪<--阻塞-->运行--->死亡。
#### 进入就绪状态 -> 运行状态。当线程任务执行完毕，自动进入死亡状态。
#### 注意：一旦线程停止（死亡）了，就不能再次开启任务。
    //1.创建线程,新建
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(task) object:nil];

    //2.启动线程,就绪<---->运行
    [thread start];
    
    //阻塞线程
    //[NSThread sleepForTimeInterval:2.0];
    [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:3.0]];
    
    // [NSThread exit];  //强制退出当前线程，线程死亡。
    
### GCD：是C语言写的的，旨在替代NSThread等线程技术，经常使用。自动管理.（任务+队列）
    GCD是苹果公司为多核的并行运算提出的解决方案
    GCD会自动管理线程的生命周期（创建线程、调度任务、销毁线程）
    程序员只需要告诉GCD想要执行什么任务，不需要编写任何线程管理代码
#### GCD框架是苹果全自动为你管理线程的生命周期，调度，你只需要写任务代码就可以了。
#### GCD框架是苹果全自动为你管理线程的生命周期，调度，你只需要写任务代码就可以了。
#### GCD框架是苹果全自动为你管理线程的生命周期，调度，你只需要写任务代码就可以了。
#### GCD是基于队列来管理任务的，你只需要把你的任务放到你的队列中，剩下的GCD会使用对应的线程执行管理。
    GCD会自动将队列中的任务取出，放到对应的线程中执行。
    任务的取出遵循队列的FIFO原则：先进先出，后进后出。
##### 1.创建队列，dispatch_queue_create("com.520it.download", DISPATCH_QUEUE_CONCURRENT); //全局的类对象
##### 2.>封装任务>添加任务到队列中，使用全局函数 dispatch_async  //第一个参数:队列，第二个参数:要执行的任务：dispatch_async(queue, ^{ 代码编写处 });
##### 3.线程执行完任务生命周期就立马结束，只是GCD帮你管理了线程，一直忙等之类的，所以就不需要你担心线程的生命周期。
##### 获取主队列：dispatch_get_main_queue()。； 获取全局并发队列： dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)。
#### 全局并发队列在整个应用程序中本身是默认存在的，并且对应有高优先级、默认优先级、低优先级和后台优先级一共四个并发队列， 我们只是选择其中的一个直接拿来用。 而Crearte函数是实打实的从头开始去创建一个队列。
#### GCD为你的队列开多少个线程是GCD内部优化决定的，你并不可控，你能控制的就只是简单任务和队列而已。就你一万个任务可能就只为你创建了3个线程。
    ■ 1.创建队列
     //第一个参数:C语言的字符串,标签
    // 第二个参数:队列的类型
        DISPATCH_QUEUE_CONCURRENT:并发，是异步的意思
        DISPATCH_QUEUE_SERIAL:串行，同步
    dispatch_queue_t queue = dispatch_queue_create("com.520it.download", DISPATCH_QUEUE_CONCURRENT);
    
    ■ 获得全局并发队列
     //第一个参数:优先级
     //第二个参数:
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSLog(@"---satrt----");
    
    //2.1>封装任务2>添加任务到队列中
     第一个参数:队列
     第二个参数:要执行的任务
    dispatch_async(queue, ^{
        NSLog(@"download1----%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"download2----%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"download3----%@",[NSThread currentThread]);
    });
#####  1、凡是放到主队列中的任务，都在主线程中执行，不会再开新线程
    //1.获得主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    NSLog(@"start----");
    //2.主线程中添加：（同步任务+主队列）-> 死锁；//因为主线程在等主队列的任务执行完，主队列在等主线程忙完，而主线程正在添加主任务进主线程，两个都在忙等，死锁。
    //同步函数:立刻马上执行,如果我没有执行完毕,那么后面的也别想执行
    //异步函数:如果我没有执行完毕,那么后面的也可以执行
    dispatch_sync(queue, ^{
        NSLog(@"download1----%@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"download2----%@",[NSThread currentThread]);
    });
    
    //2.异步函数
    dispatch_async(queue, ^{
        NSLog(@"download11----%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"download22----%@",[NSThread currentThread]);
    });
    
##### 2、CPU发现主队列里面有任务，就会从主队列中拿出任务放到主线程中执行，所以在主线程中添加主队列的同步任务会死锁。//主线程中添加：（同步任务+主队列）-> 死锁
##### 所以要在子线程中添加 （同步任务+主队列），不能在主线程中添加同步主任务。
##### 同步是不会开启新的线程，在旧的线程中顺序添加任务，也就是串行执行；异步是会开启新线程执行，在新线程中添加新任务，所以是并发执行的。

### 小技巧：可以在异步线程中下载图片，然后在子线程中添加主线程任务刷新UI。这是线程通信的一种。
#### GCD的常用函数：dispatch_after方法(延迟执行)
    //1. 延迟执行的第一种方法
    //[self performSelector:@selector(task) withObject:nil afterDelay:2.0];
    
    //2.延迟执行的第二种方法
    //[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(task) userInfo:nil repeats:YES];
    
    //3.GCD
    //    dispatch_queue_t queue = dispatch_get_main_queue();
     dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    /*
     第一个参数:DISPATCH_TIME_NOW 从现在开始计算时间
     第二个参数:延迟的时间 2.0 GCD时间单位:纳秒
     第三个参数:队列
     */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), queue, ^{
        NSLog(@"GCD----%@",[NSThread currentThread]);
    });

#### GCD的一次性代码dispatch_once_t不能放在懒加载中的，整个App运行过程中，这个代码块只执行一次，但是你可以创建多个这样的代码块。
    //一次性代码
    //不能放在懒加载中的,应用场景:单例模式
    static dispatch_once_t onceToken;       //static
        dispatch_once(&onceToken, ^{
        NSLog(@"---once----");
    });
#### GCD的栅栏函数(全局函数)，用于使异步函数顺序执行，栅栏函数 “代码行前的” 线程必然比 “代码行后的” 线程先执行。dispatch_barrier_async(queue, ^{ 代码体 });
##### 1.栅栏函数不能使用全局并发队列，不然没有任何作用。只能用自己创建的队列。
    //栅栏函数不能使用全局并发队列，不然没有任何作用
    dispatch_queue_t queue = dispatch_queue_create("download", DISPATCH_QUEUE_CONCURRENT);  //获取容纳任务的队列

#### GCD的快速迭代函数，优化for循环，常用语文件遍历。\\dispatch_apply全局函数
    /*
     第一个参数:遍历的次数
     第二个参数:队列(并发队列)
     第三个参数:index 索引
     */
    dispatch_apply(10, dispatch_get_global_queue(0, 0), ^(size_t index) {
        NSLog(@"%zd---%@",index,[NSThread currentThread]);
    });
    
    
    //1.拿到文件路径
    NSString *from = @"/Users/xiaomage/Desktop/from";
    
    //2.获得目标文件路径
    NSString *to = @"/Users/xiaomage/Desktop/to";
    
    //3.得到目录下面的所有文件
    NSArray *subPaths = [[NSFileManager defaultManager] subpathsAtPath:from];
    
    NSLog(@"%@",subPaths);
    //4.遍历所有文件,然后执行剪切操作
    NSInteger count = subPaths.count;
    
    dispatch_apply(count, dispatch_get_global_queue(0, 0), ^(size_t i) {
        //4.1 拼接文件的全路径
        // NSString *fullPath = [from stringByAppendingString:subPaths[i]];
        //在拼接的时候会自动添加/
        NSString *fullPath = [from stringByAppendingPathComponent:subPaths[i]];
        NSString *toFullPath = [to stringByAppendingPathComponent:subPaths[i]];
        
        NSLog(@"%@",fullPath);
        //4.2 执行剪切操作
        /*
         第一个参数:要剪切的文件在哪里
         第二个参数:文件应该被存到哪个位置
         */
        [[NSFileManager defaultManager]moveItemAtPath:fullPath toPath:toFullPath error:nil];
        
        NSLog(@"%@---%@--%@",fullPath,toFullPath,[NSThread currentThread]);

    });

#### GCD队列组的使用dispatch_group_create()，用于监听队列里面每一个任务的执行情况，但是是以队列为单位进行管理的。
##### 1、拦截通知,当队列组中所有的任务都执行完毕的时候回进入到下面的方法dispatch_group_notify(group, queue, ^{ 编写代码处 });
    //1.创建队列
    dispatch_queue_t queue =dispatch_get_global_queue(0, 0);
    
    //2.创建队列组
    dispatch_group_t group = dispatch_group_create();
    
    //3.异步函数
    /*
     1)封装任务、2)把任务添加到队列中
     dispatch_async(queue, ^{
        NSLog(@"1----%@",[NSThread currentThread]);
     });
     */
    /*
     1)封装任务、 2)把任务添加到队列中、3)会监听任务的执行情况,通知group
     */
    dispatch_group_async(group, queue, ^{
        NSLog(@"1----%@",[NSThread currentThread]);
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"2----%@",[NSThread currentThread]);
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"3----%@",[NSThread currentThread]);
    });
    
    //拦截通知,当队列组中所有的任务都执行完毕的时候回进入到下面的方法
    dispatch_group_notify(group, queue, ^{
        NSLog(@"-------dispatch_group_notify-------");
    });

##### 2、（旧写法）代码行后的队列进入队列组dispatch_group_enter(group);，写完代码后手动退出队列组dispatch_group_leave(group); 。
    //1.创建队列
    dispatch_queue_t queue =dispatch_get_global_queue(0, 0);
    
    //2.创建队列组
    dispatch_group_t group = dispatch_group_create();
    
    //3.在该方法后面的异步任务会被纳入到队列组的监听范围,进入群组
    //dispatch_group_enter|dispatch_group_leave 必须要配对使用
    dispatch_group_enter(group);
    
    dispatch_async(queue, ^{
        NSLog(@"1----%@",[NSThread currentThread]);
        dispatch_group_leave(group);    //离开群组
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        NSLog(@"2----%@",[NSThread currentThread]);
        dispatch_group_leave(group);     //离开群组
    });
    
    
    //拦截通知
    //问题?该方法是阻塞的吗?  内部本身是异步的
    //    dispatch_group_notify(group, queue, ^{
    //        NSLog(@"-------dispatch_group_notify-------");
    //    });
    
    //等待.死等. 直到队列组中所有的任务都执行完毕之后才能执行
    //阻塞的，后面的代码不会被执行，除非队列组的队列都执行完了。
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"----end----");
##### 3、队列组用于合并下载的多张图片，涉及到图片绘制：
    ，
    /*
     1.下载图片1 开子线程
     2.下载图片2 开子线程
     3.合成图片并显示图片 开子线程
     */
    
    //-1.获得队列组
    dispatch_group_t group = dispatch_group_create();
    
    //0.获得并发队列
    dispatch_queue_t queue =  dispatch_get_global_queue(0, 0);
    
    // 1.下载图片1 开子线程
    dispatch_group_async(group, queue,^{
        
        NSLog(@"download1---%@",[NSThread currentThread]);
        //1.1 确定url
        NSURL *url = [NSURL URLWithString:@"http://www.qbaobei.com/tuku/images/13.jpg"];
        
        //1.2 下载二进制数据
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        
        //1.3 转换图片
        self.image1 = [UIImage imageWithData:imageData];
    });
    
    // 2.下载图片2 开子线程
     dispatch_group_async(group, queue,^{
         
         NSLog(@"download2---%@",[NSThread currentThread]);
         //2.1 确定url
        NSURL *url = [NSURL URLWithString:@"http://pic1a.nipic.com/2008-09-19/2008919134941443_2.jpg"];
        
        //2.2 下载二进制数据
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        
        //2.3 转换图片
        self.image2 = [UIImage imageWithData:imageData];
    });

    //3.合并图片
    //主线程中执行
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
       
        NSLog(@"combie---%@",[NSThread currentThread]);
        //3.1 创建图形上下文
        UIGraphicsBeginImageContext(CGSizeMake(200, 200));
        
        //3.2 画图1
        [self.image1 drawInRect:CGRectMake(0, 0, 200, 100)];
        self.image1 = nil;
        
        //3.3 画图2
        [self.image2 drawInRect:CGRectMake(0, 100, 200, 100)];
        self.image2 = nil;
        
        //3.4 根据上下文得到一张图片
        UIImage *image =  UIGraphicsGetImageFromCurrentImageContext();
        
        //3.5 关闭上下文
        UIGraphicsEndImageContext();
        
        //3.6 回到主线程更新UI
        //        dispatch_async(dispatch_get_main_queue(), ^{
        
            NSLog(@"UI----%@",[NSThread currentThread]);
            self.imageView.image = image;
            //        });
    });
    
    //    dispatch_release(group)
    
###### 5、用方法来封装任务(之前是用block来封装任务)，dispatch_async(<#dispatch_queue_t queue#>, <#^(void)block#>)
    ，
    //区别:封装任务的方法(block--函数)
    /*
     第一个参数:队列
     第二个参数:方法的参数
     第三个参数:要调用的函数的名称
     */
    dispatch_async_f(dispatch_get_global_queue(0, 0), NULL, task);
    dispatch_async_f(dispatch_get_global_queue(0, 0), NULL, task);
    dispatch_async_f(dispatch_get_global_queue(0, 0), NULL, task);
#### 编程小技巧：如果不知道参数的类型是怎么定义的，用opt键点击查看定义，然后复制粘贴。

#### 编程小知识：dispatch_queue_t 是C语言的宏定义的结构体指针，宏定义了一个NSObject对象，凡是这种都是全局的宏定义对象。
#### 编程小知识：dispatch_queue_t 这种开头的全局类对象，一般都是GCD的对象。
    //Summary
    //A lightweight object to which your application submits blocks for subsequent execution.
    //Declaration
    typedef NSObject<OS_dispatch_queue> *dispatch_queue_t;


### NSOperation：是对GCD的二次封装，更加面向对象。经常使用，自动管理。（操作+队列）；创建操作，放入队列。
    先将需要执行的操作封装到一个NSOperation对象中
    然后将NSOperation对象添加到NSOperationQueue中
    系统会自动将NSOperationQueue中的NSOperation取出来
    将取出的NSOperation封装的操作放到一条新线程中执行
#### NSOperation是抽象类，你主要用到它的子类：NSInvocationOperation、NSBlockOperation、自定义子类继承NSOperation，实现内部相应的方法
#### 0、主队列:   [NSOperationQueue mainQueue] 和GCD中的主队列一样,串行队列；---  非主队列: [[NSOperationQueue alloc]init] ，默认并发
#### 1、NSInvocationOperation添加到非主队列中默认是并发的，队列添加它时就默认调用start方法执行了。
    //1.创建操作,封装任务
    /*
     第一个参数:目标对象 self
     第二个参数:调用方法的名称
     第三个参数:前面方法需要接受的参数 nil
     */
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(download1) object:nil];
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(download2) object:nil];
    NSInvocationOperation *op3 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(download3) object:nil];
    
    //2.创建队列
    /*
     GCD:
     串行类型:create & 主队列
     并发类型:create & 全局并发队列
     NSOperation:
     主队列:   [NSOperationQueue mainQueue] 和GCD中的主队列一样,串行队列
     非主队列: [[NSOperationQueue alloc]init]  非常特殊(同时具备并发和串行的功能)
     //默认情况下,非主队列是并发队列
     */
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    //3.添加操作到队列中
    [queue addOperation:op1];   //内部已经调用了[op1 start]
    [queue addOperation:op2];
    [queue addOperation:op3];

#### 2、NSBlockOperation是闭包定义操作，有个addExecutionBlock方法，可以额外添加任务。默认的是否主线程执行是看cpu的心情的。
    //1.创建操作
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"1----%@",[NSThread currentThread]);
    }];
    
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"2----%@",[NSThread currentThread]);
    }];
    
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"3----%@",[NSThread currentThread]);
    }];
    
    //追加任务
    [op2 addExecutionBlock:^{
        NSLog(@"4----%@",[NSThread currentThread]);
    }];
    
    [op2 addExecutionBlock:^{
        NSLog(@"5----%@",[NSThread currentThread]);
    }];
    
    [op2 addExecutionBlock:^{
        NSLog(@"6----%@",[NSThread currentThread]);
    }];
    
    //2.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    //3.添加操作到队列
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    
    //简便方法
    //1)创建操作,2)添加操作到队列中
    [queue addOperationWithBlock:^{
        NSLog(@"7----%@",[NSThread currentThread]);
    }];
    
#### 3、自定义NSOperation要重写- (void)main方法，在里面实现想执行的任务；
    //1.封装操作
    XMGOperation *op1 = [[XMGOperation alloc]init];
    XMGOperation *op2 = [[XMGOperation alloc]init];
    
    //2.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    //3.添加操作到队列，默认添加时调用start
    [queue addOperation:op1];
    [queue addOperation:op2];
#### 4、NSOperation的completionBlock属性可以监听操作的完成通知。
    //操作监听
    op3.completionBlock = ^{
        NSLog(@"++++客官,来看我吧------%@",[NSThread currentThread]);
    };
#### 5、NSOperation之间的通信是在任务的代码中切换到主队列，并在主队列中添加任务，非主队列也类似。
    //1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    __block UIImage *image1;
    __block UIImage *image2;
    //2 封装操作,下载图片1
    NSBlockOperation *download1 = [NSBlockOperation blockOperationWithBlock:^{
        
        NSURL *url = [NSURL URLWithString:@"http://s15.sinaimg.cn/bmiddle/4c0b78455061c1b7f1d0e"];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        image1 = [UIImage imageWithData:imageData];
        
        NSLog(@"download---%@",[NSThread currentThread]);
        
    }];
    
    //3 封装操作,下载图片2
    NSBlockOperation *download2 = [NSBlockOperation blockOperationWithBlock:^{
        
        NSURL *url = [NSURL URLWithString:@"http://www.027art.com/feizhuliu/UploadFiles_6650/201109/2011091718442835.jpg"];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        image2 = [UIImage imageWithData:imageData];
        
        NSLog(@"download---%@",[NSThread currentThread]);
        
    }];
    
    //4.封装合并图片的操作
    NSBlockOperation *combie = [NSBlockOperation blockOperationWithBlock:^{
        //4.1 开上下文
        UIGraphicsBeginImageContext(CGSizeMake(200, 200));
        
        //4.2 画图1
        [image1 drawInRect:CGRectMake(0, 0, 100, 200)];
        
        //4.3 画图2
        [image2 drawInRect:CGRectMake(100, 0, 100, 200)];
        
        //4.4 根据上下文得到图片
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        
        //4.5 关闭上下文
        UIGraphicsEndImageContext();
        
        //7.回到主队列，更新UI
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.imageView.image = image;
            NSLog(@"UI----%@",[NSThread currentThread]);
        }];
        
    }];
    
    //5.设置依赖关系
    [combie addDependency:download1];
    [combie addDependency:download2];
    
    //6.添加操作到队列中
    [queue addOperation:download2];
    [queue addOperation:download1];
    [queue addOperation:combie];
#### 6、NSOperation是先执行start方法，然后再执行main方法的，main方法用于编写任务。都是被重写的。    
#### 1、NSOperationQueue设置并发数maxConcurrentOperationCount=1时，可以实现多线程串行执行的效果。
##### NSOperationQueue设置暂停取消，需要等待当前任务执行完之后才会真正的暂停取消。以任务为单位，不是以线程为单位来暂停的。
    //1.创建队列，默认是并发队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    //2.设置最大并发数量 maxConcurrentOperationCount
    //同一时间最多有多少个任务可以执行
    //串行执行任务!=只开一条线程 (线程同步)
    // maxConcurrentOperationCount >1 那么就是并发队列
    // maxConcurrentOperationCount == 1 那就是串行队列
    // maxConcurrentOperationCount == 0  不会执行任务
    // maxConcurrentOperationCount == -1 特殊意义 最大值 表示不受限制
    queue.maxConcurrentOperationCount = 1;
    
    XMGOperation *op1 = [[XMGOperation alloc]init];
    
    //4.添加到队列
    [self.queue addOperation:op1];
    
    //暂停,是可以恢复，队列中的任务也是有状态的:已经执行完毕的 | 正在执行 | 排队等待状态
    //不能暂停当前正在处于执行状态的任务
    [self.queue setSuspended:YES];
    
    //继续执行
    [self.queue setSuspended:NO];
    
    //该方法内部调用了所有操作的cancel方法
    [self.queue cancelAllOperations];
##### NSOperationQueue通过添加任务间的依赖监听addDependency 来实现 使任务顺序执行，被addDependency的任务(作为参数)先执行。可以跨队列依赖，注意不要循环依赖

    //添加操作依赖
    //注意点:不能循环依赖
    //可以跨队列依赖
    [op1 addDependency:op4];
    //    [op4 addDependency:op1];
    
    [op2 addDependency:op3];
    
    //添加操作到队列
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    [queue2 addOperation:op4];

## 小知识：@synchronized(token)同步互斥锁:token必须是全局唯一的，token一般是self。 多个线程执行同一个task时需要在task的代码里加锁。
    //锁:必须是全局唯一的
    //1.注意枷锁的位置
    //2.注意枷锁的前提条件,多线程共享同一块资源
    //3.注意加锁是需要代价的,需要耗费性能的
    //4.加锁的结果:线程同步
    @synchronized(self) {
        //线程1
        //线程2
        //线程3
        NSInteger count = self.totalCount;
        if (count >0) {
            
            for (NSInteger i = 0; i<1000000; i++) {
            }
            
            self.totalCount = count - 1;
            //卖出去一张票
            NSLog(@"%@卖出去了一张票,还剩下%zd张票", [NSThread currentThread].name,self.totalCount);
        }else
        {
            NSLog(@"不要回公司上班了");
            break;
        }
        }
    }
### 线程同步的意思是：多条线程在同一条线上执行（按顺序地执行任务）。互斥锁，就是使用了线程同步技术
### 线程间的通信是通过调用NSObject的performSelectorOnMainThread方法、performSelector方法进行通信的。
    //4.回到主线程显示UI
    // 第一个参数:回到主线程要调用哪个方法
    // 第二个参数:前面方法需要传递的参数 此处就是image
    // 第三个参数:是否等待
    [self performSelectorOnMainThread:@selector(showImage:) withObject:image waitUntilDone:NO];

    //在指定线程中执行
    [self performSelector:@selector(showImage:) onThread:[NSThread mainThread] withObject:image waitUntilDone:YES];

## xcode小知识：xcode7之后就默认不允许直接访问Http的URL，若需要访问，则需要修改配置文件info.plist
    APP transport.....

## 编程小知识：CF开头的类是C语言框架里的类，框架是core Foundation。例如CFTimeInterval


### ARC下的单例模式，alloc-->allocWithZone，实际上 类 为 实例对象 分配内存空间的方法是allocWithZone，所以每一次实例化对象都会调用allocWithZone。
#### 1、加互斥锁保证线程安全、或者dispatch_once_t保证线程安全
#### 2、提供类的方法返回单例对象。一般类方法的命名习惯是：share+类名|default + 类名 | share | default | 类名
#### 3、重写copy方法。
    //1.alloc-->allocWithZone
    +(instancetype)allocWithZone:(struct _NSZone *)zone
    {
        //加互斥锁解决多线程访问安全问题
    //    @synchronized(self) {
    //        if (_instance == nil) {
    //            _instance = [super allocWithZone:zone];
    //        }
    //    }
        
        //dispatch_once_t本身就是线程安全的
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [super allocWithZone:zone];
        });
        
        return _instance;
    }
    //2.提供类方法
    //1.方便访问
    //2.标明身份
    //3.注意:share+类名|default + 类名 | share | default | 类名
    +(instancetype)shareTool {
        return [[self alloc]init];
    }

    //3.严谨
    -(id)copyWithZone:(NSZone *)zone {
        return _instance;
    }
    -(id)mutableCopyWithZone:(NSZone *)zone {
        return _instance;
    }


## 编程小知识：条件编译 #if __has_feature(objc_arc) ...  #else...  #endif....
    #if __has_feature(objc_arc)
    //条件满足 ARC
    #else
    // MRC
    -(oneway void)release{
        
    }

    -(instancetype)retain{
        return _instance;
    }

    //习惯
    -(NSUInteger)retainCount{
        return MAXFLOAT;
    }
    #endif

### 定义全局宏来编写单例模式
    ◆ 宏文件Single.h：（\是去掉换行符，##是宏参数）
    #define SingleH(name) +(instancetype)share##name;

    #if __has_feature(objc_arc)
    //条件满足 ARC
    #define SingleM(name) static id _instance;\
    +(instancetype)allocWithZone:(struct _NSZone *)zone\
    {\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
    _instance = [super allocWithZone:zone];\
    });\
    \
    return _instance;\
    }\
    \
    +(instancetype)share##name\
    {\
    return [[self alloc]init];\
    }\
    \
    -(id)copyWithZone:(NSZone *)zone\
    {\
    return _instance;\
    }\
    \
    -(id)mutableCopyWithZone:(NSZone *)zone\
    {\
    return _instance;\
    }

    #else
    //MRC
    #define SingleM(name) static id _instance;\
    +(instancetype)allocWithZone:(struct _NSZone *)zone\
    {\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
    _instance = [super allocWithZone:zone];\
    });\
    \
    return _instance;\
    }\
    \
    +(instancetype)share##name\
    {\
    return [[self alloc]init];\
    }\
    \
    -(id)copyWithZone:(NSZone *)zone\
    {\
    return _instance;\
    }\
    \
    -(id)mutableCopyWithZone:(NSZone *)zone\
    {\
    return _instance;\
    }\
    -(oneway void)release\
    {\
    }\
    \
    -(instancetype)retain\
    {\
        return _instance;\
    }\
    \
    -(NSUInteger)retainCount\
    {\
        return MAXFLOAT;\
    }
    #endif
    
  
    ◆ .h文件中 (  在单例类代码里，头文件中引入宏文件)
    #import <Foundation/Foundation.h>
    #import "Single.h"

    @interface XMGDownloadTool : NSObject

    SingleH(DownloadTool)
    @end
    
    ◆ .m文件中
    #import "XMGDownloadTool.h"

    @implementation XMGDownloadTool

    SingleM(DownloadTool)
    @end

----------------------
day03:
----------------------
## SB小知识：tableview的cell是通过ID与SB绑定的，通过复用池取出。
## 编程小知识：用数组或者字典作为网络下载的缓存，比网络下载快一万倍不止，数组和字典之间的性能差异可以直接忽略不计，按需来。

### ◇ 多线程结合网络下载多张图片的示例代码
#### 1、tableview的刷新某行的方法reloadRowsAtIndexPaths，可以在cellforitem方法体中放在主线程block来刷新。
#### 2、避免多个NSOperation的任务是一样的，导致重复下载网络资源的问题，可以将NSOperation放在一个数组中缓存起来，先判断NSOperation存在与否，再开任务加队列。

    //1.UI很不流畅 --- > 开子线程下载图片
    //2.图片重复下载 ---> 先把之前已经下载的图片保存起来(字典)
    //内存缓存--->磁盘缓存

    //3.图片不会刷新--->刷新某行
    //4.图片重复下载(图片下载需要时间,当图片还未完全下载之前,又要重新显示该图片)
    //5.数据错乱 ---设置占位图片

    /*
     Documents:会备份,不允许
     Libray
        Preferences:偏好设置 保存账号
        caches:缓存文件
     tmp:临时路径(随时会被删除)
     */
    -(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
        static NSString *ID = @"app";
        
        //1.创建cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        //2.设置cell的数据
        //2.1 拿到该行cell对应的数据
        XMGAPP *appM = self.apps[indexPath.row];
        
        //2.2 设置标题
        cell.textLabel.text = appM.name;
        
        //2.3 设置子标题
        cell.detailTextLabel.text = appM.download;
        
        //2.4 设置图标
        
        //先去查看内存缓存中该图片时候已经存在,如果存在那么久直接拿来用,否则去检查磁盘缓存
        //如果有磁盘缓存,那么保存一份到内存,设置图片,否则就直接下载
        //1)没有下载过
        //2)重新打开程序
        
        UIImage *image = [self.images objectForKey:appM.icon];
        if (image) {
            cell.imageView.image = image;
            NSLog(@"%zd处的图片使用了内存缓存中的图片",indexPath.row) ;
        }else{
            //保存图片到沙盒缓存
            NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            //获得图片的名称,不能包含/
            NSString *fileName = [appM.icon lastPathComponent];
            //拼接图片的全路径
            NSString *fullPath = [caches stringByAppendingPathComponent:fileName];
            
            //检查磁盘缓存
            NSData *imageData = [NSData dataWithContentsOfFile:fullPath];
            //废除
            imageData = nil;
            
            if (imageData) {
                UIImage *image = [UIImage imageWithData:imageData];
                cell.imageView.image = image;
                
                NSLog(@"%zd处的图片使用了磁盘缓存中的图片",indexPath.row) ;
                //把图片保存到内存缓存
                [self.images setObject:image forKey:appM.icon];
            }else
            {
                //检查该图片时候正在下载,如果是那么久什么都捕捉,否则再添加下载任务
                NSBlockOperation *download = [self.operations objectForKey:appM.icon];
                if (download) {
                    
                }else{
                    //先清空cell原来的图片
                    cell.imageView.image = [UIImage imageNamed:@"Snip20160221_306"];
                    
                    download = [NSBlockOperation blockOperationWithBlock:^{
                        NSURL *url = [NSURL URLWithString:appM.icon];
                        NSData *imageData = [NSData dataWithContentsOfURL:url];
                        UIImage *image = [UIImage imageWithData:imageData];
                        
                         NSLog(@"%zd--下载---",indexPath.row);
                        
                        //容错处理，避免图片的url错误导致图片下载不完整
                        if (image == nil) {
                            [self.operations removeObjectForKey:appM.icon];
                            return ;
                        }
                        //演示网速慢的情况
                        //[NSThread sleepForTimeInterval:3.0];
                    
                        //把图片保存到内存缓存
                        [self.images setObject:image forKey:appM.icon];
                        
                        //NSLog(@"Download---%@",[NSThread currentThread]);
                        //线程间通信
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            
                            //cell.imageView.image = image;
                            //刷新一行
                            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                            //NSLog(@"UI---%@",[NSThread currentThread]);
                        }];
                        
                        //写数据到沙盒
                        [imageData writeToFile:fullPath atomically:YES];
                       
                        //移除图片的下载操作
                        [self.operations removeObjectForKey:appM.icon];
                        
                    }];
                    
                    //添加操作到操作缓存中，操作作为缓存
                    [self.operations setObject:download forKey:appM.icon];
                    
                    //添加操作到队列中
                    [self.queue addOperation:download];
                }
                
            }
        }
        
        //3.返回cell
        return cell;
    }

#### 3、使用内存的空间作为缓存的话(不是沙盒作为缓存)，记得处理内存过高警告，重写VC的didReceiveMemoryWarning方法。
    -(void)didReceiveMemoryWarning
    {
        [self.images removeAllObjects];
        
        //取消队列中所有的操作
        [self.queue cancelAllOperations];
    }

## SDWebImage第三方框架，是一个为UIImageView提供一个分类来支持远程服务器图片加载的库。
### 1、SDWebImage基本使用：
    01 设置imageView的图片
       [cell.imageView sd_setImageWithURL:[NSURL URLWithString:app.icon] placeholderImage:[UIImage imageNamed:@"placehoder"]];

       02 设置图片并计算下载进度
          //下载并设置图片
       /*
        第一个参数：要下载图片的url地址
        第二个参数：设置该imageView的占位图片
        第三个参数：传一个枚举值，告诉程序你下载图片的策略是什么
        第一个block块：获取当前图片数据的下载进度
            receivedSize：已经下载完成的数据大小
            expectedSize：该文件的数据总大小
        第二个block块：当图片下载完成之后执行该block中的代码
            image:下载得到的图片数据
            error:下载出现的错误信息
            SDImageCacheType：图片的缓存策略（不缓存，内存缓存，沙盒缓存）
            imageURL：下载的图片的url地址
        */
       [cell.imageView sd_setImageWithURL:[NSURL URLWithString:app.icon] placeholderImage:[UIImage imageNamed:@"placehoder"] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {

           //计算当前图片的下载进度
           NSLog(@"%.2f",1.0 *receivedSize / expectedSize);

       } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

       }];

       03 系统级内存警告如何处理（面试）
       //取消当前正在进行的所有下载操作
       [[SDWebImageManager sharedManager] cancelAll];

       //清除缓存数据(面试)
       //cleanDisk：删除过期的文件数据，计算当前未过期的已经下载的文件数据的大小，如果发现该数据大小大于我们设置的最大缓存数据大小，那么程序内部会按照按文件数据缓存的时间从远到近删除，知道小于最大缓存数据为止。

       //clearMemory:直接删除文件，重新创建新的文件夹
       //[[SDWebImageManager sharedManager].imageCache cleanDisk];
       [[SDWebImageManager sharedManager].imageCache clearMemory];

       04 SDWebImage默认的缓存时间是1周
       05 如何播放gif图片
       /*
       5-1 把用户传入的gif图片->NSData
       5-2 根据该Data创建一个图片数据源（NSData->CFImageSourceRef）
       5-3 计算该数据源中一共有多少帧，把每一帧数据取出来放到图片数组中
       5-4 根据得到的数组+计算的动画时间-》可动画的image
       [UIImage animatedImageWithImages:images duration:duration];
       */

       06 如何判断当前图片类型，只判断图片二进制数据的第一个字节
       + (NSString *)sd_contentTypeForImageData:(NSData *)data;

       07 内部如何进行缓存处理？使用了NSCache类，使用和NSDictionary类似
       08 沙盒缓存图片的命名方式为对该图片的URL进行MD5加密  echo -n "url" |MD5
       09 当接收到内存警告之后，内部会自动清理内存缓存
       10 图片的下载顺序，默认是先进先出的

### 2、
### 3、

## 编程小技巧：Int变成double型，只要 乘以 1.0 就可以了。

### AppDelegate也有接收内存警告的方法，可以在这里清除缓存，-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application。

### NSCache(苹果)是专门用来进行缓存处理的，使用方法和NSDictionary相似，内存很低时会自动释放对象。
    _cache = [[NSCache alloc]init];
    _cache.totalCostLimit = 5;//总成本数是5 ,如果发现存的数据超过中成本那么会自动回收之前的对象，与set方法的count参数对应。
    _cache.delegate = self;
    [self.cache setObject:data forKey:@(i) cost:1];
    
     02.NSCache简单介绍：
        2-1 NSCache是苹果官方提供的缓存类，具体使用和NSDictionary类似，在AFN和SDWebImage框架中被使用来管理缓存
        2-2 苹果官方解释NSCache在系统内存很低时，会自动释放对象（但模拟器演示不会释放）
            建议：接收到内存警告时主动调用removeAllObject方法释放对象
        2-3 NSCache是线程安全的，在多线程操作中，不需要对NSCache加锁
        2-4 NSCache的Key只是对对象进行Strong引用，不是拷贝

     03 属性介绍：
        name:名称
        delegete:设置代理
        totalCostLimit：缓存空间的最大总成本，超出上限会自动回收对象。默认值为0，表示没有限制
        countLimit：能够缓存的对象的最大数量。默认值为0，表示没有限制
        evictsObjectsWithDiscardedContent：标识缓存是否回收废弃的内容

     04 方法介绍
    - (void)setObject:(ObjectType)obj forKey:(KeyType)key;//在缓存中设置指定键名对应的值，0成本
    - (void)setObject:(ObjectType)obj forKey:(KeyType)key cost:(NSUInteger)g; //在缓存中设置指定键名对应的值，并且指定该键值对的成本，用于计算记录在缓存中的所有对象的总成本，出现内存警告或者超出缓存总成本上限的时候，缓存会开启一个回收过程，删除部分元素
    - (void)removeObjectForKey:(KeyType)key;//删除缓存中指定键名的对象
    - (void)removeAllObjects;//删除缓存中所有的对象
    
## 位移枚举enum可以指定多个值，C语言的枚举不可以指定类型，OC的枚举写法可以指定类型typedef NS_ENUM。
### typedef NS_OPTIONS位移枚举可以指定多个值，也就就是可以用或、与运算。一般0不写作为什么都不干的默认值。
    //第一种写法
    typedef enum
    {
        XMGDemoTypeTop,
        XMGDemoTypeBottom,
    }XMGDemoType;

    //第二种枚举,定义类型
    typedef NS_ENUM(NSInteger,XMGType)  //第一个参数指定该枚举的类型是NSInteger，第二个参数时枚举的类型名称
    {
        XMGTypeTop,
        XMGTypeBottom,
    };

    //第三种枚举 ,位移枚举
    //一个参数可以传递多个值
    //如果是位移枚举,观察第一个枚举值,如果该枚举值!=0 那么可以默认传0做参数,如果传0做参数,那么效率最高
    typedef NS_OPTIONS(NSInteger, XMGActionType)    //第二个参数是枚举的类型名称
    {
        XMGActionTypeTop = 1<<0,  //1*2(0) =1
        XMGActionTypeBottom = 1<<1,//1*2(1)=2
        XMGActionTypeLeft = 1<<2,//1*2(2)=4
        XMGActionTypeRight = 1<<3,//8
    };
    
    //方法的定义
    -(void)demo:(XMGActionType)type
    {
        NSLog(@"%zd",type);
        
        if (type & XMGActionTypeTop) {
            NSLog(@"向上---%zd",type & XMGActionTypeTop);
        }
        
        if (type & XMGActionTypeRight) {
            NSLog(@"向右---%zd",type & XMGActionTypeRight);
        }
        if (type & XMGActionTypeBottom) {
            NSLog(@"向下---%zd",type & XMGActionTypeBottom);
        }
        
        if (type & XMGActionTypeLeft) {
            NSLog(@"向左---%zd",type & XMGActionTypeLeft);
        }
        
    }
    
    //位移枚举的使用
    [self demo:XMGActionTypeTop | XMGActionTypeRight | XMGActionTypeLeft |XMGActionTypeBottom];



## Runloop是运行时循环，用于保持任务的执行。主线程的RunLoop已经自动创建好了，子线程的RunLoop需要主动 写代码获取(懒加载创建的)，runloop随线程的死亡而死亡， 但是runloop可以通过添加任务让线程不死，也就是可以 管理线程，共生关系。
    
### 1、Runloop也是一个对象，也有对应的定义类，Main函数的返回值就是返回了Runloop对象。
    return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));

### 2、NSRunLoop是基于CFRunLoopRef的一层OC包装，CFRunLoopRef是用C语言写的，所以你要理解CFRunLoopRef类。
### 3、触摸事件、定时器事件【NSTimer】、selector事件【选择器·performSelector···】都是通过runloop机制进行管理的。
### 4、获取runloop对象，注意点：开一个子线程创建runloop,不是通过alloc init方法创建， 而是直接通过调用currentRunLoop方法来创建， 它本身是一个懒加载的。
    1.获得当前Runloop对象
        NSRunLoop * runloop1 = [NSRunLoop currentRunLoop];  //01 NSRunloop
        CFRunLoopRef runloop2 =   CFRunLoopGetCurrent();    //02 CFRunLoopRef

    2.拿到当前应用程序的主Runloop（主线程对应的Runloop）
         NSRunLoop * runloop1 = [NSRunLoop mainRunLoop];    //01 NSRunloop
         CFRunLoopRef runloop2 =   CFRunLoopGetMain();  //02 CFRunLoopRef
         
    3.注意点：开一个子线程创建runloop,不是通过alloc init方法创建，而是直接通过调用currentRunLoop方法来创建，它本身是一个懒加载的。
    4.在子线程中，如果不主动获取Runloop的话，那么子线程内部是不会创建Runloop的。可以下载CFRunloopRef的源码，搜索_CFRunloopGet0,查看代码。
    5.Runloop对象是利用字典来进行存储，而且key是对应的线程Value为该线程对应的Runloop。

### 5、每个线程都只有一个唯一与之对应的runloop对象，是一一对应的。
### 6、Runloop机制主要角色有：运行模式(常用的3种)、输入源(系统与人工)、定时器、观察者(观察runloop状态，即线程执行情况)。
    a.CFRunloopRef
    b.CFRunloopModeRef【Runloop的运行模式】
    c.CFRunloopSourceRef【Runloop要处理的事件源】
    d.CFRunloopTimerRef【Timer事件】
    e.CFRunloopObserverRef【Runloop的观察者（监听者）】
#### 1、Runloop要想跑起来，它的内部必须要有一个mode,这个mode里面必须有source\observer\timer，至少要有其中的一个。
    系统默认注册了5个mode
    a.kCFRunLoopDefaultMode：App的默认Mode，通常主线程是在这个Mode下运行
    b.UITrackingRunLoopMode：界面跟踪 Mode，用于 ScrollView 追踪触摸滑动，保证界面滑动时不受其他 Mode 影响
    c.UIInitializationRunLoopMode: 在刚启动 App 时第进入的第一个 Mode，启动完成后就不再使用
    d.GSEventReceiveRunLoopMode: 接受系统事件的内部 Mode，通常用不到
    e.kCFRunLoopCommonModes: 这是一个占位用的Mode，不是一种真正的Mode
    
#### 2、NSTimer在runloop中的使用，addTimer方法。NSTimer 调用了scheduledTimer方法， 那么会自动添加到当前的runloop里面去 (默认运行模式)。
    //NSTimer 调用了scheduledTimer方法，那么会自动添加到当前的runloop里面去，而且runloop的运行模式kCFRunLoopDefaultMode
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
    //更改模式，第一个参数:定时器、 第二个参数:runloop的运行模式
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
##### 定时器添加到UITrackingRunLoopMode(界面追踪)模式，一旦runloop切换模式，那么定时器就不工作
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];

##### 定时器添加到NSDefaultRunLoopMode模式，一旦runloop切换模式，那么定时器就不工作
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];

##### 占位模式：common modes标记，不指定模式，定时器可以在上面两种模式切换时仍然工作。
    //被标记为common modes的模式，相当于kCFRunLoopDefaultMode和UITrackingRunLoopMode模式。
    //凡是添加到NSRunLoopCommonModes中的事件都会被同时添加到打上commmon标签的运行模式上
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

#### runloop一启动就会选中一种模式，当选中了一种模式之后其它的模式就都不鸟。一个mode里面可以添加多个NSTimer,也就是说以后 当创建NSTimer的时候，可以指定它是在什么模式下运行的。
#### NSTimer是基于时间的触发器，说直白点那就是时间到了我就触发一个事件，触发一个操作。基本上说的就是NSTimer
 
#### ◆ 如果要子线程的定时器工作，那么必须要获取到子线程的runloop对象，并将该定时器添加到该runloop对象中。
    

---------------
day04:
--------------------
## GCD中的定时器其实是输入源的一种，设置参数DISPATCH_SOURCE_TYPE_TIMER就是定时器了， dispatch_source_t类型。
### 1、GCD的定时器要调用全局方法，以定时器为参数，进行设置参数的定时时间，dispatch_source_set_timer，GCD定时器的单位是纳秒。
### 2、GCD的定时器的任务设置，也是要调用全局方法，dispatch_source_set_event_handler，启动也是调用全局方法dispatch_resume
    //1.创建GCD中的定时器
    /*
     第一个参数:source的类型DISPATCH_SOURCE_TYPE_TIMER 表示是定时器
     第二个参数:描述信息,线程ID
     第三个参数:更详细的描述信息
     第四个参数:队列,决定GCD定时器中的任务在哪个线程中执行
     */
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    
    //2.设置定时器(起始时间|间隔时间|精准度)
    /*
     第一个参数:定时器对象
     第二个参数:起始时间,DISPATCH_TIME_NOW 从现在开始计时
     第三个参数:间隔时间 2.0 GCD中时间单位为纳秒
     第四个参数:精准度 绝对精准0
     */
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    
    //3.设置定时器执行的任务
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"GCD---%@",[NSThread currentThread]);
    });
    
    //4.启动执行
    dispatch_resume(timer);


## Runloop的事件源CFRunloopSourceRef，Source0：非基于Port的，Source1：基于Port的。
### 1、如果是用户主动触发的就是Scource0(非端口)事件，如果是系统触发的就是Scource1(端口的)事件
    可以通过打断点的方式查看一个方法的函数调用栈，在方法调用栈中会有一个_CFRunloopDoSource0

## Runloop的观察者CFRunLoopObserverRef，能够监听RunLoop的状态改变
### 1、也是创建一个监听者，作为全局方法CFRunLoopAddObserver的参数，去监听runloop对象。
### 2、Runloop的状态，运行流程：
####  kCFRunLoopEntry = (1UL << 0), 即将进入runloop，
####  kCFRunLoopBeforeTimers = (1UL << 1), 即将处理timer事件
####  kCFRunLoopBeforeSources = (1UL << 2),即将处理source事件
####  kCFRunLoopBeforeWaiting = (1UL << 5),即将进入睡眠
####  kCFRunLoopAfterWaiting = (1UL << 6), 被唤醒
####  kCFRunLoopExit = (1UL << 7),         runloop退出
    //1.创建监听者
    /*
     第一个参数:怎么分配存储空间
     第二个参数:要监听的状态 kCFRunLoopAllActivities 所有的状态
     第三个参数:时候持续监听
     第四个参数:优先级 总是传0
     第五个参数:当状态改变时候的回调
     */
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        
        /*
         kCFRunLoopEntry = (1UL << 0),        即将进入runloop
         kCFRunLoopBeforeTimers = (1UL << 1), 即将处理timer事件
         kCFRunLoopBeforeSources = (1UL << 2),即将处理source事件
         kCFRunLoopBeforeWaiting = (1UL << 5),即将进入睡眠
         kCFRunLoopAfterWaiting = (1UL << 6), 被唤醒
         kCFRunLoopExit = (1UL << 7),         runloop退出
         kCFRunLoopAllActivities = 0x0FFFFFFFU
         */
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"即将进入runloop");
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"即将处理timer事件");
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"即将处理source事件");
                break;
            case kCFRunLoopBeforeWaiting:
                NSLog(@"即将进入睡眠");
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"被唤醒");
                break;
            case kCFRunLoopExit:
                NSLog(@"runloop退出");
                break;
                
            default:
                break;
        }
    });
    
    /*
     第一个参数:要监听哪个runloop
     第二个参数:观察者
     第三个参数:运行模式
     //NSDefaultRunLoopMode == kCFRunLoopDefaultMode
     //NSRunLoopCommonModes == kCFRunLoopCommonModes
     */
    CFRunLoopAddObserver(CFRunLoopGetCurrent(),observer, kCFRunLoopDefaultMode);

## ios要开启常驻子线程，那么只需要在子线程中开启一个runloop对象，是懒加载获取的 [NSRunLoop currentRunLoop];。
### 1、子线程执行完任务之后，就自动销毁，所以要给子线程获取一个runloop对象(可以在子线程的任务中获取)，使得子线程不会被销毁，同时管理子线程的生命周期和任务。
### 2、runloop需要运行模式和事件才可以保持一直执行，不然直接调用run方法后，马上又销毁。 [runloop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:10]];//10秒后销毁。
    -(void)task1
    {
        NSLog(@"task1---%@",[NSThread currentThread]);
    //    while (1) {
    //       NSLog(@"task1---%@",[NSThread currentThread]);
    //    }
        //解决方法:开runloop
        //1.获得子线程对应的runloop
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        
        //保证runloop不退出，要么有定时器，要么有时间源
        //NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
        //[runloop addTimer:timer forMode:NSDefaultRunLoopMode];
        [runloop addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
        
        //2.run方法是一直执行，runUntilDate是执行参数的时间后runloop自己销毁
        [runloop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:10]];
        
        //runloop销毁后才会打印---end----，也就是runloop开启后，task1一直执行到这里。
        NSLog(@"---end----");
    }
 ### 3、退出runloop，通过调用CFRunLoopStop(CFRunLoopGetCurrent());方法。如果没有一个输入源或者timer附加于runloop上，runloop就会立刻退出(不建议)。
        - (void)run;    //苹果不建议该方法退出runloop，因为系统内部有可能会在当前线程的runloop中添加一些输入源，所以通过手动移除input source或者timer这种方式，并不能保证runloop一定会退出。
        - (void)runUntilDate:(NSDate *)limitDate；
        - (void)runMode:(NSString *)mode beforeDate:(NSDate *)limitDate;
        
        (1) 第一种方式，runloop会一直运行下去，在此期间会处理来自输入源的数据，并且会在NSDefaultRunLoopMode模式下重复调用runMode:beforeDate:方法；
        (2) 第二种方式，可以设置超时时间，在超时时间到达之前，runloop会一直运行，在此期间runloop会处理来自输入源的数据，并且也会在NSDefaultRunLoopMode模式下重复调用runMode:beforeDate:方法；
        (3) 第三种方式，runloop会运行一次，超时时间到达或者第一个input source被处理，则runloop就会退出。

### 4、Runloop中自动释放池的第一次创建是在启动runloop的时候，最后一次销毁是在runloop退出的时候。
#### 4.1、runloop自动释放池其他时候的创建和销毁:当runloop即将睡眠的时候销毁之前的释放池,重新创建一个新的。
#### 4.2、runloop自动释放池是用于释放在runloop运行期间产生的变量强引用。

## 网络的基础 
### 1、iOS中发送http请求的方案
#### 1.1、 苹果原生：NSURLConnection、NSURLSession【重点】、CFNetwork(太底层，几乎不用)
    NSURLConnection 03年推出的古老技术
    NSURLSession     13年推出iOS7之后，以取代NSURLConnection【重点】
    CFNetwork        底层技术、C语言的
#### 1.2、第三方框架：ASIHttpRequest、 AFNetworking  【重点】、MKNetworkKit

    网络基本概念
          2-1 客户端（就是手机或者ipad等手持设备上面的APP）
          2-2 服务器（远程服务器-本地服务器）
          2-3 请求（客户端索要数据的方式）
          2-4 响应（需要客户端解析数据）
          2-5 数据库（服务器的数据从哪里来）

    001 URL
          1-1 如何找到服务器（通过一个唯一的URL）
          1-2 URL介绍
              a. 统一资源定位符
              b. URL的基本格式 = 协议://主机地址/路径
                  协议：不同的协议，代表着不同的资源查找方式、资源传输方式
                  主机地址：存放资源的主机（服务器）的IP地址（域名）
                  路径：资源在主机（服务器）中的具体位置

          1-3 请求协议
              【file】访问的是本地计算机上的资源，格式是file://（不用加主机地址）
              【ftp】访问的是共享主机的文件资源，格式是ftp://
              【mailto】访问的是电子邮件地址，格式是mailto:
              【http】超文本传输协议，访问的是远程的网络资源，格式是http://（网络请求中最常用的协议）

      002 http协议
          2-1 http协议简单介绍
              a.超文本传输协议
              b.规定客户端和服务器之间的数据传输格式
              c.让客户端和服务器能有效地进行数据沟通

          2-2 http协议优缺点
              a.简单快速（协议简单，服务器端程序规模小，通信速度快）
              b.灵活（允许传输各种数据）
              c.非持续性连接(1.1之前版本是非持续的，即限制每次连接只处理一个请求，服务器对客户端的请求做出响应后，马上断开连接，这种方式可以节省传输时间)
          2-3 基本通信过程
          请求的协议格式：
                HTTP协议规定：1个完整的由客户端发给服务器的HTTP请求中包含以下内容
                请求头：包含了对客户端的环境描述、客户端请求信息等
                GET /minion.png HTTP/1.1   // 包含了请求方法、请求资源路径、HTTP协议版本
                Host: 120.25.226.186:32812     // 客户端想访问的服务器主机地址
                User-Agent: Mozilla/5.0  // 客户端的类型，客户端的软件环境
                Accept: text/html, */*     // 客户端所能接收的数据类型
                Accept-Language: zh-cn     // 客户端的语言环境
                Accept-Encoding: gzip     // 客户端支持的数据压缩格式
                
                请求体：客户端发给服务器的具体数据，比如文件数据(POST请求才会有)
                
          响应的协议格式：
                HTTP协议规定：1个完整的服务端HTTP响应中包含以下内容
                响应头：包含了对服务器的描述、对返回数据的描述
                HTTP/1.1 200 OK            // 包含了HTTP协议版本、状态码、状态英文名称
                Server: Apache-Coyote/1.1         // 服务器的类型
                Content-Type: image/jpeg         // 返回数据的类型
                Content-Length: 56811         // 返回数据的长度
                Date: Mon, 23 Jun 2014 12:54:52 GMT    // 响应的时间
                
                响应体：服务器返回给客户端的具体数据，比如文件数据

      003 GET和POST请求
          3-1 http里面发送请求的方法
          GET（常用）、POST（常用）、OPTIONS、HEAD、PUT、DELETE、TRACE、CONNECT、PATCH

          3-2 GET和POST请求的对比【区别在于参数如何传递】
              GET
              在请求URL后面以?的形式跟上发给服务器的参数，多个参数之间用&隔开，比如
              http://ww.test.com/login?username=123&pwd=234&type=JSON
              由于浏览器和服务器对URL长度有限制，因此在URL后面附带的参数是有限制的，通常不能超过1KB

              POST
              发给服务器的参数全部放在请求体中
              理论上，POST传递的数据量没有限制（具体还得看服务器的处理能力）

          3-3 如何选择【除简单数据查询外，其它的一律使用POST请求】
              a.如果要传递大量数据，比如文件上传，只能用POST请求
              b.GET的安全性比POST要差些，如果包含机密\敏感信息，建议用POST
              c.如果仅仅是索取数据（数据查询），建议使用GET
              d.如果是增加、修改、删除数据，建议使用POST

      005 http请求通信过程
          5-1 请求
              【包括请求头+请求体·非必选】
          5-2 响应
              【响应头+响应体】
          5-3 通信过程
              a.发送请求的时候把请求头和请求体（请求体是非必须的）包装成一个请求对象
              b.服务器端对请求进行响应，在响应信息中包含响应头和响应体，响应信息是对服务器端的描述，具体的信息放在响应体中传递给客户端
          5-4 状态码
              【200】：请求成功
              【400】：客户端请求的语法错误，服务器无法解析
              【404】：无法找到资源
              【500】：服务器内部错误，无法完成请求
#### 1.3、GET请求，在请求URL后面以?的形式跟上发给服务器的参数，多个参数之间用&隔开。获取数据时用GET，没有请求体。
    http://ww.test.com/login?username=123&pwd=234&type=JSON
#### 1.4、POST请求，参数放在请求体里面。不是获取数据的请求，用POST。
#### 1.5、对于请求头和相应头，请求头主要是对客户端的描述，数据放在请求体。相应头是对服务端的描述，数据放在相应体。
#### 1.6、NSURLConnection 负责发送请求，建立客户端和服务器的连接。发送数据给服务器，并收集来自服务器的响应数据。
##### 1、创建一个NSURL对象，设置请求路径 --> 传入NSURL创建一个NSURLRequest对象，设置请求头和请求体 --> 使用NSURLConnection发送请求
    //该方法是阻塞的,即如果该方法没有执行完则后面的代码将得不到执行，异步请求方法是sendAsynchronousRequest
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
##### 2、NSURLRequest对象自动生成默认的请求头，请求方法--->默认为GET。
    /*
     GET:http://120.25.226.186:32812/login?username=123&pwd=456&type=JSON
     协议+主机地址+接口名称+?+参数1&参数2&参数3
     post:http://120.25.226.186:32812/login
     协议+主机地址+接口名称
     */
    //GET,没有请求体
    //1.确定请求路径
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login?username=520it&pwd=520it&type=JSON"];
    
    //2.创建请求对象
    //NSURLRequest自动生成默认的请求头，请求方法--->默认为GET
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    
    //3.发送请求
    //真实类型:NSHTTPURLResponse
    NSHTTPURLResponse *response = nil;
    /*
     第一个参数:请求对象
     第二个参数:响应头信息
     第三个参数:错误信息
     返回值:响应体
     */
    //该方法是阻塞的,即如果该方法没有执行完则后面的代码将得不到执行
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    //4.解析 data--->字符串
    //NSUTF8StringEncoding
    NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    
    NSLog(@"%zd",response.statusCode);
##### 3、NSURLConnection的sendSynchronousRequest类方法是同步的请求，sendAsynchronousRequest类方法是异步请求。
    //3.1、发送异步请求
     第一个参数:请求对象
     第二个参数:队列 决定代码块completionHandler的调用线程
     第三个参数:completionHandler 当请求完成(成功|失败)的时候回调
                    response:响应头
                    data:响应体
                    connectionError:错误信息
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        //4.解析数据
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
        NSLog(@"%zd",res.statusCode);
        NSLog(@"%@",[NSThread currentThread]);
    }];
##### 4、NSURLConnection初始化时可以设置代理对象NSURLConnectionDataDelegate，来获取对应的连接状态、数据传输的信息。
    //3.设置代理,发送请求
    //[NSURLConnection connectionWithRequest:request delegate:self];
    
    //[[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    //3.3 设置代理,发送请求时需要检查startImmediately的值
    //(startImmediately == YES 会发送 | startImmediately == NO 则需要调用start方法)
    NSURLConnection * connect = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:NO];
    
    //调用开始方法
    [connect start];
 ##### 5、NSURLConnection的POST请求，使用NSMutableURLRequest，设置请求方法、请求体request.HTTPBody是数组。
    //1.确定请求路径
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login"];
    
    //2.创建可变请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //3.修改请求方法,POST必须大写
    request.HTTPMethod = @"POST";
    
    //设置属性,请求超时
    request.timeoutInterval = 10;
    
    //设置请求头User-Agent
    //注意:key一定要一致(用于传递数据给后台)
    [request setValue:@"ios 10.1" forHTTPHeaderField:@"User-Agent"];
    
    //4.设置请求体信息,字符串--->NSData
    request.HTTPBody = [@"username=520it&pwd=123&type=JSON" dataUsingEncoding:NSUTF8StringEncoding];
    
    //5.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
       
        //6.解析数据,NSData --->NSString
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
### URL里地址的中文转码，不转码会报错，是百分号转码。POST请求里的参数则不需要转码，因为没有在URL里，而是在请求体里。
    NSString *urlStr = @"http://120.25.226.186:32812/login2?username=小码哥&pwd=520it&type=JSON";
    //中文转码处理
    urlStr =  [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

### NSJSONSerialization对象是苹果提供用于解析JSON的类，实现JSON字符串与OC基本类型之间的互转。
        JSON         OC
    大括号 { }    NSDictionary
    中括号 [ ]    NSArray
    双引号 " "    NSString
    数字 10、10.8    NSNumber
    
    使用NSJSONSerialization的类方法：
    JSON数据 --> OC对象 （反序列化）
    + (id)JSONObjectWithData:(NSData *)data options:(NSJSONReadingOptions)opt error:(NSError **)error;

    OC对象 --> JSON数据  （序列化）
    + (NSData *)dataWithJSONObject:(id)obj options:(NSJSONWritingOptions)opt error:(NSError **)error;

#### 1、JSON可以反序列化为NSDictionary、NSArray、NSString、NSNumber




