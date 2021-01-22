.data

	public sunsetAlgo
	public _localT
	public _day
	public _month
	public _year
	public _latitude
	public _longitude
	public _hour
	public _minutes
	public _opcion
	public _zenith

	_day real8 ?
	_month real8 ?
	_year real8 ?
	_latitude REAL8 ?
	_longitude REAL8 ?
	_zenith REAL8 ?
	_opcion dd ?
	_hour dd ?
	_minutes dd ?
	_localT REAL8 ?

	;Constantes 

	localOffset REAL8 -6.0

	;Enteros
	Const_360 REAL8 -360.0
	Const_1 REAL8 -1.0
	Const0 REAL8 0.0
	Const1 REAL8 1.0 
	Const2 REAL8 2.0
	Const3 REAL8 3.0
	Const4 REAL8 4.0
	Const6 REAL8 6.0
	Const9 REAL8 9.0
	Const12 REAL8 12.0
	Const15 REAL8 15.0
	Const18 REAL8 18.0
	Const24 REAL8 24.0
	Const30 REAL8 30.0
	Const60 REAL8 60.0
	Const90 REAL8 90.0
	Const180 REAL8 180.0
	Const275 REAL8 275.0
	Const360 REAL8 360.0

	;Flotantes
	Const09856 REAL8 0.9856
	Const3289 REAL8 3.289
	Const1916 REAL8 1.916
	Const0020 REAL8 0.020
	Const286634 REAL8 282.634
	Const091764 REAL8 0.91764
	Const039782 REAL8 0.30782
	Const006571 REAL8 0.06571
	Const6622 REAL8 6.622

	;Variables
	temp REAL8 ?
	;Paso 1
	N1 REAL8 ?
	N2 REAL8 ?
	N3 REAL8 ?
	N REAL8 ?
	;Paso 2
	lngHour REAL8 ?
	aproxTime REAL8 ?
	;Paso 3
	meanAnomaly REAL8 ?
	sunLongitue REAL8 ?
	; Paso 4
	sunAsention REAL8 ?
	sunLongitude REAL8 ?
	LQuadrant REAL8 ?
	RQuadrant REAL8 ?
	;Paso 5
	cosDeclination REAL8 ?
	sinDeclination REAL8 ?
	cosHour REAL8 ?
	Hour REAL8 ?
	Time REAL8 ?

	

.code

	degrees Proc
		fld Const180
		fmul 
		fldpi
		fdiv
		ret
	degrees endP

	aCos Proc
		fstp temp
		fld Const1
		fld temp
		fld temp
		fmul			; Angulo^2
		fsub			; Resta d 1
		fsqrt			; raiz de resta, numerador
		fld Const1
		fld temp
		fadd			; Suma del angulo con el uno
		fdiv			; Se dive la parte superior de la fraccion entre el resultado anterior
		fld Const1
		fpatan		; Se saca arctan, se pasa a grados, y se multiplica por dos
		call degrees
		fld Const2
		fmul
		ret
	aCos endp

	aSin Proc
		fst temp
		fld Const1
		fld Const1
		fld temp
		fld temp
		fmul		; Se hace el angulo al cuadrado
		fsub		; A uno se le resta el angulo al cuadrado
		fsqrt		; A la suma se le saca raiz cuadrada
		fadd		; A uno se le suma lo que da la raiz
		fdiv		; El angulo se divide entre la suma anterior
		fld Const1
		fpatan	; Se saca el arcotangente
		call degrees	; Se pasa el resultado a grados y se multiplica por dos
		fld Const1
		fmul
		ret
	aSin endP

	radians Proc
		fldpi
		fmul
		fld Const180
		fdiv
		ret
	radians endP

	sunsetAlgo PROC

		movq _latitude,xmm0
		movq _longitude,xmm1
		movq _zenith,xmm2
	;1. Cacular el dia del ano
		;Extraccion de los N
		fld Const275
		fld _month
		fmul
		fld Const9
		fdiv
		fstp N1

		fld Const9
		fld _month
		fadd
		fld Const12
		fdiv
		fstp  N2

		fld _year
		fld Const4
		fdiv
		fstp temp

		fld Const4
		fmul temp
		fstp temp
		fld _year
		fsub temp
		fadd Const3
		fld Const3
		fdiv
		
		fld N2
		fmul
		fstp temp
		fld N1
		fsub temp
		fadd _day
		fsub Const30
		fstp N ;Valor de N

	;2.Convertir la longitud a hora y calcular el tiempo
		fld _longitude
		fld Const15
		fdiv
		fstp lngHour

		cmp _opcion,1
		jne HourSetting

		HourRising:
			fld Const6
			jmp ContinueHour

		HourSetting:
			fld Const18

		ContinueHour:
			fsub lngHour
			fld Const24
			fdiv
			fadd N
			fstp aproxTime


		;3.Calculate mean anomally

		fld Const09856
		fld aproxTime
		fmul
		fsub Const3289
		fstp meanAnomaly

		;4. Calculate sun true longitude

		fld meanAnomaly
		call radians
		fsin
		fld Const1916
		fmul

		fld meanAnomaly
		fld Const2
		fmul
		call radians
		fsin
		fld Const0020
		fmul

		fadd
		fadd meanAnomaly
		fadd Const286634

		;Resta de 360
		CompAbove1:
		fcom Const360
		fnstsw ax
		sahf
		jae Subs1

		;Suma de 360
		CompLess1:
		fcom Const_360
		fnstsw ax
		sahf
		jbe Addition1

		jmp Continue1

		Subs1:
		fsub Const360
		jmp CompAbove1

		Addition1:
		fadd Const360
		jmp CompLess1

		Continue1:
		fstp sunLongitude

		;5.a Calculate sun's right asention
		fld sunLongitude
		call radians
		fptan
		fld Const091764
		fmul 
		fld Const1
		fpatan
		call degrees

		;Resta de 360
		CompAbove2:
		fcom Const360
		fnstsw ax
		sahf
		jae Subs2

		;Suma de 360
		CompLess2:
		fcom Const_360
		fnstsw ax
		sahf
		jbe Addition2

		jmp Continue2

		Subs2:
		fsub Const360
		jmp CompAbove2

		Addition2:
		fadd Const360
		jmp CompLess2

		Continue2:
		fstp sunAsention

		;5.b L and R same quadrant
		fld sunLongitude
		fld Const90
		fdiv 
		fld Const90
		fmul
		fstp LQuadrant

		fld sunAsention
		fld Const90
		fdiv
		fld Const90
		fmul
		fstp RQuadrant

		fld LQuadrant
		fsub RQuadrant
		fadd sunAsention
		fstp sunAsention

		;5.c Right Asention to hours

		fld sunAsention
		fld Const15
		fdiv
		fstp sunAsention

		;6. Sun declination

		fld sunLongitude
		call radians
		fsin
		fld Const039782
		fmul
		fst sinDeclination

		call aSin
		call radians
		fcos
		fstp cosDeclination

		;7.a sun local hour angle
		fld _latitude
		call radians
		fsin
		fld sinDeclination
		fmul

		fld _zenith
		call radians
		fcos
		fsub

		fld _latitude
		call radians
		fcos
		fld cosDeclination
		fmul
		fdiv
		fst CosHour

		fcom Const1
		fnstsw ax
		sahf
		ja NeverSetOrRise

		fld cosHour
		fcom Const_1
		fnstsw ax
		sahf
		jb NeverSetOrRise

		jmp Continue
		
		NeverSetOrRise:

			cmp _opcion,1
			je NeverSet
			mov eax,1
			ret

		NeverSet:
			mov eax,-1
			ret
			

		Continue:

		;7.b calculate hours
		fld cosHour
		call aCos
		cmp _opcion,1
		je FinalHour
		fstp Hour
		fld Const360
		fsub Hour

		FinalHour:
			fld Const15
			fdiv
			fstp Hour

		;8. Calculate mean time
		fld Hour
		fadd sunAsention
		fld aproxTime
		fld Const006571
		fmul
		fadd Const6622
		fsub
		fst Time

		;9. UTC
		fsub lngHour

		;10 Local Offset
		fadd localOffset
		
				; Se compara si UT es mayor igual a 24
		fcom Const24
		fnstsw ax
		sahf
		jae Sub24

		; Se compara si UT es menor a 0
		fcom Const0
		fnstsw ax
		sahf
		jb Sum24

		jmp final_
		
		Sub24:
			fld Const24
			fsub
			jmp final_
			
		Sum24:
			fld Const24
			fadd
		
		final_:
		
		fst _localT
		fistp _hour
		fld _localT
		fild _hour
		fsub
		fld Const60
		fmul
		fabs
		fistp _minutes
		xor eax,eax
		
        RET

		 
	sunsetAlgo ENDP

END
