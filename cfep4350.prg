static aVariav := {.F.,{},{},{},{},{}, 0}
//.................1....2..3..4..5..6..7.8.9.10.11
*-----------------------------------------------------------------------------*
#xtranslate FlData    		=> aVariav\[  1 \]
#xtranslate Data  	  		=> aVariav\[  2 \]
#xtranslate Tot	  	  		=> aVariav\[  3 \]
#xtranslate Serie	  	  		=> aVariav\[  4 \]
#xtranslate Docto	  	  		=> aVariav\[  5 \]
#xtranslate CODPR	  	  		=> aVariav\[  6 \]
#xtranslate X	 	 	  		=> aVariav\[  7 \]

#include 'RCB.CH'

*-----------------------------------------------------------------------------*
function CFEP4350()	//	<MENU>-ESTOQUE-MOVIMENTAÇÃO Notas Fiscais de Entrada	*
*-----------------------------------------------------------------------------*

Tot  :={0,0}
Serie:={space(3),    'ZZZ'}
Docto:={       0, 99999999}
CODPR:={       0,        0}

pb_lin4(_MSG_,ProcName())

if !abre({	'R->PARAMETRO',;
				'R->PROD',;
				'R->MOVEST'})
	return NIL
end
select('PROD');dbsetorder(2)
dbgobottom();	CODPR[2]:=PR_CODPR
DbGoTop();		CODPR[1]:=PR_CODPR

DATA:={	BoM(	PARAMETRO->PA_DATA),;
					PARAMETRO->PA_DATA,;
			ctod('')}
X:=15
pb_box(X++,18,,,,'Selecione')
@X  ,20 say 'Data Inicial....:' get Data[1]  pict mDT
@X++,55 say      'Final.:'      get Data[2]  pict mDT      valid Data[2]>=Data[1]
X++
@X,  20 say 'Produto Inicial.:' get CODPR[1] pict masc(21)
@X++,55 say 'Final.:'           get CODPR[2] pict masc(21) valid CODPR[2]>=CODPR[1]
@X,  20 say 'Serie Inicial...:' get SERIE[1] pict mUUU
@X++,55 say 'Final.:'           get SERIE[2] pict mUUU     valid SERIE[2]>=SERIE[1]
@X,  20 say 'Docto Inicial...:' get DOCTO[1] pict mI8
@X++,55 say 'Final.:'           get DOCTO[2] pict mI8      valid DOCTO[2]>=DOCTO[1]
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_ligaimp(I15CPP),.F.)
	select('MOVEST')
	ORDEM DTPROE
	set relation to str(ME_CODPR,L_P) into PROD
	dbseek(dtos(Data[1]),.T.)
	if ME_DATA<=Data[2]
		VM_PAG := 0
		VM_LAR := 132
		VM_REL := 'N.F. Entradas  (Dt.INICIAL.: '+dtoc(Data[1])+'  Dt.FINAL.: '+dtoc(Data[2])+')'
		while !eof() .and. ME_DATA<=Data[2]
			FlData := .T.
			Data[3]:= ME_DATA
			VM_PAG := pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP4350A',VM_LAR)
			Tot[2] := 0
			while !eof().and.ME_DATA==Data[3]
				if ME_DCTO >=DOCTO[1].and.;
					ME_DCTO <=DOCTO[2].and.;
					ME_SERIE>=SERIE[1].and.;
					ME_SERIE<=SERIE[2].and.;
					ME_CODPR>=CODPR[1].and.;
					ME_CODPR<=CODPR[2]
					if FlData
						?I5CPP+dtoc(Data[3])+C5CPP+I15CPP
						?
						FlData:=.F.
					end
					VM_PAG := pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP4350A',VM_LAR)
					?  padr(pb_zer(ME_CODPR,L_P)+chr(45)+PROD->PR_DESCR,53)
					?? space(1)+PROD->PR_UND
					?? space(2)+str(ME_DCTO,10)
					?? space(0)+transform(ME_QTD,masc(5))
					?? space(0)+transform(pb_divzero(ME_VLVEN,ME_QTD),masc(2))
					?? space(2)+transform(pb_divzero(ME_VLEST,ME_QTD),masc(2))
					?? space(1)+transform(ME_VLEST,masc(2))
					Tot[2]+=ME_VLEST
				end	
				pb_brake()
			end
			if str(Tot[2],15,2)#str(0,15,2)
				Tot[1]+=Tot[2]
				?
				?  space(71)+'Vlr.Total Entradas no dia'
					?? replicate('.',17)+':  '+transform(Tot[2],masc(2))
				?
			end
		end
		if str(Tot[1],15,2)#str(0,15,2)
			?  space(71)+'T O T A L   G E R A L'
			?? replicate('.',21)+':  '+transform(Tot[1],masc(2))
			?replicate('-',VM_LAR)
			? 'Impresso as '+time()
			eject
		end
	end
	pb_deslimp(C15CPP)
	set relation to
end
dbcloseall()
return NIL

*-------------------------------------------------------------------------------------
function CFEP4350A()
*-------------------------------------------------------------------------------------
? padr('Produto',53)+' Unid.       Dcto.'+space(3)
??'Qt.Mov.  Vlr.Unt.- VENDA  Vlr.Unt.- MEDIO  Vlr.Total-MEDIO'
?replicate('-',VM_LAR)
return NIL
*-------------------------------------------------------------------------------------

*------------------------------------------------------------------------------------*
function CFEP4351()	//	<MENU>-ESTOQUE-MOVIMENTAÇÃO ENTRADA-SIMPLES						 *
*------------------------------------------------------------------------------------*
Tot  :={			0,				0	}
Serie:={space(3),		'ZZZ'		}
Docto:={       0,	99999999		}
CODPR:={       0, 			0	}

pb_lin4(_MSG_,ProcName())

if !abre({	'R->PARAMETRO',;
				'R->PROD',;
				'R->MOVEST'})
	return NIL
end
select('PROD');dbsetorder(2)
dbgobottom();	CODPR[2]:=PR_CODPR
DbGoTop();		CODPR[1]:=PR_CODPR

DATA:={	BoM(	PARAMETRO->PA_DATA),;
					PARAMETRO->PA_DATA,;
			ctod('')}
			
X	:=16
pb_box(X++,18,,,,'Selecione')
@X  ,20 say 'Data Inicial....:' get Data[1]  pict mDT
@X++,55 say      'Final.:'      get Data[2]  pict mDT      valid Data[2]>=Data[1]
X++
@X,  20 say 'Produto Inicial.:' get CODPR[1] pict masc(21)
@X++,55 say 'Final.:'           get CODPR[2] pict masc(21) valid CODPR[2]>=CODPR[1]
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_ligaimp(C15CPP),.F.)
	select('MOVEST')
	ORDEM DTPROE
	DbGoTop()
	set relation to str(ME_CODPR,L_P) into PROD
	dbseek(dtos(Data[1]),.T.)
	if ME_DATA<=Data[2]
		VM_PAG := 0
		VM_LAR := 80
		VM_REL := 'Entradas ('+dtoc(Data[1])+' - '+dtoc(Data[2])+')'
		while !eof() .and. ME_DATA<=Data[2]
			FlData := .T.
			Data[3]:= ME_DATA
			VM_PAG := pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP4351A',VM_LAR)
			while !eof().and.ME_DATA==Data[3]
				if ME_DCTO >=DOCTO[1].and.;
					ME_DCTO <=DOCTO[2].and.;
					ME_SERIE>=SERIE[1].and.;
					ME_SERIE<=SERIE[2].and.;
					ME_CODPR>=CODPR[1].and.;
					ME_CODPR<=CODPR[2]
					* ME_VLEST	// 5-Vlr.Movimentado (MEDIO-Total)
					* ME_VLVEN	// 6-Vlr.Movimentado (VENDA-Total)
					VM_PAG := pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP4351A',VM_LAR)
					?  DtoC(ME_DATA)
					?? space(1)+padr(pb_zer(ME_CODPR,L_P)+chr(45)+PROD->PR_DESCR,39)
					?? space(1)+PROD->PR_UND // 5 caracteres
					?? space(1)+transform(ME_QTD,mD42)
					?? space(1)+transform(pb_divzero(ME_VLEST,ME_QTD),mD42)
					?? space(1)+transform(pb_divzero(ME_VLVEN,ME_QTD),mD42)
					Tot[1]+=ME_VLEST
				end	
				pb_brake()
			end
		end
		if str(Tot[1],15,2)#str(0,15,2)
			?replicate('-',VM_LAR)
			? 'Impresso as '+time()
			eject
		end
	end
	pb_deslimp(C15CPP)
	set relation to
end
dbcloseall()
return NIL

*-------------------------------------------------------------------------------------
function CFEP4351A()
*-------------------------------------------------------------------------------------
? "DT Movimen "+padr	('Produto',40)+'Unid  Quantid  V.Comp V.Venda'
?replicate('-',VM_LAR)
return NIL
*-------------------------------------------------------------------------------------
