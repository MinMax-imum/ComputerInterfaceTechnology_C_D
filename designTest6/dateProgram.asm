
;������������

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
	;�س�
	MOV	DL,	0DH
	MOV	AH,	02H
	INT	21H
	;����
	MOV	DL,	0AH
	MOV	AH,	02H
	INT	21H
	;�����ӭ��ʾ��Ϣ
	LEA	DX,	MSWLC
	MOV	AH,	09H
	INT	21H
	;��ռ����Ĵ���
	XOR	AX,	AX
	XOR	CX,	CX
	XOR	DX,	DX
	;��������
	MOV	AH,	2AH
	INT	21H
	NOP
	NOP
	;@@@@@@@@@@@@@@@@@@@@@@@@�ڴ˴�
	;@@@@@@@@@@@@@@@@@@@@@@@@��ϵ�
	NOP
	NOP
	;�س�
	MOV	DL,	0DH
	MOV	AH,	02H
	INT	21H
	;����
	MOV	DL,	0AH
	MOV	AH,	02H
	INT	21H
	;����˳���ʾ��Ϣ
	LEA	DX,	MSEND
	MOV	AH,	09H
	INT	21H
	;�س�
	MOV	DL,	0DH
	MOV	AH,	02H
	INT	21H
	;����
	MOV	DL,	0AH
	MOV	AH,	02H
	INT	21H
	;����DOSϵͳ
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
