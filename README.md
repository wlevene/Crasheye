# Crasheye XCode Plugin

## 安装

下载 **CrasheyePluginXcode.xcplugin** 文件，将文件拖到如下目录并重启**XCode**

> ~/Library/Application Support/Developer/Shared/Xcode/Plug-ins


## 卸载
进入如下目录，删除 **CrasheyePluginXcode.xcplugin** 文件，并重启**XCode**

> ~/Library/Application Support/Developer/Shared/Xcode/Plug-ins


## 使用
安装成功后会在菜单 **XCode->Product** 下添加 **Crasheye** 菜单项

##### 打开XCode工程

![setp 1](https://raw.githubusercontent.com/GangWang/Crasheye/master/XCodePlugin/1.png)

![setp 2](https://raw.githubusercontent.com/GangWang/Crasheye/master/XCodePlugin/2.png)

![setp 3](https://raw.githubusercontent.com/GangWang/Crasheye/master/XCodePlugin/3.png)

![setp 4](https://raw.githubusercontent.com/GangWang/Crasheye/master/XCodePlugin/4.png)

最终会打开并定位到:

	[Crasheye initWithAppkey:@"Appkey"];
	
这行代码，在此处填入自己的Appkey就完成了 **Crasheye SDK** 的安装。


---
更多内容请访问:[Crasheye](http://www.crasheye.cn)
