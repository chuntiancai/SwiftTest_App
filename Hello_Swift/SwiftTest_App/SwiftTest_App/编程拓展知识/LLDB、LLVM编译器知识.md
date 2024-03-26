
## Switf和OC源代码的编译流程：
    OC中通过clang编译器，编译成IR，然后再生成可执行文件.o（即机器码）。
    swift中通过swiftc编译器，编译成IR(中间表示)，然后再生成可执行文件.o文件。
    注意两者是通过不同的编译器，都变易成IR，然后再通过LLVM生成.o可执行文件。
    根据语法树生成中间表示（IR），IR 是一种与具体机器无关的表示形式，便于后续优化和生成目标代码。
    
    Swift与OC的区别在于 Swift生成了高级的SIL(swift 中间语言)。
    




## LLDB是调试器，LLVM是编译器架构(虚拟机)，Clang是LLVM的架构中的前端部分(负责语言解析)。
    LLVM是一个编译器的架构，就是一个苹果的一个虚拟机。然后clang是LLVM架构中的其中一个框架(第三方库)，Clang负责解析语法、词法解析。而其他的框架负责优化，生成目标代码的等等。
    还有一个是Clang驱动器，也就是把Clang和LLVM的其它部分集成起来，所以Clang驱动器也有他的表达式和命令。
    
    LLDB是macOS的调试器，就是一个调试其它软件 的软件，例如断点调试什么的。xcode的控制台说的就是LLDB，也就是调试器了。
    
## GCC编译器是Linux的，Clang是苹果自己开放的编译器。编译器的目的都是把平台语言（C、java、Object-C等）编译成 cpu 能够接受的命令。
    所以编译器需要根据cpu的架构进行不同的编译，例如 ARM、x86、x86-64、MIPS、PowerPC、M1等等。
    然后虚拟cpu的软件，也被叫做虚拟机。例如Clang就是一个编译器，把 Object-C语言 编译成 LLVM虚拟机 能接受的语言(或者说命令)。
    
##  平台语言(C、java、swift等) ==> 经过编译器编译  ==> CPU的语言(汇编语言 或者 直接就是cpu的指令代码)

## Clang编译器
    macOS下的编译器，一般是集成在xcode里面的，也就是你安装了xcode，也就安装了Clang编译器，如果在终端用不了Clang命令，那么就在 xcode -> preference -> locations中选择命令行工具，就可以了。
    Clang是object-c、c、c++ 的编译器，swift使用 swiftcc编译器，但是两者最终都会生成llvm接受的语言。然后llvm再编译成arm、x86、m1等CPU架构接受的语言。


## OC情况下，LLDB不能打印view的bounds时。命令行打印不了UIKit的情况。
    在命令行输入：expr @import UIKit
