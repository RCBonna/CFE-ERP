*-----------------------------------------------------------------------------*
	function FATPPIS() // Listagem de Vendas												*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local Pag
local X
local Total:=array(10)
local TotGeral:=array(10)
private Flag

VM_CPO:={0,'dt1','dt2', , ,0, ,'T',0,3,2}
//       1   2      3  4  56  7 8  9 0,1

VM_REL:='Vendas por Produto com PIS'

pb_lin4(VM_REL,ProcName())

if !abre({	'R->PROD',	'R->PARAMETRO','R->CLIENTE',	'R->PEDCAB',;
				'R->DPCLI',	'R->PEDDET',	'R->HISCLI',	'R->GRUPOS'})
	return NIL
end
select('PROD')
dbsetorder(2)	// Cadastro de Produtos

select('PEDCAB')
ordsetfocus('DTEPED')
DbGoTop()


ARQ:=ArqTemp(,,'')
dbcreate(ARQ,{ {'RV_CODPR',  'N',L_P,0},;
					{'RV_DESCR',  'C', 40,0},;
					{'RV_ATIVID', 'N',  2,0},;
					{'RV_VLRVEN', 'N', 12,2}})

if !net_use(ARQ,.T., ,'RELVENDAS', ,.F.,RDDSETDEFAULT())
	dbcloseall()
	return NIL
end

Index on str(RV_CODPR,L_P)+str(RV_ATIVID,2) tag CODIGO_PROD to (ARQ) eval {||ODOMETRO('COD PRODUTO')}

dTipo  :=restarray('TIPOCLI.ARR')
VM_CPO[2]:=bom(PARAMETRO->PA_DATA)
VM_CPO[3]:=PARAMETRO->PA_DATA
pb_box(16,20,,,,'Selecione')
@17,22 say 'Data Emissao Incial....:' get VM_CPO[2] pict masc(07)
@18,22 say 'Data Emissao Final.....:' get VM_CPO[3] pict masc(07)  valid VM_CPO[3]>=VM_CPO[2]
read
if if(lastkey()#K_ESC,pb_ligaimp(I15CPP),.F.)
	pb_msg('Calculando valores... Aguarde...')
	FLAG:=array(10)
	afill(FLAG,.F.)
	FATPCALC()
	pb_msg('Imprimindo ESC cancela...')
	select('RELVENDAS')
	DbGoTop()
	afill(TotGeral,0)
	VM_LAR:=132
	Pag   :=0
	VM_REL+=' Ref: '+dtoc(VM_CPO[2])+' ate '+dtoc(VM_CPO[3])
	while !eof()
		VM_CPO[1]:=RV_CODPR
		afill(TOTAL,0)
		Pag:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,Pag,'FATPPISC',VM_LAR)
		? padl(transform(RV_CODPR,masc(21))+space(1)+RV_DESCR,38)
		while !eof().and.VM_CPO[1]==RV_CODPR
			if RV_ATIVID>0 .and. RV_ATIVID<10
				TOTAL[RV_ATIVID]+=RV_VLRVEN
			else
				TOTAL[10]+=RV_VLRVEN
			end
			dbskip()
		end
		for X:=1 to 10
			if FLAG[X]
				??transform(TOTAL[X],mD82)+'|'
				TotGeral[X]+=TOTAL[X]
			end
		next
	end
	?replicate('-',VM_LAR)
	?padc('Total',38,'.')
	for X:=1 to 10
		if FLAG[X]
			??transform(TotGeral[X],mD82)+'|'
		end
	next
	?replicate('-',VM_LAR)
	eject
	pb_deslimp(C15CPP)
end
dbcloseall()
Ferase(ARQ+'.DBF')
Ferase(ARQ+OrdBagExt())
return NIL

*----------------------------------------------------------------------------*
 static function FATPCALC()
*----------------------------------------------------------------------------*
local VM_PEDID
salvabd(SALVA)
select('PEDCAB')
ORDEM DTEPED
DbGoTop()
dbseek(dtos(VM_CPO[2]),.T.)
while !eof().and.PC_DTEMI<=VM_CPO[3]
	@24,60 say dtoc(PC_DTEMI)
	if !PEDCAB->PC_FLCAN.and.PEDCAB->PC_FLAG
		CLIENTE->(dbseek(str(PEDCAB->PC_CODCL,5)))
		VM_PEDID:=PEDCAB->PC_PEDID
		select PEDDET
		dbseek(str(VM_PEDID,6),.T.)
		while !eof().and.PEDDET->PD_PEDID==VM_PEDID
			PROD->(dbseek(str(PEDDET->PD_CODPR,L_P)))
			select('RELVENDAS')
			if !dbseek(str(PEDDET->PD_CODPR,L_P)+str(CLIENTE->CL_ATIVID,2))
				AddRec()
				replace 	RV_CODPR  with PEDDET->PD_CODPR,;
							RV_ATIVID with CLIENTE->CL_ATIVID,;
							RV_DESCR  with PROD->PR_DESCR,;
							RV_VLRVEN with 0
			end
			replace  RV_VLRVEN with RV_VLRVEN+trunca((PEDDET->PD_QTDE*PEDDET->PD_VALOR)-PEDDET->PD_DESCV,2)
			if CLIENTE->CL_ATIVID>0.and.CLIENTE->CL_ATIVID<10
				if !FLAG[CLIENTE->CL_ATIVID]
					FLAG[CLIENTE->CL_ATIVID]:=.T.
				end
			else
				FLAG[10]:=.T.
			end
			select('PEDDET')
			dbskip()
		end
		select('PEDCAB')
	end
	dbskip()
end
salvabd(RESTAURA)
return NIL

*-----------------------------------------------------------------------------*
 function FATPPISC()
*-----------------------------------------------------------------------------*
?
? padr('Produto/Descricao',38)
for X:=1 to 10
	if FLAG[X]
		??padl(trim(dTipo[X,2]),12)+'|'
	end
next
?replicate('-',VM_LAR)
return NIL
*-----------------------------------------------------------------------------*
