
# 排序设计

def sortSub():  # 排序函数
    for i in range(0, numLen - 1):
        for j in range(i + 1, numLen):
            if numList[j] < numList[i]: # 找到更小的数则交换两个数
                numList[j]  =   numList[j] + numList[i]
                numList[i]  =   numList[j] - numList[i]
                numList[j]  =   numList[j] - numList[i]

print("\n********** WELCOME **********\n")
print("这是字符串" + "能不能连接起来\n")
if input("你想以空格分隔字符还是以逗号分隔字符？\n\
(空格键选择空格，否则为逗号)\n") == " ":
    print("你选择了空格作为分隔符\n")
    sparator    =   " "
else:
    print("你选择了逗号作为分隔符\n")
    sparator    =   ","
strIn   =   input("输入排序的数字，并用分隔符分隔：\n ")
# 语法分析，字符串转数字数组
print("\n正在分析输入的内容……\n")
errFlag =   False
tmpBuf  =   ""
numList =   []
numLen  =   0
if strIn[-1] != sparator:
    strIn   +=  sparator
for i in strIn:
    if i == sparator:
        if len(tmpBuf) == 1:
            numList.append(eval(tmpBuf))
            tmpBuf  =   ""
        elif len(tmpBuf) == 2:
            tmpNum  =   eval(tmpBuf[1])
            tmpNum  =   tmpNum + 10 * eval(tmpBuf[0])
            numList.append(tmpNum)
        else:
            errFlag =   True
            break
        numLen  +=  1
        tmpBuf  =   ""
    elif i.isdigit():
        tmpBuf  =   tmpBuf + i
    else:
        errFlag =   True
        break

if errFlag:
    print("错误：输入内容无法识别！")
else:
    # 暂时赋值
    # "2,87,5,77,2,54,10,97,26,51,10,24,0,3"
    # "2 87 5 77 2 54 10 97 26 51 10 24 0 3"
    # numList =   [2, 87, 5, 77, 2, 54, 10, 97, 26, 51, 10, 24, 0, 3]
    # numLen  =   14
    print("输入内容分析完毕，正在排序……\n")
    sortSub()   # 排序
    # 输出排序结果
    print("排序结果：\n " + sparator.join("%s"%i for i in numList))

    # # 输出排序结果(复杂些的写法)
    # print("排序结果：", end = "\n ")
    # for i in range(numLen - 1):
    #     print(str(numList[i]), end = sparator)
    # print(str(numList[numLen - 1]))

print("\n************* END ************\n")
