//
//  mulitpleFile_Note.h
//  C_Syntac_CmdLine
//
//  Created by mathew on 2023/4/18.
//
//MARK: - .h文件，多文件开发
/**
    1、.h文件不会参与到编译器的编译，只是把声明拷贝到.c源文件 的#include 所在行，然后编译.c文件的时候，这些声明才会参与编译。
        我猜 声明语句 编译后是占位指针，等到 链接阶段 才回把 从.h文件拷贝过来的声明语句 对应的 .c文件中的实现 填充进去。
    2、运行步骤分析：
        在编译之前，预编译器会将sum.h文件中的内容拷贝到main.c中。
        接着编译main.c和sum.c两个源文件，生成目标文件main.o和sum.o，这2个文件是不能被单独执行的，原因很简单：
            sum.o中不存在main函数，肯定不可以被执行。
            main.o中虽然有main函数，但是它在main函数中调用了一个sum函数，而sum函数的定义却存在于sum.o中，因此main.o依赖于sum.o。
        把main.o、sum.o链接在一起，生成可执行文件。
        运行程序。
 
    3、基于.h头文件只用于被拷贝和声明，不参与编译，所以需要注意：
        1)头文件中可以和C程序一样引用其它头文件,可以写预处理块,但不要写具体的语句。
        2)可以声明么函数, 当不可以定义函数。
        3)可以声明常量, 当不可以定义变量。
        4)可以“定义”一个宏函数。注意:宏函数很象函数,但却不是函数。其实还是一个申明。
        5)结构的定义、自定义数据类型一般也放在头文件中。
        6)多文件编程时,只能有一个文件包含 main() 函数,因为一个工程只能有一个入口函数。我们 把包含 main() 函数的文件称为主文件。
        7)为了更好的组织各个文件,一般情况下一个 .c 文件对应一个 .h 文件,并且文件名要相同, 例如 fun.c 和 fun.h。
        8)头文件要遵守幂等性原则,即可以多次包含相同的头文件,但效果与只包含一次相同。
        9)防止重复包含的措施

 */

// MARK: - 预处理
/**
    1、所谓预处理，就是在编译之前做的处理，预处理指令一般以 # 开头。
    2、#include 是C语言的预处理指令之一。
        #include 指令后面会跟着一个文件名，预处理器发现 #include 指令后，就会根据文件名去查找文件，并把这个文件的内容包含到当前文件中。
        被包含文件中的文本将替换源文件中的 #include 指令，就像你把被包含文件中的全部内容拷贝到这个 #include 指令所在的位置一样。
        所以第一行指令的作用是将stdio.h文件里面的所有内容拷贝到第一行中。
        如果被包含的文件拓展名为.h，我们称之为"头文件"(Header File)，头文件可以用来声明函数，要想使用这些函数，就必须先用 #include 指令包含函数所在的头文件。
        #include 指令不仅仅限于.h头文件，可以包含任何编译器能识别的C/C++代码文件，包括.c、.hpp、.cpp等，甚至.txt、.abc等等都可以。
 
     注意: include 语句之后不需要加";"(因为#include它使一个预处理指令,不是一个语句)。
          当包含我们自己写的文件就是使用 #include "" 当包含系统提供头文件的时候,就是用#include <>。
 
     #include <>和#include ""的区别：当被include的文件路径不是绝对路径的时候，有不同的搜索顺序。
        对于使用双引号""来include文件，搜索的时候按以下顺序：
            先在这条include指令的父文件所在文件夹内搜索，所谓的父文件，就是这条include指令所在的文件。
            如果上一步找不到，则在父文件的父文件所在文件夹内搜索；
            如果上一步找不到，则在编译器设置的include路径内搜索；
            如果上一步找不到，则在系统的include环境变量内搜索。

        对于使用尖括号<>来include文件，搜索的时候按以下顺序：
            在编译器设置的include路径内搜索；
            如果上一步找不到，则在系统的include环境变量内搜索。
        如果你是自己安装clang编译器，clang设置include路径是（4.2是编译器版本）：
        /usr/lib/clang/4.2/include
        
        Xcode自带编译器, clang设置include路径是
        /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.10.sdk/usr/include
        
        Mac系统的include路径有：
        /usr/include
        /usr/local/include
        
        如果没有这个目录,可参考如下:
        打开终端输入:xcode-select --install
        安装Command Line Tools之后就会出现

 
 */
