*-----------------------------------------------------------------------------*
 static aVariav := {  '','P','S','','','',0,0 }
*.....................1...2...3...4..5..6.7.8..................................
*-----------------------------------------------------------------------------*
#xtranslate cTipo		=> aVariav\[  1 \]
#xtranslate cOrdem	=> aVariav\[  2 \]
#xtranslate Resumo	=> aVariav\[  3 \]
#xtranslate cQGRUPO	=> aVariav\[  4 \]
#xtranslate cDescPr	=> aVariav\[  5 \]
#xtranslate cUnidPr	=> aVariav\[  6 \]
#xtranslate cUnidPr	=> aVariav\[  6 \]
#xtranslate cUnidPr	=> aVariav\[  6 \]

#include 'RCB.CH'

*-----------------------------------------------------------------------------*
 function CFEP4340()	//	<MENU>-Movimentacao de Produtos								*
*-----------------------------------------------------------------------------*
  
local   X
private Total :=array(2,10,3)
private VM_REL:='Movimentacao do Estoque'
private VM_PAG:=0

pb_lin4(VM_REL,ProcName())

if !abre({	'R->PARAMETRO'	,;
				'R->GRUPOS'		,;
				'R->PROD'		,;
				'R->SALDOS'		,;
				'R->MOVEST';
			})
	return NIL
end
select('GRUPOS')
	dbgobottom();VM_GRFIM:=GE_CODGR
	DbGoTop()	;VM_GRINI:=GE_CODGR

select('PROD')
	dbsetorder(2)
	dbgobottom();VM_PRFIM:=PR_CODPR
	DbGoTop()	;VM_PRINI:=PR_CODPR

VM_DATA	:={bom(PARAMETRO->PA_DATA),PARAMETRO->PA_DATA}
SERIE		:={space(3),'ZZZ'}
DOCTO		:={0,    99999999}
Resumo	:='S'
cOrdem	:='P'
CTipo		:='IESAFT'
X			:=09
pb_box(X++,18,,,,'Selecione')
@X++,20 say 'Impr Resumo Movto?' get Resumo     pict mUUU		valid Resumo$'SN' when pb_msg('Imprimir Resumo dos lancamentos por tipo de movimento?')
@X++,20 say 'Selec.Prod/Grupo.:' get cOrdem     pict mUUU		valid cOrdem$'PG' when pb_msg('Listar Relatorio por P=Produto  G=Grupo de Produtos')

@X++,20 say 'Produto Inicial..:' get VM_PRINI   pict masc(21)	valid fn_codpr(@VM_PRINI,77)									when cOrdem='P'
@X++,20 say 'Produto Final....:' get VM_PRFIM   pict masc(21)	valid fn_codpr(@VM_PRFIM,77).and.VM_PRFIM>=VM_PRINI	when cOrdem='P'
 X++
@X++,20 say 'Grupo Inicial....:' get VM_GRINI   pict mGRU 		valid fn_codigo(@VM_GRINI,{'GRUPOS',{||GRUPOS->(dbseek(str(VM_GRINI,6)))},,{2,1}})									when cOrdem='G'
@X++,20 say 'Grupo Final......:' get VM_GRFIM   pict mGRU		valid fn_codigo(@VM_GRFIM,{'GRUPOS',{||GRUPOS->(dbseek(str(VM_GRFIM,6)))},,{2,1}}).and.VM_GRINI<=VM_GRFIM	when cOrdem='G'
 X++
@X  ,20 say 'Data Inicial.....:' get VM_DATA[1] pict mDT
@X++,50 say      'Final.......:' get VM_DATA[2] pict mDT valid VM_DATA[2]>=VM_DATA[1]
@X,  20 say 'Serie Inicial....:' get SERIE[1]   pict mUUU
@X++,50 say 'Final.:'            get SERIE[2]   pict mUUU valid SERIE[2]>=SERIE[1]
@X,  20 say 'Docto Inicial....:' get DOCTO[1]   pict mI8
@X++,50 say 'Final.:'            get DOCTO[2]   pict mI8  valid DOCTO[2]>=DOCTO[1]
@X++,20 say 'Tipo Movimento...:' get cTipo		pict mUUU 									when pb_msg('Tipos:   <I>MPLANTACAO  <E>NTRADAS  <S>AIDAS   <A>CERTOS   AJUSTE <F>RETE  <T>RANSFERENCIAS')
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_ligaimp(I15CPP),.F.)
	VM_LAR:=132
	for X:=1 to 10//..........Zera total geral
		TOTAL[2,X,1]:=0
		TOTAL[2,X,2]:=0
		TOTAL[2,X,3]:=0
	next
	select('MOVEST')
	ORDEM CODDT // Imprimir por <E>ntrada de Produto (Data e Documento)
	
	if cOrdem=='P' 	// Seleção por Código de Produto
		select('PROD')
		dbsetorder(2)
		select('MOVEST')
		dbseek(str(VM_PRINI,L_P),.T.) // Procura Produto Inicial
		while !eof().and.MOVEST->ME_CODPR<=VM_PRFIM
			PROD->(dbseek(str(MOVEST->ME_CODPR,L_P)))
			cDescPr	:=PROD->PR_DESCR
			cUnidPr	:=PROD->PR_UND
			nSldQPr	:=PROD->PR_SLDQT
			nSldVPr	:=PROD->PR_SLDVL
			CFEP4340I()
		end
		
	elseif cOrdem=='G'//......................Seleção por Grupo de Estoque
		cQGRUPO	:=''
		VM_QCODGR:=0
		select('PROD')
		ORDEM GRUPRO
		dbseek(str(VM_GRINI,6),.T.) //.........Procura Grupo Inicial + Produto
		while !eof().and.PR_CODGR<=VM_GRFIM
			VM_CODPR	:=PROD->PR_CODPR //........Primeiro Item do Grupo
			cDescPr	:=PROD->PR_DESCR
			cUnidPr	:=PROD->PR_UND
			nSldQPr	:=PROD->PR_SLDQT
			nSldVPr	:=PROD->PR_SLDVL

			select('MOVEST')
			dbseek(str(VM_CODPR,L_P),.T.) //....Procura Produto Inicial Movimento
			if ME_CODPR==VM_CODPR //............Codigo do Produto exite na movimentação
				if VM_QCODGR# PROD->PR_CODGR
					VM_QCODGR:=PROD->PR_CODGR
					GRUPOS->(dbseek(str(VM_QCODGR,6),.T.)) // Pegar Descrição do Grupo
					cQGRUPO:='Grupo: '+transform(VM_QCODGR,mGRU)+'-'+GRUPOS->GE_DESCR
				end
				CFEP4340I() // imprimir movimento
			end
			select('PROD')
			skip
		end
	end

	if Resumo=='S'
		ImprTotal(2)
	end
	?replicate('-',VM_LAR)
	? 'Impresso as '+time()
	eject
	pb_deslimp(C15CPP)
end
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
	function CFEP4340I()	//	Movimentacao de Produtos-loop								*
*-----------------------------------------------------------------------------*
VM_CODPR:=ME_CODPR
dbseek(str(VM_CODPR,L_P)+dtos(VM_DATA[1]),.T.)
SALDOS  :=fn_clcsld(VM_CODPR,VM_DATA[1]) // Primeira Data Saldo
FLAG_CAB:=.T.
for X:=1 to 10	//..........Zera Produto
	TOTAL[1,X,1]:=0
	TOTAL[1,X,2]:=0
	TOTAL[1,X,3]:=0
next
Indice:=0
while !eof().and.ME_CODPR==VM_CODPR.and.ME_DATA<=VM_DATA[2]
	VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP4340A',VM_LAR)
	if ME_DCTO >=DOCTO[1].and.;
		ME_DCTO <=DOCTO[2].and.;
		ME_SERIE>=SERIE[1].and.;
		ME_SERIE<=SERIE[2].and.;
		ME_TIPO$cTipo
		if !empty(cQGRUPO)
			?cQGRUPO
			?
			cQGRUPO:=''
		end
		if FLAG_CAB
			?  padr(pb_zer(VM_CODPR,L_P)+' - '+cDescPr,51)+space(1)
			?? cUnidPr+space(16)
			?? 'SALDO ANTERIOR'+replicate('.',3)+':'+space(1)
			?? transform(SALDOS[1],mD132)+space(6)
			?? transform(SALDOS[2],mD132)
			?
			FLAG_CAB:=.F.
		end
		*-----------------------------------------------> ver se é desta forma
		SALDOS[1]+=(ME_QTD  * if(ME_TIPO=='S',-1,1))
		if ME_TIPO=='S' .or. ME_QTD<0
			SALDOS[2]-=abs(ME_VLEST)
		else
			if ME_TIPO=='A'
				SALDOS[2]+=ME_VLEST // pode ser negativo
			else
				SALDOS[2]+=abs(ME_VLEST)
			end
		end
		*-----------------------------------------------> ver se é desta forma
		if ME_TIPO=='I' // reiniciar os saldos
			SALDOS[1]:=ME_QTD
			SALDOS[2]:=ME_VLEST
		end
		?  space(5)+dtoc(ME_DATA)+space(2)
		?? if(ME_TIPO='I','IMPLANTACAO  ',;
			if(ME_TIPO='E','ENTRADA      ',;
			if(ME_TIPO='S','SAIDA        ',;
			if(ME_TIPO='A','ACERTO       ',;
			if(ME_TIPO='F','AJUSTE FRETE ',;
								'TRANSFERENCIA')))))
		?? space(3)+pb_zer(ME_DCTO,10)+space(1)
		?? transform(ME_QTD,   mI122)+space(0)
		?? transform(ME_VLVEN, mD132)+space(4)
		?? transform(ME_VLEST, mD132)+space(2)
		?? transform(SALDOS[1],mD132)+space(6)
		?? transform(SALDOS[2],mD132)
		if ME_TIPO='I'
			Indice:=1
		elseif ME_TIPO='E'
			Indice:=2
		elseif ME_TIPO='S'
			Indice:=3
		elseif ME_TIPO='A'
			Indice:=4
		elseif ME_TIPO='F'
			Indice:=5
		else
			Indice:=6
		end
		Total[1,Indice,1]+=ME_QTD
		Total[1,Indice,2]+=ME_VLVEN
		Total[1,Indice,3]+=ME_VLEST
	end
	pb_brake()
end
if !eof()
	dbseek(str(VM_CODPR,L_P)+'99999999',.T.)
end
//?  padl(replicate('-',37),VM_LAR)
if Resumo=='S'
	ImprTotal(1)
else
	if Indice>0
		?replicate('-',VM_LAR)
	end
end
return NIL

*------------------------------------------------------------
static function ImprTotal(P1)
*------------------------------------------------------------
local X
local Indice
local Titulo	:=.T.
local DesTitulo:=if(P1==1,'Resumo das movimentacoes do produto','Resumo das movimentacoes GERAL')

For X:=1 to 10
	if Total[P1,X,1]+Total[P1,X,2]+Total[P1,X,3]#0
		if Titulo
			?replicate('-',VM_LAR)
			?DesTitulo
			Titulo:=.F.
		end
		VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP4340A',VM_LAR)
		? space(15)
		??	if(X==1,'IMPLANTACAO  ',;
			if(X==2,'ENTRADA      ',;
			if(X==3,'SAIDA        ',;
			if(X==4,'ACERTO       ',;
			if(X==5,'AJUSTE FRETE ',;
					  'TRANSFERENCIA')))))
		?? space(15)
		?? transform(Total[P1,X,1],mI132)
		?? transform(Total[P1,X,2],mD132)+space(4)
		?? transform(Total[P1,X,3],mD132)+space(2)
		?? transform(pb_divzero(Total[P1,X,3],Total[P1,X,1]),mD132)+space(6)
		?? transform(pb_divzero(Total[P1,X,2],Total[P1,X,1]),mD132)
		if P1==1
			Total[2,X,1]+=Total[1,X,1]
			Total[2,X,2]+=Total[1,X,2]
			Total[2,X,3]+=Total[1,X,3]
		end
	end
next
if Total[P1,3,1]+Total[P1,3,2]+Total[P1,3,3]>0
	? padc('Margem Bruta',28,'.')
	?? space(28)
	?? transform(Total[P1,3,2]-Total[P1,3,3],mD132)
end
if !Titulo
	?replicate('-',VM_LAR)
end
return

*-----------------------------------------------------------------------------*
function CFEP4340A()
*------------------------------------------------------------
?  space(9)+'Data    Tipo'+space(12)+'Dcto'+space(12)+'Qt.Mov.'+space(2)+'Vlr.Mov.-VENDA'
?? space(5)+'Vlr.Mov.-MEDIO'+space(7)+'SALDO QTDE'+space(4)+'SALDO A VLR.MEDIO'
?  replicate('-',VM_LAR)
return NIL

*-----------------------------------------------------------------------------*
function FN_CLCSLD(pProd,pData)
*------------------------------------------------------------
local TOT:={0,0}
local PERIOD:=left(dtos(bom(pData)-1),6) // INICIO DO MES
local REG   :=MOVEST->(recno())
if SALDOS->(lastrec())>0
	select('SALDOS')
	if dbseek(str(1,2)+PERIOD+str(pProd,L_P)) // O PERIODO OU pb_brake()
		TOT[1]:=SA_QTD
		TOT[2]:=SA_VLR
	end
else
	TOT[1]:=nSldQPr
	TOT[2]:=nSldVPr
end

select('MOVEST')
dbseek(str(pProd,L_P)+dtos(bom(pData)),.T.)
while !eof().and.pProd==ME_CODPR.and.ME_DATA<pData
	TOT[1]+=(ME_QTD  *if(ME_TIPO='S',-1,1))
	TOT[2]+=(ME_VLEST*if(ME_TIPO='S',-1,1))
	if ME_TIPO=='I'
		TOT[1]:=ME_QTD
		TOT[2]:=ME_VLEST
	end
	dbskip()
end
MOVEST->(DbGoTo(REG))
return TOT
*---------------------------------------EOF---------------------*
