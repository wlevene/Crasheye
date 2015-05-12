# Crasheye XCode Plugin
CrasheyeXCodePlugin 针对iOS APP开发接入并升级Crasheye SDK过程，使SDK的接入和升级可以一键完成


## 下载
* CrasheyeXCodePlugin下载地址:[CrasheyeXCodePlugin](https://raw.githubusercontent.com/GangWang/Crasheye/master/XCodePlugin/CrasheyePluginXcode.zip)
* Crasheye 各平台 SDK 下载，请前往:[http://www.crasheye.cn/sdk](http://www.crasheye.cn/sdk)


## 安装

下载 **CrasheyePluginXcode.xcplugin**，将其拖到如下目录并重启**XCode**

> ~/Library/Application Support/Developer/Shared/Xcode/Plug-ins


## 卸载
进入如下目录，删除 **CrasheyePluginXcode.xcplugin** ，并重启**XCode**

> ~/Library/Application Support/Developer/Shared/Xcode/Plug-ins


## 使用
安装成功后会在XCode的菜单 **XCode->Product** 下添加 **Crasheye** 菜单项

##### 打开XCode工程

![setp 1](https://raw.githubusercontent.com/GangWang/Crasheye/master/XCodePlugin/1.png)

##### 如果未安装或者有新版本时，会提示是否安装并升级

![setp 2](https://raw.githubusercontent.com/GangWang/Crasheye/master/XCodePlugin/2.png)

![setp 3](https://raw.githubusercontent.com/GangWang/Crasheye/master/XCodePlugin/3.png)

![setp 4](https://raw.githubusercontent.com/GangWang/Crasheye/master/XCodePlugin/4.png)

##### 最终会打开并定位到:

	[Crasheye initWithAppkey:@"Appkey"];
	
这行代码，在此处填入自己的Appkey就完成了 **Crasheye SDK** 的接入和升级。


---
更多内容请访问:[Crasheye](http://www.crasheye.cn)
