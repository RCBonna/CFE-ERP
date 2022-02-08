*-----------------------------------------------------------------------------*
function ORDP3500() // Impressao por Funcionario % produtividade
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local TOT

pb_lin4(_MSG_,ProcName())
if !abre({	'E->CLIENTE',	'E->PROD',		'E->PARAMORD',;
				'E->ATIVIDAD',	'E->MECMAQ',	'E->EQUIDES',;
				'E->PARAMETRO','E->MOVORDEM'})
	return NIL
end
ORDEM HORAS

pb_box(18,20,,,,'Selecao')
VM_CODMM:=0
VM_DATA :={date()-30,date()}
VM_TIPO :='S'
@19,50 say '[0] para todos'
@20,50 say '[S]intetico/[A]nalitico'
@19,22 say padr(trim(PARAMORD->PA_DESCR1),18,'.') get VM_CODMM   pict masc(11) valid VM_CODMM=0.or.fn_codigo(@VM_CODMM,{'MECMAQ',{||MECMAQ->(dbseek(str(VM_CODMM,2)))},{||ORDP1200T(.T.)},{2,1}})
@20,22 say padr('Tipo Relatorio',18,'.')    get VM_TIPO    pict masc(1) valid VM_TIPO$'AS'
@21,22 say padr('Periodo',18,'.')           get VM_DATA[1] pict masc(7)
@21,55                                      get VM_DATA[2] pict masc(7) valid VM_DATA[2]>=VM_DATA[1]
read
if if(lastkey()#K_ESC,pb_ligaimp(chr(18)),.F.)
	set filter to 	if(VM_CODMM>0,IT_CODPR==VM_CODMM,.T.).and.;
						IT_DTLCT>=VM_DATA[1].and.;
						IT_DTLCT<=VM_DATA[2]
	DbGoTop()
	TOT   :=array(3,7)
	REL   :='Produtividade/Atividades '+trim(PARAMORD->PA_DESCR1)
	PAG   :=0
	LAR   :=132
	afill(TOT[1],0)
	while !eof()
		PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),REL,PAG,'ORDP3501',LAR)
		VM_CODMM1:=IT_CODPR
		MECMAQ->(dbseek(str(VM_CODMM1,2)))
		?pb_zer(VM_CODMM1,2)+'-'+MECMAQ->MM_NOME
		VM_CUSTO:=MECMAQ->MM_VLRHR
		afill(TOT[2],0)
		while !eof().and.VM_CODMM1==IT_CODPR
			VM_CODAT:=IT_CODAT
			ATIVIDAD->(dbseek(str(VM_CODAT,2)))
			?padr(space(10)+pb_zer(VM_CODAT,2)+'-'+ATIVIDAD->AT_DESCR,39)
			afill(TOT[3],0)
			while !eof().and.VM_CODMM1==IT_CODPR.and.VM_CODAT==IT_CODAT
				PAG=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),REL,PAG,'ORDP3501',LAR)
				VM_VLCUSTO:=round(VM_CUSTO*IT_QTD,2)
				TOT[3,1]+=IT_QTD
				TOT[3,2]+=VM_VLCUSTO
				TOT[3,3]+=IT_VLRRE
				TOT[3,4]+=trunca(IT_VLRRE*MECMAQ->MM_PPROD /100)
				TOT[3,5]+=trunca(IT_VLRRE*MECMAQ->MM_PASSID/100)
				TOT[3,6]+=trunca(IT_VLRRE*MECMAQ->MM_PRESP /100)
				if VM_TIPO=='A'
					? space(21)+dtoc(IT_DTLCT)    +space(02)
					??pb_zer(IT_CODOR,6)    +space(02)
					??transform(IT_QTD,  masc(06))+space(02)
					??transform(VM_VLCUSTO,masc(25))+space(02)
					??transform(IT_VLRRE,masc(25))+space(04)
					??transform(trunca(IT_VLRRE*MECMAQ->MM_PPROD /100),masc(06))+space(04)
					??transform(trunca(IT_VLRRE*MECMAQ->MM_PASSID/100),masc(06))+space(04)
					??transform(trunca(IT_VLRRE*MECMAQ->MM_PRESP /100),masc(06))+space(02)
					??transform(trunca(IT_VLRRE*MECMAQ->MM_PPROD /100)+;
									trunca(IT_VLRRE*MECMAQ->MM_PASSID/100)+;
									trunca(IT_VLRRE*MECMAQ->MM_PRESP /100),;
									masc(06))
				end
				dbskip()
			end
			if VM_TIPO=='A'
				? padc('Total da Atividade',39)
			end
			??transform(TOT[3,1],masc(06))+space(02)
			??transform(TOT[3,2],masc(25))+space(02)
			??transform(TOT[3,3],masc(25))+space(04)
			??transform(TOT[3,4],masc(06))+space(04)
			??transform(TOT[3,5],masc(06))+space(04)
			??transform(TOT[3,6],masc(06))+space(02)
			??transform(TOT[3,4]+TOT[3,5]+TOT[3,6],masc(06))
			if VM_TIPO=='A'
				?
			end
			for X:=1 TO 6
				TOT[2,X]+=TOT[3,X]
				TOT[3,X]:=0
			next
		end
		? padr('Total '+REL,39,'.')
		??transform(TOT[2,1],masc(06))+space(02)
		??transform(TOT[2,2],masc(25))+space(02)
		??transform(TOT[2,3],masc(25))+space(02)
		??transform(MECMAQ->MM_PPROD,mI2)
		??transform(TOT[2,4],masc(06))+space(02)
		??transform(MECMAQ->MM_PASSID,mI2)
		??transform(TOT[2,5],masc(06))+space(02)
		??transform(MECMAQ->MM_PRESP,mI2)
		??transform(TOT[2,6],masc(06))+space(02)
		??transform(TOT[2,4]+TOT[2,5]+TOT[2,6],masc(06))
		for X:=1 TO 6
			TOT[1,X]+=TOT[2,X]
			TOT[2,X]:=0
		next
	end
	?replicate('-',LAR)
	? padr('Total Geral',39,'.')
	??transform(TOT[1,1],masc(06))+space(02)
	??transform(TOT[1,2],masc(25))+space(02)
	??transform(TOT[1,3],masc(25))+space(04)
	??transform(TOT[1,4],masc(06))+space(04)
	??transform(TOT[1,5],masc(06))+space(04)
	??transform(TOT[1,6],masc(06))+space(02)
	??transform(TOT[1,4]+TOT[1,5]+TOT[1,6],masc(06))

	?replicate('-',LAR)
	eject
	pb_deslimp()
end
dbcloseall()
return NIL

function ORDP3501()
? left(PARAMORD->PA_DESCR1,9)
??' Atividade      Data  CodOrd      Horas     Vlr Custo    Vlr Cobrad   %=Produtiv   %=Assiduid   %=Responsab     Total'
? replicate('-',LAR)
return NIL
