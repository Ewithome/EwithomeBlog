---
title: WiseMapServer从0搭建
date: 2026-06-02 09:33:09
categories: WiseMap
tags:
  - WiseMap
cover: /images/WiseMapServer从0搭建/image.png   # 封面图
---

# WiseMapServer从0搭建

<写此文档原因是本人愚钝，做此记录>

## 1. 准备工作

需要的软件有：

1.vs2019

2.ActivePerl_x64_5.24.1.2402

3.SVN

[建议提前安装软件](#123)

## 1.1 SVN拉去代码

```txt
 http://10.0.0.200:8080/svn/WiseMap2022/Products/GisServer/trunk/MapGuide
 
 MapGuide代码总大小70G左右

 ！！！其中.svn文件夹有30G左右
 ```

### 1.2 安装vs2019

 1.安装组件选项（如下图）

> 首页勾选

 ![alt text](/images/WiseMapServer从0搭建/PixPin_2025-03-05_15-36-23.png)

> 上方切换到<单个组件>选项，然后勾选以下选项

 ![alt text](/images/WiseMapServer从0搭建/PixPin_2025-03-05_15-37-12.png)

 ![alt text](/images/WiseMapServer从0搭建/PixPin_2025-03-05_15-37-16.png)

 ![alt text](/images/WiseMapServer从0搭建/PixPin_2025-03-05_15-37-21.png)

 ![alt text](/images/WiseMapServer从0搭建/PixPin_2025-03-05_15-36-35.png)

 ![alt text](/images/WiseMapServer从0搭建/PixPin_2025-03-05_15-36-45.png)

 ![alt text](/images/WiseMapServer从0搭建/PixPin_2025-03-05_15-36-50.png)

 ![alt text](/images/WiseMapServer从0搭建/PixPin_2025-03-05_15-36-56.png)

 ![alt text](/images/WiseMapServer从0搭建/PixPin_2025-03-05_15-37-01.png)

 ![alt text](/images/WiseMapServer从0搭建/PixPin_2025-03-05_15-37-06.png)

 2.开始安装

 3.启动vs2019

 ![alt text](/images/WiseMapServer从0搭建/PixPin_2025-03-06_08-49-01-1.png)

### 1.3 ActivePerl

ActivePerl_x64_5.24.1.2402 这个必须安装 这是一个坑 mapguide必须安装 (完全安装 看图片)

![alt text](/images/WiseMapServer从0搭建/PixPin_2025-03-06_08-50-36-1.png)

## 2 编译代码

### 2.1 编译

双击MgDev/z-build-x64.bat（无需管理员运行）
弹出黑窗口  需要等待2-3小时（和电脑配置有关系）
注意！！！如果卡主不动了，可选择黑窗口按回车按钮

> 错误1：
安装vs2019 无法打开项目文件。 无法找到 .NET SDK。请检查确保已安装此项且 global.json 中指定的版本(如有)与所安装的版本相匹配。

解决：
1.安装dotnet-runtime dotnet-sdk （名称如下）一共6个包  建议在安装vs2019之前就安装一下

<h id="123">建议提前安装</h>

[aspnetcore-runtime-8.0.3-win-x64.exe](https://download.visualstudio.microsoft.com/download/pr/e91876a9-1760-42cb-a6f4-97c57e9cca52/b433fcf4768929539f17e1908cb315bf/aspnetcore-runtime-8.0.3-win-x64.exe)

[dotnet-runtime-8.0.3-win-x64.exe](https://download.visualstudio.microsoft.com/download/pr/961dfc84-ea72-48a2-b3f4-b82cefc34580/6ac50b6bf244a2c5481ad705a92cf843/dotnet-runtime-8.0.3-win-x64.exe)

[dotnet-sdk-8.0.202-win-x64.exe](https://download.visualstudio.microsoft.com/download/pr/f71e824f-ceab-444f-bd41-7a3852cb9d8a/f9227b2b0c3111777f349d9200592fbd/dotnet-sdk-8.0.202-win-x64.exe)

[windowsdesktop-runtime-8.0.3-win-x64.exe](https://download.visualstudio.microsoft.com/download/pr/51bc18ac-0594-412d-bd63-18ece4c91ac4/90b47b97c3bfe40a833791b166697e67/windowsdesktop-runtime-8.0.3-win-x64.exe)

[dotnet-sdk-2.1.202-win-x64.exe](https://builds.dotnet.microsoft.com/dotnet/Sdk/2.1.202/dotnet-sdk-2.1.202-win-x64.exe)

[AspNetCore.2.0.6.RuntimePackageStore_x64.exe](https://download.microsoft.com/download/8/D/A/8DA04DA7-565B-4372-BBCE-D44C7809A467/AspNetCore.2.0.6.RuntimePackageStore_x64.exe)

2.修改环境变量顺序
![alt text](/images/WiseMapServer从0搭建/PixPin_2025-03-07_09-10-27.png)
3.查看信息

```bat
dotnet --list-sdks
dotnet --list-runtimes
```

最终版本信息显示为
小峰显示图片
![alt text](/images/WiseMapServer从0搭建/PixPin_2025-03-07_09-17-37.png)
小明显示图片
![alt text](/images/WiseMapServer从0搭建/PixPin_2025-03-07_09-21-33.png)

> 错误2
error NU1102: 找不到版本为 (>= 2.0.3) 的包 NETStandard.Library
这个错误是编译Bingdings 的时候出现的

解决方法：

1.提前现在Desktop(Maestro前端)代码
![alt text](/images/WiseMapServer从0搭建/PixPin_2025-03-07_09-29-35.png)
![alt text](/images/WiseMapServer从0搭建/PixPin_2025-03-07_09-30-08.png)
![alt text](/images/WiseMapServer从0搭建/PixPin_2025-03-07_09-30-38.png)

修改一定要点击一下 <清楚所有NuGet缓存(C)>

> 错误3
error : 找不到资产文件“D:\SVN\MgDev\Bindings\src\Managed\DotNet\OSGeo.MapGuide.Foundation\obj\project.assets.json”。运行 NuGet 程序包还原以生成此文件。

解决方法:
修改一定要点击一下 <清楚所有NuGet缓存(C)>
![alt text](/images/WiseMapServer从0搭建/PixPin_2025-03-07_09-30-08.png)
然后重新编译一下MgDesktopApi.sln项目

或者通过MgDev/z-build-x64.bat重新编译（建议使用此方法）

### 2.2 目录结构介绍

 ![alt text](/images/WiseMapServer从0搭建/PixPin_2025-03-06_13-56-51.png)
 ![alt text](/images/WiseMapServer从0搭建/PixPin_2025-03-06_13-58-25.png)
 ![alt text](/images/WiseMapServer从0搭建/PixPin_2025-03-06_14-01-00.png)

## 3 Desktop(Maestro前端)

svn地址：<http://10.0.0.200:8080/svn/WiseMap2022/Products/Desktop/trunk>

1.编译成果
编译执行：Desktop/z-build-x64.bat
编译后的成果在out文件夹下

2.编译debug版本
通过vs编译

## 4 WiseMapPro

svn地址：<http://10.0.0.200:8080/svn/WiseMap2022/Products/GisServer/trunk/MapGuide/MgDev/WiseMapPro>

1. 安装 VS2019 qt 插件

snv地址：<http://win-hno8k61pvpi:18018/svn/OpenSource/Tools/qt-vsaddin-msvc2019-3.0.2.vsix> 账号：hanxiaofeng  123

注意！！！安装qt插件时需要关闭vs2019

2. 设置Qt环境

![alt text](/images/WiseMapServer从0搭建/PixPin_2025-03-10_13-54-49.png)

文件在svn这个目录下，但是要选择本地目录路径

<http://10.0.0.200:8080/svn/WiseMap2022/Products/GisServer/trunk/MapGuide/MgDev/Oem/QT-5.15.2/msvc2019_64/>

然后修改Version name的名字为QT-5.15.2_msvc2019_64，然后点击OK，即可

![alt text](/images/WiseMapServer从0搭建/PixPin_2025-03-10_13-54-58.png)

问题1
error C2440: “ return” : 无法从“ const char [13]”转换为“ char *”

解决方法：
当初安装qt插件的版本为3.0导致的
但是通过设置/Zc:strictStrings- 解决了这个问题
但是建议还是安装qt2.6的版本

2. 启动项目

选择WiseMap Pro 设置为启动项目

3. 目录结构介绍

![alt text](/images/WiseMapServer从0搭建/PixPin_2025-03-10_15-01-57.png)

