
// 此文档编码应为GBK

// 排序设计

#include <stdio.h>

char strIn[32];
char runFlag;           // runFlag7 errorFlag   0没出错1出错
                        // runFlag6 unusedFlag
                        // runFlag5 unusedFlag
                        // runFlag4 unusedFlag
                        // runFlag3 unusedFlag
                        // runFlag2 unusedFlag
                        // runFlag1 onesFlag    0个位未用1个位已用
                        // runFlag0 digitFlag   0一位数1两位数
char numList[16];
char numLen = 0;

void stringPareser(){   // 语法分析器
    char tmpBuf[2];     // [0]是十位，[1]是个位
    char i;
    numLen  =   0;
    runFlag &=  0x7C;   // runFlag7 errFlag     =   0
                        // runFlag1 onesFlag    =   0
                        // runFlag0 digitFlag   =   0
    for(i = 0; i < 32; i++){
        if(strIn[i] < '0' || strIn[i] > '9'){
                       // 输入的不是数字则认为是分隔符
            if(runFlag & 0x01){         // 两位数
                numList[numLen] =   tmpBuf[1];
                numList[numLen] +=  10 * tmpBuf[0];
            }else if(runFlag & 0x02)    // 一位数且个位已用
                numList[numLen] =   tmpBuf[1];
            else{                       // 个位未用
                runFlag |=  0x80;       // runFlag7 errFlag =   1
                break;
            }
            numLen++;
            runFlag &=  0xFC;           // runFlag1 onesFlag    =   0
                                        // runFlag0 digitFlag   =   0
            if(strIn[i] == '\0'){
                break;
            }
        }else{
            if(runFlag & 0x01){         // 已经是两位数
                runFlag |=  0x80;       // runFlag7 errFlag =   1
                break;
            }else if(runFlag & 0x02){   // 个位已用分离十位
                tmpBuf[0]   =   strIn[i] - '0';
                runFlag     |=  0x01;   // runFlag0 digitFlag   =   1
                                        // 标记为两位数
            }else{                      // 个位未用分离个位
                tmpBuf[1]   =   strIn[i] - '0';
                runFlag     |=  0x02;   // runFlag1 onesFlag    =   1
                                        // 标记个位已用
            }
        }
    }
}

void sortSub(){         // 排序函数
    char i, j;
    for(i = 0; i < (numLen - 1); i++){
        for(j = i + 1; j < numLen; j++){
            if(numList[j] < numList[i]){
                                        // 找到更小的数则交换两个数
                numList[j]  =   numList[j] + numList[i];
                                        // 注意这一步不要溢出了
                numList[i]  =   numList[j] - numList[i];
                numList[j]  =   numList[j] - numList[i];
            }
        }
    }
}

void outResult(){       // 输出排序结果函数
    char i;
    for(i = 0; i < (numLen - 1); i++){
        printf("%d", numList[i]);
        printf(",");
    }
    printf("%d\n", numList[i]);
}

int main(void){
    char str1[32];
    printf("\n********** WELCOME ***********\n");
    printf("\n输入排序的数字，并用逗号分隔：\n ");
    scanf("%s", strIn);
    printf("\n正在分析输入的内容……\n");
    stringPareser();    // 调用语法分析器，将字符串转数字数组
    if(runFlag & 0x80)  // 出错报错
        printf("错误：输入内容无法识别！");
    else{               // 没出错排序并输出
        printf("\n输入内容分析完毕，正在排序……\n");
        sortSub();      // 排序
        printf("\n排序结果：\n ");
        outResult();    // 输出排序结果
    }
    printf("\n************* END ************\n");
    printf("\n");
    return 0;
}
