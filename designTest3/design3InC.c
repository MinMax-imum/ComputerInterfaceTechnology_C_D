
// ���ĵ�����ӦΪGBK

// �������

#include <stdio.h>

char strIn[32];
char runFlag;           // runFlag7 errorFlag   0û����1����
                        // runFlag6 unusedFlag
                        // runFlag5 unusedFlag
                        // runFlag4 unusedFlag
                        // runFlag3 unusedFlag
                        // runFlag2 unusedFlag
                        // runFlag1 onesFlag    0��λδ��1��λ����
                        // runFlag0 digitFlag   0һλ��1��λ��
char numList[16];
char numLen = 0;

void stringPareser(){   // �﷨������
    char tmpBuf[2];     // [0]��ʮλ��[1]�Ǹ�λ
    char i;
    numLen  =   0;
    runFlag &=  0x7C;   // runFlag7 errFlag     =   0
                        // runFlag1 onesFlag    =   0
                        // runFlag0 digitFlag   =   0
    for(i = 0; i < 32; i++){
        if(strIn[i] < '0' || strIn[i] > '9'){
                       // ����Ĳ�����������Ϊ�Ƿָ���
            if(runFlag & 0x01){         // ��λ��
                numList[numLen] =   tmpBuf[1];
                numList[numLen] +=  10 * tmpBuf[0];
            }else if(runFlag & 0x02)    // һλ���Ҹ�λ����
                numList[numLen] =   tmpBuf[1];
            else{                       // ��λδ��
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
            if(runFlag & 0x01){         // �Ѿ�����λ��
                runFlag |=  0x80;       // runFlag7 errFlag =   1
                break;
            }else if(runFlag & 0x02){   // ��λ���÷���ʮλ
                tmpBuf[0]   =   strIn[i] - '0';
                runFlag     |=  0x01;   // runFlag0 digitFlag   =   1
                                        // ���Ϊ��λ��
            }else{                      // ��λδ�÷����λ
                tmpBuf[1]   =   strIn[i] - '0';
                runFlag     |=  0x02;   // runFlag1 onesFlag    =   1
                                        // ��Ǹ�λ����
            }
        }
    }
}

void sortSub(){         // ������
    char i, j;
    for(i = 0; i < (numLen - 1); i++){
        for(j = i + 1; j < numLen; j++){
            if(numList[j] < numList[i]){
                                        // �ҵ���С�����򽻻�������
                numList[j]  =   numList[j] + numList[i];
                                        // ע����һ����Ҫ�����
                numList[i]  =   numList[j] - numList[i];
                numList[j]  =   numList[j] - numList[i];
            }
        }
    }
}

void outResult(){       // �������������
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
    printf("\n������������֣����ö��ŷָ���\n ");
    scanf("%s", strIn);
    printf("\n���ڷ�����������ݡ���\n");
    stringPareser();    // �����﷨�����������ַ���ת��������
    if(runFlag & 0x80)  // ������
        printf("�������������޷�ʶ��");
    else{               // û�����������
        printf("\n�������ݷ�����ϣ��������򡭡�\n");
        sortSub();      // ����
        printf("\n��������\n ");
        outResult();    // ���������
    }
    printf("\n************* END ************\n");
    printf("\n");
    return 0;
}
