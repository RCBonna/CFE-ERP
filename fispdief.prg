static NAT1:=0,NAT2:=99999,VM_LAR,VM_PAG,TOTAL

#include 'RCB.CH'
*-----------------------------------------------------------------------------*
	function FISPDIEF() // Dados para a DIEF
*-----------------------------------------------------------------------------*

local ARQ
local X

local VM_CPO:={'U','dt1','dt2',,,0, ,'T',0,3,2}
//              1     2     3  4     5 6 7 8  9 0,1

VM_REL:='Infomacoes DIEF'

pb_lin4(VM_REL,ProcName())

if !abre({	'R->PROD',;
				'R->PARAMETRO',;
				'R->CLIENTE',;
				'R->PEDCAB',;
				'R->PEDDET',;
				'R->ENTCAB',;
				'R->ENTDET',;
				'R->NATOP',;
				'R->GRUPOS'})
	return NIL
end
select('PROD')
dbsetorder(2)	// Cadastro de Produtos

select('PEDCAB')
ordem DTEPED
DbGoTop()

ARQ   := ArqTemp(,,'')
dbcreate(ARQ,{ {'RV_NATOP','N',  7,0},;
					{'RV_UF',	'C',	2,0},;
					{'RV_MUNIC','C', 20,0},;
					{'RV_TOTAL','N', 15,2},;
					{'RV_FUNRU','N', 15,2},;
					{'RV_ICMBA','N', 15,2},;
					{'RV_ICMVL','N', 15,2},;
					{'RV_VENIN','N', 15,2}}) // VENDAS PARA CLIENTES COM INSCRICAO

if !net_use(ARQ,.T., ,'DIEF', ,.F.,RDDSETDEFAULT())
	dbcloseall()
	return NIL
end

Index on str(RV_NATOP,7) + RV_UF + RV_MUNIC tag UF    to (ARQ)
Index on RV_UF + RV_MUNIC + str(RV_NATOP,7) tag MUNIC to (ARQ)
ordem UF

VM_CPO[2]:=bom(PARAMETRO->PA_DATA)
VM_CPO[3]:=PARAMETRO->PA_DATA
select('NATOP')
DbGoTop()
NAT1:=NO_CODIG
dbgobottom()
NAT2:=NO_CODIG

pb_box(12,20,,,,'Selecione')
@13,50 say '<U>UF   <M>Municipio'
@13,22 say 'Base de Impressao.......:' get VM_CPO[1] pict mUUU  valid VM_CPO[1]$'UMX' when pb_msg('Ordem de Impressao do Relatorio-<U>Unidade Federecao <M>-Municipio')
@14,22 say 'Natureza Operacao-Inicio:' get NAT1      pict mNAT  valid fn_codigo(@NAT1,{'NATOP',{||NATOP->(dbseek(str(NAT1,7)))},{||CFEPNATT(.T.)},{2,1,3}}) when pb_msg('Informe Natureza de Operacao-Inicial')
@15,22 say 'Natureza Operacao-Fim...:' get NAT2      pict mNAT  valid fn_codigo(@NAT2,{'NATOP',{||NATOP->(dbseek(str(NAT2,7)))},{||CFEPNATT(.T.)},{2,1,3}}) when pb_msg('Informe Natureza de Operacao-Final')
@17,22 say 'Data Emissao Incial.....:' get VM_CPO[2] pict mDT
@18,22 say 'Data Emissao Final......:' get VM_CPO[3] pict mDT  valid VM_CPO[3]>=VM_CPO[2]
read
if if(lastkey()#K_ESC,pb_ligaimp(I15CPP),.F.)
	select('DIEF')
	FISPDIEF0(VM_CPO) // ACUMULANDO
	pb_msg('Imprimindo ESC cancela...')
	ordem UF
	DbGoTop()
	VM_REL+=' ref:'+dtoc(VM_CPO[2])+' - '+dtoc(VM_CPO[3])
	VM_LAR:=130
	VM_PAG:=0
	TOTAL :={ {0,0,0,0,0},;	
				 {0,0,0,0,0}} //
	while !eof()
		VM_CPO[4]:=RV_NATOP
		NATOP->(dbseek(str(VM_CPO[4],7)))
		VM_PAG   :=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'FISPDIEFC',VM_LAR)
		?transform(VM_CPO[4],mNAT)+'-'+NATOP->NO_DESCR
		while !eof().and.VM_CPO[4]==RV_NATOP
			?	space(8)+RV_UF+'/'+RV_MUNIC
			??	transform(RV_TOTAL,mD132)
			?? transform(RV_FUNRU,mD132)
			?? transform(RV_ICMBA,mD132)
			?? transform(RV_ICMVL,mD132)
			?? transform(RV_VENIN,mD132)
			TOTAL[1,1]+=RV_TOTAL
			TOTAL[1,2]+=RV_FUNRU
			TOTAL[1,3]+=RV_ICMBA
			TOTAL[1,4]+=RV_ICMVL
			TOTAL[1,5]+=RV_VENIN
			dbskip()
		end
		? padr('Total da Natureza de Operacao',31)
		for X:=1 to 5
			??	transform(TOTAL[1,X],mD132)
			TOTAL[2,X]+=TOTAL[1,X]
			TOTAL[1,X]:=0
		next
		?
	end
	? replicate('-',VM_LAR)
	? padr('T o t a l   d  a   G e r a l',31)
	for X:=1 to 5
		??	transform(TOTAL[2,X],mD132)
		TOTAL[2,X]:=0
	next
	?replicate('-',VM_LAR)
	?'Impresso as '+time()
	eject
	pb_deslimp(C15CPP)
end
dbcloseall()
FileDelete (Arq + '.*')
ferase(ARQ+OrdBagExt())
return NIL

*----------------------------------------------------------------------------*
function FISPDIEF0(P1)
*-----------------------------------------------------------------------------*
local MUNIC
local VICMS
pb_msg('Processando Entradas...')
salvabd(SALVA)
*----------------------------------------------------------------------------*
select('ENTCAB')
ordem DTEDOC
DbGoTop()
dbseek(dtos(P1[2]),.T.)
while !eof().and.EC_DTENT<=P1[3]
	if ENTCAB->EC_CODOP>=NAT1.and.ENTCAB->EC_CODOP<=NAT2
		CLIENTE->(dbseek(str(ENTCAB->EC_CODFO,5)))
		if P1[1]=='U'
			MUNIC:=space(20)
		elseif P1[1]=='X'
			MUNIC:=str(ENTCAB->EC_DOCTO,20)
		else
			MUNIC:=upper(CLIENTE->CL_CIDAD)
		end
//		if ENTCAB->EC_DOCTO==153728
//			alert(str(ENTCAB->EC_TOTAL,15,3)+';'+;
//					str(ENTCAB->EC_DESC ,15,3)+';'+;
//					str(ENTCAB->EC_ACESS,15,3))
//		end
		select('DIEF')
		if !dbseek(str(ENTCAB->EC_CODOP,7)+CLIENTE->CL_UF+MUNIC)
			AddRec()
			replace 	RV_NATOP with ENTCAB->EC_CODOP,;
						RV_UF    with CLIENTE->CL_UF,;
						RV_MUNIC with MUNIC,;
						RV_TOTAL with 0,;
						RV_FUNRU with 0,;
						RV_ICMBA with 0,;
						RV_ICMVL with 0,;
						RV_VENIN with 0
		end
		replace  RV_TOTAL with RV_TOTAL+ENTCAB->EC_TOTAL-ENTCAB->EC_DESC+ENTCAB->EC_ACESS,;
					RV_FUNRU with RV_FUNRU+ENTCAB->EC_FUNRU,;
					RV_ICMBA with RV_ICMBA+ENTCAB->EC_ICMSB,;
					RV_ICMVL with RV_ICMVL+ENTCAB->EC_ICMSV
		select('ENTCAB')
	end
	dbskip()
end

*----------------------------------------------------------------------------*
pb_msg('Processando Saidas...')
*----------------------------------------------------------------------------*
select('PEDCAB')
ordem DTENNF
DbGoTop()
dbseek(dtos(P1[2]),.T.)
while !eof().and.PC_DTEMI<=P1[3]
	if !PC_FLCAN.and.PC_FLAG.and.PC_CODOP>=NAT1.and.PC_CODOP<=NAT2
		
		VICMS :=fn_nfsoma(PEDCAB->PC_PEDID,{PC_TOTAL,PC_DESC,NATOP->NO_CDVLFI})
		
		CLIENTE->(dbseek(str(PEDCAB->PC_CODCL,5)))
		if P1[1]=='U'
			MUNIC:=space(20)
		else
			MUNIC:=upper(CLIENTE->CL_CIDAD)
		end
		select('DIEF')
		if !dbseek(str(PEDCAB->PC_CODOP,7)+CLIENTE->CL_UF+MUNIC)
			AddRec()
			replace 	RV_NATOP with PEDCAB->PC_CODOP,;
						RV_UF    with CLIENTE->CL_UF,;
						RV_MUNIC with MUNIC,;
						RV_TOTAL with 0,;
						RV_FUNRU with 0,;
						RV_ICMBA with 0,;
						RV_ICMVL with 0,;
						RV_VENIN with 0
		end
		for X:=1 to len(VICMS)
			replace  RV_TOTAL with RV_TOTAL+abs(VICMS[X,2]),;
						RV_ICMBA with RV_ICMBA+abs(VICMS[X,3]),;
						RV_ICMVL with RV_ICMVL+abs(VICMS[X,4])
			if CLIENTE->CL_TIPOFJ=='J'.and.!empty(CLIENTE->CL_INSCR).and.upper(left(CLIENTE->CL_INSCR,6))#'ISENTO'
				replace  RV_VENIN with RV_VENIN+abs(VICMS[X,2])
			end
		next
		
		select('PEDCAB')
	end
	dbskip()
end
salvabd(RESTAURA)
return NIL

*-----------------------------------------------------------------------------*
	function FISPDIEFC()
*-----------------------------------------------------------------------------*
? 'Natureza Operacao'
? space(9)+padr('UF/Municipio',27)
??"Valor Total   Vlr Funrural      Icms-Base     Icms-Valor Venda p/Contrib"
?replicate('-',VM_LAR)
return NIL
*-----------------------------------EOF---------------------------------------*
