# Accident Detection Based on Accelerometer

This is an accelerometer-based accident detection for electric scooters (E-Scooters) developed on the basis of anomaly event detection. I uploaded several simple detection algorithms for users to study. The basic algorithm is very important, which is of great help and reference for subsequent optimization and development. In [`AccidentDetection_CFAR`](https://github.com/Rc-W024/AccidDetec-Accel/blob/main/AccidentDetection_CFAR.m) of this project, the acceleration signal is analyzed by the CFAR algorithm to detect and identify accident events. Based on this, other detection algorithms is developed that process and analyze the data and signals to detect anomaly events (crash).

For the basic principles and framework of the CFAR algorithm, you can refer to my repository of [CFAR-based SAR ship detection](https://github.com/Rc-W024/SAR_Ship_detection_CFAR#constant-false-alarm-rate-cfar), or refer to the following MATLAB official web site: [Constant False Alarm Rate (CFAR) Detection](https://ww2.mathworks.cn/help/phased/ug/constant-false-alarm-rate-cfar-detection.html)

本项目以异常事件检测为基础，开发了基于加速度计的电动滑板车事故检测算法，并上传了几个简单的检测算法供用户学习。基础算法是相当重要的，它对算法后续的优化、开发有很大的帮助和参考意义。在[`AccidentDetection_CFAR`](https://github.com/Rc-W024/AccidDetec-Accel/blob/main/AccidentDetection_CFAR.m)中，通过CFAR算法分析加速度信号以检测识别事故事件。在此基础上，开发的其他检测算法都是通过处理、分析数据和信号本身来检测异常（事故）事件。

CFAR算法的基本原理和框架可以参考本人SAR舰船检测项目中的[相关章节](https://github.com/Rc-W024/SAR_Ship_detection_CFAR#constant-false-alarm-rate-cfar)，或参考MATLAB官网的说明。

Among them, [`AccidentDetection_Realtime`](https://github.com/Rc-W024/AccidDetec-Accel/blob/main/AccidentDetection_Realtime.m) algorithm simulates real-time accident detection to realize traversal of all data. It will stop traversal when an abnormal situation is detected and judges whether it is an accident, then continues to traverse the remaining data after the detection is completed. In this case, the [`circshift`](https://www.mathworks.com/help/matlab/ref/circshift.html) function in MATLAB is used to simulate the process of acceleration data being monitored in real time.

其中，[`AccidentDetection_Realtime`](https://github.com/Rc-W024/AccidDetec-Accel/blob/main/AccidentDetection_Realtime.m)算法模拟了实时事故检测流程，以实现遍历全部数据，在有异常情况部分暂监控并判断其是否为事故，在检测工作结束后继续监控剩余数据直到结束。在此情况下，使用了MATLAB中的[`circshift`](https://www.mathworks.com/help/matlab/ref/circshift.html)函数来模拟加速度数据被实时监视的过程。

## Data & files...
Three test data are uploaded to the `data` folder for studying. Two of the files where the filename contains *"crash"* have two accident events and additional "disturbances" (steps, violent shaking, etc.). The [`Normaldrive`](https://github.com/Rc-W024/AccidDetec-Accel/blob/main/data/Normaldrive.tsv) file is a part of normal drive data with U-turn behavior for comparison and reference.

`data`文件夹中上传了三个测试数据供参考学习。其中，文件名包含*crash*的两个数据文件中，有两起事故事件和附加的“干扰”（台阶、颠簸等非事故振动），[`Normaldrive`](https://github.com/Rc-W024/AccidDetec-Accel/blob/main/data/Normaldrive.tsv)文件是一段带有调头行为的正常行驶数据，用于对比参考。

## Example of detection results...
Algorithm CFAR:
![cfar](https://user-images.githubusercontent.com/97808991/156751830-3220bc8e-1b9a-4ff6-827d-5d37ef054066.png)
![image](https://user-images.githubusercontent.com/97808991/156751927-ad3edd30-d26f-488a-b9f3-4e686257a73a.png)

Algorithm 2:
![accel](https://user-images.githubusercontent.com/97808991/156752181-45d5baad-4693-466f-98d5-f53a67d7868e.png)

Algorithm 3:
![accel_y](https://user-images.githubusercontent.com/97808991/156752351-1a3d5a43-6434-44f1-8716-4dc73af61fef.png)
![image](https://user-images.githubusercontent.com/97808991/156752457-5e4fa8ad-3277-4085-9f0e-66f7a8655270.png)

## Related repository
Contributor: Srinivas Kulkarni [@cna274](https://github.com/cna274)

Implementation of Signal Processing Algorithm on a smartphone: [`ISPA`](https://github.com/Rc-W024/Implementation-of-Signal-Processing-Algorithm-on-a-smartphone)
