
;此文档编码应为GBK

;接收年、月、日信息并显示

;注意仅在dosbox-x能够成功响铃发出声音

;MULTIBELL	EQU	0	;只在开始时响一次铃
MULTIBELL	EQU	1	;程序运行过程中允许多次响铃
BELLERR		EQU	3	;允许多次响铃时错了的响铃次数
BELLYES		EQU	1	;允许多次响铃时正确的响铃次数

;输出字符串的宏汇编
;参数STRP为字符串指针
;注意使用这个会影响DX和AX
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
		DB	"            欢迎             ", 0DH, 0AH, "$"
	_R_N	DB	0DH, 0AH, "$"
	MSGET	DB	0DH, 0AH, "正在获取系统日期……", 0DH, 0AH
		DB	"Getting system date...", 0DH, 0AH, "$"
	MSGOT	DB	0DH, 0AH, "系统日期获取成功！", 0DH, 0AH
		DB	"System date got!", 0DH, 0AH, "$"
	MSIN	DB	0DH, 0AH, "今天的日期是？", 0DH, 0AH
		DB	"What is the date? ", 07H, 0DH, 0AH
		DB	"请以YYYY-MM-DD的格式输入", 0DH, 0AH
		DB	"Please input in this format: YYYY-MM-DD"
		DB	0DH, 0AH, 0DH, 0AH, "$"
	INTSY	DW	?
	INTSM	DB	?
	INTSD	DB	?
	INTIY	DW	?
	INTIM	DB	?
	INTID	DB	?
	ONEN	DB	?
	MSOK	DB	0DH, 0AH, 0DH, 0AH, "年月日都正确！", 0DH, 0AH
		DB	"All input is correct!", 0DH, 0AH, "$"
	MSERR	DB	0DH, 0AH, 0DH, 0AH, "出错了！", 0DH, 0AH
		DB	"Misinput!", 0DH, 0AH, "$"
	MSEND	DB	"          谢谢使用！          ", 0DH, 0AH
		DB	"************ END ************", 0DH, 0AH, "$"
DATA	ENDS
CODE	SEGMENT
	ASSUME	CS:CODE, DS:DATA, SS:_STACK
STA:	MOV	AX,	DATA
	MOV	DS,	AX
	PRINTS	_R_N		;回车换行
	PRINTS	MSWLC		;输出欢迎提示信息
	PRINTS	MSGET		;输出获取日期提示信息
	MOV	AH,	2AH	;CX年，DH月，DL日
	INT	21H		;AL星期
	MOV	INTSY,	CX	;将获取到的年放入内存
	MOV	INTSM,	DH	;将获取到的月放入内存
	MOV	INTSD,	DL	;将获取到的日放入内存
	PRINTS	MSGOT		;输出获取完毕提示信息
	PRINTS	MSIN		;输出询问提示信息(同时会响铃)
	CALL	INYYYY		;输入年数字
	MOV	AX,	INTSY
	CMP	AX,	INTIY	;比较年数字是否相等
	JNE	IERR		;不相等则跳转报错退出
	MOV	DL,	"-"	;输出字符
	MOV	AH,	02H
	INT	21H
	CALL	INMM		;输入月数字
	MOV	AL,	INTSM
	CMP	AL,	INTIM	;比较月数字是否相等
	JNE	IERR		;不相等则跳转报错退出
	MOV	DL,	"-"	;输出字符
	MOV	AH,	02H
	INT	21H
	CALL	INDD		;输入日数字
	MOV	AL,	INTSD
	CMP	AL,	INTID	;比较日数字是否相等
	JNE	IERR		;不相等则跳转报错退出
	PRINTS	MSOK		;输出全部输入正确的信息
IF MULTIBELL AND BELLYES
	MOV	CX,	BELLYES	;设置循环次数
	MOV	DL,	07H	;响铃符
	MOV	AH,	02H	;输出字符(响铃)
BELL1:	INT	21H
	LOOP	BELL1		;根据CX控制循环
ENDIF
	JMP	EXIT		;退出程序
IERR:	PRINTS	MSERR		;输出报错信息
IF MULTIBELL AND BELLERR
	MOV	CX,	BELLERR	;设置循环次数
	MOV	DL,	07H	;响铃符
	MOV	AH,	02H	;输出字符(响铃)
BELL4:	INT	21H
	LOOP	BELL4		;根据CX控制循环
ENDIF
EXIT:	PRINTS	_R_N		;回车换行
	PRINTS	MSEND		;输出结束提示信息
	PRINTS	_R_N		;回车换行
	MOV	AH,	4CH
	INT	21H
INYYYY	PROC			;输入年子程序
	PUSH	AX
	PUSH	BX
	PUSH	DX
	CALL	IN1NUM		;先输入一个数字
	MOV	AL,	ONEN	;将输入的数字放到AX(先放入AL忽略AH)
	CALL	IN1NUM		;再输入一个数字
	MOV	BX,	10	;准备AX乘10(提前将BH设为0备用)
	MUL	BL		;此时AH应被乘积高八位变为了0
	ADD	AL,	ONEN	;将输入的数字加到AX(不会溢出且AH仍为0)
	CALL	IN1NUM		;再输入第三个数字
	MUL	BL		;再次AL乘10(此时AH可能不为0了)
	ADD	AL,	ONEN	;将输入的数字加到AX
	ADC	AH,	0	;将输入的数字加到AX
	CALL	IN1NUM		;再输入第四个数字
	MUL	BX		;再次AX乘10(此时DS应为0，弃之)
	ADD	AL,	ONEN	;将输入的数字加到AX
	ADC	AH,	0	;将输入的数字加到AX
	MOV	INTIY,	AX	;将输入的年数放入内存
	POP	DX
	POP	BX
	POP	AX
	RET
INYYYY	ENDP
INMM	PROC			;输入月子程序
	PUSH	AX
	PUSH	BX
	CALL	IN1NUM		;先输入一个数字
	MOV	AL,	ONEN	;将输入的数字放到AL
	CALL	IN1NUM		;再输入一个数字
	MOV	BL,	10	;准备AL乘10
	MUL	BL		;此时AH应为0，弃之
	ADD	AL,	ONEN	;将输入的数字加到AL
	MOV	INTIM,	AL	;将输入的月数放入内存
	POP	BX
	POP	AX
	RET
INMM	ENDP
INDD	PROC			;输入日的子程序
	PUSH	AX
	PUSH	BX
	CALL	IN1NUM		;先输入一个数字
	MOV	AL,	ONEN	;将输入的数字放到AL
	CALL	IN1NUM		;再输入一个数字
	MOV	BL,	10	;准备AL乘10
	MUL	BL		;此时AH应为0，弃之
	ADD	AL,	ONEN	;将输入的数字加到AL
	MOV	INTID,	AL	;将输入的日数放入内存
	POP	BX
	POP	AX
	RET
INDD	ENDP
IN1NUM	PROC			;输入一个数字子程序
	PUSH	AX
	PUSH	BX
	PUSH	DX
KIN:	MOV	AH,	07H	;设置无回显等待按键
	INT	21H		;准备输入一个数字
	CMP	AL,	"0"	;输入的不是数字则不接收
	JB	KIN		;跳回重新输入
	CMP	AL,	"9"
	JA	KIN		;跳回重新输入
	MOV	BL,	AL	;保护AL的值(后面会影响DL和AX)
	MOV	DL,	AL	;输入的是数字则显示出来
	MOV	AH,	02H
	INT	21H
	SUB	BL,	"0"	;将ASCII码字符变为数字(暂存于BL中)
	MOV	ONEN,	BL	;将数字放入内存备用
	POP	DX
	POP	BX
	POP	AX
	RET
IN1NUM	ENDP
CODE	ENDS
	END	STA
