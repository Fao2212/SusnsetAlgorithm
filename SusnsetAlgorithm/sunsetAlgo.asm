public funct
.data
ten REAL8 51.0               
                             
                              
_test REAL8 22.0
.code

	degrees Proc
		fild cons180
		fmul
		fld pi
		fdiv
		ret
	degrees endP

	aCos Proc
		fstp temporal
		fild cons1
		fld temporal
		fld temporal
		fmul			; Se hace el angulo al cuadrado
		fsub			; A uno se le resta el resultado
		fsqrt			; Se saca la raiz cuadrada de la resta (parte superior de la fraccion)
		fild cons1
		fld temporal
		fadd			; A uno se le suma el angulo
		fdiv			; Se dive la parte superior de la fraccion entre el resultado anterior
		fild cons1
		fpatan		; Se saca arctan, se pasa a grados, y se multiplica por dos
		call degrees
		fild cons2
		fmul
		ret
	aCos endp

	aSin Proc
		fst temporal
		fild cons1
		fild cons1
		fld temporal
		fld temporal
		fmul		; Se hace el angulo al cuadrado
		fsub		; A uno se le resta el angulo al cuadrado
		fsqrt		; A la suma se le saca raiz cuadrada
		fadd		; A uno se le suma lo que da la raiz
		fdiv		; El angulo se divide entre la suma anterior
		fild cons1
		fpatan	; Se saca el arcotangente
		call degrees	; Se pasa el resultado a grados y se multiplica por dos
		fild cons2
		fmul
		ret
	aSin endP

	radians Proc
		fld pi
		fmul
		fild cons180
		fdiv
		ret
	radians endP

	funct PROC

		fld _test                 
		fld ten                   
		fmul                      
		fstp REAL8 ptr _test        
		movsd xmm0, REAL8 ptr _test 

		ret
	funct ENDP

	sunsetAlgo PROC
	;1. Cacular el dia del ano
		;Extraccion de los N
		fild Const275
		fild _month
		fmul
		fild Const9
		fdiv
		fstp N1

		fld Const9
		fld _month
		fadd
		fld Const12
		fdiv
		fstp  N2

		fild _year
		fild Const4
		fdiv
		fstp _tempVar

		fild _year
		fsub _tempVar
		fadd Const2
		fild Const3
		fdiv
		
		fld N2
		fmul
		fstp _tempVar
		fld N1
		fsub _tempVar
		fadd _day
		fsub Const30
		fstp N ;Valor de N

	;2.Convertir la longitud a hora y calcular el tiempo
		fld _longitude
		fld Const15
		fdiv
		fstp _tempVar

		cmp rising,0
		jne HourSetting

		HourRising:
			fild Const6
			jmp ContinueHour:

		HourSetting:
			fild Const18

		ContinueHour:
		fsub _tempVar
		fild Const24
		fadd N
		fstp aproxTime
		 
	sunsetAlgo ENDP

END
