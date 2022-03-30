
##  OC对象的语法

### 结构体作为对象的属性
#### 结构体作对象的属性时，对象不会默认初始化结构体，需要在调用时显示初始化，默认为null
#### 因为结构体和数组的实现语法是一样的，系统并不清楚它是数组还是结构体，所以初始化结构体属性时需要显示初始化
        #import <Foundation/Foundation.h>
        
        /**
            1.结构体只能在定义的时候初始化，声明的时候
            2.系统并不清楚它是数组还是结构体
        */
        typedef struct {
            int year;
            int month;
            int day;
        } Date;


        @interface Student : NSObject
        {
            @public
            NSString *_name;
            Date _birthday;
        }

        - (void)say;

        @end

        @implementation Student

        - (void)say
        {
            NSLog(@"name = %@; year = %i, month = %i, day = %i", _name, _birthday.year, _birthday.month, _birthday.day);
        }

        @end

        int main(int argc, const char * argv[]) {
            // 1.创建学生对象
            // 1.开辟存储空间
            // 2.初始化属性
            // 3.返回地址
            Student *stu = [Student new];

            // 2.设置学生对象的属性
            stu->_name = @"lnj";
            // 1.结构体只能在定义的时候初始化
            // 2.系统并不清楚它是数组还是结构体
            
            //初始化结构体属性
            //方法一:强制转换
        //    stu->_birthday = (Date){1986, 1, 15};
            
            //方法二:定义一个新的结构体,给d赋值,将d赋值给_birthday
            Date d = {1986, 1, 15};
            stu->_birthday = d;
            
            //方法三:分别赋值
        //    stu->_birthday.year = 1986;
        //    stu->_birthday.month = 1;
        //    stu->_birthday.day = 15;
            
            // 3.让学生说出自己的姓名和生日
            [stu say];
            
            
            /*
            Date d1  = {1999, 1, 5};
            Date d2;
            d2 = d1; // 本质是将d1所有的属性的值都拷贝了一份赋值给d;
            
            d2.year = 2000;
            printf("d1 = year = %i\n", d1.year);
            printf("d2 = year = %i\n", d2.year);
             */
            
            return 0;
        }


### 对象作为方法的参数
#### 代码在加载进系统运行时，会先创建类对象，而实例对象会在运行期间被调用时才会分配堆内存，而类对象在运行初期就已经分配完成了
#### 类对象保存了属性的声明，方法的汇编代码，用于创建实例对象；实例对象会默认维护一个isa指针，指向类对象，用于寻找方法体，起到复用的作用
        @interface Gun : NSObject
        {
            @public
            int _bullet; // 子弹
        }
        // 射击
        - (void)shoot;
        @end


        @implementation Gun
        - (void)shoot
        {
            // 判断是否有子弹
            if (_bullet > 0) {
                
                _bullet--;
                NSLog(@"打了一枪 %i", _bullet);
            }else
            {
                NSLog(@"没有子弹了, 请换弹夹");
            }
        }
        @end


        @interface Soldier : NSObject
        {
            @public
            NSString *_name;
            double _height;
            double _weight;
        }
        //- (void)fire;
        - (void)fire:(Gun *)gun;
        @end


        @implementation Soldier
        /*
        - (void)fire
        {
            NSLog(@"打了一枪");
        }
         */

        //  Gun * g = gp
        - (void)fire:(Gun *)g
        {
        //    NSLog(@"打了一枪");
            [g shoot];
        }

        @end
        
        

        int main(int argc, const char * argv[]) {
            
            // 1.创建士兵
            Soldier *sp =[Soldier new];
            sp->_name = @"屎太浓";
            sp->_height = 1.88;
            sp->_weight = 100.0;
            
            // 2.创建一把枪
            Gun *gp = [Gun new];
            gp->_bullet = 10;
            
            // 2.让士兵开枪
        //    [sp fire];
            // 让对象作为方法的参数传递
            [sp fire:gp]; // 地址
            [sp fire:gp];
            [sp fire:gp];
            [sp fire:gp];
            [sp fire:gp];
            [sp fire:gp];
            
            return 0;
        }

#### .h文件的存在是为了多人协作开发，方便多个源文件的管理。
.h文件里声明的方法必须实现，没在.h方法声明的方法，也可以在.m文件中添加。但是对外不可见，仅限于.m实现体内部使用，相当于私有方法。
