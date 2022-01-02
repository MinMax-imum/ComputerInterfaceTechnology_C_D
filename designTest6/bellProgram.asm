
;通过字符输出响铃试验

;注意仅在dosbox-x能够成功响铃发出声音

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
	;响铃2次
	MOV	CX,	2
BELL:	MOV	DL,	07H
	MOV	AH,	02H
	INT	21H
	LOOP	BELL
	;延时
	MOV	CX,	50
AGAIN:	CALL	NNOP
	MOV	DL,	"P"
	MOV	AH,	02H
	INT	21H
	LOOP	AGAIN
	;响铃
	MOV	DL,	07H
	MOV	AH,	02H
	INT	21H
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
