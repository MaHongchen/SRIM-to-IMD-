此文件夹中首先包括了SRIM计算的输出文件；

fvac.m是计算质子和空穴的体积分数的文件，目的是为了进一步计算等效折射率；
Au_nk.m, Cr_nk.m, Si_nk.m是计算插值波长对应的nk值的函数；


FR of inclusion Does=...是经过计算后的质子和空穴的体积分数的文件；

EMT_main.m是计算等效介质理论的主程序，其主要函数是maxwell.m；

maxwell nk_eff under Does=...是经过等效介质理论程序计算的对应剂量下的等效nk值；

parratt_ref.m是递归法计算X反射率的主要函数；

XrayReflection.m 调用parratt_ref.m 计算X射线反射率；

maxwell Reflection under Does=...是使用分层结构等效nk值计算的光学反射率文件。

AverDeviation_SquareDeviation.m 是将不同剂量下反射率和未辐照剂量下的反射率进行均差和均方根差的计算文件；