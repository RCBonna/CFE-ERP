*-----------------------------------------------------------------------------*
  static aVariav := {{}, 0,.T.,0,'',0,.F.,0}
*.....................1..2..3..4.5..6.7...8...9, 10, 11, 12,13,14,15
*-----------------------------------------------------------------------------*
#xtranslate VM_REL		=> aVariav\[  1 \]
#xtranslate nX				=> aVariav\[  2 \]
#xtranslate lRT			=> aVariav\[  3 \]
#xtranslate nCLI			=> aVariav\[  4 \]
#xtranslate cArq			=> aVariav\[  5 \]
#xtranslate nTotalG		=> aVariav\[  6 \]
#xtranslate lMudaCli		=> aVariav\[  7 \]
#xtranslate nPag			=> aVariav\[  8 \]

#include 'RCB.CH'

*-----------------------------------------------------------------------------*
 function CFEPEXTR(P1) // Listagem de Vendas												*
*-----------------------------------------------------------------------------*
default P1 to 'A'

private TIPOREL:=P1 // TIPOS A=AMBOS F=FORNECEDORES C=CLIENTES

VM_CPO:={'A','N','N','D','D','N','N','N','N','N','L'}
// .......1...2...3...4...5...6...7...8...9..10..11.....TEM RELAÇÃO COM CFEPDVCP.PRG

VM_REL:='Extrato do Periodo'
pb_lin4(VM_REL,ProcName())

if !abre({	'R->GRUPOS',;
				'R->PROD',;
				'R->PARAMETRO',;
				'R->PEDCAB',;
				'R->PEDDET',;
				'R->ENTCAB',;
				'R->CLIENTE',;
				'R->NATOP',;
				'R->ENTDET'})
	return NIL
end
select('PROD')
ordem CODIGO
select('GRUPOS')
set filter to GE_CODGR % 10000 # 0

cArq:= ArqTemp(,,'')

dbatual(cArq,;
			{{'XX_CHAVE',  'C', 30,  0},; // chave
			 {'XX_ALIAS',  'C', 20,  0},; // nome arquivo
			 {'XX_RECNO',  'N',  8,  0}}) // nr do registro

if !net_use(cArq,.T.,20,'TEMP',.T.,.F.,RDDSETDEFAULT())
	dbcloseall()
	return NIL
end
select('PROD');dbsetorder(2)	// Cadastro de Produtos

VM_CPO[4] :=boy(PARAMETRO->PA_DATA)
VM_CPO[5] :=eoy(PARAMETRO->PA_DATA)
VM_CLII   :=0
VM_CLIF   :=99999
VM_SELGRU:=array(10,2)
nTotalG:={0,0}
aeval(VM_SELGRU,{|DET|DET:=afill(DET,0)})
VM_SELPRO:=array(20,2)
aeval(VM_SELPRO,{|DET|DET:=afill(DET,0)})
nX:=10
pb_box(nX++,20,,,,'Selecao ('+TIPOREL+')' )
@nX++,22 say 'Tipo [A]nalitico [S]int‚tico.:' get VM_CPO[01]  pict mUUU valid VM_CPO[01]$'AS'
@nX++,22 say 'Selecionar Grupos de Produtos?' get VM_CPO[06]  pict mUUU valid VM_CPO[06]$'SN'.and.fn_SelGru(VM_CPO[6],VM_SELGRU)
@nX++,22 say 'Selecionar Diversos Produtos ?' get VM_CPO[07]  pict mUUU valid VM_CPO[07]$'SN'.and.fn_SelPro(VM_CPO[7],VM_SELPRO) when VM_CPO[6]=='N'
@nX++,22 say 'Validar CFOP-Nat. Operacao   ?' get VM_CPO[08]  pict mUUU valid VM_CPO[08]$'SN'
@nX++,22 say 'Emitente Inicial.............:' get VM_CLII     pict mI5  valid VM_CLII==0.or.    fn_codigo(@VM_CLII,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CLII,5)))},{||CFEP3100T(.T.)},{2,1,8,7}})
@nX++,22 say 'Emitente Final...............:' get VM_CLIF     pict mI5  valid VM_CLIF==99999.or.fn_codigo(@VM_CLIF,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CLIF,5)))},{||CFEP3100T(.T.)},{2,1,8,7}})
@nX++,22 say 'Somar Mov Socio Todo Periodo.:' get VM_CPO[10]  pict mUUU valid VM_CPO[10]$'SN'   when pb_msg('Socio somar movimentos antes da entrada na sociedade?')
@nX++,22 say 'Pular Pagina Emitente?.......:' get VM_CPO[09]  pict mUUU valid VM_CPO[09]$'SN'
@nX++,22 say 'Data Emissao Inicial.........:' get VM_CPO[04]  pict mDT
@nX++,22 say 'Data Emissao Final...........:' get VM_CPO[05]  pict mDT  valid VM_CPO[05]>=VM_CPO[04]
@nX++,22 say '<L>istagem <E>xtrato Excel...:' get VM_CPO[11]  pict mUUU valid VM_CPO[11]$'LE'
read
if if(lastkey()#K_ESC,if(VM_CPO[11]=='L',;
								 pb_ligaimp(C15CPP+I12CPP),;
								 pb_ligaimp(,"C:\TEMP\EXTRATO.XLS")),.F.)
	
	if VM_CPO[11]=='L'
		VM_LAR:=96
		VM_PAG:=0
		nPag  :=0
		VM_REL+= ' de '+dtoc(VM_CPO[4])+' ate '+dtoc(VM_CPO[5])
	else
		??'Tipo' 			+ chr(09)
		??'Cod.Emit'		+ chr(09)
		??'Nome'				+ chr(09)
		??'CPF/CNPJ'		+ chr(09)
		??'Dt NF'			+ chr(09)
		??'NR.NF'			+ chr(09)
		??'Cod.Prod'		+ chr(09)
		??'Descricao'		+ chr(09)
		??'Unid'				+ chr(09)
		??'Qtdade'			+ chr(09)
		??'Valor'			+ chr(09)		
	end
	select('CLIENTE')
	DbGoTop()
	dbseek(str(VM_CLII,5),.T.)
	while !eof().and.fieldget(1)<=VM_CLIF
		@24,00 say padr('Emitente'+FieldGet(2))
		VM_CLI:=fieldget(1)
		CFEPEXTR1(VM_CLI)	// Calcula
		lMudaCli:=.T.
		if VM_CPO[11]=='L'
			CFEPEXTR2(VM_CLI)	// Imprime
			if VM_CPO[09]=='S'
				setprc(64,1)
			end
		else
			CFEPEXTRE(VM_CLI)	// Imprime
		end
		VM_CLII:=VM_CLI
		pb_brake()
	end
	
	if VM_CPO[11]=='L'
		VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEPEXTRA',VM_LAR)
		? padr('T O T A I S    G E R A L',68,'.')
		??transform(nTotalG[1],masc(2))
		??substr(transform(nTotalG[2],masc(2)),3)
		pb_deslimp(C12CPP,PULA_PAGINA)
	else
		pb_deslimp(,.F.,.F.)
		setprc(01,01)
	end
end
dbcloseall()
FileDelete (cArq + '.*')
return NIL

*----------------------------------------------------------------------------*
 function CFEPEXTR1(P1)
*----------------------------------------------------------------------------*
local RT
local aDtInicio:=VM_CPO[4]
if CLIENTE->CL_DTCAD > aDtInicio.and.VM_CPO[10]=='N' // Para sócios validar data de entrada [N] soma só periodo [S] soma todo movimento
	aDtInicio:=CLIENTE->CL_DTCAD
end
salvabd(SALVA)
select('PEDCAB');dbsetorder(7) // cli + dt emi
select('ENTCAB');dbsetorder(3) // for + dt emi
//---------------------------------------------------------ENTRADAS
pb_msg(CLIENTE->CL_RAZAO)
@24,55 say 'E-Gerando...'
if TIPOREL$'FA'
	select('ENTCAB')
	dbseek(str(P1,5)+dtos(aDtInicio),.T.) // FOR+Data Inicial
	while !eof().and.ENTCAB->EC_CODFO==P1.and.EC_DTENT<=VM_CPO[5]
		@24,70 say str(ENTCAB->EC_DOCTO,8)
		RT:=.F.
		if ENTCAB->EC_GERAC$' GA'.and.(VM_CPO[8]=='N'.or.VerNatOp(ENTCAB->EC_CODOP))
			select('ENTDET') // Doc + Serie + Fornecedor + Ordem
			dbseek(str(ENTCAB->EC_DOCTO,8),.T.)
			while !eof().and.str(ENTDET->ED_DOCTO,10)+ENTDET->ED_SERIE==str(ENTCAB->EC_DOCTO,10)+ENTCAB->EC_SERIE
				if ENTDET->ED_CODFO==ENTCAB->EC_CODFO
					if (RT:=fn_VerGrPr(ENTDET->ED_CODPR))
						dbgobottom()
					end
				end
				dbskip()
			end
			select('ENTCAB')
		end
		if RT
			addtemp(dtos(ENTCAB->EC_DTENT)+'E',alias(),recno())
		end
		dbskip()
	end
end
//---------------------------------------------------------SAIDAS
@24,55 say 'S-Gerando...'
if TIPOREL$'CA'
	select('PEDCAB')
	dbseek(str(P1,5)+dtos(aDtInicio),.T.) // CLI+Data Inicial
	while !eof().and.PEDCAB->PC_CODCL==P1.and.PEDCAB->PC_DTEMI<=VM_CPO[5]
		@24,70 say str(PEDCAB->PC_PEDID,8)
		if PEDCAB->PC_GERAC$' GA'.and.PEDCAB->PC_FLAG.and.!PEDCAB->PC_FLCAN // NF Gerados/Alterados e Impressa e Nao cancelada
			RT:=.F.
			if VM_CPO[8]=='N'.or.VerNatOp(PEDCAB->PC_CODOP)
				select('PEDDET')
				dbseek(str(PEDCAB->PC_PEDID,6),.T.)
				while !eof().and.PEDCAB->PC_PEDID==PEDDET->PD_PEDID
					if (RT:=fn_vergrpr(PEDDET->PD_CODPR))
						dbgobottom()
					end
					dbskip()
				end
				select('PEDCAB')
			end
			if RT
				addtemp(dtos(PEDCAB->PC_DTEMI)+'S',alias(),recno())
			end
		end
		dbskip()
	end
end
@24,60 say 'Ordenando'
select('TEMP')
Index on XX_CHAVE tag CHAVE to (cARQ)
@24,60 say '         '
salvabd(RESTAURA)
return NIL

*-----------------------------------------------------------------------------*
	function CFEPEXTR2(P1) // Imprime
*-----------------------------------------------------------------------------*
local TOTAL :={0,0}
local QUEBRA:=''
salvabd(SALVA)
select('TEMP')
DbGoTop()
while !eof()
	VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEPEXTRA',VM_LAR)
//	if prow()>10.and.VM_CLI#VM_CLII
	if lMudaCli.or.nPAG#VM_PAG
		CFEPEXTRB()
		lMudaCli:=.F.
		nPag    :=VM_PAG
	end
	if QUEBRA#left(XX_CHAVE,8)
		QUEBRA:=left(XX_CHAVE,8)
		?right(QUEBRA,2)+'/'+substr(QUEBRA,5,2)+'/'+substr(QUEBRA,3,2)
	else
		?space(8)
	end
	if trim(XX_ALIAS)=='ENTCAB'
		select('ENTCAB')
		DbGoTo(TEMP->XX_RECNO)
		?? space(1)+str(EC_DOCTO,8)+space(1)
		TOTAL[1]+=imprpre(EC_DOCTO,EC_CODFO,VM_REL)
	else
		select('PEDCAB')
		DbGoTo(TEMP->XX_RECNO)
		?? space(1)+str(PC_NRNF,8)+space(1)
		TOTAL[2]+=imprprs(PC_PEDID,VM_REL)
	end
	select('TEMP')
	dbskip()
end
if TOTAL[1]+TOTAL[2]>0
	?replicate('-',VM_LAR)
	if TIPOREL=='A'
		? padr('TOTAIS DO ASSOCIADO',68,'.')
	elseif TIPOREL=='C'
		? padr('TOTAIS DO CLIENTE',68,'.')
	elseif TIPOREL=='F'
		? padr('TOTAIS DO FORNECEDOR',68,'.')
	end
	??transform(TOTAL[1],masc(2))
	??substr(transform(TOTAL[2],masc(2)),3)
	?replicate('-',VM_LAR)
	nTotalG[1]+=TOTAL[1]
	nTotalG[2]+=TOTAL[2]
end
select('TEMP')
zap
salvabd(RESTAURA)
return NIL

*-----------------------------------------------------------------------------*
	function CFEPEXTRB()
*-----------------------------------------------------------------------------*
?
if TIPOREL=='A'
	? 'Associado.: '
elseif TIPOREL=='C'
	? 'Cliente...: '
elseif TIPOREL=='F'
	? 'Fornecedor: '
end
	??pb_zer(VM_CLI,5)+'-'+CLIENTE->CL_RAZAO
?
return NIL

*--------------------------------------------------VALIDA SE A NATUREZA DEVE SER SOMA AO RELATORIO
	static function VerNatop(pNatOp)
*------------------------------------------------------------------
lRT:=.F.
if NATOP->(dbseek(str(pNatOp,7)))// NO_CODIG==pNatOp
	lRT:=(NATOP->NO_CONCP=='S')
end
return lRT

*-----------------------------------------------------------------------------*
	function CFEPEXTRE(P1) // Gera Excel
*-----------------------------------------------------------------------------*
salvabd(SALVA)
select('TEMP')
DbGoTop()
while !eof()
	if trim(XX_ALIAS)=='ENTCAB'
		select('ENTCAB')
		DbGoTo(TEMP->XX_RECNO)
		select('ENTDET')
		dbseek(str(ENTCAB->EC_DOCTO,8),.T.)
		while !eof().and.ENTCAB->EC_DOCTO==ED_DOCTO
			if ENTCAB->EC_CODFO==ED_CODFO
				if fn_vergrpr(ENTDET->ED_CODPR)
					? 'Entrada' 								+ chr(09)
					??str (ENTDET->ED_CODFO)				+ chr(09)
					??trim(CLIENTE->CL_RAZAO)				+ chr(09)
					if CLIENTE->CL_TIPOFJ=='F'
						??transform(CLIENTE->CL_CGC,mCPF)+ chr(09)
					else
						??transform(CLIENTE->CL_CGC,mCGC)+ chr(09)
					end
					??dtoc(ENTCAB->EC_DTENT)				+ chr(09)
					??str (ENTCAB->EC_DOCTO)				+ chr(09)
					??str (ENTDET->ED_CODPR)				+ chr(09)
					??trim(PROD->PR_DESCR)					+ chr(09)
					??trim(PROD->PR_UND)						+ chr(09)
					??transform(ENTDET->ED_QTDE,mI123)	+ chr(09)
					??transform(ENTDET->ED_VALOR,mI123)	+ chr(09)
				end
			end
			dbskip()
		end
	else
		select('PEDCAB')
		DbGoTo(TEMP->XX_RECNO)
		select('PEDDET')
		dbseek(str(PEDCAB->PC_PEDID,6),.T.)
		while !eof().and.PEDCAB->PC_PEDID==PD_PEDID
			if fn_vergrpr(PEDDET->PD_CODPR)
				? 'Saida' 											+ chr(09)
				??str (PEDCAB->PC_CODCL)						+ chr(09)
				??trim(CLIENTE->CL_RAZAO)						+ chr(09)
				if CLIENTE->CL_TIPOFJ=='F'
					??transform(CLIENTE->CL_CGC,mCPF)		+ chr(09)
				else
					??transform(CLIENTE->CL_CGC,mCGC)		+ chr(09)
				end
				??dtoc(PEDCAB->PC_DTEMI)						+ chr(09)
				??str (PEDCAB->PC_NRNF)							+ chr(09)
				??str (PEDDET->PD_CODPR)						+ chr(09)
				??trim(PROD->PR_DESCR)							+ chr(09)
				??trim(PROD->PR_UND)								+ chr(09)
				??transform(PEDDET->PD_QTDE,mI123)			+ chr(09)
				??transform(round(PD_VALOR*PD_QTDE,2)-PD_DESCV-PD_DESCG,mI123)+chr(09)
			end
			dbskip()
		end
	end
	select('TEMP')
	dbskip()
end
select('TEMP')
zap
salvabd(RESTAURA)
return NIL

*-----------------------------------------------------------EOF------------------------
