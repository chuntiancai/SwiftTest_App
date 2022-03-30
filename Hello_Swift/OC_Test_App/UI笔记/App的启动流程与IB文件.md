

## App的启动流程：
### 程序从main函数启动，main函数就会去通知Appdelegate去寻找Main Interface，找到之后 就会加载Main.storyboard文件，然后就会去初始化Main.storyboard绑定的VC，然后就这样执行下去了 。(Main.storyboard可以在Target -> General -> Deployment Info -> Main Interface 中自定义).
#### 程序会根据storyboard的内容创建相应的VC和view
    一般都是命名为Main.storyboard，你也可以自定义命名为xxx.storyboard,但是如果xxx.storyboard作为启动VC，那么必须在storyboraad的VC的属性中勾选 is initial View Controller 。
    storyboard是一个scene，是一个画布，要忘上面添加组件，例如VC、View、button等等进行绘制。

    
### Stroyboard技巧：创建storyboard之后，直接添加VC控件就可以了。按住 控件+Optional键+鼠标拖动 就可以复制该控件。

## Storyboard知识：
    
### IBAction连线方法：用于连线storyboard中的控件与方法代码，是方法的返回值类型，相当于Void
    - (IBAction)buttonClick{
        //方法代码
    }
    
    

### IBOutlet连线属性：用于连线storyboard中的控件与属性
    @property (nonatomic, weak) IBOutlet UILabel *label;
    
    关于IBAction、IBOutlet前缀IB的解释

    全称：Interface Builder
    以前的UI界面开发模式：Xcode3 + Interface Builder
    从Xcode4开始，Interface Builder已经整合到Xcode中了
    
### IB技巧：右键点击sb上的控件可以删除连线，也可以连线到空白代码处；可以从代码的左侧小点连线到sb上，也可以从sb上连线到空白代码处。
### IB知识：常用的连线是sb直接按住ctrl键 拖到代码空白处，一个sb控件可以连线多个方法。
    经典的错误
      1. 错误一
       描述:
         reason: '[<MainViewController 0x7ffebbc1a880> setValue:forUndefinedKey:]: this class is not key value coding-compliant for the key testLabel.'
       原因: 有多余的连线
       解决: 删除多余的连线
    
      2.错误二
       描述:
         reason: '-[MainViewController clickBtn:]: unrecognized selector sent to instance 0x7feb69418640'
       原因:找不到对应的方法
       解决:1.添加对应的方法  2.删除多余的连线

