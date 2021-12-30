
;此文档编码应为GBK
;使用时请保证其文件名和各级文件夹名都小于8个字符
;(例如“D:\ASM\d1XyASM\d1Xy.asm”)

;十六进制转换为ASCII码

;考虑到星研集成软件平台可直接利用DOS调用输入十六进制数字
;这里写仅适用于星研集成软件平台的代码

;EXTKEY	EQU	00H	;键入0为退出
EXTKEY	EQU	0FH	;键入16(即F键)为退出

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
IF	EXTKEY EQ 00H
	MSTIP	DB	"Press 0 to EXIT.", "$"
ELSEIF	EXTKEY EQ 0FH
	MSTIP	DB	"Press F to EXIT.", "$"
ELSE
	MSTIP	DB	"We don't know how to exit the program!", "$"
ENDIF
	MSIN	DB	0AH, "Input your HEX number: '", "$"
	KCODE	DB	?
	TABC	DB	(16 * 5) DUP (?)	;留出来空间用于存放表格
	MSOUT	DB	"'. The ASCII is: ", "$"
	MSHDOT	DB	"H.", "$"
	MSNAN	DB	"'. Error: Not a HEX number! ", "$"
	MSEND	DB	"************* END ************", 0AH, "$"
DATA	ENDS
CODE	SEGMENT
	ASSUME	CS:CODE, DS:DATA, SS:_STACK
STA:	MOV	AX,	DATA
	MOV	DS,	AX
	PRINTC	0AH		;换行
	PRINTS	MSWLC		;输出欢迎提示文字
	PRINTS	MSTIP		;输出退出方法提示文字
	;生成表格前半部分
	MOV	CX,	10	;初始化计数器
	LEA	BX,	TABC	;初始化数据指针
	MOV	AL,	"0"
CTABF:	MOV	BYTE PTR [BX],	"3"
	INC	BX
	MOV	BYTE PTR [BX],	AL
	INC	AL
	INC	BX
	MOV	BYTE PTR [BX],	"H"
	INC	BX
	MOV	BYTE PTR [BX],	"."
	INC	BX
	MOV	BYTE PTR [BX],	"$"
	INC	BX
	LOOP	CTABF
	;生成表格后半部分(数据指针接续不变)
	MOV	CX,	6	;初始化计数器
	MOV	AL,	"1"
CTABB:	MOV	BYTE PTR [BX],	"4"
	INC	BX
	MOV	BYTE PTR [BX],	AL
	INC	AL
	INC	BX
	MOV	BYTE PTR [BX],	"H"
	INC	BX
	MOV	BYTE PTR [BX],	"."
	INC	BX
	MOV	BYTE PTR [BX],	"$"
	INC	BX
	LOOP	CTABB
	;表格生成完毕
NEXT:	PRINTS	MSIN		;输出提示文字
	;等待输入一个字符
	MOV	AX,	0101H	;Xingyan星研集成软件平台
	INT	21H		;可直接输入十六进制数字
	MOV	KCODE,	AL	;将输入的数字装入内存
	CMP	AL,	0FH
	JA	_ERR		;输入内容若出现大于15的则报错
	MOV	CL,	5
	MUL	CL		;计算AL×5准备查表
	MOV	SI,	AX	;将计算结果装入SI
	PRINTS	MSOUT		;输出提示文字
	LEA	BX,	TABC	;开始查表
	LEA	DX,	[BX + SI]
	MOV	AH,	09H	;输出查表结果
	INT	21H
	JMP	ISEXT
_ERR:	PRINTS	MSNAN		;输出错误信息
ISEXT:	CMP	KCODE,	EXTKEY	;判断输入的是不是退出程序的键
	JNE	NEXT		;不是则准备下一次输入
	PRINTC	0AH		;换行
	PRINTS	MSEND		;输出结束退出提示文字
	;退出程序返回DOS系统
	MOV	AH,	4CH
	INT	21H
CODE	ENDS
	END	STA
