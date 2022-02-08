 static aVariavF := {1,1,1,1,1,1,1,1,1, 1, 1, 1, 1, 1, 1, 1, 1, 1,1,1,1,1,1}
 //..................1.2.3.4.5.6.7.8.9,10,11,12,13,14,15,16
*-----------------------------------------------------------------------------*
#xtranslate OK      => aVariavF\[  1 \]
#xtranslate BASE    => aVariavF\[  2 \]
#xtranslate vPOS    => aVariavF\[  3 \]
#xtranslate vALG    => aVariavF\[  4 \]
#xtranslate vSOMA   => aVariavF\[  5 \]
#xtranslate vRES    => aVariavF\[  6 \]
#xtranslate vDIG1   => aVariavF\[  7 \]
#xtranslate vDIG2	  => aVariavF\[  8 \]
#xtranslate vPRO    => aVariavF\[  9 \]
#xtranslate vMUL    => aVariavF\[ 10 \]
#xtranslate p       => aVariavF\[ 11 \]
#xtranslate d       => aVariavF\[ 12 \]
#xtranslate n       => aVariavF\[ 13 \]
#xtranslate vBASE2  => aVariavF\[ 14 \]
#xtranslate ORIGEM  => aVariavF\[ 15 \]
#xtranslate MASCARA => aVariavF\[ 16 \]


*************************************************
* Ie_OK(pie,puf,tppess)	: Validacao de Inscricao Estadual
* Parametros	: pie : string,2 caracteres,maiusculo,unidade federal
*					  puf : string,tam.variavel,alfanumerico maiusculo,insc.estadual
*                tppess :
* Retorno		: Logico
* Linguagem	  : Clipper 5.2d
* Linkedicao	 : Normal, nao sao utilizadas bibliotecas externas.
* Desenvolvedor : Machado, Paulo H.S. - phmach@terra.com.br
*************************************************
function IE_OK(pie,puf,tppess)
	OK  :=.F.
	BASE:=''
	vBASE2:=''
	ORIGEM:=''
	if alltrim(pie)=="ISENTO".or.tppess=='F'
		return .t.
	endif
	for vPOS:=1 to len(alltrim(pie))
		if substr(pie,vPOS,1)$"0123456789P"
			origem+=substr(pie,vPOS,1)
		endif
	next
	MASCARA:="99999999999999"
	if puf=="AC"
		MASCARA:="99,99,9999-9"
		base	:=padr(ORIGEM,9,"0")
		if left(BASE,2)=="01" .and. substr(BASE,3,2)<>"00"
			vSOMA:=0
			for vPOS:=1 to 8
				vALG:=val(substr(BASE,vPOS,1))
				vALG:=vALG*(10-vPOS)
				vSOMA+=vALG
			next
			vRES  :=vSOMA%11
			vDIG1 :=str(if(vRES<2,0,11-vRES),1,0)
			vBASE2:=left(BASE,8)+vdig1
			OK	 :=(vBASE2==ORIGEM)
		endif
	elseif puf=="AL"
		MASCARA:="999999999"
		BASE	:=padr(ORIGEM,9,"0")
		if left(BASE,2)=="24"
			vSOMA:=0
			for vPOS:=1 to 8
				 vALG:=val(substr(BASE,vPOS,1))
				 vALG:=vALG*(10-vPOS)
				 vSOMA+=vALG
			next
			vPRO  :=vSOMA*10
			vRES  :=vPRO%11
			vDIG1 :=if(vRES==10,"0",str(vRES,1,0))
			vBASE2:=left(BASE,8)+vDIG1
			OK	 :=(vBASE2==ORIGEM)
		endif
	elseif puf=="AM"
		MASCARA:="99,999,999-9"
		BASE	:=padr(ORIGEM,9,"0")
		vSOMA	:=0
		for vPOS:=1 to 8
			 vALG:=val(substr(BASE,vPOS,1))
			 vALG:=vALG*(10-vPOS)
			 vSOMA+=vALG
		next
		if vSOMA<11
			vDIG1:=str(11-vSOMA,1,0)
		else
			vRES :=vSOMA%11
			vDIG1:=if(vRES<2,"0",str(11-vRES,1,0))
		endif
		vBASE2:=left(BASE,8)+vDIG1
		OK	 :=(vBASE2==ORIGEM)
	elseif puf=="AP"
		MASCARA:="999999999"
		BASE	:=padr(ORIGEM,9,"0")
		if left(BASE,2)=="03"
			n:=val(left(BASE,8))
			if	  n>=3000001 .and. n<=3017000
				p:=5
				d:=0
			elseif n>=3017001 .and. n<=3019022
				p:=9
				d:=1
			elseif n>=3019023
				p:=0
				d:=0
			endif
			vSOMA:=p
			for vPOS:=1 to 8
				 vALG:=val(substr(BASE,vPOS,1))
				 vALG:=vALG*(10-vPOS)
				 vSOMA+=vALG
			next
			vres :=vSOMA%11
			vDIG1:=11-vRES
			if vDIG1==10
				vDIG1:=0
			elseif vDIG1==11
				vDIG1:=d
			endif
			vDIG1 :=str(vDIG1,1,0)
			vBASE2:=left(BASE,8)+vDIG1
			OK	 :=(vBASE2==ORIGEM)
		endif
	elseif puf=="BA"
		MASCARA:="999999-99"
		BASE	:=padr(ORIGEM,8,"0")
		if left(BASE,1)$"0123458"
			vSOMA:=0
			for vPOS:=1 to 6
				 vALG:=val(substr(BASE,vPOS,1))
				 vALG:=vALG*(8-vPOS)
				 vSOMA+=vALG
			next
			vRES  :=vSOMA%10
			vDIG2 :=str(if(vRES==0,0,10-vRES),1,0)
			vBASE2:=left(BASE,6)+vDIG2
			vSOMA  :=0
			for vPOS:=1 to 7
				 vALG:=val(substr(vBASE2,vPOS,1))
				 vALG:=vALG*(9-vPOS)
				 vSOMA+=vALG
			next
			vRES :=vSOMA%10
			vDIG1:=str(if(vRES==0,0,10-vRES),1,0)
		else
			vSOMA:=0
			for vPOS:=1 to 6
				 vALG:=val(substr(BASE,vPOS,1))
				 vALG:=vALG*(8-vPOS)
				 vSOMA+=vALG
			next
			vRES  :=vSOMA%11
			vDIG2 :=str(if(vRES<2,0,11-vRES),1,0)
			vBASE2:=left(BASE,6)+vDIG2
			vSOMA  :=0
			for vPOS:=1 to 7
				 vALG:=val(substr(vBASE2,vPOS,1))
				 vALG:=vALG*(9-vPOS)
				 vSOMA+=vALG
			next
			vRES :=vSOMA%11
			vDIG1:=str(if(vRES<2,0,11-vRES),1,0)
		endif
		vBASE2:=left(BASE,6)+vDIG1+vDIG2
		OK:=(vBASE2==ORIGEM)
	elseif puf=="CE"
		MASCARA:="99999999-9"
		BASE	:=padr(ORIGEM,9,"0")
		vSOMA	:=0
		for vPOS:=1 to 8
			 vALG:=val(substr(BASE,vPOS,1))
			 vALG:=valg*(10-vPOS)
			 vSOMA+=vALG
		next
		vRES :=vSOMA%11
		vDIG1:=11-vRES
		if vDIG1>9;vDIG1:=0;endif
		vBASE2:=left(BASE,8)+str(vDIG1,1,0)
		OK	 :=(vBASE2==ORIGEM)
	elseif puf=="DF"
		MASCARA:="999,99999,999-99"
		BASE	:=padr(ORIGEM,13,"0")
		if left(BASE,3)=="073"
			vSOMA:=0
			vMUL:={4,3,2,9,8,7,6,5,4,3,2}
			for vPOS:=1 to 11
				 vALG:=val(substr(BASE,vPOS,1))
				 vALG:=vALG*vMUL[vPOS]
				 vSOMA+=vALG
			next
			vRES  :=vSOMA%11
			vDIG1 :=if(vRES<2,0,11-vRES)
			vBASE2:=left(BASE,11)+str(vDIG1,1,0)
			vSOMA  :=0
			vMUL  :={5,4,3,2,9,8,7,6,5,4,3,2}
			for vPOS:=1 to 12
				 vALG:=val(substr(vBASE2,vPOS,1))
				 vALG:=vALG*vmul[vPOS]
				 vSOMA+=vALG
			next
			vRES  :=vSOMA%11
			vDIG2 :=if(vRES<2,0,11-vRES)
			vBASE2+=str(vDIG2,1,0)
			OK	 :=(vBASE2==ORIGEM)
		endif
	elseif puf=="ES"
		MASCARA:="999999999"
		BASE	:=padr(ORIGEM,9,"0")
		vSOMA	:=0
		for vPOS:=1 to 8
			 vALG:=val(substr(BASE,vPOS,1))
			 vALG:=vALG*(10-vPOS)
			 vSOMA+=vALG
		next
		vRES  :=vSOMA%11
		vDIG1 :=str(if(vRES<2,0,11-vRES),1,0)
		vBASE2:=left(BASE,8)+vDIG1
		OK	 :=(vBASE2==ORIGEM)
	elseif puf=="GO"
		MASCARA:="99,999,999-9"
		BASE	:=padr(ORIGEM,9,"0")
		if left(BASE,2)$"10,11,15"
			vSOMA:=0
			for vPOS:=1 to 8
				 vALG:=val(substr(BASE,vPOS,1))
				 vALG:=vALG*(10-vPOS)
				 vSOMA+=vALG
			next
			vRES:=vSOMA%11
			if vRES==0
				vDIG1:="0"
			elseif vRES==1
				n	 :=val(left(BASE,8))
				vDIG1:=if(n>=10103105 .and. n<=10119997,"1","0")
			else
				vDIG1:=str(11-vRES,1,0)
			endif
			vBASE2:=left(BASE,8)+vDIG1
			OK	 :=(vBASE2==ORIGEM)
		endif
	elseif puf=="MA"
		MASCARA:="999999999"
		BASE	:=padr(ORIGEM,9,"0")
		if left(BASE,2)=="12"
			vSOMA:=0
			for vPOS:=1 to 8
				 vALG:=val(substr(BASE,vPOS,1))
				 vALG:=vALG*(10-vPOS)
				 vSOMA+=vALG
			next
			vRES  :=vSOMA%11
			vDIG1 :=str(if(vRES<2,0,11-vRES),1,0)
			vBASE2:=left(BASE,8)+vDIG1
			OK	 :=(vBASE2==ORIGEM)
		endif
	elseif puf=="MT"
		MASCARA:="9999999999-9"
		vMUL	:={3,2,9,8,7,6,5,4,3,2}
		for vPOS:=1 to 10
			 vALG:=val(substr(BASE,vPOS,1))
			 vALG:=vALG*vMUL[vPOS]
			 vSOMA+=vALG
		next
		vRES  :=vSOMA%11
		vDIG1 :=if(vRES<2,0,11-vRES)
		vBASE2:=left(BASE,10)+str(vDIG1,1,0)
		OK	 :=(vBASE2==ORIGEM)
	elseif puf=="MS"
		MASCARA:="999999999"
		BASE	:=padr(ORIGEM,9,"0")
		if left(BASE,2)=="28"
			vSOMA:=0
			for vPOS:=1 to 8
				 vALG:=val(substr(BASE,vPOS,1))
				 vALG:=vALG*(10-vPOS)
				 vSOMA+=vALG
			next
			vRES  :=vSOMA%11
			vDIG1 :=str(if(vRES<2,0,11-vRES),1,0)
			vBASE2:=left(BASE,8)+vDIG1
			OK	 :=(vBASE2==ORIGEM)
		endif
	elseif puf=="MG"
		MASCARA:="999,999,999/9999"
		BASE	:=padr(ORIGEM,13,"0")
		vBASE2 :=left(BASE,3)+"0"+substr(BASE,4,8)
		n		:=2
		vSOMA	:=""
		for vPOS:=1 to 12
			 vALG:=val(substr(vBASE2,vPOS,1))
			 n	:=if(n==2,1,2)
			 vALG:=alltrim(str(vALG*n,2,0))
			 vSOMA+=vALG
		next
		n	  :=0
		for vPOS:=1 to len(vSOMA);n+=val(substr(vSOMA,vPOS,1));next
		vSOMA  :=n
		do while right(str(n,3,0),1)<>"0";n++;enddo
		vDIG1 :=str(n-vSOMA,1,0)
		vBASE2:=left(BASE,11)+vDIG1
		vSOMA  :=0
		vMUL  :={3,2,11,10,9,8,7,6,5,4,3,2}
		for vPOS:=1 to 12
			 vALG:=val(substr(vBASE2,vPOS,1))
			 vALG:=vALG*vMUL[vPOS]
			 vSOMA+=vALG
		next
		vRES  :=vSOMA%11
		vDIG2 :=if(vRES<2,0,11-vRES)
		vBASE2+=str(vDIG2,1,0)
		OK	 :=(vBASE2==ORIGEM)
	elseif puf=="PA"
		MASCARA:="99-999999-9"
		BASE	:=padr(ORIGEM,9,"0")
		if left(BASE,2)=="15"
			vSOMA:=0
			for vPOS:=1 to 8
				 vALG:=val(substr(BASE,vPOS,1))
				 vALG:=vALG*(10-vPOS)
				 vSOMA+=vALG
			next
			vRES  :=vSOMA%11
			vDIG1 :=str(if(vRES<2,0,11-vRES),1,0)
			vBASE2:=left(BASE,8)+vDIG1
			OK	 :=(vBASE2==ORIGEM)
		endif
	elseif puf=="PB"
		MASCARA:="99,999,999-9"
		BASE	:=padr(ORIGEM,9,"0")
		vSOMA	:=0
		for vPOS:=1 to 8
			 vALG:=val(substr(BASE,vPOS,1))
			 vALG:=vALG*(10-vPOS)
			 vSOMA+=vALG
		next
		vRES  :=vSOMA%11
		vDIG1 :=11-vRES
		if vDIG1>9;vDIG1:=0;endif
		vBASE2:=left(BASE,8)+str(vDIG1,1,0)
		OK	 :=(vBASE2==ORIGEM)
	elseif puf=="PE"
		MASCARA:="99,9,999,9999999-9"
		BASE	:=padr(ORIGEM,14,"0")
		vSOMA	:=0
		vMUL	:={5,4,3,2,1,9,8,7,6,5,4,3,2}
		for vPOS:=1 to 13
			 vALG:=val(substr(BASE,vPOS,1))
			 vALG:=vALG*vMUL[vPOS]
			 vSOMA+=vALG
		next
		vRES  :=vSOMA%11
		vDIG1 :=11-vRES
		if(vDIG1>9,vDIG1-=10,)
		vBASE2:=left(BASE,13)+str(vDIG1,1,0)
		OK	 :=(vBASE2==ORIGEM)
	elseif puf=="PI"
		MASCARA:="999999999"
		BASE	:=padr(ORIGEM,9,"0")
		vSOMA	:=0
		for vPOS:=1 to 8
			 vALG:=val(substr(BASE,vPOS,1))
			 vALG:=vALG*(10-vPOS)
			 vSOMA+=vALG
		next
		vRES  :=vSOMA%11
		vDIG1 :=str(if(vRES<2,0,11-vRES),1,0)
		vBASE2:=left(BASE,8)+vDIG1
		OK	 :=(vBASE2==ORIGEM)
	elseif puf=="PR"
		MASCARA:="999,99999-99"
		BASE	:=padr(ORIGEM,10,"0")
		vSOMA	:=0
		vMUL	:={3,2,7,6,5,4,3,2}
		for vPOS:=1 to 8
			 vALG:=val(substr(BASE,vPOS,1))
			 vALG:=vALG*vMUL[vPOS]
			 vSOMA+=vALG
		next
		vRES  :=vSOMA%11
		vDIG1 :=str(if(vRES<2,0,11-vRES),1,0)
		vBASE2:=left(BASE,8)+vDIG1
		vSOMA  :=0
		vMUL  :={4,3,2,7,6,5,4,3,2}
		for vPOS:=1 to 9
			 vALG:=val(substr(vBASE2,vPOS,1))
			 vALG:=vALG*vMUL[vPOS]
			 vSOMA+=vALG
		next
		vRES  :=vSOMA%11
		vDIG2 :=str(if(vRES<2,0,11-vRES),1,0)
		vBASE2+=vDIG2
		OK	 :=(vBASE2==ORIGEM)
	elseif puf=="RJ"
		MASCARA:="99,999,99-9"
		BASE	:=padr(ORIGEM,8,"0")
		vSOMA	:=0
		vMUL	:={2,7,6,5,4,3,2}
		for vPOS:=1 to 7
			 vALG:=val(substr(BASE,vPOS,1))
			 vALG:=vALG*vMUL[vPOS]
			 vSOMA+=vALG
		next
		vRES  :=vSOMA%11
		vDIG1 :=str(if(vRES<2,0,11-vRES),1,0)
		vBASE2:=left(BASE,7)+vDIG1
		OK	 :=(vBASE2==ORIGEM)
	elseif puf=="RN"
		MASCARA:="99,999,999-9"
		BASE	:=padr(ORIGEM,9,"0")
		if left(BASE,2)=="20"
			vSOMA:=0
			for vPOS:=1 to 8
				 vALG:=val(substr(BASE,vPOS,1))
				 vALG:=vALG*(10-vPOS)
				 vSOMA+=vALG
			next
			vPRO  :=vSOMA*10
			vRES  :=vPRO%11
			vDIG1 :=str(if(vRES>9,0,vRES),1,0)
			vBASE2:=left(BASE,8)+vDIG1
			OK	 :=(vBASE2==ORIGEM)
		endif
	elseif puf=="RO"
		MASCARA:="999999999"
		BASE	:=padr(ORIGEM,9,"0")
		vBASE2 :=substr(BASE,4,5)
		vSOMA	:=0
		for vPOS:=1 to 5
			 vALG:=val(substr(vBASE2,vPOS,1))
			 vALG:=vALG*(7-vPOS)
			 vSOMA+=vALG
		next
		vRES  :=vSOMA%11
		vDIG1 :=11-vRES
		if vDIG1>9;vDIG1-=10;endif
		vBASE2:=left(BASE,8)+str(vDIG1,1,0)
		OK	 :=(vBASE2==ORIGEM)
	elseif puf=="RR"
		MASCARA:="99999999-9"
		BASE	:=padr(ORIGEM,9,"0")
		if left(BASE,2)=="24"
			vSOMA:=0
			for vPOS:=1 to 8
				 vALG:=val(substr(BASE,vPOS,1))
				 vALG:=vALG*vPOS
				 vSOMA+=vALG
			next
			vRES  :=vSOMA%9
			vDIG1 :=str(vRES,1,0)
			vBASE2:=left(BASE,8)+vDIG1
			OK	 :=(vBASE2==ORIGEM)
		endif
	elseif puf=="RS"
		MASCARA:="999/999999-9"
		BASE	:=padr(ORIGEM,10,"0")
		n		:=val(left(BASE,3))
		if n>0 .and. n<468
			vSOMA:=0
			vMUL:={2,9,8,7,6,5,4,3,2}
			for vPOS:=1 to 9
				 vALG:=val(substr(BASE,vPOS,1))
				 vALG:=vALG*vMUL[vPOS]
				 vSOMA+=vALG
			next
			vRES  :=vSOMA%11
			vDIG1 :=11-vRES
			if vDIG1>9;vDIG1:=0;endif
			vBASE2:=left(BASE,9)+str(vDIG1,1,0)
			OK	 :=(vBASE2==ORIGEM)
		endif
	elseif puf=="SC"
		MASCARA:="999,999,999"
		BASE	:=padr(ORIGEM,9,"0")
		vSOMA	:=0
		for vPOS:=1 to 8
			 vALG:=val(substr(BASE,vPOS,1))
			 vALG:=vALG*(10-vPOS)
			 vSOMA+=vALG
		next
		vRES  :=vSOMA%11
		vDIG1 :=if(vRES<2,"0",str(11-vRES,1,0))
		vBASE2:=left(BASE,8)+vDIG1
		OK	 :=(vBASE2==ORIGEM)
	elseif puf=="SE"
		MASCARA:="99999999-9"
		BASE	:=padr(ORIGEM,9,"0")
		vSOMA	:=0
		for vPOS:=1 to 8
			 vALG:=val(substr(BASE,vPOS,1))
			 vALG:=vALG*(10-vPOS)
			 vSOMA+=vALG
		next
		vRES  :=vSOMA%11
		vDIG1 :=11-vRES
		if vDIG1>9;vDIG1:=0;endif
		vBASE2:=left(BASE,8)+str(vDIG1,1,0)
		OK	 :=(vBASE2==ORIGEM)
	elseif puf=="SP"
		if left(BASE,1)=="P"
			MASCARA:="P-99999999,9/999"
			BASE	:=padr(ORIGEM,13,"0")
			vBASE2 :=substr(BASE,2,8)
			vSOMA	:=0
			vMUL	:={1,3,4,5,6,7,8,10}
			for vPOS:=1 to 8
				 vALG:=val(substr(vBASE2,vPOS,1))
				 vALG:=vALG*vMUL[vPOS]
				 vSOMA+=vALG
			next
			vRES  :=vSOMA%11
			vDIG1 :=right(str(vRES,2,0),1)
			vBASE2:=left(BASE,9)+vDIG1+substr(BASE,11,3)
		else
			MASCARA:="999,999,999,999"
			BASE	:=padr(ORIGEM,12,"0")
			vSOMA	:=0
			vMUL	:={1,3,4,5,6,7,8,10}
			for vPOS:=1 to 8
				 vALG:=val(substr(BASE,vPOS,1))
				 vALG:=vALG*vMUL[vPOS]
				 vSOMA+=vALG
			next
			vRES  :=vSOMA%11
			vDIG1 :=right(str(vRES,2,0),1)
			vBASE2:=left(BASE,8)+vDIG1+substr(BASE,10,2)
			vSOMA  :=0
			vMUL  :={3,2,10,9,8,7,6,5,4,3,2}
			for vPOS:=1 to 11
				 vALG:=val(substr(BASE,vPOS,1))
				 vALG:=vALG*vMUL[vPOS]
				 vSOMA+=vALG
			next
			vRES  :=vSOMA%11
			vDIG2 :=right(str(vRES,2,0),1)
			vBASE2+=vDIG2
		endif
		OK:=(vBASE2==ORIGEM)
	elseif puf=="TO"
		MASCARA:="99,99,999999-9"
		BASE	:=padr(ORIGEM,11,"0")
		if substr(BASE,3,2)$"01,02,03,99"
			vBASE2:=left(BASE,2)+substr(BASE,5,6)
			vSOMA  :=0
			for vPOS:=1 to 8
				 vALG:=val(substr(vBASE2,vPOS,1))
				 vALG:=vALG*(10-vPOS)
				 vSOMA+=vALG
			next
			vRES  :=vSOMA%11
			vDIG1 :=str(if(vRES<2,0,11-vRES),1,0)
			vBASE2:=left(BASE,10)+vDIG1
			OK	 :=(vBASE2==ORIGEM)
		endif
	else
		alert("Unidade Federal Invalida !")
	endif
	if !OK
		if empty(vBASE2)
			alert("Os D¡gitos Identificadores de Cidade e/ou Estado N„o Conferem !")
		else
			vBASE2:=strtran(transform(val(vBASE2),MASCARA)," ","0")
			vBASE2:=strtran(vBASE2,",",".")
			alert("Inscri‡„o Inv lida !;O Correto Seria;"+vBASE2)
		endif
	endif
return .t.
*-------------------------------------------------------
