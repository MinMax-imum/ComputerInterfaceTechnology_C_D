
;���ĵ�����ӦΪGBK
;ʹ��ʱ�뱣֤���ļ����͸����ļ�������С��8���ַ�
;(���硰D:\ASM\d1XyASM\d1Xy.asm��)

;ʮ������ת��ΪASCII��

;���ǵ����м������ƽ̨��ֱ������DOS��������ʮ����������
;����д�����������м������ƽ̨�Ĵ���

;EXTKEY	EQU	00H	;����0Ϊ�˳�
EXTKEY	EQU	0FH	;����16(��F��)Ϊ�˳�

;����ַ����ĺ���
;����STRPΪ�ַ���ָ��
;ע��ʹ�������Ӱ��DX��AX
PRINTS	MACRO	STRP
	LEA	DX,	STRP
	MOV	AH,	09H
	INT	21H
	ENDM

;���һ���ַ��ĺ���
;����CHRCΪ�ַ���ASCII��
;ע��ʹ�������Ӱ��DL��AX
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
	TABC	DB	(16 * 5) DUP (?)	;�������ռ����ڴ�ű��
	MSOUT	DB	"'. The ASCII is: ", "$"
	MSHDOT	DB	"H.", "$"
	MSNAN	DB	"'. Error: Not a HEX number! ", "$"
	MSEND	DB	"************ END *************", 0AH, "$"
DATA	ENDS
CODE	SEGMENT
	ASSUME	CS:CODE, DS:DATA, SS:_STACK
STA:	MOV	AX,	DATA
	MOV	DS,	AX
	PRINTC	0AH		;����
	PRINTS	MSWLC		;�����ӭ��ʾ����
	PRINTS	MSTIP		;����˳�������ʾ����
	;���ɱ��ǰ�벿��
	MOV	CX,	10	;��ʼ��������
	LEA	BX,	TABC	;��ʼ������ָ��
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
	;���ɱ���벿��(����ָ���������)
	MOV	CX,	6	;��ʼ��������
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
	;����������
NEXT:	PRINTS	MSIN		;�����ʾ����
	;�ȴ�����һ���ַ�
	MOV	AX,	0101H	;Xingyan���м������ƽ̨
	INT	21H		;��ֱ������ʮ����������
	MOV	KCODE,	AL	;�����������װ���ڴ�
	CMP	AL,	0FH
	JA	_ERR		;�������������ִ���15���򱨴�
	MOV	CL,	5
	MUL	CL		;����AL��5׼�����
	MOV	SI,	AX	;��������װ��SI
	PRINTS	MSOUT		;�����ʾ����
	LEA	BX,	TABC	;��ʼ���
	LEA	DX,	[BX + SI]
	MOV	AH,	09H	;��������
	INT	21H
	JMP	ISEXT
_ERR:	PRINTS	MSNAN		;���������Ϣ
ISEXT:	CMP	KCODE,	EXTKEY	;�ж�������ǲ����˳�����ļ�
	JNE	NEXT		;������׼����һ������
	PRINTC	0AH		;����
	PRINTS	MSEND		;��������˳���ʾ����
	;�˳����򷵻�DOSϵͳ
	MOV	AH,	4CH
	INT	21H
CODE	ENDS
	END	STA
