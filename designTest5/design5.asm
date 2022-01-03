
;读文件功能设计
;考虑挂载目录
;C:\Users\%用户名%\AppData\Roaming\Code\User\globalStorage\xsro.masm-tasm\workspace

SOUND	EQU	0

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
	MSWLC	DB	"********** WELCOME **********", 0DH, 0AH, "$"
	MSIN	DB	0DH, 0AH, "Input file name: ", "$"
	PATHF	DB	32, ?, 32 DUP (?)
	BUF	DB	100H DUP (?)
	MSOUT	DB	0DH, 0AH, 0DH, 0AH, 18H DUP ("=")
		DB	" File Content ", 18H DUP ("=")
		DB	0DH, 0AH, 0DH, 0AH, "$"
	MSEOP	DB	0DH, 0AH, 0DH, 0AH, "Error: Open error!"
		DB	0DH, 0AH, 0DH, 0AH, "$"
	MSERD	DB	0DH, 0AH, 0DH, 0AH, "Error: Read error!"
		DB	0DH, 0AH, 0DH, 0AH, "$"
	_R_N	DB	0DH, 0AH, "$"
	MSEND	DB	"************ END ************", 0DH, 0AH, "$"
DATA	ENDS
CODE	SEGMENT
	ASSUME	CS:CODE, DS:DATA, SS:_STACK
STA:	MOV	AX,	DATA
	MOV	DS,	AX
	PRINTS	_R_N		;回车换行
	PRINTS	MSWLC		;输出欢迎提示信息
	MOV	DL,	07H	;响铃符
	MOV	AH,	02H	;输出字符(响铃)
	INT	21H
	PRINTS	MSIN		;提示输入文件名
	LEA	DX,	PATHF	;输入字符串
	MOV	AH,	0AH
	INT	21H
	;处理文件名(将回车符换成00H)
	LEA	SI,	[PATHF][1]
	XOR	BH,	BH
	MOV	BL,	[SI]	;取输入的字符串的长度(此处不包括回车符)
	INC	BX		;定位到回车符的位置
	MOV	BYTE PTR [BX][SI], 00H
	;打开文件
	LEA	DX,	PATHF+2	;文件路径
	MOV	AH,	3DH	;打开文件
	MOV	AL,	0	;0读，1写，2读写
	INT	21H		;AX返回文件号或错误码
				;CF做失败标志
	JC	FAILOP		;CF为1失败跳转
	MOV	BX,	AX	;保护AX的值(顺便作为放到读文件的文件号处)
	PRINTS	MSOUT		;输出提示将要开始读取文件内容
	;读文件内容
RDAGN:	LEA	DX,	BUF	;缓冲区
	MOV	CX,	80H	;字节数
	MOV	AH,	3FH	;读文件
	INT	21H		;BX文件号已处理好
				;CF做失败标志
	JC	FAILRD		;CF为1失败跳转
	TEST	AX,	0FFFFH	;看实际读入的字节数是否为0
	JZ	OUTED		;为0则判定为读完
				;不为0则准备输出读到的内容
	MOV	CX,	AX	;字节数作为循环次数
	LEA	SI,	BUF	;字符指针初始化至缓冲区开头
	MOV	AH,	02H	;准备输出字符
OUTCHR:	MOV	DL,	[SI]	;读字符指针指向的内容
	CMP	DL,	1AH	;查看是否为文件结束符EOF
	JE	OUTED		;是则跳转到读完
	INT	21H		;否则输出这个字符(AH和DL已准备好)
	INC	SI		;字符指针移动一个位置
	LOOP	OUTCHR		;根据CX控制循环
	JMP	RDAGN		;再次读文件内容
OUTED:	PRINTS	MSOUT		;读完输出读取结束
	MOV	AH,	3EH	;关闭文件
	INT	21H		;BX为文件号不变
	JMP	EXIT		;准备退出程序
FAILOP:	PRINTS	MSEOP		;输出打开报错信息
	JMP	EXIT		;准备退出程序
FAILRD:	PRINTS	MSOUT		;读取出错则读取结束
	MOV	AH,	3EH	;关闭文件
	INT	21H		;BX为文件号不变
	PRINTS	MSERD		;输出读取报错信息
EXIT:	PRINTS	MSEND		;输出结束提示信息
	PRINTS	_R_N		;回车换行
	MOV	AH,	4CH
	INT	21H
CODE	ENDS
	END	STA
