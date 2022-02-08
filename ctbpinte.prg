*-----------------------------------------------------------------------------*
 static aVariav := {0,{},0,0,0,0,0,0}
 //.................1,.2,3,4,5,6,7,8
*-----------------------------------------------------------------------------*
#xtranslate nX       => aVariav\[  1 \]
#xtranslate Flag     => aVariav\[  2 \]
#xtranslate wConta   => aVariav\[  3 \]
#xtranslate wData    => aVariav\[  4 \]
#xtranslate wValor   => aVariav\[  5 \]
#xtranslate wHist    => aVariav\[  6 \]
#xtranslate wChave   => aVariav\[  7 \]
#xtranslate nY       => aVariav\[  8 \]

#include 'RCB.CH'
*-----------------------------------------------------------------------------*
	function CTBPINTE()	//	Integracao Contabil
*-----------------------------------------------------------------------------*

pb_lin4('<Atualizacao Contabil>',ProcName())

if !abre({	'R->PARAMCTB',;
				'R->PARAMETRO'})
	return NIL
end

if PARAMETRO->PA_CONTAB#chr(255)+chr(25)
	alert(';Modulo Contabil nao disponivel;')
	dbcloseall()
	return NIL
end

DATA:={bom(PARAMETRO->PA_DATA),eom(PARAMETRO->PA_DATA)}
Flag:={'S','S','S','S','S','S'}
nX:=11
pb_box(nX++,16,,,,'Contabilizacao')
@nX++,18 say 'NF Entradas..:' get Flag[1] pict mUUU valid Flag[1]$'SN' when pb_msg('Contabilizar NF Entradas ?')
@nX++,18 say 'Servicos.....:' get Flag[2] pict mUUU valid Flag[2]$'SN' when pb_msg('Contabilizar Faturamento Produtos/Serviços ?')
@nX++,18 say 'Conta Parte..:' get Flag[3] pict mUUU valid Flag[3]$'SN' when pb_msg('Contabilizar Lancamentos de Cota Parte ?')
@nX++,18 say 'Transferencia:' get Flag[4] pict mUUU valid Flag[4]$'SN' when pb_msg('Contabilizar Transferencia de Produtos-Consumo e Producao ?')
@nX++,18 say 'Adto Cli/Forn:' get Flag[5] pict mUUU valid Flag[5]$'SN' when pb_msg('Contabilizar Adiantamentos a Clientes e Fornecedores ?')
@nX++,18 say 'Conhec.Frete.:' get Flag[6] pict mUUU valid Flag[6]$'SN' when pb_msg('Contabilizar Conhecimento de Frete ?')
nX++
@nX++,18 say 'Data Inicial.:' get DATA[1] pict mDT  valid ValidaMesContabilFechado(DATA[1],'CONTABILIZAR')
@nX++,18 say 'Data Final...:' get DATA[2] pict mDT  valid DATA[2]>=DATA[1].and.ValidaMesContabilFechado(DATA[2],'CONTABILIZAR')
@nX  ,18 say 'Processando..:'
nX:=12
@nX++,48 say 'Ano/Mes Contabil.: '+pb_zer(PARAMCTB->PA_ANO,4)+'/'+pb_zer(PARAMCTB->PA_MES,2)
read
dbcloseall()
if if(lastkey()#K_ESC,pb_sn('Contabilizar'),.F.)
	//----------------------------------------------------CONTABILIZAR ENTRADAS
	nX:=13
	if Flag[1]=='S'
		CtbPImEn(DATA,nX)
	end
	nX++
	//----------------------------------------------------CONTABILIZAR SERVICOS + FATURAMENTO <- AINDA NÃO CONCLUIDO)
	if Flag[2]=='S'
		CtbPImFa(DATA,nX)
	end
	nX++
	//----------------------------------------------------CONTABILIZAR COTA PARTE
	if Flag[3]=='S'
		CotaInte(DATA,nX)
	end
	nX++
	//----------------------------------------------------CONTABILIZAR TRANSFERENCIA (PROD/CONS/SAIDAS)
	if Flag[4]=='S'
		CtbPMeTr(DATA,nX)
	end
	nX++
	//----------------------------------------------------CONTABILIZAR ADIANTAMENTOS CLIENTES/FORNECEDOR
	if Flag[5]=='S'
		CxaPInte(DATA,nX)
	end
	nX++
	//----------------------------------------------------CONTABILIZAR CONHECIMENTO DE FRETE
	if Flag[6]=='S'
		CtbPInCF(DATA,nX)
	end
end
return NIL

*-----------------------------------------------------------------------------*
 function wContabilizar()
*-----------------------------------------------------------------------------*
SALVABANCO
select WORK
DbGoTop()
while !eof()
	wConta:=WK_CONTA
	wData :=WK_DATA
	wValor:=0
	wHist :=upper(WK_HIST)
	wChave:=upper(WK_CHAVE)
	while !eof().and.wConta==WK_CONTA.and.wData==WK_DATA.and.wHist==upper(WK_HIST)
		wValor+=WK_VALOR
		dbskip()
	end
	fn_atdiario(wDATA,;	//.............1-Data
					wCONTA,;	//.............2-Conta Contabil
					wVALOR,;	//.............3-Valor
					wHIST,;	//.............4-Histórico
					wCHAVE)	//.............5-Documento/Chave
end
zap
RESTAURABANCO
return NIL

*------------------------------------------------GRAVA
	function Grava_Work(pDados)
*------------------------------------------------GRAVA
SALVABANCO
select WORK
AddRec(,pDados)
dbUnlock()
dbCommit()
RESTAURABANCO
return NIL
*---------------------------------------------------EOF------------------
