
;乘法试验

_STACK	SEGMENT	stack
	DB	100 DUP (?)
_STACK	ENDS
DATA	SEGMENT
	MSWLC	DB	"********** WELCOME ***********", 0AH, "$"
	N1	DB	7
	N2	DB	8
	R	DB	?
	MSOUT	DB	"计算完成！ ", 0AH, "$"
	MSEND	DB	"************ END *************", 0AH, "$"
DATA	ENDS
CODE	SEGMENT
	ASSUME	CS:CODE, DS:DATA, SS:_STACK
STA:	MOV	AX,	DATA
	MOV	DS,	AX
	;输出欢迎提示文字
	LEA	DX,	MSWLC
	MOV	AH,	09H
	INT	21H
	;准备乘法计算
	MOV	AL,	N1
	MOV	SI,	N2
	MUL	SI
	;输出计算结果高位
	PUSH	AX
	MOV	DL,	AH
	MOV	AH,	02H
	INT	21H
	;输出计算结果低位
	POP	AX
	MOV	DL,	AL
	MOV	AH,	02H
	INT	21H
	;换行
	MOV	DL,	0AH
	MOV	AH,	02H
	INT	21H
	;输出计算完成提示文字
	LEA	DX,	MSOUT
	MOV	AH,	09H
	INT	21H
	;@@@@@@@@@@@@@@@@@@@@@@@@在此处
	;@@@@@@@@@@@@@@@@@@@@@@@@打断点
	;输出结束退出提示文字
	LEA	DX,	MSEND
	MOV	AH,	09H
	INT	21H
	;退出程序返回DOS系统
	MOV	AH,	4CH
	INT	21H
CODE	ENDS
	END	STA




