# Crasheye XCode Plugin
* __CrasheyeXCodePlugin__ 一键完成 __CrasheyeSDK__ 的安装、升级。


## 下载
* __CrasheyeXCodePlugin__         传送门:[CrasheyeXCodePlugin](https://github.com/GangWang/Crasheye)
* __Crasheye__ 各平台 __SDK__ 下载，传送门:[http://www.crasheye.cn/sdk](http://www.crasheye.cn/sdk)


## 安装

* 下载此工程点击运行后，重启xcode
* 为了支持不同的Xcode，例如Xcode 5.0.2, Xcode 5.1.1等，需要设置Info.plist文件的DVTPlugInCompatibilityUUIDs选项，在其中加入不同的Xcode的UUID。查看Xcode UUID的方法：


>   defaults read /Applications/Xcode.app/Contents/Info DVTPlugInCompatibilityUUID



## 卸载

* 进入如下目录，删除 **CrasheyePluginXcode.xcplugin** ，并重启**XCode**

> ~/Library/Application Support/Developer/Shared/Xcode/Plug-ins


## 使用
安装成功后会在 __XCode__ 的菜单 **XCode->Product** 下添加 **Crasheye** 菜单项

##### 打开XCode工程

![setp 1](https://raw.githubusercontent.com/GangWang/Crasheye/master/XCodePlugin/1.png)

##### 如果未安装或者有新版本时，会提示是否安装、升级

![setp 2](https://raw.githubusercontent.com/GangWang/Crasheye/master/XCodePlugin/2.png)

![setp 3](https://raw.githubusercontent.com/GangWang/Crasheye/master/XCodePlugin/3.png)

![setp 4](https://raw.githubusercontent.com/GangWang/Crasheye/master/XCodePlugin/5.png)

##### 最后会打开并定位到:

	[Crasheye initWithAppkey:@"Appkey"];

这行代码，在此处填入自己的 __Appkey__ 就完成了 **Crasheye SDK** 的接入、升级。

## 注意事项

>   在使用此插件之前，如果工程中已手工接入过Crasheye请，先删除Crasheye.h & libCrasheye.a 两个文件

---
* 更多内容请访问:[http://www.crasheye.cn](http://www.crasheye.cn)



