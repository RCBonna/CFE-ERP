*-----------------------------------------------------------------------------*
function ORDP3400() // Impressao por Funcionario . Maquina
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local TOT

pb_lin4(_MSG_,ProcName())
if !abre({	'E->CLIENTE',	'E->PROD',		'E->PARAMORD',;
				'E->ATIVIDAD',	'E->MECMAQ',	'E->EQUIDES',;
				'E->PARAMETRO','E->MOVORDEM'})
	return NIL
end
ordem HRATIV

VM_CODMM:=0
VM_CODAT:=0
VM_DATA :={date()-30,date()}
VM_TIPO :='S'
pb_box(17,20)
@18,50 say '[0] para todos'
@19,50 say '[0] para todos'
//@20,50 say '[S]intetico/[A]nalitico'
@18,22 say padr(trim(PARAMORD->PA_DESCR1),18,'.') get VM_CODMM   pict masc(11) valid VM_CODMM=0.or.fn_codigo(@VM_CODMM,{'MECMAQ',{||MECMAQ->(dbseek(str(VM_CODMM,2)))},{||ORDP1200T(.T.)},{2,1}})
@19,22 say padr('Cod Atividade',18,'.')           get VM_CODAT   pict masc(11) valid VM_CODAT=0.or.fn_codigo(@VM_CODAT,{'ATIVIDAD',{||ATIVIDAD->(dbseek(str(VM_CODAT,2)))},{||ORDP1400T(.T.)},{2,1}})
//@20,22 say padr('Tipo Relatorio',18,'.')    get VM_TIPO    pict masc(1) valid VM_TIPO$'AS'
@21,22 say padr('Periodo',18,'.')           get VM_DATA[1] pict masc(7)
@21,55                                      get VM_DATA[2] pict masc(7) valid VM_DATA[2]>=VM_DATA[1]
read
if if(lastkey()#K_ESC,pb_ligaimp(chr(18)),.F.)
	set filter to 	if(VM_CODMM>0,IT_CODPR==VM_CODMM,.T.).and.;
						if(VM_CODAT>0,IT_CODAT==VM_CODAT,.T.).and.;
						IT_DTLCT>=VM_DATA[1].and.;
						IT_DTLCT<=VM_DATA[2]
	DbGoTop()
	TOT   :=array(9)
	REL   :='Hr Atividade ('+dtoc(VM_DATA[1])+' a '+dtoc(VM_DATA[2])
	PAG   := 0
	LAR   :=78
	TOT[1]:= 0
	TOT[2]:= 0
	TOT[3]:= 0
	while !eof()
		PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),REL,PAG,'ORDP3401',LAR)
		TOT[4]:=0
		TOT[5]:=0
		TOT[6]:=0
		VM_CODATQ:=IT_CODAT
		ATIVIDAD->(dbseek(str(VM_CODATQ,2)))
		?pb_zer(VM_CODATQ,2)+'-'+ATIVIDAD->AT_DESCR
		while !eof().and.VM_CODATQ==IT_CODAT
			VM_CODMMQ:=IT_CODPR
			MECMAQ->(dbseek(str(VM_CODMMQ,2)))
			?space(10)+padr(pb_zer(VM_CODMMQ,2)+'-'+MECMAQ->MM_NOME,25)
			VM_CUSTO:=MECMAQ->MM_VLRHR
			TOT[7]:=0
			TOT[8]:=0
			TOT[9]:=0
			while !eof().and.VM_CODATQ==IT_CODAT.and.VM_CODMMQ==IT_CODPR
				PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),REL,PAG,'ORDP3401',LAR)
				VM_VLCUSTO:=round(VM_CUSTO*IT_QTD,2)
				if VM_TIPO=='A'
					? space(23)+dtoc(IT_DTLCT)    +space(01)
					??transform(IT_QTD,  masc(06))+space(01)
					??transform(VM_VLCUSTO,masc(25))+space(01)
					??transform(IT_VLRRE,masc(25))+space(01)
					??pb_zer(IT_CODOR,6)
				end
				TOT[7]+=IT_QTD               //....fn_hrdec(IT_QTD)
				TOT[8]+=VM_VLCUSTO
				TOT[9]+=IT_VLRRE
				dbskip()
			end
			if VM_TIPO=='A'
				? padc('Total do Mecanico',35)
			end
			??transform(TOT[7],masc(06))+space(02)
			??transform(TOT[8],masc(25))+space(02)
			??transform(TOT[9],masc(25))
			if VM_TIPO=='A'
				?
			end
			TOT[4]+=TOT[7]
			TOT[5]+=TOT[8]
			TOT[6]+=TOT[9]
		end
		? padr('   Total da Atividade',35,'.')
		??transform(TOT[4],masc(06))+space(2)
		??transform(TOT[5],masc(25))+space(2)
		??transform(TOT[6],masc(25))
		?
		TOT[1]+=TOT[4]
		TOT[2]+=TOT[5]
		TOT[3]+=TOT[6]
	end
	?replicate('-',LAR)
	? padr('TOTAL GERAL',35,'.')
	??transform(TOT[1],masc(06))+space(2)
	??transform(TOT[2],masc(25))+space(2)
	??transform(TOT[3],masc(25))
	?replicate('-',LAR)
	eject
	pb_deslimp()
end
dbcloseall()
return NIL

function ORDP3401()
?'Atividade/Mecanico                     Horas     Vlr Custo    Vlr Cobrad'
? replicate('-',LAR)
return NIL
