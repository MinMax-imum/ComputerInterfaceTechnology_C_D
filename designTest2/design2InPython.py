
# 计算S＝1＋2×3＋3×4＋4×5＋…＋N×(N＋1)(N≥2)

print("\n********** WELCOME ***********\n")
n           =   2                       # 初始化变量n
overFlag    =   False                   # 溢出标志
while n > 0:                            # 判断是否退出程序
    n   =   eval(input("输入N的值，\n当 N＝0 则退出程序：\n\tN＝"))
                                        # 此处默认输入为非负的整数
    if n >= 2:
        s           =   1
        overFlag    =   False           # 标志位初始化
        for i in range(2, n + 1):
            s   =   s + i * (i + 1)
            if s > 65535:               # 当s超过16位寄存器存储能力时
                overFlag    =   True    # 触发溢出报错
                print("错误：溢出！\n")  # 报错
                break                   # 不再继续计算
        if overFlag == False:           # 没溢出则输出计算结果
            print("计算结果：\n\tS＝" + str(s)+"\n")
    elif n == 1:
        print("错误：无法计算！\n")
print("\n************* END ************\n")
