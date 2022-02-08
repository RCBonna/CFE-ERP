*-----------------------------------------------------------------------------*
 static aVariav2:= {0, 0,.T.,0,.F.}
 //.................1..2..3..4..5
*-----------------------------------------------------------------------------*
#xtranslate nReg			=> aVariav2\[  1 \]
#xtranslate nQTD			=> aVariav2\[  2 \]
#xtranslate lRT			=> aVariav2\[  3 \]
#xtranslate VLRDEVEDOR	=> aVariav2\[  4 \]
#xtranslate lValida		=> aVariav2\[  5 \]

*-----------------------------------------------------------------------------*
*  CFEPFUNC - Funcoes Gerais																	*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

request FN_TECLAX
*-----------------------------------------------------------------------------*
function FN_OBS(VM_P1)  // Verificar OBSERVACAO
*-----------------------------------------------------------------------------*
local VM_TF
lRT:=.T.
salvabd(SALVA)
select('OBS')
if left(VM_P1,1)=='+'
	salvacor()
	DbGoTop()
	VM_TF:=savescreen(5,0)
	pb_box(05,00,22,42,,'Observa‡”es')
	pb_msg('Para incluir uma OBS press <INS>',NIL,.F.)
	private VM_ROT:={||CFEP6300T(.T.)}
	VM_TECLA:=''
	dbedit(06,01,21,41,{fieldname(1)},'FN_TECLAx','','','',' ¯ ')
	VM_P1:=&(fieldname(1))
	lRT  :=.F.
	restscreen(5,0,,,VM_TF)
	salvacor(.F.)
end
salvabd(RESTAURA)
return(lRT)

*-----------------------------------------------------------------------------------*
function FN_CODIGO(P1,P2)
*................. P1=Variavel
*.....................P2=(Arquivo,{||dbseek(str(XXXXX,6))},{||ASAP1200(.T.),{2,1}})
*----------------------------------------------------------------------------------*
local VM_TF
local CPO:={}
local X
lRT:=.T.
if !eval(P2[2])
	salvabd(SALVA)
	select(P2[1])
	X:=indexord()
	dbsetorder(P2[4,1])
	DbGoTop()
	salvacor(SALVA)
	VM_TF		:=savescreen(5,0)
	pb_box(05,00,maxrow()-2,maxcol(),'W+/RB',P2[1])
	if valtype(P2[3])=='B'
		pb_msg('Para incluir '+P2[1]+'. Press <INS>',NIL,.F.)
		private VM_ROT:=P2[3]
	end
	for VM_RT:=1 to len(P2[4])
		aadd(CPO,fieldname(P2[4,VM_RT]))
	next
	dbedit(06,01,maxrow()-3,maxcol()-1,CPO,'FN_TECLAx','','','')
	if P2[4,1]==1
		P1:=&(fieldname(P2[4,1]))
	else
		P1:=&(fieldname(P2[4,2]))
	end
	lRT:=.F.
	keyboard chr(if(lastkey()==K_ESC,0,K_ENTER))
	restscreen(5,0,,,VM_TF)
	salvacor(RESTAURA)
	dbsetorder(X)
	salvabd(RESTAURA)
else
	if P2[4,1]==1
		X:=P2[1]+'->(fieldname('+str(P2[4,2],2)+'))'
	else
		X:=P2[1]+'->(fieldname('+str(P2[4,1],2)+'))'
	end
	@row(),col() say '-'+trim(padr(&(P2[1]+'->'+&X),77-col()))
end
return(lRT)

*-----------------------------------------------------------------------------*
 function FN_VLRCOM(VM_P1,VM_P2)  // valor compra
*-----------------------------------------------------------------------------*
lRT:=.F.
if pb_ifcod2(str(VM_P2,L_P),'PROD',.T.,2)
	lRT=.T.
	pb_msg('Valor atual do produto R$ '+alltrim(transform(PROD->PR_VLVEN,masc(05)))+'.',NIL,.F.)
else
	pb_msg('Problemas, produto n„o encontrado',2,.T.)
end
return(lRT)

*-------------------------------------------------------------------------*
 function FN_ARRED(VM_P1)  // Arredondamento
*-----------------------------------------------------------------------------*
local VM_DIV := {0.01,0.10,1,10,100,1000,10000}
salvabd()
select('PARAMETRO')
if PA_ARRED%2 # 0
	VM_P1 = int(VM_P1*100+.9)/100
else
	if (VM_P1/VM_DIV[PA_ARRED/2])%10 > 5
		VM_P1 = ((int(int(VM_P1/VM_DIV[PA_ARRED/2])/10)+1)*10)*VM_DIV[PA_ARRED/2]
	elseif (VM_P1/VM_DIV[PA_ARRED/2])%10 < 5 .and. (VM_P1/VM_DIV[PA_ARRED/2])%10 > 0
		VM_P1 = ((int(int(VM_P1/VM_DIV[PA_ARRED/2])/10)+.5)*10)*VM_DIV[PA_ARRED/2]
	end
end
salvabd(.F.)
return (VM_P1)

*-----------------------------------------------------------------------------*
 function FN_SDEST(P1,P2,P3) // SALDO DO ESTOQUE RETORNA PRECO DE VENDA
*-----------------------------------------------------------------------------*
lRT:=round(	PROD->PR_QTATU+P1,2)>=0.00.or.;
				PROD->PR_CTB==99.or.;
				PROD->PR_CTB==97
P3 :=if(valtype(P3)#'N',0,P3)
if !lRT
	beeperro()
	pb_msg('Saldo ['+transform(PROD->PR_QTATU,masc(5))+'] insuficiente para esta transa‡„o',2,.T.)
end
P2:=round(PROD->PR_VLVEN+(PROD->PR_VLVEN*PARAMETRO->PA_DESCV/100)*P3,3)
return(lRT)

*-------------------------------------------------------------------------*
 function FN_PERFIN(P1)
*-----------------------------------------------------------------------------*
local RT :=0
local REG:=CTRNF->(recno())
if CTRNF->(dbseek(P1))
	RT:=CTRNF->NF_PERFIN
end
CTRNF->(DbGoTo(REG))
return(RT)

*-----------------------------------------------------------------------------*
 function FN_FATUSA(P1) // SERIE TEM FATURAMENTO
*-----------------------------------------------------------------------------*
//P1=serie
local REG:=CTRNF->(recno())
lRT :=.T.
if CTRNF->(dbseek(P1))
	lRT:=CTRNF->NF_TEMFAT
end
CTRNF->(DbGoTo(REG))
return(lRT)

*-------------------------------------------------------------------------*
 function FN_DIAS(VM_P1)
*-----------------------------------------------------------------------------*
lRT:=VM_TOT[3,VM_P1]>VM_TOT[3,VM_P1-1]
if lRT
	if VM_P1=15
		@21,08 say str(VM_TOT[3,15]-1,4)
	else
		@row()-1,col()+2 say str(VM_TOT[3,VM_P1]-1,4)
	end
end
return (lRT)

*-----------------------------------------------------------------------------*
 function FN_HIST(VM_P1)
*-----------------------------------------------------------------------------*
if VM_P1=2
	if empty(CLIENTE->CL_RAZAO)
		VM_RT='Cliente exclu¡do'
	else
		VM_RT=CLIENTE->CL_RAZAO
	end
else
	if empty(CLIENTE->CL_RAZAO)
		VM_RT='Fornecedor exclu¡do'
	else
		VM_RT=CLIENTE->CL_RAZAO
	end
end
return(padr(VM_RT,20))

*-----------------------------------------------------------------------------*
 function FN_IMPGRP(P1)
*-----------------------------------------------------------------------------*
local RT:='',VM_CHAVE:=padr(P1,6,'0')
RT:=transform(left(VM_CHAVE,len(P1)),'@R 99.99.99')+' - '
salvabd()
select('GRUPOS')
if dbseek(VM_CHAVE)
	RT+=GE_DESCR
else
	RT+='Grupo/subgrupo nao existente'
end
salvabd(.F.)
return(RT)

*-----------------------------------------------------------------------------*
 function FN_CADCGC(P1,P2,P3)
*-----------------------------------------------------------------------------*
local RT,ORD:=indexord()
local RG:=recno()
ordem CGC
if dbseek(padr(P1,14))
	if P2 // inclusao
		alert('INCLUSAO->CNPJ/CPF ja cadastrado;CONTINUAR')
	elseif recno()#P3
		alert('ALTERACAO->CNPJ/CPF ja cadastrado;CONTINUAR')
		DbGoTo(P3)
	end
end
dbsetorder(ORD)
DbGoTo(RG)
return .T.

*----------------------------------------------------------------------------*
 function FN_SELPRO(P1,P2)
*-----------------------------------------------------------------------------*
local OPC:=1
local TF:=savescreen()
local Getlist:={}
if P1=='S'
	while OPC>0
		OPC:=ABROWSE(10,0,22,46,P2,;
										{ 'Produto','Descricao'},;
										{      L_P ,         35},;
										{  masc(21),    masc(1)},,'Selecao Produtos')
		if OPC>0
			VM_CODPR:=P2[OPC,1]
			@row(),2 get VM_CODPR pict masc(21) valid fn_codpr(@VM_CODPR,47)
			read
			if lastkey()#K_ESC
				P2[OPC,1]:=VM_CODPR
				P2[OPC,2]:=PROD->PR_DESCR
			end			
		else
			exit
		end
	end
end
restscreen(,,,,TF)
return(.T.)

*-----------------------------------------------------------------------------*
 function FN_VERGRPR(P1)
*-----------------------------------------------------------------------------*
lRT:=.T.
PROD->(dbseek(str(P1,L_P)))
if VM_CPO[6]='S'.or.VM_CPO[7]=='S'
	if VM_CPO[6]=='S'
		lRT:=(ascan(VM_SELGRU,{|DET|DET[1]==PROD->PR_CODGR})>0)
	elseif VM_CPO[7]=='S'
		lRT:=(ascan(VM_SELPRO,{|DET|DET[1]==PROD->PR_CODPR})>0)
	end
end
return lRT

*-----------------------------------------------------------------------------*
 function FN_CHKSVET(P1,P2,pQtd,pOrd) // verif saldo prod usando itens do vet
*-----------------------------------------------------------------------------*
nQTD:=0
lRT:=.T.
if !str(PROD->PR_CTB,3)$' 99 97'
	aeval(P2,{|DET|nQTD+=if(DET[2]==P1,DET[4],0)})
	nQTD:=nQTD-P2[pOrd,4]+pQtd // QTD - QTD ANT + QTD ATU
	lRT :=(PROD->PR_QTATU-nQTD>=0.000)
	if !lRT
		beeperro()
		pb_msg('Saldo ['+transform(PROD->PR_QTATU,masc(5))+'] insuficiente para esta transa‡„o',2,.T.)
	end
end
return(lRT)

*---------------------------------------------------------------------------------------------*
 function CalcSitTr(_CODTR,_VALOR,_PCICM,_VLICM,pTrib,pVIPI) // verif saldo prod usando itens do vet
*----------------------------------------------------------------------------------------------*
BICM:=0
OUTR:=0
ISEN:=0
	if right(_CODTR,2)=='00' // tributado
		BICM:=_VALOR
		OUTR:=pVIPI
		ISEN:=0
	elseif right(_CODTR,2)=='10'
		BICM:=_VALOR
		OUTR:=pVIPI
		ISEN:=0
	elseif right(_CODTR,2)=='20'
		BICM:=Trunca(_VALOR*pTrib)
		OUTR:=pVIPI
		ISEN:=Trunca(_VALOR-BICM,2)
		if ISEN<0
			ISEN:=0
		end
	elseif right(_CODTR,2)=='40'
		BICM:=0
		OUTR:=pVIPI
		ISEN:=_VALOR
	elseif right(_CODTR,2)=='41'
		BICM:=0
		OUTR:=pVIPI
		ISEN:=_VALOR
	elseif right(_CODTR,2)=='50'
		BICM:=0
		OUTR:=_VALOR+pVIPI
		ISEN:=0
	elseif right(_CODTR,2)=='51'
		BICM:=0
		OUTR:=_VALOR+pVIPI
		ISEN:=0
	elseif right(_CODTR,2)=='60'
		BICM:=0
		OUTR:=_VALOR+pVIPI
		ISEN:=0
	elseif right(_CODTR,2)=='70'
		BICM:=0
		OUTR:=_VALOR+pVIPI
		ISEN:=0
	else //-----------------90-OUTRAS
		BICM:=0
		OUTR:=_VALOR+pVIPI
		ISEN:=0
	end
return ({BICM,ISEN,OUTR})

*---------------------------------------------------------------------------------------*
 function Dev_Saida(pNatureza) // Verificar se nf Saida é Devoluçao
*---------------------------------------------------------------------------------------*
return(left(str(pNatureza,7,0),4)$" 5201 5202 6201 6202")	// É Devolução ? <SIM> <NAO>

*-----------------------------------------------------------------------------*
 function Nat_Transf(pNatureza) // Verificar se nf Saida é Transferencia
*-----------------------------------------------------------------------------*
nReg:=NATOP->(recno())
NATOP->(dbseek(str(pNatureza,7)))
lRT :=NATOP->NO_FLTRAN=='S'
NATOP->(DbGoTo(nReg))
return lRT

*-----------------------------------------------------------------------------*
 function PR(pArq,aChave,pNCPO,pTp,pPos) // Retorna Pesquisa
*-----------------------------------------------------------------------------*
lRT:=.T.
(pArq)->(dbseek(aChave))
if pTP
	@pPos[1],pPos[2] say '-'+(pArq)->(FieldGet(pNCPO))
else
	lRT:=(pArq)->(FieldGet(pNCPO))
end
return lRT

*-----------------------------------------------------------------------------*
 function ValidaLimiteCredito(pParc,pValorCompra,pCliente) // Retorna Pesquisa
*-----------------------------------------------------------------------------*
lRT:=.T.
if pParc>0 // Venda Parcelado
	SALVABANCO
	CLIENTE->(dbseek(str(pCliente,5))) //......................Procura cliente
	if CLIENTE->CL_LIMCRE>0 //.................................Cliente tem controle de credito
		VLRDEVEDOR:=0.00 //.....................................Para controle de limite de credito
		select DPCLI //.........................................Duplicatas pendentes
		ORDEM CLIDTV
		dbseek(str(CLIENTE->CL_CODCL,5),.T.)
		while !eof().and.DPCLI->DR_CODCL==CLIENTE->CL_CODCL
			VLRDEVEDOR+=max(DPCLI->DR_VLRDP-DPCLI->DR_VLRPG,0) // Soma Pendencias
			dbskip()
		end
		if ( CLIENTE->CL_LIMCRE-VLRDEVEDOR-pValorCompra) < 0
			lRT:=pb_sn(;
							'LIMITE CREDITO ULTRAPASSADO;;'+;
							'LIMITE CREDITO.:'+transform(CLIENTE->CL_LIMCRE,mD82)+';'+;
							'SALDO DEVEDOR..:'+transform(VLRDEVEDOR,mD82)+';'+;
							'VALOR COMPRA...:'+transform(pValorCompra,mD82)+';LIBERAR MESMO ASSIM?')
			if lRT //.............................................Liberar Limite
				lValida:=.T.
				while lValida
					lRT:=XXSenha(ProcName(),'Liberar Limite Credito') //...Senha
					if !lRT // Errou a SENHA
						lValida:=pb_sn('Voce erro a SENHA;O pedido pode ser cancelado;Tentar digitar novamente a SENHA?')
					else
						lValida:=.F.
					end
				end
			end
		end
	end
	RESTAURABANCO
end

return lRT

*------------------------------------------------------------------------EOF---------------
