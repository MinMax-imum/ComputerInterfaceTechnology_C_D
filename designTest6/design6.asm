
;���ĵ�����ӦΪGBK

;�����ꡢ�¡�����Ϣ����ʾ

;ע�����dosbox-x�ܹ��ɹ����巢������

;MULTIBELL	EQU	0	;ֻ�ڿ�ʼʱ��һ����
MULTIBELL	EQU	1	;�������й���������������
BELLERR		EQU	3	;����������ʱ���˵��������
BELLYES		EQU	1	;����������ʱ��ȷ���������

;����ַ����ĺ���
;����STRPΪ�ַ���ָ��
;ע��ʹ�������Ӱ��DX��AX
PRINTS	MACRO	STRP
	LEA	DX,	STRP
	MOV	AH,	09H
	INT	21H
	ENDM

_STACK	SEGMENT	stack
	DB	100 DUP (?)
_STACK	ENDS
DATA	SEGMENT
	MSWLC	DB	"********** WELCOME ***********", 0DH, 0AH
		DB	"            ��ӭ             ", 0DH, 0AH, "$"
	_R_N	DB	0DH, 0AH, "$"
	MSGET	DB	0DH, 0AH, "���ڻ�ȡϵͳ���ڡ���", 0DH, 0AH
		DB	"Getting system date...", 0DH, 0AH, "$"
	MSGOT	DB	0DH, 0AH, "ϵͳ���ڻ�ȡ�ɹ���", 0DH, 0AH
		DB	"System date got!", 0DH, 0AH, "$"
	MSIN	DB	0DH, 0AH, "����������ǣ�", 0DH, 0AH
		DB	"What is the date? ", 07H, 0DH, 0AH
		DB	"����YYYY-MM-DD�ĸ�ʽ����", 0DH, 0AH
		DB	"Please input in this format: YYYY-MM-DD"
		DB	0DH, 0AH, 0DH, 0AH, "$"
	INTSY	DW	?
	INTSM	DB	?
	INTSD	DB	?
	INTIY	DW	?
	INTIM	DB	?
	INTID	DB	?
	ONEN	DB	?
	MSOK	DB	0DH, 0AH, 0DH, 0AH, "�����ն���ȷ��", 0DH, 0AH
		DB	"All input is correct!", 0DH, 0AH, "$"
	MSERR	DB	0DH, 0AH, 0DH, 0AH, "�����ˣ�", 0DH, 0AH
		DB	"Misinput!", 0DH, 0AH, "$"
	MSEND	DB	"          ллʹ�ã�          ", 0DH, 0AH
		DB	"************ END ************", 0DH, 0AH, "$"
DATA	ENDS
CODE	SEGMENT
	ASSUME	CS:CODE, DS:DATA, SS:_STACK
STA:	MOV	AX,	DATA
	MOV	DS,	AX
	PRINTS	_R_N		;�س�����
	PRINTS	MSWLC		;�����ӭ��ʾ��Ϣ
	PRINTS	MSGET		;�����ȡ������ʾ��Ϣ
	MOV	AH,	2AH	;CX�꣬DH�£�DL��
	INT	21H		;AL����
	MOV	INTSY,	CX	;����ȡ����������ڴ�
	MOV	INTSM,	DH	;����ȡ�����·����ڴ�
	MOV	INTSD,	DL	;����ȡ�����շ����ڴ�
	PRINTS	MSGOT		;�����ȡ�����ʾ��Ϣ
	PRINTS	MSIN		;���ѯ����ʾ��Ϣ(ͬʱ������)
	CALL	INYYYY		;����������
	MOV	AX,	INTSY
	CMP	AX,	INTIY	;�Ƚ��������Ƿ����
	JNE	IERR		;���������ת�����˳�
	MOV	DL,	"-"	;����ַ�
	MOV	AH,	02H
	INT	21H
	CALL	INMM		;����������
	MOV	AL,	INTSM
	CMP	AL,	INTIM	;�Ƚ��������Ƿ����
	JNE	IERR		;���������ת�����˳�
	MOV	DL,	"-"	;����ַ�
	MOV	AH,	02H
	INT	21H
	CALL	INDD		;����������
	MOV	AL,	INTSD
	CMP	AL,	INTID	;�Ƚ��������Ƿ����
	JNE	IERR		;���������ת�����˳�
	PRINTS	MSOK		;���ȫ��������ȷ����Ϣ
IF MULTIBELL AND BELLYES
	MOV	CX,	BELLYES	;����ѭ������
	MOV	DL,	07H	;�����
	MOV	AH,	02H	;����ַ�(����)
BELL1:	INT	21H
	LOOP	BELL1		;����CX����ѭ��
ENDIF
	JMP	EXIT		;�˳�����
IERR:	PRINTS	MSERR		;���������Ϣ
IF MULTIBELL AND BELLERR
	MOV	CX,	BELLERR	;����ѭ������
	MOV	DL,	07H	;�����
	MOV	AH,	02H	;����ַ�(����)
BELL4:	INT	21H
	LOOP	BELL4		;����CX����ѭ��
ENDIF
EXIT:	PRINTS	_R_N		;�س�����
	PRINTS	MSEND		;���������ʾ��Ϣ
	PRINTS	_R_N		;�س�����
	MOV	AH,	4CH
	INT	21H
INYYYY	PROC			;�������ӳ���
	PUSH	AX
	PUSH	BX
	PUSH	DX
	CALL	IN1NUM		;������һ������
	MOV	AL,	ONEN	;����������ַŵ�AX(�ȷ���AL����AH)
	CALL	IN1NUM		;������һ������
	MOV	BX,	10	;׼��AX��10(��ǰ��BH��Ϊ0����)
	MUL	BL		;��ʱAHӦ���˻��߰�λ��Ϊ��0
	ADD	AL,	ONEN	;����������ּӵ�AX(���������AH��Ϊ0)
	CALL	IN1NUM		;���������������
	MUL	BL		;�ٴ�AL��10(��ʱAH���ܲ�Ϊ0��)
	ADD	AL,	ONEN	;����������ּӵ�AX
	ADC	AH,	0	;����������ּӵ�AX
	CALL	IN1NUM		;��������ĸ�����
	MUL	BX		;�ٴ�AX��10(��ʱDSӦΪ0����֮)
	ADD	AL,	ONEN	;����������ּӵ�AX
	ADC	AH,	0	;����������ּӵ�AX
	MOV	INTIY,	AX	;����������������ڴ�
	POP	DX
	POP	BX
	POP	AX
	RET
INYYYY	ENDP
INMM	PROC			;�������ӳ���
	PUSH	AX
	PUSH	BX
	CALL	IN1NUM		;������һ������
	MOV	AL,	ONEN	;����������ַŵ�AL
	CALL	IN1NUM		;������һ������
	MOV	BL,	10	;׼��AL��10
	MUL	BL		;��ʱAHӦΪ0����֮
	ADD	AL,	ONEN	;����������ּӵ�AL
	MOV	INTIM,	AL	;����������������ڴ�
	POP	BX
	POP	AX
	RET
INMM	ENDP
INDD	PROC			;�����յ��ӳ���
	PUSH	AX
	PUSH	BX
	CALL	IN1NUM		;������һ������
	MOV	AL,	ONEN	;����������ַŵ�AL
	CALL	IN1NUM		;������һ������
	MOV	BL,	10	;׼��AL��10
	MUL	BL		;��ʱAHӦΪ0����֮
	ADD	AL,	ONEN	;����������ּӵ�AL
	MOV	INTID,	AL	;����������������ڴ�
	POP	BX
	POP	AX
	RET
INDD	ENDP
IN1NUM	PROC			;����һ�������ӳ���
	PUSH	AX
	PUSH	BX
	PUSH	DX
KIN:	MOV	AH,	07H	;�����޻��Եȴ�����
	INT	21H		;׼������һ������
	CMP	AL,	"0"	;����Ĳ��������򲻽���
	JB	KIN		;������������
	CMP	AL,	"9"
	JA	KIN		;������������
	MOV	BL,	AL	;����AL��ֵ(�����Ӱ��DL��AX)
	MOV	DL,	AL	;���������������ʾ����
	MOV	AH,	02H
	INT	21H
	SUB	BL,	"0"	;��ASCII���ַ���Ϊ����(�ݴ���BL��)
	MOV	ONEN,	BL	;�����ַ����ڴ汸��
	POP	DX
	POP	BX
	POP	AX
	RET
IN1NUM	ENDP
CODE	ENDS
	END	STA
