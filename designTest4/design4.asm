
;字符串匹配判断设计

_STACK	SEGMENT	stack
	DB	100 DUP (?)
_STACK	ENDS
DATA	SEGMENT
	MSWLC	DB	"********** WELCOME ***********", 0AH, "$"
	MSIN1	DB	"INPUT STRING1: ", "$"
	MSIN2	DB	"INPUT STRING2: ", "$"
	STR1	DB	32, ?, 32 DUP (?)
	STR2	DB	32, ?, 32 DUP (?)
	MSOUTM	DB	"MATCH", 0AH, "$"
	MSOUTN	DB	"NO MATCH", 0AH, "$"
	MSEND	DB	"************* END ************", 0AH, "$"
DATA	ENDS
CODE	SEGMENT
	ASSUME	CS:CODE, DS:DATA, SS:_STACK
STA:	MOV	AX,	DATA
	MOV	DS,	AX
	;换行
	MOV	DL,	0AH
	MOV	AH,	02H
	INT	21H
	;输出欢迎提示文字
	LEA	DX,	MSWLC
	MOV	AH,	09H
	INT	21H
	;输出第一个字符串的提示文字
	LEA	DX,	MSIN1
	MOV	AH,	09H
	INT	21H
	;输入第一个字符串
	LEA	DX,	STR1
	MOV	AX,	0A00H
	INT	21H
	;换行
	MOV	DL,	0AH
	MOV	AH,	02H
	INT	21H
	;输出第二个字符串的提示文字
	LEA	DX,	MSIN2
	MOV	AH,	09H
	INT	21H
	;输入第二个字符串
	LEA	DX,	STR2
	MOV	AX,	0A00H
	INT	21H
	;换行
	MOV	DL,	0AH
	MOV	AH,	02H
	INT	21H
	;判断字符串个数是否相同
	MOV	AL,	[STR1 + 1]
	CMP	AL,	[STR2 + 1]
	JNZ	NMATCH			;个数不同直接输出“NO MATCH”
	;个数相同比较字符串内容
	MOV	CL,	AL
	MOV	CH,	0		;初始化循环计数器CX
	LEA	DI,	[STR1+2]	;初始化字符指针
	LEA	SI,	[STR2+2]	;初始化字符指针
NEXT:	MOV	AL,	[DI]		;比较一个字符
	CMP	AL,	[SI]
	JNZ	NMATCH			;字符不同直接输出“NO MATCH”
	INC	DI
	INC	SI
	LOOP	NEXT	;根据CX处理循环
	;若全部比较完成没发现不同字符则输出输出“MATCH”
	LEA	DX,	MSOUTM
	MOV	AH,	09H
	INT	21H
	JMP	EXIT
	;输出“NO MATCH”
NMATCH:	LEA	DX,	MSOUTN
	MOV	AH,	09H
	INT	21H
	;输出结束退出提示文字
EXIT:	LEA	DX,	MSEND
	MOV	AH,	09H
	INT	21H
	;退出程序返回DOS系统
	MOV	AH,	4CH
	INT	21H
CODE	ENDS
	END	STA
