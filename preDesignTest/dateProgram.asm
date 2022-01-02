
;接收日期试验

_STACK	SEGMENT	stack
	DB	100 DUP (?)
_STACK	ENDS
DATA	SEGMENT
	MSWLC	DB	"********** WELCOME ***********", 0DH, 0AH, "$"
	MSEND	DB	"************ END *************", 0DH, 0AH, "$"
DATA	ENDS
CODE	SEGMENT
	ASSUME	CS:CODE, DS:DATA, SS:_STACK
STA:	MOV	AX,	DATA
	MOV	DS,	AX
	;回车
	MOV	DL,	0DH
	MOV	AH,	02H
	INT	21H
	;换行
	MOV	DL,	0AH
	MOV	AH,	02H
	INT	21H
	;输出欢迎提示信息
	LEA	DX,	MSWLC
	MOV	AH,	09H
	INT	21H
	;清空几个寄存器
	XOR	AX,	AX
	XOR	CX,	CX
	XOR	DX,	DX
	;接收日期
	MOV	AH,	2AH
	INT	21H
	NOP
	NOP
	;@@@@@@@@@@@@@@@@@@@@@@@@在此处
	;@@@@@@@@@@@@@@@@@@@@@@@@打断点
	NOP
	NOP
	;回车
	MOV	DL,	0DH
	MOV	AH,	02H
	INT	21H
	;换行
	MOV	DL,	0AH
	MOV	AH,	02H
	INT	21H
	;输出退出提示信息
	LEA	DX,	MSEND
	MOV	AH,	09H
	INT	21H
	;回车
	MOV	DL,	0DH
	MOV	AH,	02H
	INT	21H
	;换行
	MOV	DL,	0AH
	MOV	AH,	02H
	INT	21H
	;返回DOS系统
	MOV	AH,	4CH
	INT	21H
NNOP	PROC
	PUSH	CX
	MOV	CX,	30000
RE_:	NOP
	LOOP	RE_
	POP	CX
	RET
NNOP	ENDP
CODE	ENDS
	END	STA
