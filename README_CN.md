# 基于加速度计的事故检测算法
[English](README.md) | 中文

![](https://skillicons.dev/icons?i=matlab)

## 引言
<p>
<img src="https://github.com/Rc-W024/AccidDetec-Accel/assets/97808991/59074c57-fe89-40be-97c9-9da5ae591cff" width=300px /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<img src="https://github.com/Rc-W024/AccidDetec-Accel/assets/97808991/ad5521de-d3b7-49e6-b90d-38da43525c99" width=350px />
</p>

[**RideSafeUM**](https://ridesafeum.com/) 是由欧洲创新与技术研究院Urban Mobility 共同资助的一项计划，通过使用创新技术为用户、公共机构和运营商带来微型交通的安全效益。 该举措将能够主动防止违规骑行行为，在发生事故时提供稳定响应，并通过收集数据进行更广泛的学习，以用于政策制定和管理的目的。 该项目旨在满足使微型移动的高阶安全需求，并鼓励增加客流量，这已成为我们移动系统未来的关键模式。

**RideSafeUM** 解决方案集成了计算机视觉软件与摄像头、GPS和加速计。 该技术催生了一款可支持用户智能手机或外部设备的应用程序。 多功能性是RideSafeUM的核心价值之一，该应用程序可供个人骑手使用，并可轻松与共享微型交通运营商的应用程序集成。 在后台，城市管理系统将使管理部门能够设置用户应用程序中所显示的限制和警告信息，从而达到有效识别并动态管理微型移动安全问题的目的。

*“该系统基于双边通信进行工作。法规等信息将实时通过数字信息的方式展示给用户（通过应用程序或运营商前端）。 同时，一旦发生事故，系统将通过黑匣子功能来识别安全模式，从而向管理部门发送匿名警报。”*

## 事故检测
本项目以异常事件检测技术为基础，开发了基于加速度计的电动滑板车事故检测算法，并上传了几个简单的检测算法供用户学习。基础算法是相当重要的，它对算法后续的优化、开发有很大的帮助和参考意义。在[`AccidentDetection_CFAR.m`](https://github.com/Rc-W024/AccidDetec-Accel/blob/main/AccidentDetection_CFAR.m)中，通过CFAR算法分析加速度信号以检测识别事故事件。在此基础上，开发的其他检测算法都是通过处理、分析数据和信号本身来检测异常（事故）事件。

CFAR算法的基本原理和框架可以参考本人SAR舰船检测项目中的[相关章节](https://github.com/Rc-W024/SAR_Ship_detection_CFAR#constant-false-alarm-rate-cfar)，或参考MATLAB官网的[说明](https://ww2.mathworks.cn/help/phased/ug/constant-false-alarm-rate-cfar-detection.html)。

其中，[`AccidentDetection_Realtime.m`](https://github.com/Rc-W024/AccidDetec-Accel/blob/main/AccidentDetection_Realtime.m)算法模拟了实时事故检测流程，以实现遍历全部数据，在有异常情况部分暂监控并判断其是否为事故，并在检测判断后继续监控剩余数据直到结束。在此情况下，使用了MATLAB中的[`circshift`](https://www.mathworks.com/help/matlab/ref/circshift.html)函数来模拟加速度数据被实时监控的过程。

## 数据与文件...
`data`文件夹中提供了三个测试数据供参考研究。其中，文件名包含“*crash*”的两个数据中，有两起事故事件和附加的“干扰”（台阶、颠簸等非事故振动），[`Normaldrive`](https://github.com/Rc-W024/AccidDetec-Accel/blob/main/data/Normaldrive.tsv)文件是一段带有调头（或类似急转弯）行为的正常行驶数据，用于对比研究。

## 检测结果示例...
CFAR算法：
![cfar](https://user-images.githubusercontent.com/97808991/156751830-3220bc8e-1b9a-4ff6-827d-5d37ef054066.png)
![image](https://user-images.githubusercontent.com/97808991/156751927-ad3edd30-d26f-488a-b9f3-4e686257a73a.png)

算法2：
![accel](https://user-images.githubusercontent.com/97808991/156752181-45d5baad-4693-466f-98d5-f53a67d7868e.png)

算法3：
![accel_y](https://user-images.githubusercontent.com/97808991/156752351-1a3d5a43-6434-44f1-8716-4dc73af61fef.png)
![image](https://user-images.githubusercontent.com/97808991/156752457-5e4fa8ad-3277-4085-9f0e-66f7a8655270.png)

## 相关仓库
Implementation of Signal Processing Algorithm on a smartphone: [`ISPA`](https://github.com/Rc-W024/Implementation-of-Signal-Processing-Algorithm-on-a-smartphone)
