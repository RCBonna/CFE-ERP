*-----------------------------------------------------------------------------*
 static aVariav := {0,0,0,4,.T.,0,'ADT',0,0, 0, 0, 0, 0,{}, 0, 0, 0, 0,'','A',''}
 //.................1.2.3,4, 5..6,  7,  8,9,10,11.12,13,14.15.16,17.18.19.20..21
*---------------------------------------------------------------------------------------*
#xtranslate nX         => aVariav\[  1 \]
#xtranslate nX1        => aVariav\[  2 \]
#xtranslate nCodCli    => aVariav\[  3 \]
#xtranslate TipoAdto   => aVariav\[  4 \]
#xtranslate LCont      => aVariav\[  5 \]
#xtranslate NroAdto    => aVariav\[  6 \]
#xtranslate cTipoCTRL  => aVariav\[  7 \]
#xtranslate nRec       => aVariav\[  8 \]
#xtranslate nProgCont  => aVariav\[  9 \]
#xtranslate dData      => aVariav\[ 10 \]
#xtranslate nNro       => aVariav\[ 11 \]
#xtranslate nVLRTOT    => aVariav\[ 12 \]
#xtranslate nVLRUSA    => aVariav\[ 13 \]
#xtranslate aADTO      => aVariav\[ 14 \]
#xtranslate cREL       => aVariav\[ 15 \]
#xtranslate nTipoAlt   => aVariav\[ 16 \]
#xtranslate cLAT       => aVariav\[ 17 \]
#xtranslate nTOT       => aVariav\[ 18 \]
#xtranslate cTELA      => aVariav\[ 19 \]
#xtranslate cTipoSIT   => aVariav\[ 20 \]
#xtranslate aADTOx     => aVariav\[ 21 \]

*-----------------------------------------------------------------------------*
function CXAPADT(_TIPO)	//	Acumular Cheque pré
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
TipoAdto:=_TIPO
if !TipoAdto$'CF'
	TipoAdto:='C'
end
pb_tela()
pb_lin4(_MSG_,ProcName())

if !abre({	'C->PARAMETRO',;
				'C->CLIENTE',;
				'C->BANCO',;
				'C->CTRNF',;
          	'C->DPFOR',;
				'R->PEDCAB',;
				'R->PEDDET',;
				'C->HISCLI',;
				'R->ENTCAB',;
				'R->ENTDET',;
				'C->HISFOR',;
				'C->PROD',;
				'C->ADTOSD',;	//DETALHE
				'C->ADTOSC'})	//CABEÇALHO
	return NIL
end

select PEDCAB
	ORDEM CLIDTE
select ENTCAB
	ORDEM FORDTE

select ADTOSD
while !eof()
	if str(C3_VLRTOT,15,2)==str(0,15,2)
		if reclock()
			replace ADTOSD->C3_VLRTOT with trunca(ADTOSD->C3_VLRVEN*ADTOSD->C3_QTDEPE)
			dbrunlock()
		end
	end
	pb_brake()
end

nProgCont:=0
while nProgCont<2
	pb_tela()
	pb_lin4(_MSG_,ProcName())

	SELECT PROD
	ORDEM CODIGO
	
	SELECT ADTOSC // CABEÇALHO
	if TipoAdto=='C'
		ORDEM CODIGOC
	else
		ORDEM CODIGOF
	end
	DbGoTop()
	set relation to str(ADTOSC->C2_CODCL,5) into CLIENTE
	
	pb_dbedit1('CXAPADT','IncluiAlteraPesqu.ExcluiLista Contra')
	VM_CAMPO:={'pb_zer(C2_CODCL,5)+chr(45)+left(CLIENTE->CL_RAZAO,20)',;
				  'C2_DTEMI',;
				  'C2_VLRADT',;
				  'C2_VLRUSA',;
				  'C2_NRO',;
				  'if(C2_PEND, "SIM","nao")',;
				  'if(C2_FLCTB,"SIM","nao")',;
				  'C2_HIST',;
				  'C2_PARC'}

	dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',;
							 {     mXXX,    mDT ,    mD112 ,    mD112 ,   mI5 , mXXX, mXXX ,      mXXX , mI2 },;
							 {'Cli/For','DtEmis','Vlr Adto','Vlr Usad','NroAd','Pen','CTB?','Historico','Parc'})
	nProgCont++
	setcolor(VM_CORPAD)
end
dbcloseall()
return NIL
*-----------------------------------------------------------------------------*
function CXAPADT1() // Rotina de Inclusão
*-----------------------------------------------------------------------------*
while lastkey()#K_ESC
	cTipoSIT:='I'
	NroAdto :=fn_psnf(cTipoCTRL)
	nTipoAlt:=1 // alteração produtos
	dbgobottom()
	dbskip()
	CXAPADTT(.T.)
end
return NIL

*-----------------------------------------------------------------------------*
function CXAPADT2() // Rotina de Alteracao
*-----------------------------------------------------------------------------*
if TipoAdto==C2_TIPO
	cTipoSIT:='A'
	if C2_FLCTB
		alert('Este registro ja foi contabilizado;mudancas nao serao refletidas;na contabilizacao.;devem ser feita manualmente')
	end
	if reclock()
		nTipoAlt:=max(alert('Alteracao de',{'Produtos','Vlr Total Adto'}),1)
		NroAdto :=C2_NRO
		CXAPADTT(.F.)
	end
else
	alert('Este registro nao pode ser alterado;por esta rotina;tipo Adto diferente')
end
return NIL

*-----------------------------------------------------------------------------*
 function CXAPADTT(VM_FL)
*-----------------------------------------------------------------------------*
local GETLIST  := {}
LCont          :=.T.
for nX:=1 to fcount()
	X1 :="VM"+substr(fieldname(nX),3)
	&X1:=&(fieldname(nX))
next
VM_DTEMI:=if(empty(VM_DTEMI),date(),VM_DTEMI)
if VM_FL	//	novo
	VM_TIPO  :=TipoAdto
	VM_PEND  :=.T.
	VM_CODBCO:=BuscBcoCx()// buscar código do caixa na tabela de bancos
end
nX1:=12
pb_box(nX1++,24,,,,'Informe')
@nX1++,25 say 'Tipo Adto.:' get VM_TIPO   pict mXXX valid VM_TIPO$'CF'                                                                                              when .F.
@nX1++,25 say 'Nr.Control: '+transform(NroAdto,mI7)
@nX1++,25 say 'Cli/Fornec:' get VM_CODCL  pict mI5  valid fn_codigo(@VM_CODCL,  {'CLIENTE', {||CLIENTE->(dbseek(str(VM_CODCL,5)))},  {||CFEP3100T(.T.)},{2,1,8,7}}) when VM_FL
@nX1++,25 say 'Dt.Emissao:' get VM_DTEMI  pict mDT  valid pb_ifcod2(str(VM_CODCL,5)+VM_TIPO+dtos(VM_DTEMI),NIL,.F.,1)                                               when VM_FL
if TipoAdto=='F'
	@nX1++,25 say 'Nr.Parcela:' get VM_PARC pict mI2 valid VM_PARC>=0 when pb_msg('Informe nro de parcelas. Zero e considerado a Vista').and.VM_FL
end
@nX1++,25 say 'Banco.....:' get VM_CODBCO pict mI2 valid fn_codigo(@VM_CODBCO,{'BANCO',{||BANCO->(dbseek(str(VM_CODBCO,2)))},{||CFEP1500T(.T.)},{2,1}})
@nX1++,25 say 'Historico.:' get VM_HIST   pict mXXX
@nX1++,25 say 'Vlr Adto..:' get VM_VLRADT pict mI122 when nTipoAlt==2
@nX1++,25 say 'Vlr Usado.:' get C2_VLRUSA PICT mI122 when .F.
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	VM_NRO:=NroAdto // Salvar novo número
	if VM_FL
		LCont:=AddRec()
	end
	if LCont
		for nX:=1 to fcount()
			X1 :="VM"+substr(fieldname(nX),3)
			replace &(fieldname(nX)) with &X1
		next
	end
	dbcommit()
	cTELA:=savescreen()
	EdAdtoDet(VM_NRO)//..............Editar detalhes
	restscreen(,,,,cTELA)
	SELECT ADTOSC
	replace  C2_VLRADT with nVLRTOT,;
				C2_VLRUSA with nVLRUSA
	cTELA:=chr(K_ESC)
	if VM_FL	//..............................................Lancamento somente para inclusão
		if VM_PARC>0//.... tem lancamentos em duplicatas pendentes
			VM_FAT:=fn_parc(VM_PARC,nVLRTOT,NroAdto,VM_DTEMI)
			if len(VM_FAT)>0
				replace ADTOSC->C2_PARC with VM_PARC
				SELECT DPFOR
				for nX:=1 to VM_PARC
					while !AddRec(30);end
					replace	DP_DUPLI with VM_FAT[nX,1],;
								DP_CODFO with if(empty(CLIENTE->CL_MATRIZ),VM_CODCL,CLIENTE->CL_MATRIZ),;
								DP_DTEMI with VM_DTEMI,;
								DP_CODBC with VM_CODBCO,;
								DP_DTVEN with VM_FAT[nX,2],;
								DP_VLRDP with VM_FAT[nX,3],;
								DP_MOEDA with 1,;
								DP_NRNF  with NroAdto,;
								DP_SERIE with "ADT",;
								DP_ALFA  with CLIENTE->CL_RAZAO
						dbrunlock(recno())
				next
				SELECT ADTOSC
			end
		elseif VM_PARC==0 //.........Lancamento em histórico de cliente/fornecedor somente a vista
			CXAPHIST(TipoAdto)
		else
			alert(ProcName()+';Parcela Negativa?')
		end
		cTELA+=chr(K_ESC)
	end
	if VM_FL.and.TipoAdto=='C'//..............Impressão comprovante.
		CXAPADT6()
	end

	KeyBoard cTELA
elseif VM_FL
	FN_BACKNF(cTipoCTRL,NroAdto) // se for o ultimo não usado pode voltar
end
dbrunlock()
return NIL

*-----------------------------------------------------------------------------*
 function CXAPADT3() // Rotina de Pesquisa
*-----------------------------------------------------------------------------*
nX1:= C2_CODCL
pb_box(20,40,,,,'Selecione Cliente')
@21,42 get nCodCli picture mI5
read
setcolor(VM_CORPAD)
dbseek(str(nCodCli,5),.T.)
return NIL

*-----------------------------------------------------------------------------*
 function CXAPADT4() // Rotina de Exclusao
*-----------------------------------------------------------------------------*
if TipoAdto==C2_TIPO
	if RecLock().and.pb_sn('Excluir Adto de :'+pb_zer(C2_CODCL,5)+chr(45)+left(CLIENTE->CL_RAZAO,25))
		if str(C2_VLRUSA,15,2)==str(0,15,2)
			VM_NRO:=C2_NRO
			fn_elimi()
			select ADTOSD
			dbseek(str(VM_NRO,5),.T.)
			while !eof().and.C3_NRO==VM_NRO
				if reclock()
					fn_elimi()
				end
			end
			dbrunlock()
			select ADTOSC
		else
			alert('Este adiantamento já tem baixa... nao pode ser excluido')
		end
	end
else
	alert('Este registro nao pode ser excluido;por esta rotina;tipo Adto diferente')
end
dbrunlock()
return NIL

*-----------------------------------------------------------------------------*
 function CXAPADT5() // Rotina de Impressao
*-----------------------------------------------------------------------------*
CXAPADTI(TipoAdto)
return NIL

*-------------------------------------------------------------------------*
	static function EdAdtoDet(pNroAdto)
*-------------------------------------------------------------------------*
private VM_NRO:=pNroAdto
pb_tela()
pb_lin4(_MSG_+' Detalhes Adto Nro:'+str(VM_NRO,5),ProcName())
SALVABANCO
select ADTOSD
ORDEM PRODUTO
set filter to ADTOSD->C3_NRO == VM_NRO
DbGoTop()
set relation to str(ADTOSD->C3_CODPR,L_P) into PROD
setColor('GR+/B')
pb_dbedit1('CXAPADTD','IncluiAlteraExclui')
nVLRTOT  :=AdtoSoma()
VM_CAMPOD:={'str(C3_CODPR,L_P)+chr(45)+left(PROD->PR_DESCR,25)','C3_QTDEPE','C3_QTDESA','C3_VLRVEN','C3_VLRTOT' ,'C3_VLRSA' }
while .T.
	dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPOD,'PB_DBEDIT2',;
							 {     mXXX,                                    mI113 ,      mI113 ,       mI113 ,   mI122 ,     mI122 },;
							 {'Produto',                              'Qtd-Pedida','Qtd-Entreg','Vl-Vend(Un)','Vlr Adt','Vlr Saida'})
	nVLRTOT:=AdtoSoma()
	if cTipoSIT=='A'
		if str(nVLRTOT,15,2)==str(ADTOSC->C2_VLRADT,15,2)
			Exit
		else
			alert('Alteracao em adiantamento deve manter ;Vlr Original:'+str(ADTOSC->C2_VLRADT,15,2)+';'+;
																		'Vlr Somado..:'+str(nVLRTOT          ,15,2))
		end
	else
		Exit
	end
end

nVLRUSA:=0
DbGoTop()
dbeval({||nVLRUSA+=(pb_DivZero(C3_VLRTOT,C3_QTDEPE)*C3_QTDESA)},,{||C3_NRO==VM_NRO})
set filter to 
set relation to 
RESTAURABANCO
return NIL

*-------------------------------------------------------------------------*
 function CXAPADTD1()  // Inclui 
*-------------------------------------------------------------------------*
while lastkey()#K_ESC
	nVLRTOT  :=AdtoSoma()
	dbgobottom()
	dbskip()
	CXAPADTDT(.T.)
end
return NIL

*-------------------------------------------------------------------------*
 function CXAPADTD2()  // Altera
*-------------------------------------------------------------------------*
nVLRTOT  :=AdtoSoma()
	if reclock()
		CXAPADTDT(.F.)
	end
return NIL

*-------------------------------------------------------------------------*
 function CXAPADTD3()  // Exclui
*-------------------------------------------------------------------------*
if reclock().and.pb_sn('Excluir Adto Prod:'+pb_zer(C3_CODPR,L_P)+chr(45)+left(PROD->PR_DESCR,25))
	if str(C3_QTDESA,15,3)==str(0,15,3)
		fn_elimi()
	else
		alert('Item de adiantamento ja contem saida, nao pode ser eliminado')
	end
end
dbrunlock()
return NIL

*-------------------------------------------------------------------------*
 function CXAPADTDT(VM_FLAG1)  // Inclui+Altera Detalhe=Tela
*-------------------------------------------------------------------------*
local GETLIST  := {}
private X1
LCont  :=.T.
nVLRTOT:=AdtoSoma()
for nX :=1 to fcount()
	X1  :="VM"+substr(fieldname(nX),3)
	&X1 :=&(fieldname(nX))
next
VM_NRO :=ADTOSC->C2_NRO
nX     :=16
pb_box(nX++,20,,,,'Informe')
@nX++,22 say 'Nro Ctrl Adto.:'+str(VM_NRO,5)
@nX  ,22 say 'Produto.......:'  get VM_CODPR  pict masc(21)   valid pb_ifcod2(str(VM_NRO,5)+str(VM_CODPR,L_P),NIL,.F.,2).and.fn_codpr(@VM_CODPR,77) when VM_FLAG1
@nX++,col() say '-'+left(PROD->PR_DESCR,25)
@nX  ,22 say 'Qtde Pedida...: ' get VM_QTDEPE pict mI123 valid VM_QTDEPE>0.and.if(cTipoSIT=='A',VM_QTDEPE>=C3_QTDESA,.T.)
@nX++,55 say 'Entregue: '       get VM_QTDESA pict mI123                      when .F.
@nX++,22 say 'Vlr Venda Unit: ' get VM_VLRVEN pict mI123 valid VM_VLRVEN>0    when (VM_VLRVEN:=if(empty(VM_VLRVEN),PROD->PR_VLVEN,VM_VLRVEN))>=0.and.pb_msg("Vlr Unit-Quando Inclusão(lista Produtos)-Alteração(Mantem anterior)")
@nX  ,22 say 'Vlr Total Item:'  get VM_VLRTOT pict mI122 valid VM_VLRTOT>0    when (VM_VLRTOT:=trunca(VM_QTDEPE*VM_VLRVEN,2))                >=0.and.pb_msg("Vlr Total calculado - confirmar")
@nX++,55 say 'Entregue:'        get VM_VLRSA  pict mI122                      when .F.
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if VM_FLAG1
		if !Addrec()
			LCont:=.F.
		end
	end
	if lCont
		VM_VLRVEN:=trunca(pb_divZero(VM_VLRTOT,VM_QTDEPE),3)
		for nX :=1 to fcount()
			X1 :="VM"+substr(fieldname(nX),3)
			fieldput(nX,&X1)
		next
	end
	dbunlock()
end
nVLRTOT:=AdtoSoma()
return NIL

*----------------------------------------------------------------------------------------------
 static function AdtoSoma()
*----------------------------------------------------------------------------------------------
nVLRTOT:=0
nRec   :=RecNo()
go top
dbeval({||nVLRTOT+=trunca(ADTOSD->C3_VLRTOT)})
	@maxrow()-1,55 say 'Soma Prod.:'+transform(nVLRTOT,          mI122) COLOR 'GR+/B'
if cTipoSIT=='A'
	@maxrow()-0,55 say 'Total Adto:'+transform(ADTOSC->C2_VLRADT,mI122) COLOR 'G+/B'
end
DbGoTo(nRec)
return (nVLRTOT)

*----------------------------função de uso interno no dbedit2
 function CXAPADTD_() // dentro de dbedit2 (função escondida - uso de _ no inicio)
*----------------------------------------------------------------------------------------------
	nVLRTOT:=AdtoSoma()
return NIL

*----------------------------------------------------------------------------------------------
 function CXAPADTX(P1,P2)
*------------------------------------------------* Adiantamentos - Cabeçalho
local ARQ:='CXAAADT'
if P2=='VER ARQUIVOS'.and.;
	dbatual(ARQ,;
				{{'C2_CODCL',  'N',  5, 0},;	// 01-Código Cliente
				 {'C2_TIPO',   'C',  1, 0},;	// 02-Tipo "<F>ornecedor" ou "<C>liente"
				 {'C2_DTEMI',  'D',  8, 0},;	// 03-Data Emissao
				 {'C2_CODBCO', 'N',  3, 0},;	// 04-Código Banco
				 {'C2_VLRADT', 'N', 15, 2},;	// 05-Valor Adiantamento
				 {'C2_VLRUSA', 'N', 15, 2},;	// 06-Valor Usado Adto
				 {'C2_PEND',   'L',  1, 0},;	// 07-Pendente
				 {'C2_NRO',    'N',  5, 0},;	// 08-NumeroAdiantamento
				 {'C2_HIST',   'C', 30, 0},;	// 09-Histórico
				 {'C2_FLCTB',  'L',  1, 0},;	// 10-Contabilizado
				 {'C2_PARC',   'N',  2, 0}},;	// 11-Parcelamento
				 RDDSETDEFAULT())
	ferase(ARQ+OrdBagExt())
end
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. Adiantamentos-Cabec - Reg:'+str(LastRec(),7))
		pack
		Index on str(C2_CODCL,5)+dtos(C2_DTEMI)+str(C2_NRO,5)         tag CODIGOC to (Arq) eval {||ODOMETRO('COD+DT+NRO=C')} 	for  C2_TIPO=="C"
		Index on str(C2_CODCL,5)+dtos(C2_DTEMI)+str(C2_NRO,5)         tag CODIGOF to (Arq) eval {||ODOMETRO('COD+DT+NRO=F')} 	for  C2_TIPO=="F"
		Index on str(C2_CODCL,5)+C2_TIPO+dtos(C2_DTEMI)+str(C2_NRO,5) tag ATIVOS  to (Arq) eval {||ODOMETRO('COD+TP+DTEMI+NR')} for !C2_PEND
		Index on str(C2_NRO,5)                                        tag NUMERO  to (Arq) eval {||ODOMETRO('NUMERO')}
		close
	end
end

*------------------------------------------------* Adiantamentos - Detalhes
ARQ:='CXAAADD'
if P2=='VER ARQUIVOS'.and.;
	dbatual(ARQ,;
				{{'C3_NRO',    'N',  5, 0},;	// 01-Numero Contrato
				 {'C3_CODPR',  'N',L_P, 0},;	// 02-Código Produto
				 {'C3_QTDEPE', 'N', 12, 3},;	// 03-Qtde Pedida
				 {'C3_QTDESA', 'N', 12, 3},;	// 04-Qtde Saida/Entrada
				 {'C3_VLRVEN', 'N', 15, 3},;	// 05-Vlr Venda Unitário
				 {'C3_VLRTOT', 'N', 15, 2},;	// 06-Vlr Venda Total Item 
				 {'C3_VLRSA',  'N', 15, 2}},;	// 07-Vlr Venda Total Item (Saida/Entrada)
				 RDDSETDEFAULT())
	ferase(ARQ+OrdBagExt())
end
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. Adiantamentos-Detalhes - Reg:'+str(LastRec(),7))
		pack
		Index on str(C3_NRO,5)                   tag NUMERO  to (Arq) eval {||ODOMETRO('NUMERO')}
		Index on str(C3_NRO,5)+str(C3_CODPR,L_P) tag PRODUTO to (Arq) eval {||ODOMETRO('PRODUTO')}
		close
	end
end
return NIL

*----------------------------------------------------------------------------------------------
 function fn_aAdtos(pCli,pTipo)
*----------------------------------------------------------------------------------------------
aADTO:={}

	SALVABANCO
	SELECT ADTOSC // CABEÇALHO
	if pTipo=='C'
		ORDEM CODIGOC
	else
		ORDEM CODIGOF
	end
	
	fn_aAdtosS(pCli,pTipo)
	
	if len(aADTOx)>0
		for nX1:=1 to len(aADTOx)
			if aADTOx[nX1][1]=='[X]' // se selecionado... ir para
				SELECT ADTOSC // CABEÇALHO
				DbGoTo(aADTOx[nX1][5]) // Ir para Registro do Cabec Adto
				SELECT ADTOSD // Detalhe
				dbseek(str(ADTOSC->C2_NRO,5),.T.)
				while !eof().and.ADTOSC->C2_NRO==C3_NRO
					if str(C3_QTDEPE,15,3)>str(C3_QTDESA,15,3) //....tem saldo ?
						PROD->(dbseek(str(ADTOSD->C3_CODPR,L_P)))
						if RecLock()
							aadd(aAdto,{C3_NRO,C3_CODPR,PROD->PR_DESCR,C3_QTDEPE-C3_QTDESA,C3_QTDEPE,C3_QTDESA,C3_VLRVEN,    0,.F., RecNo(),    0 })
							//..........1NAdto 2Cod     3Descricao Prd 4Saldo Qtde........ 5QPedid.. 6QSaida.. 7VVenda.. 8QRet 9Alt 10Reg...11VSaid
						end
					end
					skip
				end
			end
		next
	end
	RESTAURABANCO

return (aADTO)

*----------------------------------------------------------------------------------------------
 static function fn_aAdtosS(pCli,pTipo)
*----------------------------------------------------------------------------------------------
aADTOx:={}

	DbGoTop()
	dbseek(str(pCli,5),.T.)
	while !eof().and.C2_CODCL==pCli
		if str(C2_VLRADT,15,2)>str(C2_VLRUSA,15,2)
			aadd(aADTOx,{'[ ]',ADTOSC->C2_NRO,ADTOSC->C2_DTEMI,ADTOSC->C2_HIST,RecNo()})
			//.............1...........2..............3................4.......5
		end
		skip
	end

	if pTipo=='C'
		aEval(aADTOx,{|DET|DET[1]:='[X]'})
	else
		if len(aADTOx)>=1
			aADTOx[1][1]:='[X]' // Seleciona o Primeiro
			cTELA:=SaveScreen()
			while .T.//.and.len(aADTOs)>1
				pb_msg('Selecione um Contrato com <Enter>. Para sair <ESC>')
				setcolor('Gr+/G')
				nX1:=abrowse(5,25,13,79,;
								aADTOx,;
								{'Sel','NrAdto','DtEmis','Histo'},;
								{   3 ,      6 ,     10 ,    30 },;
								{mUUU ,    mI6 ,    mDT ,  mUUU },,'Adiantamentos em Aberto')
				if nX1>0
					if aADTOx[nX1][1]=='[X]'
						aADTOx[nX1][1]:='[ ]' // Seleciona
					else
						aEval(aADTOx,{|DET|DET[1]:='[ ]'})
						aADTOx[nX1][1]           :='[X]' // Seleciona
					end
				else
					exit
				end
			end
			RestScreen(,,,,cTELA)
		end
	end
return NIL

*-------------------------------------------------------------------------------------------------*
  function ChkAdtoPrd(pProd,plAdto)  // Verificar se é adto e se produto consta na lista (mostra)
*-------------------------------------------------------------------------------------------------*
lFlag:=.T.
if plAdto=="S" // é adiantamento
	nX:=aScan(aAdtos,{|DET|DET[2]==pProd})
	if nX==0
		cDesc:='Produto na lista de adiantamento;'
		for nX:=1 to len(aAdtos)
			cDesc+=";|"+str(aAdtos[nX,2],L_P)+"|"+left(aAdtos[nX,3],25)+"|"+str(aAdtos[nX,4],9,3)+"|"
		next
		alert(cDesc)
		lFlag:=.F.
	end
end
return (lFlag)

*-----------------------------------------------------------------------------------------------*
 function ChkAdtoQtd(pProd,plAdto,pQtde,pVlrVen)  // Verificar se é adto e se produto tem saldo
*-----------------------------------------------------------------------------------------------*
lFlag:=.T.
if plAdto=="S" // é adiantamento
	nX:=aScan(aAdtos,{|DET|DET[2]==pProd})
	if nX>0
		if !str(aAdtos[nX,4],15,3)>=str(pQtde,15,3)
			cDesc:=	'Produto com saldo inferior a retirada;Saldo...:'+;
						str(aAdtos[nX,4],15,3)+';Retirada:'+str(pQtde,15,3)+';Verificar...'
			alert(cDesc)
			lFlag:=.F.
		else
			pVlrVen:=aAdtos[nX,7]
		end
	else
		lFlag:=.F.
	end
end
return (lFlag)

*----------------------------------------------------------------------------------------------
 function GraAdtos(plAdto)
*----------------------------------------------------------------------------------------------
if plAdto=="S" // é Adiantamento
	SALVABANCO
	SELECT ADTOSC // CABEÇALHO
	ORDEM NUMERO
		for nX:=1 to len(aAdtos)
			select ADTOSD
			if aAdtos[nX,9] // Registro foi Alterado
				DbGoTo(aAdtos[nX,10])
				replace C3_QTDESA with C3_QTDESA+aAdtos[nX,08]
				replace C3_VLRSA  with C3_VLRSA +aAdtos[nX,11]
				SELECT ADTOSC //.......................................CABEÇALHO
				if dbseek(str(ADTOSD->C3_NRO,5))
					if reclock()
						//-----------------------------------------em mudança...pode ser que nao tenha vlr
						if str(aAdtos[nX,11],15,2)>str(0,15,2)
							replace C2_VLRUSA with C2_VLRUSA+(aAdtos[nX,11])
						else
							replace C2_VLRUSA with C2_VLRUSA+(aAdtos[nX,08]*ADTOSD->C3_VLRVEN)
						end
						if str(C2_VLRADT,15,2)==str(C2_VLRUSA,15,2)
							replace C2_PEND with .F.
						else
							replace C2_PEND with .T.
						end
					end
				end
			end
		next
	RESTAURABANCO
end
return Nil

*----------------------------------------------------------------------------------------------
 static function CXAPHIST()
*----------------------------------------------------------------------------------------------
SALVABANCO
if TipoAdto=='F'
	select HISFOR
	while !AddRec(30);end
	replace 	HF_CODFO with if(empty(CLIENTE->CL_MATRIZ),ADTOSC->C2_CODCL,CLIENTE->CL_MATRIZ),;
				HF_DUPLI with ADTOSC->C2_NRO*100,;
				HF_DTEMI with ADTOSC->C2_DTEMI,;
				HF_DTVEN with ADTOSC->C2_DTEMI,;
				HF_DTPGT with ADTOSC->C2_DTEMI,;
				HF_VLRDP with ADTOSC->C2_VLRADT,;
				HF_VLRPG with ADTOSC->C2_VLRADT,;
				HF_NRNF  with ADTOSC->C2_NRO,;
				HF_SERIE with 'ADT',;
				HF_CXACG with 2,;//......................................Tipo de lancamento no caixa Geral
				HF_VLRMO with pb_divzero(ADTOSC->C2_VLRADT,PARAMETRO->PA_VALOR),;
				HF_CDCXA with ADTOSC->C2_CODBCO //...............................Codigo do Banco
	dbrunlock(recno())
elseif TipoAdto=='C'
	select HISCLI
	while !AddRec(30);end
	replace 	HC_CODCL with if(empty(CLIENTE->CL_MATRIZ),ADTOSC->C2_CODCL,CLIENTE->CL_MATRIZ),;
				HC_DUPLI with ADTOSC->C2_NRO*100,;
				HC_DTEMI with ADTOSC->C2_DTEMI,;
				HC_DTVEN with ADTOSC->C2_DTEMI,;
				HC_DTPGT with ADTOSC->C2_DTEMI,;
				HC_VLRDP with ADTOSC->C2_VLRADT,;
				HC_VLRPG with ADTOSC->C2_VLRADT,;
				HC_NRNF  with ADTOSC->C2_NRO,;
				HC_SERIE with 'ADT',;
				HC_CXACG with 1,;//.................................Tipo de lancamento no caixa Geral-Receb)
				HC_VLRMO with pb_divzero(ADTOSC->C2_VLRADT,PARAMETRO->PA_VALOR),;
				HC_CDCXA with ADTOSC->C2_CODBCO //...............................Codigo do Banco
	dbrunlock(recno())
else
	alert(ProcName()+';Tipo Adiantamento = ('+TipoAdto+')')
end
RESTAURABANCO
return Nil
*-----------------------------------------------EOF----------------------------------------
