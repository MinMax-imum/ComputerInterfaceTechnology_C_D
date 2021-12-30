
;十六进制转换为ASCII码

EXTKEY	EQU	" "	;空格键为退出
;EXTKEY	EQU	0DH	;回车键为退出

;输出字符串的宏汇编
;参数STRP为字符串指针
;注意使用这个会影响DX和AX
PRINTS	MACRO	STRP
	LEA	DX,	STRP
	MOV	AH,	09H
	INT	21H
	ENDM

;输出一个字符的宏汇编
;参数CHRC为字符的ASCII码
;注意使用这个会影响DL和AX
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
IF	EXTKEY EQ " "
	MSTIP	DB	"Press SPACE to EXIT.", "$"
ELSEIF	EXTKEY EQ 0DH
	MSTIP	DB	"Press ENTER to EXIT.", "$"
ELSE
	MSTIP	DB	"We don't know how to exit the program!", "$"
ENDIF
	MSIN	DB	0AH, "Input your code: '", "$"
	KCODE	DB	?
	MSOUT	DB	"'. The ASCII is: ", "$"
	MSHDOT	DB	"H.", "$"
	MSNAN	DB	"'. Error: Not a HEX number! ", "$"
	MSEND	DB	"************* END ************", 0AH, "$"
DATA	ENDS
CODE	SEGMENT
	ASSUME	CS:CODE, DS:DATA, SS:_STACK
STA:	MOV	AX,	DATA
	MOV	DS,	AX
	PRINTC	0AH		;换行
	PRINTS	MSWLC		;输出欢迎提示文字
	PRINTS	MSTIP		;输出退出方法提示文字
NEXT:	PRINTS	MSIN		;输出提示文字
	;等待输入一个字符
	MOV	AH,	01H	;对于星研集成软件平台此处可另外考虑
	INT	21H
	MOV	KCODE,	AL	;将输入的字符装入内存
	CMP	AL,	"0"
	JB	JNAN		;ASCII小于"0"的ASCII则不是数字
	CMP	AL,	"9"	;ASCII大于等于"0"的ASCII时
	JBE	JI09		;ASCII小于等于"9"的ASCII则是数字
	CMP	AL,	"A"	;ASCII大于"9"的ASCII时
	JB	JNAN		;ASCII小于"A"的ASCII则不是数字
	CMP	AL,	"F"	;ASCII大于等于"A"的ASCII时
	JBE	JIAF		;ASCII小于等于"F"的ASCII则是数字
	CMP	AL,	"a"	;ASCII大于"F"的ASCII时
	JB	JNAN		;ASCII小于"a"的ASCII则不是数字
	CMP	AL,	"f"	;ASCII大于等于"a"的ASCII时
	JA	JNAN		;ASCII大于"f"的ASCII则不是数字
				;ASCII小于等于"f"的ASCII则是数字
	;输出小写字母a到f的十六进制的ASCII码值			
	PRINTS	MSOUT		;输出提示文字
	PRINTC	"6"
	MOV	AL,	KCODE
	SUB	AL,	30H	;从61H到66H范围减到31H到36H范围
	PRINTC	AL
	PRINTS	MSHDOT
	JMP	ISEXT
TMPJMP:	JMP	NEXT
	;输出大写字母A到F的十六进制的ASCII码值
JIAF:	PRINTS	MSOUT		;输出提示文字
	PRINTC	"4"
	MOV	AL,	KCODE
	SUB	AL,	10H	;从41H到46H范围减到31H到36H范围
	PRINTC	AL
	PRINTS	MSHDOT
	JMP	ISEXT
	;输出数字0到9的十六进制的ASCII码值
JI09:	PRINTS	MSOUT		;输出提示文字
	PRINTC	"3"
	PRINTC	KCODE
	PRINTS	MSHDOT
	JMP	ISEXT
JNAN:	PRINTS	MSNAN		;输出NaN信息
ISEXT:	CMP	KCODE,	EXTKEY	;判断输入的是不是退出程序的键
	JNE	TMPJMP		;不是则准备下一次输入
	PRINTC	0AH		;换行
	PRINTS	MSEND		;输出结束退出提示文字
	;退出程序返回DOS系统
	MOV	AH,	4CH
	INT	21H
CODE	ENDS
	END	STA
