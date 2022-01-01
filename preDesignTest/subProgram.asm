
;子程序试验

_STACK	SEGMENT	stack
	DB	100 DUP (?)
_STACK	ENDS
DATA	SEGMENT
	MSWLC	DB	"********** WELCOME ***********", 0AH, "$"
	MS1	DB	"This is string one. ", "$"
	MS2	DB	"This is string two. ", "$"
	MS3	DB	"This is string three. ", "$"
	MS4	DB	"This is string four. ", "$"
	MS5	DB	"This is string five. ", "$"
	MSEND	DB	"************ END *************", 0AH, "$"
DATA	ENDS
CODE	SEGMENT
	ASSUME	CS:CODE, DS:DATA, SS:_STACK
STA:	MOV	AX,	DATA
	MOV	DS,	AX
	CALL	NLINE
	;输出欢迎提示文字
	LEA	DX,	MSWLC
	MOV	AH,	09H
	INT	21H
	;输出第一个字符串的提示文字
	LEA	DX,	MS1
	MOV	AH,	09H
	INT	21H
	CALL	POUT5
	;循环
	MOV	CX,	2
NEXT:	CALL	NLINE
	LEA	DX,	MS2
	MOV	AH,	09H
	INT	21H
	CALL	NLINE
	LEA	DX,	MS3
	MOV	AH,	09H
	INT	21H
	LOOP	NEXT
	CALL	NLINE
	CALL	POUT4
	;输出结束退出提示文字
	LEA	DX,	MSEND
	MOV	AH,	09H
	INT	21H
	;退出程序返回DOS系统
	MOV	AH,	4CH
	INT	21H
	;换行子程序
NLINE	PROC
	PUSH	DX
	PUSH	AX
	MOV	DL,	0AH
	MOV	AH,	02H
	INT	21H
	POP	AX
	POP	DX
	RET
NLINE	ENDP
POUT4	PROC
	PUSH	DX
	PUSH	AX
	LEA	DX,	MS4
	MOV	AH,	09H
	INT	21H
	CALL	NLINE
	POP	AX
	POP	DX
	RET
POUT4	ENDP
POUT5	PROC
	PUSH	DX
	PUSH	AX
	CALL	NLINE
	LEA	DX,	MS5
	MOV	AH,	09H
	INT	21H
	POP	AX
	POP	DX
	RET
POUT5	ENDP
CODE	ENDS
	END	STA
