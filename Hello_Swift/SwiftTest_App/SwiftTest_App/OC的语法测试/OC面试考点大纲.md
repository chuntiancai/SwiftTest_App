
## NSInteger是基本数据类型Int或者Long的别名（NSInteger的定义typedef long NSInteger），NSInteger会根据系统是32位还是64位 来决定是本身是int还是Long。

## copy与mutableCopy方法：
        copy是指针复制，或者是不可修改内容的内容复制。
        mutablecopy是内容可修改的内容复制。

## @property属性的strong和copy修饰符：
        copy代表该属性作为参数传递的时候，是值传递。（别的方法的参数，或者调用属性自身的方法，不是值修改属性值的代码）
        strong代笔该属性作为参数传递的时候，是引用传递。
    
    @property 是Objective-C的一项特性，在编译器遇到@property标识符时，会自动编写与属性相关的getter/setter方法，
                并在方法内部做相关的操作，并且还把属性编写为各种对应的实例变量。
                就是语法糖的意思。
        例如：如果是atomic关键字修饰，则在getter/setter方法加锁，保证线程安全。
             如果是copy修饰符，则根据不同的场景去实现浅复制和深复制。
             
    @property的原理：
        OC既可以通过指针直接访问内存上的实例变量，也可以通过元数据里的变量列表去访问变量，而@property就是在访问变量列表的过程插入相关代码。
        编译阶段：每添加一个property属性的时候，编译器就隐式添加一个变量，在属性列表中添加一个属性，在方法列表中添加getter/setter方法。
        
        运行阶段：而你访问该属性的时候，就会去调用getter/setter方法，getter/setter方法就会根据属性 在对象中的偏移量 来找出该属性对应的变量的地址。
        
        
    @property的修饰符关键字：
        atomic     原子性访问    //译器会通过锁定机制确保setter和getter的完整性。
                    但是并不能保证整个对象的线程安全，也就是多线程同时操作这个属性的时候，并不能保证每个线程都是你想得到的值。
                    就是本来这个线程A是对属性+1的，但是另外一个线程已经对它+1了，所以回到线程A，就是+2了，这没有破坏getter/setter的完整性。
                    但是却产生了线程的数据冲突，即数据不符合预期了。
        
        nonatomic     非原子性访问，多线程并发访问会提高性能，不保证setter和getter的完整性。
        
        readwrite     此标记说明属性会被当成课读写的，这也是默认属性
        
        readonly     此标记说明属性只可以读，也就是不能设置，可以获取
        
        strong     打开ARC时才会使用，相当于retain，就是一个指针。
        
        weak     打开ARC时才会使用，相当于assign，可以把对应的指针变量置为nil
        
        assign     不会使引用计数加1，也就是直接赋值，用于基本数据类型。
        
        unsafe_unretain     与weak类似，但是销毁时不自动清空，容易形成野指针。
        
        copy    属性作为方法参数 或者调用自身方法 时会拷贝一份副本。 
                对于block 在 ARC 中写不写都行，使用 copy还是 strong效果是一样的。（都是在堆区）
                但是建议写上 copy,因为这样显示告知调用者“编译器会自动对 block 进行了 copy 操作.block用copy修饰。
                在MRC中，方法内部的 block 是在栈区的(不捕获外部变量的话),使用 copy 可以把它放到堆区.


