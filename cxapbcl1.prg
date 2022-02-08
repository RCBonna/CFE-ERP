*-----------------------------------------------------------------------------*
function CXAPBCL1() // Lista Movimento Bancario 
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local SALDO

if !abre({	'C->PARAMETRO',;
				'C->CTACTB',;
				'C->BANCO',;
				'C->CAIXAPA',;
				'C->CAIXACG',;
				'C->DIARIO',;
				'C->CTADET',;
				'C->CAIXAMB'})
	return NIL
end
pb_lin4(_MSG_,ProcName())
if !cxa_cont()
	dbcloseall()
	return NIL
end

VM_CODBC:=if(BANCO->(lastrec())>1,0,BANCO->BC_CODBC)

if BANCO->(lastrec())>1
	VM_CODBC:=fn_banco()
	if VM_CODBC==0
		dbcloseall()
		return NIL
	end
end

VM_DATA:={bom(PARAMETRO->PA_DATA),eom(PARAMETRO->PA_DATA)}
pb_box(17,40,,,,'Selecao')
@19,42 say 'Data Inicial.:' get VM_DATA[1] pict mDT
@20,42 say 'Data Final...:' get VM_DATA[2] pict mDT valid VM_DATA[2]>=VM_DATA[1]
read
if if(lastkey()#27,pb_ligaimp(C15CPP),.F.)
	pb_msg('Calculando Saldo Inicial...')
	VM_SLDINI:=BANCO->BC_SLDINI
	ordem GDATA
	dbseek(str(VM_CODBC,2)+dtos(CAIXAPA->PA_DTFECB+1),.T.)
	if VM_DATA[1]>=CAIXAPA->PA_DTFECB
		while !eof().and.MB_CODBC==VM_CODBC.and.MB_DATA<VM_DATA[1]
			@24,50 say dtoc(MB_DATA)
			if !MB_FECHADO
				VM_SLDINI+=if(MB_TIPO=='-',-MB_VALOR,+MB_VALOR)
			end
			dbskip()
		end
	else
		dbskip(-1)
		while !bof().and.MB_CODBC==VM_CODBC.and.MB_DATA>=VM_DATA[1]
			@24,50 say dtoc(MB_DATA)
			if MB_FECHADO
				VM_SLDINI+=if(MB_TIPO=='-',+MB_VALOR,-MB_VALOR)
			end
			dbskip(-1)
		end
		dbskip()
	end
	go top
	pb_msg('Imprimindo... <ESC> cancela.')
	dbseek(str(VM_CODBC,2)+dtos(VM_DATA[1]),.T.)
	VM_PAG  := 0
	VM_REL  := 'Saldo Bancario-'
	VM_REL  +=  dtoc(VM_DATA[1])+'-'+dtoc(VM_DATA[2])
	VM_LAR  := 78
	VM_TOTAL:={0,0}
	while !eof().and.MB_CODBC==VM_CODBC.and.MB_DATA<=VM_DATA[2]
		VM_PAG:= pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CXAPBCL1C',VM_LAR)
		?  dtoc(MB_DATA)
		?? str(MB_DOCTO,8) + space(1)
		?? left(MB_HISTO,47)
		?? transform(MB_VALOR*if(MB_TIPO=='+',1,-1),mD82)
		VM_TOTAL[if(MB_TIPO=='+',1,2)]+=MB_VALOR
//		?? transform(VM_SLDINI+VM_TOTAL[1]-VM_TOTAL[2],mD82)
		pb_brake()
 	end
	?replicate('-',VM_LAR)
//	if VM_TOTAL[1]>0
		?padr('Total Lancamentos-Entradas',63,'.')+transform(VM_TOTAL[1],mD132)
//	end
//	if VM_TOTAL[2]>0
		?padr('Total Lancamentos-Saidas',63,'.')+transform(-VM_TOTAL[2],mD132)
//	end
	?padr('Saldo Final em '+dtoc(VM_DATA[2]),63,'.')+transform(VM_SLDINI+VM_TOTAL[1]-VM_TOTAL[2],mD132)
	?replicate('-',VM_LAR)
	?'Impresso as '+time()
	eject
	pb_deslimp(C15CPP)
end
dbcloseall()
return NIL

*-----------------------------------------------*  CABECALHO
function CXAPBCL1C()
?'Banco : '+pb_zer(VM_CODBC,2)+' - '+BANCO->BC_DESCR
?space(18)+'Saldo Inicial..:'+transform(VM_SLDINI,mD132)
?'  Data    Documen Historico'+space(45)+'Valor'
? replicate('-',VM_LAR)
return NIL
*--------------------------------------------------EOF