//
//  Class与Struct的区别.swift
//  SwiftTest_CommandLine
//
//  Created by ctch on 2024/3/12.
//  Copyright © 2024 com.fendaTeamIOS. All rights reserved.
//
//MARK: - 笔记
/**
 
    iOS 中的内存大致可以分为代码区，全局/静态区，常量区，堆区，栈区，其地址由低到高。
 
    1、class是引用类型，也就是方法栈上的class实例的变量是指针，该指针指向内存的堆空间，是实例对象所占的堆空间的首地址。
        let关键字声明，是这方法栈上的变量的值不可变，并不是不能修改堆内存上的值，所以let声明class实例对象的属性可以改变。
        class里的用let声明属性不能改变，是指这时候的let绑定的是变量所在内存地址上的值不能变了，所以就是属性的值不能变了。
 
        class 被设计为用于创建具有继承层次结构的对象。它们适用于那些需要在多个地方共享状态和行为的情况，例如模型、视图控制器和管理器等。
 
    Swift对象本质在C++的实现中是一个HeapObject结构体指针，HeapObject结构中有两个成员变量，metadata 和 refCounts，
    metadata 是指向元数据对象的指针，里面存储着类的信息，比如属性信息，虚函数表等。而refCounts 是一个引用计数信息相关的东西。
 

 
    创建类的实例对象的底层原理：
        1、从执行构造函数开始，系统执行的方法流程(创建对象)是：
            swift_allocObject --> _swift_allocObject_ --> swift_slowAlloc --> malloc
 
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
                TargetClassMetadata结构体：有很多成员变量，初始化大小，类大小等一些属性。
                TargetAnyClassMetadata的结构：Superclass，CacheData[2]，Data等属性，和OC中的类结构很类似
                TargetHeapMetadata结构体：一个 Kind 成员变量和ConstTargetMetadataPointer函数用于判断当前类型的种类。
                Class在内存结构由 TargetClassMetadata属性 + TargetAnyClassMetaData属性 + TargetMetaData属性构成, 所以得出的metadata的数据结构体如下:
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
         静态派发：直接拿到函数的地址直接调用，Swift是一门静态语言，这个函数地址在编译器决定，并存储在__text段中，也就是代码段中。
        
    为什么class有动态派发，strct只有静态派发？
        因为class有多态继承，在运行时，并不知道该方法是自身的方法还是父类的方法，所以需要通过函数表确定。
        struct没有多态继承，所以直接用静态派发，更快性能更高，在编译阶段就能确定改结构体的类型和方法的实现。
        struct 需要通过方法修改自身的属性的话，则需要在方法的声明前添加 mutating关键字，底层默认传入了一个标记了 inout 的 Self 参数进来，
        这样 self 就可以修改了，本质还是静态派发，只是通过传递self作为参数来修改属性的值。
 
 */


struct C_S_Struct {
    
    var x: Int
    var y: Int
      
    //必须加上mutating关键字，因为结构体是值类型，是副本。添加 mutating关键字，底层默认传入了一个标记了 inout 的 Self 参数进来。
    //struct的方法是放在内存的代码段的，是静态派发，无法获知结构体实例的内存地址，所以必须加上mutating关键字。
    mutating func moveBy(dx: Int, dy: Int) {
        self.x =  dx + 1
        self.y =   dy + 1
    }
}

class  C_S_Class{
    
    var x: Int = 0
    var y: Int = 1
      
    func moveBy(dx: Int, dy: Int) {
        self.x =  dx + 1
        self.y =   dy + 1
    }
}

