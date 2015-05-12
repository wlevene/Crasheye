# Crasheye XCode Plugin
* __CrasheyeXCodePlugin__ 一键完成 __CrasheyeSDK__ 的安装、升级。


## 下载
* __CrasheyeXCodePlugin__         传送门:[CrasheyeXCodePlugin](https://raw.githubusercontent.com/GangWang/Crasheye/master/XCodePlugin/CrasheyePluginXcode.xcplugin.zip)
* __Crasheye__ 各平台 __SDK__ 下载，传送门:[http://www.crasheye.cn/sdk](http://www.crasheye.cn/sdk)


## 安装

* 下载 **CrasheyePluginXcode.xcplugin** 并解压，将解压后的文件拖到如下目录并重启 **XCode**

> ~/Library/Application Support/Developer/Shared/Xcode/Plug-ins


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

![setp 4](https://raw.githubusercontent.com/GangWang/Crasheye/master/XCodePlugin/4.png)

##### 最后会打开并定位到:

	[Crasheye initWithAppkey:@"Appkey"];
	
这行代码，在此处填入自己的 __Appkey__ 就完成了 **Crasheye SDK** 的接入、升级。


---
* 更多内容请访问:[http://www.crasheye.cn](http://www.crasheye.cn)
