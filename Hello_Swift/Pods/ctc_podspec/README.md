# ctc_podspec

[![CI Status](https://img.shields.io/travis/mathew.cai/ctc_podspec.svg?style=flat)](https://travis-ci.org/mathew.cai/ctc_podspec)
[![Version](https://img.shields.io/cocoapods/v/ctc_podspec.svg?style=flat)](https://cocoapods.org/pods/ctc_podspec)
[![License](https://img.shields.io/cocoapods/l/ctc_podspec.svg?style=flat)](https://cocoapods.org/pods/ctc_podspec)
[![Platform](https://img.shields.io/cocoapods/p/ctc_podspec.svg?style=flat)](https://cocoapods.org/pods/ctc_podspec)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

ctc_podspec is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ctc_podspec'
```
测试自己制作的cocoapod私有库：

1、首先你要配置安装好cocoapod的环境，然后就可以使用cocoapod命令了。

2、通过命令创建cocoapod私有库：
    $ cd 合适的目录（最好是空文件夹）
    $ pod lib create yourLibName（库名字）
    //这里会生成一系列必要文件，和一个Example工程，包括yourLibName.podspec文件，熟悉之后可以手动生成添加。

3、描述信息：在yourLibName.podspec文件中，描述你的库的信息、xcode工程信息等。例如它们的github地址、编译文件、依赖关系等等。

4、上传文件：将yourLibName.podspe和工程文件一同上传到yourLibName.podspe中描述的仓库地址上，并打上tag （和yourLibName.podspec中s.version 的保持一致）


## Author

mathew.cai

## License

ctc_podspec is available under the MIT license. See the LICENSE file for more info.
