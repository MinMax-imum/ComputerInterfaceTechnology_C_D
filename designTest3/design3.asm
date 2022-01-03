
;排序设计

;输出字符串的宏汇编
;参数STRP为字符串指针
;注意使用这个会影响DX和AX
PRINTS	MACRO	STRP
	LEA	DX,	STRP
	MOV	AH,	09H
	INT	21H
	ENDM

_STACK	SEGMENT	stack
	DB	100 DUP (?)
_STACK	ENDS
DATA	SEGMENT
	MSWLC	DB	"********** WELCOME **********", 0DH, 0AH, "$"
	MSIN	DB	0DH, 0AH, "Input a series of numbers,", 0DH, 0AH
		DB	"separated by commas("","") or SPACEs:", 0DH, 0AH
		DB	"	", "$"	;"$"前的空格是相当于“\t”(09H)的制表符
	STRIN	DB	32, ?, 32 DUP (?)	;允许输入32个字符
	MSPRISE	DB	0DH, 0AH, 0DH, 0AH, "Parsing input..."
		DB	0DH, 0AH, "$"
	MSPOK	DB	0DH, 0AH, "The input is parsed. Sorting..."
		DB	0DH, 0AH, "$"
	MSERR	DB	0DH, 0AH, "Error: The input cannot be parsed!"
		DB	0DH, 0AH, "$"
	NUMLST	DB	16 DUP (?)
	NUMLEN	DB	?
	MSANS	DB	0DH, 0AH, "Sorted result:", 0DH, 0AH, "	", "$"
				;"$"前的空格是相当于“\t”(09H)的制表符
	_R_N	DB	0DH, 0AH, "$"
	MSEND	DB	"************ END ************", 0DH, 0AH, "$"
DATA	ENDS
CODE	SEGMENT
	ASSUME	CS:CODE, DS:DATA, SS:_STACK
STA:	MOV	AX,	DATA
	MOV	DS,	AX
	PRINTS	_R_N	;回车换行
	PRINTS	MSWLC	;输出欢迎信息
	PRINTS	MSIN	;输出等待输入的信息
	LEA	DX,	STRIN
	MOV	AH,	0AH
	INT	21H	;输入字符串
	PRINTS	MSPRISE	;输出分析字符串信息
	CALL	SPRISE	;调用语法分析器，转化出数字
	TEST	AL,	0FFH;判断返回信息
	JNZ	PERR	;出错则报错退出
	PRINTS	MSPOK	;未出错则认为分析完成，输出正在排序等信息
	CALL	LSTSRT	;调用排序子程序进行排序
	PRINTS	MSANS	;输出排序结果提示信息
	CALL	OUTLST	;输出排序结果
	JMP	EXIT	;准备退出程序
PERR:	PRINTS	MSERR	;输出字符串无法解析报错信息
EXIT:	PRINTS	_R_N	;回车换行
	PRINTS	MSEND	;输出结束信息
	PRINTS	_R_N	;回车换行
	MOV	AH,	4CH
	INT	21H
	;语法分析器子程序
	;分析出错情况通过AL传回(0FFH为出错)
SPRISE	PROC
	PUSH	SI
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSH	AX
	LEA	SI,	NUMLST	;取数组地址
	AND	NUMLEN,	0	;清零数字个数
	LEA	BX,	[STRIN + 1];取字符串地址(先指向字符个数)
	XOR	CH,	CH	;取循环次数为字符个数
	MOV	CL,	[BX]	;(不包含结尾回车符)
	INC	CX		;多加一次以包括回车符
	INC	BX		;BX指向字符串第一个字符
	XOR	AL,	AL	;此处用AL做临时的标志位
				;其高四位0H个位未用FH个位已用
				;其低四位0H一位数FH两位数
CHRDM:	MOV	AH,	[BX]	;取一个字符
	CMP	AH,	0DH	;判断是否为回车符(0DH)
	JB	ERREX		;小于则报错
	JE	SEPA		;等于则判定为分隔符
	CMP	AH,	" "	;大于则判断是否为空格符(20H)
	JB	ERREX		;小于则报错
	JE	SEPA		;等于则判定为分隔符
	CMP	AH,	","	;大于则判断是否为逗号(2CH)
	JB	ERREX		;小于则报错
	JE	SEPA		;等于则判定为分隔符
	CMP	AH,	"0"	;大于则判断是否为数字(30H到39H)
	JB	ERREX		;小于则报错
	CMP	AH,	"9"	;大于等于继续比较
	JA	ERREX		;大于则报错
				;小于等于则判定为一个一位数字
	TEST	AL,	0FH	;判断是否已经是两位数
	JNZ	ERREX		;已是两位数跳转报错(因为不接受三位数)
	SUB	AH,	"0"	;不是两位数将字符转换为数字待用
	TEST	AL,	0F0H	;判断是否个位已用
	JZ	ONES		;个位未用跳转分离个位
	MOV	DH,	DL	;个位已用则
				;将已放在个位的数(DL)推到十位(临时放在DH)
	MOV	DL,	AH	;新的数作为个位(临时放在DL)
	OR	AL,	0FH	;标记为两位数
	JMP	CHRNXT		;准备判断下一个字符
ONES:	MOV	DL,	AH	;个位未用分离个位(临时放在DL)
	OR	AL,	0F0H	;标记为个位已用
	JMP	CHRNXT		;准备判断下一个字符
SEPA:	TEST	AL,	0FH	;遇到分隔符首先判断是否为两位数
	JZ	SEODIG		;不是两位数跳转继续判断
				;是两位数则计算DH乘10加DL
	MOV	AL,	10	;(此时AL可用于乘法，暂时不作为标志位)
	MUL	DH		;DH乘10放在AX里(此时AH应为0，丢弃)
	ADD	DL,	AL	;DH乘10加DL结果放在DL里
	JMP	SENXT		;跳转将数放入内存并增加数字个数
SEODIG:	TEST	AL,	0F0H	;判断是否个位已用
	JZ	ERREX		;个位未用跳转报错
			;(可能遇到首字符为分隔符或连续两个分隔符的情况了)
				;个位已用且确实是一位数则
				;将一位十进制数字(在DL里)直接放入内存
SENXT:	MOV	[SI],	DL	;将处理得的一个数放入内存
	INC	NUMLEN		;数字个数增加一个
	INC	SI		;数组的数字指针后移一位
	XOR	AL,	AL	;清掉个位已用或两位数的标志位
				;(准备下一个数的循环)
CHRNXT:	INC	BX		;字符指针向后移一位
	LOOP	CHRDM		;根据CX控制循环
	POP	AX		;先恢复AH
	AND	AL,	00H	;AL作为返回值返回未出错信息
	JMP	EXSUB		;退出子程序
ERREX:	POP	AX		;先恢复AH
	OR	AL,	0FFH	;AL作为返回值返回出错信息
EXSUB:	POP	DX		;出栈并退出子程序
	POP	CX
	POP	BX
	POP	SI
	RET
SPRISE	ENDP
	;排序子程序
LSTSRT	PROC
	PUSH	SI
	PUSH	DI
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	LEA	BX,	NUMLST	;数组基地址
	MOV	AL,	NUMLEN
	XOR	AH,	AH
	DEC	AX		;循环(N－1)次
	XOR	SI,	SI	;外循环循环变量i
LOOPEX:	MOV	CL,	NUMLEN
	XOR	CH,	CH
	SUB	CX,	SI
	DEC	CX		;循环(N－i－1)次
	MOV	DI,	SI
	INC	DI		;内循环循环变量j
LOOPIN:	MOV	DL,	[BX][DI];取后面的数
	CMP	DL,	[BX][SI];和前面的数比较
	JAE	NEXTS		;后面的数大于等于前面的数则跳过
	XCHG	DL,	[BX][SI];否则交换将较小的数字放到前面
	MOV	[BX][DI], DL	;取后面的数
NEXTS:	INC	DI		;内循环循环变量j
	LOOP	LOOPIN		;根据CX处理内循环
	INC	SI		;外循环循环变量i
	DEC	AX
	JNZ	LOOPEX		;根据AX处理外循环
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	POP	DI
	POP	SI
	RET
LSTSRT	ENDP
	;输出排序结果子程序
OUTLST	PROC
	PUSH	SI
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	MOV	CL,	NUMLEN
	XOR	CH,	CH	;初始化循环次数
	DEC	CX		;循环(N－1)次
	LEA	SI,	NUMLST	;初始化数据指针
LSTOUT:	MOV	BL,	[SI]
	CALL	OUT1NUM		;输出BL中的数字
	MOV	DL,	","	;输出逗号
	MOV	AH,	02H
	INT	21H
	INC	SI
	LOOP	LSTOUT		;根据CX控制循环
	MOV	BL,	[SI]	;输出最后一个数
	CALL	OUT1NUM		;输出AH中的数字
	PRINTS	_R_N		;回车换行
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	POP	SI
	RET
OUTLST	ENDP
	;输出一个数字子程序
	;数字放在BL里传进子程序
OUT1NUM	PROC
	PUSH	AX
	PUSH	BX
	PUSH	DX
	CMP	BL,	10	;判断是一位数还是两位数
	JB	ONEDIG		;小于则是一位数
	XOR	AH,	AH	;大于等于则输出十位
	MOV	AL,	BL
	MOV	BH,	10
	DIV	BH		;个位(余数)在AH十位(商)在AL
	ADD	AL,	"0"	;数字转换为字符(ASCII码)
	MOV	DL,	AL	;准备输出十位的数字
	MOV	BL,	AH	;保护AH的值(转移到BL)
	MOV	AH,	02H
	INT	21H		;输出十位的数字
ONEDIG:	ADD	BL,	"0"	;个位数字转换为字符(ASCII码)
	MOV	DL,	BL
	MOV	AH,	02H
	INT	21H		;输出个位的数字
	POP	DX
	POP	BX
	POP	AX
	RET
OUT1NUM	ENDP
CODE	ENDS
	END	STA
