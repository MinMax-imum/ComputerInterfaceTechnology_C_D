
;键盘输入一系列内容(回车键结束)
;将这些内容保存到内存区域BUF
;然后将这些内容输出

_STACK	SEGMENT	stack
	DB	100 DUP (?)
_STACK	ENDS
DATA	SEGMENT
	MSIN	DB	0AH, "ENTER YOUR STRING: ", "$"
	MSOUT	DB	"    OUTPUT STRING: ", "$"
	BUF	DB	"$", 80 DUP (?), "$"
DATA	ENDS
CODE	SEGMENT
	ASSUME	CS:CODE, DS:DATA, SS:_STACK
STA:	MOV	AX,	DATA
	MOV	DS,	AX
	;先输出MSIN信息
	LEA	DX,	MSIN
	MOV	AH,	09H
	INT	21H
	;等待键盘按下一个按键
	LEA	BX,	BUF
NEXT1:	MOV	AX,	0100H	;等待按键
	INT	21H
	CMP	AL,	0DH	;判断是否按下回车键
	JE	LF		;按了回车跳走
	MOV	[BX],	AL	;不是回车
	INC	BX
	JMP	NEXT1
LF:	MOV	BYTE PTR [BX],	0AH	;加换行符
	INC	BX
	MOV	BYTE PTR [BX],	"$"	;加结尾符号
	;输出MSOUT信息
	MOV	AH,	02H
	LEA	BX,	MSOUT
NEXT2:	CMP	BYTE PTR [BX],	"$"
	JE	DOL		;是结尾符号则跳走
	MOV	DL,	[BX]	;不是则输出
	INT	21H
	INC	BX
	JMP	NEXT2
DOL:
	;效果等价于
	;LEA	DX,	MSOUT
	;MOV	AH,	09H
	;INT	21H

	;输出内容
	LEA	DX,	BUF
	MOV	AH,	09H
	INT	21H
	;返回DOS
	MOV	AH,	4CH
	INT	21H
CODE	ENDS
	END	STA
