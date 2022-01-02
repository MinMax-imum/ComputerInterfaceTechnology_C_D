
;通过8253发出声音试验

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
	;初始化计数器
	CALL	TINIT
	MOV	CX,	10
MLOOP:	CALL	MAINP
	LOOP	MLOOP
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
TINIT	PROC
	PUSH	AX
	PUSH	DX
	PUSH	DI
	MOV	AL,	0B6H
	;7,6	10	选择计数器2
	;5,4	11	先低八位再高八位
	;3,2,1	011	方式3(方波发生器)
	;0	0	二进制计数
	OUT	43H,	AL
	MOV	DX,	12H
	MOV	AX,	34DCH
	MOV	DI,	1000	;设定频率
	DIV	DI		;高位DX是余数，丢弃
	OUT	42H,	AL	;取低位AX(商)分两次送出到计数器
	MOV	AL,	AH
	OUT	42H,	AL
	;打开计数器并关闭与门
	IN	AL,	61H
	OR	AL,	01H
	AND	AL,	0FDH
	OUT	61H,	AL
	POP	DI
	POP	DX
	POP	AX
	RET
TINIT	ENDP
MAINP	PROC
	PUSH	AX
	PUSH	CX
	;打开与门
	IN	AL,	61H
	OR	AL,	02H
	OUT	61H,	AL
	;延时
	CALL	DLYSUB
	;关闭与门
	IN	AL,	61H
	AND	AL,	0FDH
	OUT	61H,	AL
	;延时
	CALL	DLYSUB
	POP	CX
	POP	AX
	RET
MAINP	ENDP
DLYSUB	PROC
	PUSH	CX
	PUSH	DX
	MOV	DX,	20
DLYCX:	MOV	CX,	0FFFFH
DLYLP:	LOOP	DLYLP
	DEC	DX
	JNZ	DLYCX
	POP	DX
	POP	CX
	RET
DLYSUB	ENDP
CODE	ENDS
	END	STA