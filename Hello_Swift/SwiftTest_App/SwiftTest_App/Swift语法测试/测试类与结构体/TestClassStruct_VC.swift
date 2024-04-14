//
//  TestClassStruct_VC.swift
//  SwiftTest_App
//
//  Created by mathew on 2022/7/4.
//  Copyright © 2022 com.mathew. All rights reserved.
//
//测试类与结构体的VC
// MARK: - 笔记
/**
 
    iOS 中的内存大致可以分为代码区，全局/静态区，常量区，堆区，栈区，其地址由低到高。
    所以是通过这一系列系统方法，创建了一个对象，对应 就是堆内存上的一段空间。
    而在对应的C++语言上，描述这段空间的结构体 就是 通过一系列HeapObject结构体 创建出结构体来 对应这段空间(即swift的所谓meta)。
    
    对象对应的内存空间上的内容：
        前8个字节：存放类型相关信息  //方法体所在的地址从这里去寻找。方法是独立放在一段内存空间里的，class和struct的维护方式不同。
        接下来8个字节：存放引用计数  //内存管理
        后面的字节：存放你定义的变量1、2、3. . .
 
    1、class是引用类型，也就是方法栈上的class实例的变量是指针，该指针指向内存的堆空间，是实例对象所占的堆空间的首地址。
        let关键字声明，是这方法栈上的变量的值不可变，并不是不能修改堆内存上的值，所以let声明class实例对象的属性可以改变。
        class里的用let声明属性不能改变，是指这时候的let绑定的是变量所在内存地址上的值不能变了，所以就是属性的值不能变了。
 
        class 被设计为用于创建具有继承层次结构的对象。它们适用于那些需要在多个地方共享状态和行为的情况，例如模型、视图控制器和管理器等。
 
    Swift对象本质在C++的实现中是一个HeapObject结构体指针，HeapObject结构中有两个成员变量，metadata 和 refCounts，
    metadata 是指向元数据对象的指针，里面存储着类的信息，比如属性信息，虚函数表等。而refCounts 是一个引用计数信息相关的东西。
 

    创建类的实例对象的底层原理：
        1、从执行构造函数开始，系统执行的方法流程(创建对象)是：
            swift_allocObject --> _swift_allocObject_ --> swift_slowAlloc --> malloc
 
        所以是通过这一系列系统方法，创建了一个对象，就是堆内存上的一段空间。
        而在对应的C++语言上，描述这段空间的结构体就是HeapObject结构体。
 
            最终返回的对象类型是HeapObject *，所有类都是该类型结构。
                struct HeapObject { //堆对象
                    HeapMetadata const *metadata;   //元数据类型
                    SWIFT_HEAPOBJECT_NON_OBJC_MEMBERS;  //refCounts，引用计数
                    
                    // 省略初始化方法
                };

            而元数据类型，是TargetHeapMetadata的别名：
                struct TargetHeapMetadata : TargetMetadata<Runtime> {
                    using HeaderType = TargetHeapMetadataHeader<Runtime>;
                
                    TargetHeapMetadata() = default;
                    constexpr TargetHeapMetadata(MetadataKind kind)
                        : TargetMetadata<Runtime>(kind) {}
                //在这里有对 OC 和 Swift 做兼容。如果是一个纯Swift类，初始化传入了MetadataKind；如果和OC交互，它就传入了一个isa。
                #if SWIFT_OBJC_INTEROP
                    constexpr TargetHeapMetadata(TargetAnyClassMetadata<Runtime> *isa)
                        : TargetMetadata<Runtime>(isa) {}
                #endif
                };
 
            而MetadataKind则是一个枚举类型，定义了swift的基础类型、结构类型、方法类型等：
                enum class MetadataKind : uint32_t {
                    #define METADATAKIND(name, value) name = value,
                    #define ABSTRACTMETADATAKIND(name, start, end)                                 \
                        name##_Start = start, name##_End = end,
                    #include "MetadataKind.def"
                
                        LastEnumerated = 0x7FF,
                };
                例如Class、Struct、 Enum、Optional、ForeignClass、Opaque、Tuple、 Function、Existential、Metatype等等
 
        所以最终的class的元数据类型结构大概是：
                TargetClassMetadata 继承-> TargetAnyClassMetadata 继承-> TargetHeapMetadata
                （这里的结构体是指C++的结构体）
                TargetClassMetadata结构体：有初始化大小，类大小等一些属性。
                TargetAnyClassMetadata的结构：Superclass，CacheData[2]，Data等属性，和OC中的类结构很类似
                TargetHeapMetadata结构体：一个 Kind 成员变量和ConstTargetMetadataPointer函数用于判断当前类型的种类。
                Class在内存结构由 TargetClassMetadata属性 + TargetAnyClassMetaData属性 + TargetMetaData属性构成。
        所以由上面一系列元数据类型，创建出的对象，在内存那段空间，得出的metadata的数据结构体如下:
                struct Metadata {
                    var kind: Int   //该元素的种类（option，tuple，struct还是class等等）
                    var superClass: Any.Type
                    var cacheData: (Int, Int)
                    var data: Int
                    var classFlags: Int32
                    var instanceAddressPoint: UInt32
                    var instanceSize: UInt32
                    var instanceAlignmentMask: UInt16
                    var reserved: UInt16
                    var classSize: UInt32
                    var classAddressPoint: UInt32
                    var typeDescriptor: UnsafeMutableRawPointer
                    var iVarDestroyer: UnsafeRawPointer
                }
        class的方法调度有两种：
            动态派发：在类的元数据结构体中找到函数表的地址，通过V-Table函数表找到方法体的地址来进行调度的。如类的实例方法。
                        
            静态派发：如extension中的方法，调用这些方法时是直接拿到函数的地址直接调用，也就是cpu指令直接通过偏移寻找到该方法的地址，直接执行。
                    所以这个函数地址在编译器时就决定了，并存储在__text段中，也就是代码段中。
 
                类是可以继承的，如果给父类添加extension方法，继承该类的所有子类都可以调用这些方法。并且每个子类都有自己的函数表，
                所以这个时候方法存储就成为问题，为了解决这个问题，直接把 extension 独立于虚函数表之外，采用静态调用的方式。
                在程序进行编译的时候，函数的地址就已经知道了。

 
    2、struct是值类型，也就是当struct放进去cpu运行的时候，会把整个struct所占的内存空间都搬运到运行内存上，
        当执行完的时候，运行时脱离作用域的时候会马上把struct内存释放掉。
        一句话，class是通过指针(中间者)来访问对象的所在地址，struct是直接访问实体所在的首地址。
        let是绑定标志符当前所指向的内存区域的值不能变，内存区域是指当前标志符当前所占的内存区间。
 
        struct被设计为用于创建轻量级的数据结构，它们适用于表示简单的数据集合，例如坐标、日期、几何形状等。
        由于结构体是值类型，它们在函数间传递时不会引入额外的内存管理开销。
 
        struct没有多态继承，只能实现协议protocol。
 
        结构体的实例也是由 ARC 管理的，但由于它们是值类型，所以它们的内存管理通常更简单。没有引用计数+1，而是不用就直接释放掉。
        当你创建一个结构体的实例并将其赋值给另一个变量时，ARC 会创建一个新的实例副本，而不是增加引用计数。
        当你删除对结构体实例的引用时，ARC 会释放不再使用的实例。
 
        所谓的值类型，就是你把它传递给方法参数，或者是对用它赋值给新变量，都是传递了它的副本，如果用用它的真身，那么就只能是最开始的那个标志符。
 
     struct的方法调度只有一种：
         静态派发：代码上执行该方法 就是 直接拿到函数的地址直接调用 ，Swift是一门静态语言，这个函数地址在编译器决定，
                 并存储在__text段中，也就是代码段中。
        
    为什么class有动态派发，struct只有静态派发？
        因为class有多态继承，在运行时，并不知道该方法是自身的方法还是父类的方法，所以需要通过函数表确定。
        struct没有多态继承，所以直接用静态派发，更快性能更高，在编译阶段就能确定改结构体的类型和方法的实现。
        struct 需要通过方法修改自身的属性的话，则需要在方法的声明前添加 mutating关键字，底层默认传入了一个标记了 inout 的 Self 参数进来，
        这样 self 就可以修改了，本质还是静态派发，只是通过传递self作为参数来修改属性的值。
 
 */
//MARK: - swift的内存存储分布，从内存文件的角度看。
/**
    1、对象的内存空间，是存放在“堆空间”。
    2、静态属性（类属性或类型属性），在“数据段”的一个特定区域，通常称为“类型元数据”或“全局存储区”。
                            这个区域用于存储与类型本身相关的信息，包括静态属性的值。
 
    3、方法（无论是实例方法还是静态方法）：方法的实现被转换为机器代码，并存储在“代码段”（也称为文本段或指令段）中。
                                代码段是程序二进制文件的一部分，它包含了程序执行时所需的指令。
 
    4、局部变量和方法的上下文环境：内存的“栈空间”主要用于存储局部变量和函数调用的信息。
                当函数或方法被调用时，也就是时执行方法体代码时，每个函数调用都会在栈内存中生成一个栈帧（stack frame）。
                这个栈帧包含了函数执行时所需的局部变量、参数、返回地址以及其它一些与函数调用相关的信息。
 */

//MARK: - swift的内存引用计数管理
/**
    1、refCounts是HeapObject的一个成员变量，refCounts是C++语言的InlineRefCounts模版类。
            InlineRefCountBits是InlineRefCounts泛型类的参数，也是一个模版类，也有一个泛型参数。
            InlineRefCountBits是RefCountBitsT函数的别名，该模版类有一个泛型参数RefCountIsInline（是true）。
            在RefCountBitsT中，发现只有一个bits属性，而该属性是由RefCountBitsInt的Type属性定义的。
            RefCountBitsInt 类型有一个Type，是一个 uint64_t 的位域信息，在这个 uint64_t 的位域信息中存储着运行生命周期的相关引用计数。
            而这个bit属性则通过位域来记录引用计数的相关信息，例如第几位代表是无主引用，第几位代表是强引用，等等。
 
        总结：refCounts在C++里是一个模版类，主要是操作一个泛型参数，该泛型参数也是一个类，里面有一个bits属性，该属性的位域信息，
            记录了对象生命周期相关的引用计数信息，例如第几位代表是无主引用，第几位代表是强引用，第几位标识当前类是否正在析构等等。
 
    2、在对对象进行强引用的时候，底层本质上是调用 refCounts 的 increment 方法，使得引用计数 +1。
        所以最终是会对引用计数模版类的bits属性进行相关位域操作，导致引用计数+1。
 
    3、使用weak关键字修饰的引用类型数据在传递时不会使引用计数加1，不会对其引用的实例保持强引用，因此不会阻止ARC释放被引用的实例。
        当实例被释放的时候，弱引用仍旧引用着这个实例也是有可能。因此，ARC会在被引用的实例释放时，自动地将弱引用设置为nil。
        由于弱引用需要允许设置为nil，因此它一定是可选类型；
 
    4、在对对象进行弱引用的时候，弱引用修饰的变量，变量变成了一个可选项，底层还会调用一个 swift_weakInit 函数。
        该函数会根据实例对象的refcount 的信息创建出一个弱引用的散列表。(在可选项中)
        该散列表里存储这对象的指针，并且还有一个的refcount类型，这个refcount多了一个weakbit成员变量，用于记录弱引用信息。
        所以弱引用不仅有强引用的引用计数信息，也有自己的引用计数信息，但是不会对强引用的引用信息产生影响。
 
    5、在Swift中可以通过 unowned 定义无主引用，unowned 不会产生强引用，实例销毁后仍然存储着实例的内存地址。
        unowned 要比 weak 少一些性能消耗，因为unowned只需要操作64位位域信息。
 
 */
//MARK: - 存储属性的属性观察器，在内存上的分配
/**
    1、存储属性在编译的时候，编译器默认会合成get/set方式，而我们访问/赋值 存储属性的时候，实际上就是调用get/set。
        而get/set方法并不占用对象在堆空间的内存，而是编译器会在属性值改变之前插入一段代码来执行程序员定义的操作。
        也就是你在代码上访问存储属性的时候，编译器会自动插入一段代码执行，并不是直接就访问该属性在堆空间的内存地址。
 
    2、计算属性并不存储值，他们提供 getter 和 setter 来修改和获取值。
        计数属性本质就是一个方法，也存储在类的元数据，可以理解为swift编译器提供的语法糖，可以让你用访问属性的方式来调用方法。
 
 */

/**
    1、
        X 代表类,是X.self的简写。是实例对象的类型
        x 代表类的实例对象。
        X.self 代表实例对象的类对象
        X.Type 代表类对象的类型，代表 类X 的元类型(类信息)
        AnyClass 是AnyObject.Type的别名，是类对象的类型
        Self(大写) 代表只能源文件内部使用的类对象。
 
    2、
        X.classForCoder() 是获取类对象。
        x.classForCoder  也是获取类对象。
        class_getName(X.self)   通过类对象获取类对象的名字，返回的是C语言的字符串
        object_getClassName(x)   通过实例获取类对象的名字，返回的是C语言的字符串
 
 
 */

class TestClassStruct_VC: UIViewController {
    
    //MARK: 对外属性
    public var collDataArr = ["0、","1、","2、","3、","4、","5、","6、","7、","8、","9、","10、","11、","12、"]

    ///UI组件
    private var baseCollView: UICollectionView!
    
    //MARK: 测试组件
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 199/255.0, green: 204/255.0, blue: 237/255.0, alpha: 1.0)
        self.title = "测试类、结构体VC"
        
        setNavigationBarUI()
        setCollectionViewUI()
        initTestViewUI()
    }
    
    
    
}


//MARK: - 遵循数据源协议,UICollectionViewDataSource
extension TestClassStruct_VC: UICollectionViewDataSource {
    
    ///点击了cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了第\(indexPath.row)个item")
        switch indexPath.row {
        case 0:
            //TODO: 0、测试类对象初始化实例对象。
            print("     (@@ 0、测试类对象初始化实例对象。 ")
            let dog = TestClass_Dog.self.init()
            var animalType:TestClass_Animal.Type?
            animalType = TestClass_Cat.self
            let animal = animalType!.init()
            print("名字是：\(dog.name)")
            print("动物是：\(animal.name)")
            
            print("实例的classForCoder是：\(dog.classForCoder)")
            print("类的classForCoder()是：\(TestClass_Dog.classForCoder())")
            let classForCoder: AnyClass = TestClass_Dog.classForCoder()
            print("classForCoder是：\(classForCoder)")
            
        
            let typeofx = type(of: dog)
            let typeofX = type(of: TestClass_Dog.self)
            print("typeofx是：\(typeofx)")
            print("typeofX是：\(typeofX)")

            //通过类对象获取类对象的名字，返回的是C语言的字符串
            let class_getName = class_getName(TestClass_Dog.self)
            let class_getNameStr:String = String(cString: class_getName)
            print("class_getNameStr的名字是：\(class_getNameStr)")
            
            //通过实例获取类对象的名字，返回的是C语言的字符串
            let object_getClassName = object_getClassName(dog)
            let object_getClassNameStr:String = String(cString: object_getClassName)
            print("object_getClassName的名字是：\(object_getClassNameStr)")
        case 1:
            //TODO: 1、
            print("     (@@ ")
        case 2:
            //TODO: 2、
            print("     (@@ ")
        case 3:
            //TODO: 3、
            print("     (@@ ")
        case 4:
            print("     (@@")
        case 5:
            print("     (@@")
        case 6:
            print("     (@@")
        case 7:
            print("     (@@")
        case 8:
            print("     (@@")
        case 9:
            print("     (@@")
        case 10:
            print("     (@@")
        case 11:
            print("     (@@")
        case 12:
            print("     (@@")
        default:
            break
        }
    }
    
}
//MARK: - 测试的方法
extension TestClassStruct_VC{
   
    //MARK: 0、
    func test0(){
        
    }
    
}


//MARK: - 设置测试的UI
extension TestClassStruct_VC{
    
    /// 初始化你要测试的view
    func initTestViewUI(){
        
    }
    
}


//MARK: - 设计UI
extension TestClassStruct_VC {
    
    /// 设置导航栏的UI
    private func setNavigationBarUI(){
        //设置子页面的navigation bar的返回按钮样式
        let backItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    /// 设置collection view的UI
    private func setCollectionViewUI(){
        
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: 80, height: 40)
        layout.sectionInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 0, right: 5)
        baseCollView = UICollectionView.init(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width,height:200),
                                             collectionViewLayout: layout)
        
        baseCollView.backgroundColor = UIColor.cyan.withAlphaComponent(0.8)
        baseCollView.contentSize = CGSize.init(width: UIScreen.main.bounds.size.width * 2, height: UIScreen.main.bounds.size.height)
        baseCollView.showsVerticalScrollIndicator = true
        baseCollView.alwaysBounceVertical = true
        baseCollView.layer.borderWidth = 1.0
        baseCollView.layer.borderColor = UIColor.gray.cgColor
        baseCollView.delegate = self
        baseCollView.dataSource = self
        baseCollView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionView_Cell_ID")
        
        self.view.addSubview(baseCollView)
        
    }
}

//MARK: - 遵循委托协议,UICollectionViewDelegate
extension TestClassStruct_VC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collDataArr.count
    }
    ///设置cell的UI
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionView_Cell_ID", for: indexPath)
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        cell.backgroundColor = .lightGray
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: cell.frame.size.width-20, height: cell.frame.size.height));
        label.numberOfLines = 0
        label.textColor = .white
        cell.layer.cornerRadius = 8
        label.text = collDataArr[indexPath.row];
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        cell.contentView.addSubview(label)
        
        return cell
    }
    ///一旦入栈，就隐藏入栈vc的tabBar，底部工具栏
    private func pushNext(viewController: UIViewController) {
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}



