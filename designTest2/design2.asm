
;计算S＝1＋2×3＋3×4＋4×5＋…＋N×(N＋1)(N≥2)

;输出字符串的宏汇编
;参数STRP为字符串指针
;注意使用这个会影响DX和AX
PRINTS	MACRO	STRP
	LEA	DX,	STRP
	MOV	AH,	09H
	INT	21H
	ENDM

;输出一个字符的宏汇编
;参数CHRC为字符的ASCII码
;注意使用这个会影响DL和AX
PRINTC	MACRO	CHRC
	MOV	DL,	CHRC
	MOV	AH,	02H
	INT	21H
	ENDM

_STACK	SEGMENT	stack
	DB	100 DUP (?)
_STACK	ENDS
DATA	SEGMENT
	MSWLC	DB	"********** WELCOME ***********", 0AH, "$"
	MSIN	DB	0AH, "EXIT when N = 0.", 0AH, "Input N = ", "$"
	INTN	DB	?
	MSCAL	DB	0AH, "Calculating...", 0AH, "$"
	OVFLAG	DB	?
	SOUT	DW	?
	MSOUTS	DB	"Result: S = ", "$"
	MSOUTN	DB	0AH, "Error: Unable to caculate!", 0AH, "$"
	MSOUTO	DB	"Error: Overflow!", 0AH, "$"
	MSEND	DB	"************ END *************", 0AH, "$"
DATA	ENDS
CODE	SEGMENT
	ASSUME	CS:CODE, DS:DATA, SS:_STACK
STA:	MOV	AX,	DATA
	MOV	DS,	AX
	PRINTC	0AH	;换行
	PRINTS	MSWLC	;输出欢迎提示文字
AGAIN:	PRINTS	MSIN	;输出待输入的提示文字
	CALL	INSUB	;输入N的值
	CMP	INTN,	2
	JB	BTWO	;小于2跳转，大于等于2进行计算
	PRINTS	MSCAL	;输出正在计算信息
	CALL	CALSUB	;调用子程序进行计算
	TEST	OVFLAG,	0FFH
	JNZ	OVOUT	;判断溢出情况，若溢出则跳转
	PRINTS	MSOUTS	;若未溢出则输出结果提示信息
	CALL	ROUTS	;调用子程序输出S的值
	JMP	AGAIN	;返回去准备下一次计算
OVOUT:	PRINTS	MSOUTO	;若溢出则输出溢出错误信息
	JMP	AGAIN	;返回去准备下一次计算
BTWO:	TEST	INTN,	01H
	JZ	EXIT	;当N＝0退出
	PRINTS	MSOUTN	;当N＝1输出无法计算提示信息
	JNZ	AGAIN	;返回去准备下一次计算
EXIT:	PRINTC	0AH	;换行
	PRINTC	0AH	;换行
	PRINTS	MSEND	;输出结束退出提示文字
	MOV	AH,	4CH
	INT	21H	;退出程序返回DOS系统
INSUB	PROC			;输入子程序
	PUSH	AX
	PUSH	BX
KIN1:	MOV	AH,	07H	;设置无回显等待按键
	INT	21H		;准备输入一个数字
	CMP	AL,	"0"	;输入的不是数字则不接收
	JB	KIN1		;跳回重新输入
	CMP	AL,	"9"
	JA	KIN1		;跳回重新输入
	MOV	BL,	AL	;保护AL的值(后面会影响DL和AX)
	PRINTC	AL		;输入的是数字则显示出来
	SUB	BL,	"0"	;将ASCII码字符变为数字(暂存于BL中)
KIN2:	MOV	AH,	07H	;设置无回显等待按键
	INT	21H		;准备再输入一个数字或空格或回车
	CMP	AL,	0DH	;检查是否为回车键
	JE	ONLY1		;按回车则跳转直接将BL作为N存入内存
	CMP	AL,	" "	;检查是否为空格键
	JE	ONLY1		;按空格则跳转直接将BL作为N存入内存
	CMP	AL,	"0"	;输入的不是数字则不接收
	JB	KIN2		;跳回重新输入
	CMP	AL,	"9"
	JA	KIN2		;跳回重新输入
	MOV	BH,	AL	;保护AL的值(后面会影响DL和AX)
	PRINTC	AL		;输入的是数字则显示出来
	SUB	BH,	"0"	;将ASCII码字符变为数字(暂存于BH中)
	XCHG	BL,	BH	;交换后形成BH为高位BL为低位的结构(有另外的写法)
	MOV	AL,	10	;准备BH乘10
	MUL	BH		;乘完乘积的AH一定为0，用AL继续运算
	ADD	BL,	AL	;到这里算完BL乘10加BH
ONLY1:	MOV	INTN,	BL	;将输入的数字转换后的结果送入内存

; 	;另一种写法
; KIN2:	MOV	AH,	07H	;设置无回显等待按键
; 	INT	21H		;准备再输入一个数字或空格或回车
; 	CMP	AL,	0DH	;检查是否为回车键
; 	JE	ONLY1		;按回车则跳转直接将BL作为N存入内存
; 	CMP	AL,	" "	;检查是否为空格键
; 	JE	ONLY1		;按空格则跳转直接将BL作为N存入内存
; 	CMP	AL,	"0"	;输入的不是数字则不接收
; 	JB	KIN2		;跳回重新输入
; 	CMP	AL,	"9"
; 	JA	KIN2		;跳回重新输入
; 	MOV	BH,	BL	;已知输入两位十进制数那么BH放十位
; 	MOV	BL,	AL	;保护AL的值(后面会影响DL和AX)
; 	PRINTC	AL		;输入的是数字则显示出来
; 	SUB	BL,	"0"	;将ASCII码字符变为数字(暂存于BL中)
; 	MOV	AL,	10	;准备BH乘10
; 	MUL	BH		;乘完乘积的AH一定为0，用AL继续运算
; 	ADD	BL,	AL	;到这里算完BL乘10加BH
; ONLY1:	MOV	INTN,	BL	;将输入的数字转换后的结果送入内存

	POP	BX
	POP	AX
	RET
INSUB	ENDP
CALSUB	PROC			;进行计算子程序
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	MOV	CL,	INTN	;CX用于控制循环次数
	XOR	CH,	CH	;将CH清零
	DEC	CX		;循环(N－1)次
	MOV	BL,	2	;BL用于循环变量
	MOV	DX,	1	;DX用于保存S的值
NEXT:	MOV	AL,	BL	;BL为循环变量N
	INC	AL		;AL的值设为N＋1
	MUL	BL		;计算N(N＋1)放在AX里
	ADD	DX,	AX	;将乘积加到S里(判断是否产生了溢出)
	JC	ERROV		;如果溢出则报错(JC比JO无符号运算范围大)
	INC	BL		;没溢出继续计算
	LOOP	NEXT		;根据CX控制循环
	MOV	SOUT,	DX	;计算结果放入内存
	AND	OVFLAG,	00H	;溢出标志置零
	JMP	CALE		;计算完成退出子程序
ERROV:	OR	OVFLAG,	0FFH	;溢出标志置一
CALE:	POP	DX
	POP	CX
	POP	BX
	POP	AX
	RET
CALSUB	ENDP
ROUTS	PROC			;输出结果子程序
	PUSH	DX
	PUSH	AX
	PUSH	BX
	MOV	AX,	SOUT	;准备除法(置被除数低十六位)
	XOR	DX,	DX	;被除数高十六位DX清零
	MOV	BX,	10000	;除数
	DIV	BX		;AX为万位数字(此处AH应总为0)
	ADD	AL,	"0"	;数字转换为字符(ASCII码)
	MOV	BX,	DX	;保护DX的值(余数)
	PRINTC	AL		;输出万位数字(会影响DL和AX)
	MOV	AX,	BX	;取余数继续计算(置被除数低十六位)
	XOR	DX,	DX	;被除数高十六位DX清零
	MOV	BX,	1000	;除数
	DIV	BX		;AX为千位数字(此处AH应总为0)
	ADD	AL,	"0"	;数字转换为字符(ASCII码)
	MOV	BX,	DX	;保护DX的值(余数)
	PRINTC	AL		;输出千位数字(会影响DL和AX)
	MOV	AX,	BX	;取余数继续计算(置十六位被除数)
	MOV	BL,	100	;除数
	DIV	BL		;AL为百位数字
	ADD	AL,	"0"	;数字转换为字符(ASCII码)
	MOV	BH,	AH	;保护AH的值(余数)
	PRINTC	AL		;输出百位数字(会影响DL和AX)
	MOV	AL,	BH	;取余数继续计算(置被除数低八位)
	XOR	AH,	AH	;被除数高八位清零
	MOV	BL,	10	;除数
	DIV	BL		;AL为十位数字
	ADD	AL,	"0"	;数字转换为字符(ASCII码)
	MOV	BH,	AH	;保护AH的值(余数即个位数字)
	PRINTC	AL		;输出十位数字(会影响DL和AX)
	ADD	BH,	"0"	;数字转换为字符(ASCII码)
	PRINTC	BH		;输出个位数字(会影响DL和AX)
	PRINTC	0AH		;换行
	POP	BX
	POP	AX
	POP	DX
	RET
ROUTS	ENDP
CODE	ENDS
	END	STA
