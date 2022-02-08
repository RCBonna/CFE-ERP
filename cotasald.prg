*-----------------------------------------------------------------------------------------------*
 static aVariav := {0,  0,  0,  0,  0,  0,   ,80,  0, '', '',  0, '',{0,0},{{0,0},{0,0}},{},'N'}
 //.................1...2...3...4...5...6...7..8...9, 10, 11, 12, 13,  14,            15,16,17
*-----------------------------------------------------------------------------------------------*
#xtranslate nX         => aVariav\[  1 \]
#xtranslate nY         => aVariav\[  2 \]
#xtranslate nOrdem     => aVariav\[  3 \]
#xtranslate nCliente   => aVariav\[  4 \]
#xtranslate NumDocto   => aVariav\[  5 \]
#xtranslate nVlrReceb  => aVariav\[  6 \]
#xtranslate DtMovto    => aVariav\[  7 \]
#xtranslate nLar       => aVariav\[  8 \]
#xtranslate nPag       => aVariav\[  9 \]
#xtranslate cTipo      => aVariav\[ 10 \]
#xtranslate cRel       => aVariav\[ 11 \]
#xtranslate nCliente   => aVariav\[ 12 \]
#xtranslate cCliente   => aVariav\[ 13 \]
#xtranslate aSelCli    => aVariav\[ 14 \]
#xtranslate aTotProd   => aVariav\[ 15 \]
#xtranslate aDadosRec  => aVariav\[ 16 \]
#xtranslate cTipoC     => aVariav\[ 17 \]

*-----------------------------------------------------------------------------*
 function CotaSald()	//	Saldo Cota Parte
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
if !abre({	'R->PARAMETRO',;
				'C->CLIENTE',;
				'C->BANCO',;
				'E->COTAMV',;
				'C->CAIXACG',;
				'R->LAYOUT',;
				'E->COTADV'})
	return NIL
end

pb_tela()
pb_lin4(_MSG_,ProcName())
DbGoTop()
set relation to str(COTADV->DV_CODCL,5) into CLIENTE

	pb_dbedit1("COTASALD",'OutrasRecebePagar Lista IncluiAlteraExclui')
//.....................1.....2.....3.....4.....5.....6.....7.....
VM_CAMPO   := array(fcount())
afields(VM_CAMPO)
VM_CAMPO[1]:="pb_zer(DV_CODCL,5)+chr(45)+left(CLIENTE->CL_RAZAO,25)"
VM_CAMPO[6]:="if(DV_FLCTB,'SIM','nao')"
VM_MUSC    :={       mXXX,      mDT,       mI92,     mI92,  mXXX,mXXX,mDT}
VM_CABE    :={"Associado","Dt Vcto","Vlr Inic.","Pago/Rec.",'TP','Ctb?','Dt Movto'}
dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,"PB_DBEDIT2",VM_MUSC,VM_CABE)
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
 function COTASALD1() // Selecao Outras Opcoes
*-----------------------------------------------------------------------------*
nCliente:=0
nOrdem  :=IndexOrd()
nX      :=15
pb_box(nX++,10,,,,'Selecione Ordem a ser mostrada')
@nX++,12 Prompt ' 1-Todos os Valores  '
@nX++,12 Prompt ' 2-Valores a Receber '
@nX++,12 Prompt ' 3-Valores a Pagar   '
@nX++,12 Prompt ' 4-Corrigir Pacelas  '
menu to Ordem
if lastkey() # K_ESC
	if Ordem>0.and.Ordem<4
		dbsetorder(nOrdem)
		DbGoTop()
		Cliente:=0
		nX++
		@nX++,12 Say 'Informe Associado :' get Cliente Pict mI5 valid fn_codigo(@Cliente,{'CLIENTE',{||CLIENTE->(dbseek(str(Cliente,5)))},{||CFEP3100T(.T.)},{2,1,8,7}})
		read
		if lastkey()#K_ESC
			dbseek(str(Cliente,5),.T.)
		end
	elseif Ordem==4
		nX      :=15
		VM_DATA :=boy(PARAMETRO->PA_DATA)+1
		VM_PERC :=0
		VM_TOTAL:=0
		@nX++,50 say '[Corrigir Pagamentos]' color 'W+/R*'
		 nX++
		@nX++,50 say 'A Patir de:' get VM_DATA pict mDT  valid VM_DATA>=PARAMETRO->PA_DATA
		@nX++,50 say '% Correcao:' get VM_PERC pict mI62 valid VM_PERC>0
		read
		if if(lastkey()#K_ESC,pb_sn('Corrigir valores das;parcelas a pagar?'),.F.)
			ordem 3
			go top
			while !eof()
				if str(DV_SLDINI,15,2)#str(DV_VLRPG,15,2)
					VM_TOTAL+=trunca(DV_SLDINI*VM_PERC/100,2)
					replace DV_SLDINI with DV_SLDINI + trunca(DV_SLDINI*VM_PERC/100,2)
				end
				skip
			end
			ordem 1
			go top
			alert('TOTALIZACAO DA CORRECAO;VALOR R$ = '+str(VM_TOTAL,13,2))
		end
	end
end
return NIL

*-----------------------------------------------------------------------------*
 function COTASALD2() // Recebe Valores
*-----------------------------------------------------------------------------*
if DV_TPMOV == 'P'
	alert('Esta Rotina faz Recebimento de Valores;Para Pagamento use opcao 3')
	return NIL
end
if str(DV_SLDINI-DV_VLRPG,15,2)==str(0,15,2)
	alert('Saldo para Recebimento esta ZERADO;Nao permitido movimentacao')
	return NIL
end

private CodBanco :=10
private CodCaixa :=BuscTipoCx('R')
NumDocto :=0
nX       :=12
nVlrReceb:=DV_SLDINI-DV_VLRPG
DtMovto  :=date()
cTipo    :='S'
CAIXACG->(dbseek(str(CodCaixa,3)))

pb_box(nX++,12,,,,'Recebimento de Valores')
@nX++,14 say 'Associado.......: '+&(VM_CAMPO[1])
@nX++,14 say 'Data Inicial....: '+transform(DV_DATA,mDT)
@nX++,14 say 'Saldo A Receber.: '+transform(DV_SLDINI-DV_VLRPG,mI92)
@nX++,14 say 'Data Movimento.:'  get DtMovto   pict mDT
@nX++,14 say 'Cod.Banco......: ' get CodBanco  pict mI2  valid fn_codigo(@CodBanco,{'BANCO',{||BANCO->(dbseek(str(CodBanco,2)))},{||CFEP1500T(.T.)},{2,1}})     when USACAIXA.and.pb_msg('Codigo do Banco para lancamento')
@nX  ,35 say '-'+CAIXACG->CG_DESCR
@nX++,14 say 'Cod Mov.Caixa..:'  get CodCaixa  pict mI3  valid fn_codigo(@CodCaixa,{'CAIXACG',{||CAIXACG->(dbseek(str(CodCaixa,3)))},{||CXAPCDGRT(.T.)},{2,1}}) when USACAIXA.and.pb_msg('Codigo Despesa/Receita de lancamento no Caixa').and.CodCaixa==0
@nX++,14 say 'Documento......:'  get NumDocto  pict mI6  valid NumDocto >0                                                                                      when pb_msg('Informe o valor recebido deste Associado')
@nX++,14 say 'Valor Recebido.:'  get nVlrReceb pict mI92 valid nVlrReceb>0                                                                                      when pb_msg('Informe o numero do documento para este recebimento')
@nX++,14 say 'Imprimir Recibo?'  get cTipo     pict mUUU valid cTipo$'SN'                                                                                       when pb_msg('Imprimir Recibo ?')
read
if (DV_SLDINI-DV_VLRPG)>0.and.if(lastkey()#K_ESC,pb_sn(),.F.)
	replace DV_VLRPG with DV_VLRPG + nVlrReceb
	GravaCotaMV({	COTADV->DV_CODCL,;	//1-Associado
						DtMovto,;				//2-Data
						nVlrReceb,;				//3-Saldo Inicial
						'R',;						//4-Tipo Movimento=Recebimento
						CodBanco,;				//5-Codigo Banco
						CodCaixa,;				//6-Cod Mov Caixa
						NumDocto,;				//7-NumDocto
						.F. ,;					//8-Flag de Contabilizado
						.F. })					//9-Flag de Lancado no Caixa
	if cTipo=='S'
		aDadosRec:={space(2)+'Docto.  Data Movto       Valor'}
		aadd(aDadosRec, 	space(2)+;
								pb_zer(NumDocto,6) +'   '+;
								dtoc(DtMovto)      +;
								transform(nVlrReceb,mD112))
		RECIBO('C',CLIENTE->CL_RAZAO+'('+pb_zer(COTADV->DV_CODCL,5)+')',aDadosRec,DtMovto,nVlrReceb)
	end
end
return NIL

*-----------------------------------------------------------------------------*
 function COTASALD3() // Pagamento Valores de Cotas 
*-----------------------------------------------------------------------------*
if DV_TPMOV == 'R'
	alert('Esta Rotina faz Pagamentos de Valores;Para Recebimentos Use Opcao 2')
	return NIL
end

if str(DV_SLDINI-DV_VLRPG,15,2)==str(0,15,2)
	alert('Saldo para Pagamento ZERADO;Nao permitido movimentacao')
	return NIL
end

private CodBanco :=10
private CodCaixa :=BuscTipoCx('P')

NumDocto := 0
nX       :=11
nVlrReceb:=(DV_SLDINI-DV_VLRPG)
DtMovto  :=date()
cTipo    :='S'
cTipoC   :='S'
CAIXACG->(dbseek(str(CodCaixa,3)))

pb_box(nX++,12,,,,'Pagamento de Valores')
@nX++,14 say 'Associado.......: '+&(VM_CAMPO[1])
@nX++,14 say 'Data Inicial....: '+transform(DV_DATA,mDT)
@nX++,14 say 'Saldo A Pagar...: '+transform(DV_SLDINI-DV_VLRPG,mI92)
@nX++,14 say 'Data Movimento.:'  get DtMovto   pict mDT
@nX++,14 say 'Cod.Banco......: ' get CodBanco  pict mI2  valid fn_codigo(@CodBanco,{'BANCO',{||BANCO->(dbseek(str(CodBanco,2)))},{||CFEP1500T(.T.)},{2,1}})     when USACAIXA.and.pb_msg('Codigo do Banco para lancamento')
@nX  ,35 say '-'+CAIXACG->CG_DESCR
@nX++,14 say 'Cod Mov.Caixa..:'  get CodCaixa  pict mI3  valid fn_codigo(@CodCaixa,{'CAIXACG',{||CAIXACG->(dbseek(str(CodCaixa,3)))},{||CXAPCDGRT(.T.)},{2,1}}) when USACAIXA.and.pb_msg('Codigo Despesa/Receita de lancamento no Caixa').and.CodCaixa==0
@nX++,14 say 'Documento......:'  get NumDocto  pict mI6  valid NumDocto>0                                                                                       when pb_msg('Informe o valor recebido deste Associado').and.(NumDocto:=BANCO->BC_ULTCHE+1)>=0
@nX++,14 say 'Valor Pago.....:'  get nVlrReceb pict mI92 valid nVlrReceb>0                                                                                      when pb_msg('Informe numero do Documento')
@nX++,14 say 'Imprimir Recibo?'  get cTipo     pict mUUU valid cTipo $'SN'                                                                                       when pb_msg('Imprimir Recibo ?')
@nX++,14 say 'Imprimir Cheque?'  get cTipoC    pict mUUU valid cTipoC$'SN'                                                                                       when pb_msg('Imprimir Recibo ?')
read
if (DV_SLDINI-DV_VLRPG)>0.and.if(lastkey()#K_ESC,pb_sn(),.F.)
	replace DV_VLRPG with DV_VLRPG + nVlrReceb
	GravaCotaMV({	COTADV->DV_CODCL,;	//1-Associado
						DtMovto,;				//2-Data
						nVlrReceb,;				//3-Saldo Inicial
						'P',;						//4-Tipo Movimento=Pagamento
						CodBanco,;				//5-Codigo Banco
						CodCaixa,;				//6-Cod Mov Caixa
						NumDocto,;				//7-NumDocto
						.F. ,;					//8-Flag de Contabilizado
						.F. })					//9-Flag de Lancado no Caixa

	if cTipo=='S'
		aDadosRec:={space(2)+'Docto.  Data Movto       Valor'}
		aadd(aDadosRec, 	space(2)+;
								pb_zer(NumDocto,6) +'   '+;
								dtoc(DtMovto)      +;
								transform(nVlrReceb,mD112))
		RECIBO('F',CLIENTE->CL_RAZAO+'('+pb_zer(COTADV->DV_CODCL,5)+')',aDadosRec,DtMovto,nVlrReceb)
	end
	if cTipoC=='S'
		BANCO->(dbseek(str(CodBanco,2)))
		if BANCO->BC_IMPCHE
			CHEQUE(CodBanco,nVlrReceb,CLIENTE->CL_RAZAO,DtMovto)
			if BANCO->(reclock())
				replace BANCO->BC_ULTCHE with NumDocto
				dbrunlock(recno())
			end
		end
	end
end
return NIL

*-----------------------------------------------------------------------------*
 function COTASALD4() // Impressao
*-----------------------------------------------------------------------------*
aSelCli:={0,1000}

cTipo:='A'
nLar :=80
nPag :=0

pb_box(18,28,,,,'Selecione Produtor')
@19,30 say 'Inicial.......: ' get aSelCli[1]  pict mI5
@20,30 say 'Final.........: ' get aSelCli[2]  pict mI5  valid aSelCli[2]>=aSelCli[1]
@21,30 say 'Tipo Relatorio: ' get cTipo       pict mUUU valid cTipo$'AS'             when pb_msg('Tipo de relatorio :   <A>nalitico    <S>intetico')
read
if if(lastkey()#K_ESC,pb_ligaimp(C15CPP),.F.)
	if cTipo=='A'
		cRel:='Conta Parte-Movimentacao (Analitico)'
		COTASALD4A()
	else
		cRel:='Conta Parte-Movimentacao (Sintetico)'
		COTASALD4S()
	end
	? 'Impresso as '+time()
	eject
	pb_deslimp(C15CPP)
	DbGoTop()
end
return NIL

*-----------------------------------------------------------------------------*
 static function COTASALD4A() // Impressao
*-----------------------------------------------------------------------------*

	ORDEM ASSDT
	DbGoTop()
	dbseek(str(aSelCli[1],5),.T.)
	while !eof().and.DV_CODCL<=aSelCli[2]
		nCliente :=DV_CODCL
		cCliente :=CLIENTE->CL_RAZAO
		nPag     :=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),cRel,nPag,'COTASALDA',nLar)
		nVlrReceb:=0
		while !eof().and.nCliente==DV_CODCL
			nPag:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),cRel,nPag,'COTASALDA',nLar)
			nVlrReceb+=(DV_SLDINI-DV_VLRPG)
			? 'Lancamento : '
			??if(DV_TPMOV=='R','Receber','Pagar  ')+' '
			??dtoc(DV_DTMOV)+' '
			??dtoc(DV_DATA) +' '
			??Transform(DV_SLDINI,mD82)+' '
			??Transform(DV_VLRPG, mD82)
			??Transform(nVlrReceb,mD82)
			dbskip()
		end
		SALVABANCO
		select COTAMV
		dbseek(str(nCliente,5))
		while !eof().and.nCliente==MV_CODCL
			? 'Movimentos :'
			??if(MV_TPMOV=='R','Recebido','Pago    ')+' '
			??dtoc(MV_DATA)+' '
			??space(11)
			??Transform(MV_VALOR,mD82)+' '
			dbskip()
		end
		? replicate('-',nLar)
		setprc(64,1) // força pulo de página
		RESTAURABANCO
	end
return NIL

*-----------------------------------------------------------------------------*
 static function COTASALD4S() // Impressao Sintetico
*-----------------------------------------------------------------------------*

	aTotProd[1][1]:=0
	aTotProd[1][2]:=0

	ORDEM ASSDT
	DbGoTop()
	dbseek(str(aSelCli[1],5),.T.)
	while !eof().and.DV_CODCL<=aSelCli[2]
		nCliente:=DV_CODCL
		cCliente:=CLIENTE->CL_RAZAO
		nPag    :=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),cRel,nPag,'COTASALDB',nLar)
		aTotProd[2][1]:=0
		aTotProd[2][2]:=0
		while !eof().and.DV_CODCL==nCliente
			aTotProd[2][if(DV_TPMOV=='R',1,2)]+=(DV_SLDINI-DV_VLRPG)
			dbskip()
		end
		if (aTotProd[2][1]+aTotProd[2][2]) > 0
			?pb_zer(nCliente,5)+' - '+cCliente    +' '
			??Transform(aTotProd[2][1],mD112)+' '
			??Transform(aTotProd[2][2],mD112)
			aTotProd[1][1]+=aTotProd[2][1]
			aTotProd[1][2]+=aTotProd[2][2]
		end
	end
	?replicate('-',nLar)
	?Padr('T O T A I S',54,'.')
	??Transform(aTotProd[1][1],mD112)+' '
	??Transform(aTotProd[1][2],mD112)
	?replicate('-',nLar)

return NIL

*----------------------------------------------------------------------------*
 function COTASALDA() // Cabecalho Lista Grupos
*----------------------------------------------------------------------------*
?
? 'Associado :'+pb_zer(nCliente,5)+' - '+cCliente
?
?replicate('-',nLar)
?padr('Movimentacao',21)+'Dt Movimen  Dt Vencto  Vlr Parcela Pago/Recebid   Vlr Saldo'
?replicate('-',nLar)
return NIL

*----------------------------------------------------------------------------*
 function COTASALDB() // Cabecalho Lista Grupos
*----------------------------------------------------------------------------*
?'Associado'+space(44)+'Valor Receber  Valor Pagar'
?replicate('-',nLar)
return NIL

*-----------------------------------------------------------------------------*
 function GravaCotaMV(P1)
*-----------------------------------------------------------------------------*
SALVABANCO
select COTAMV
while !AddRec();end
for nX:=1 to fcount()
	fieldput(nX,P1[nX])
next
RESTAURABANCO
return NIL

*-----------------------------------------------------------------------------*
 function COTASALD5() // Incluir
*-----------------------------------------------------------------------------*
local Y
dbgobottom()
Skip
for nX:=1 to fcount()
	Y:='VM'+substr(fieldname(nX),3)
	private &Y
	&Y:=FieldGet(nX)
next
nX:=15
pb_box(nX++,12,,,,'Inclusão de Valores')
@nX++,14 say 'Associado.......:' Get VM_CODCL   Pict mI5  valid fn_codigo(@VM_CODCL,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CODCL,5)))},{||CFEP3100T(.T.)},{2,1,8,7}})
@nX++,14 say 'Data Vencimento.:' Get VM_DATA    Pict mDT  
@nX++,14 say 'Vlr Inicial.....:' Get VM_SLDINI  Pict mI92 valid VM_SLDINI > 0
@nX++,14 say 'Tipo Movimento..:' Get VM_TPMOV   Pict mUUU valid VM_TPMOV $ 'PR' when pb_msg('Informe Tipo de Movimento      <P>agamento      <R>ecebimento')
read
if if(lastkey()#K_ESC,pb_sn(),.F.)
	while !addrec()
	end
	for nX:=1 to fcount()
		Y:="VM"+substr(fieldname(nX),3)
		FieldPut(nX,&Y)
	next
end
return NIL

*-----------------------------------------------------------------------------*
 function COTASALD6() // Alterar
*-----------------------------------------------------------------------------*
local Y
for nX:=1 to fcount()
	Y:='VM'+substr(fieldname(nX),3)
	private &Y
	&Y:=FieldGet(nX)
next
nX:=15
pb_box(nX++,12,,,,'Alteracao de Valores')
@nX++,14 say 'Associado.......: '+&(VM_CAMPO[1])
@nX++,14 say 'Data Vencimento.:' Get VM_DATA    Pict mDT
@nX++,14 say 'Data Movimento..:' Get VM_DTMOV   Pict mDT
@nX++,14 say 'Vlr Inicial.....:' Get VM_SLDINI  Pict mI92 valid VM_SLDINI >  0
@nX++,14 say 'Vlr Pago/Receb..:' Get VM_VLRPG   Pict mI92 valid VM_VLRPG  >= 0
@nX++,14 say 'Tipo Movimento..:' Get VM_TPMOV   Pict mUUU valid VM_TPMOV $ 'PR' when pb_msg('Informe Tipo de Movimento      <P>agamento      <R>ecebimento')
read
if if(lastkey()#K_ESC,pb_sn(),.F.)
	for nX:=1 to fcount()
		Y:="VM"+substr(fieldname(nX),3)
		FieldPut(nX,&Y)
	next
end
return NIL

*-----------------------------------------------------------------------------*
 function COTASALD7() // Excluir
*-----------------------------------------------------------------------------*
local Y
cTipo:='N'
for nX:=1 to fcount()
	Y:='VM'+substr(fieldname(nX),3)
	private &Y
	&Y:=FieldGet(nX)
next
nX:=13
pb_box(nX++,12,,,,'Exclusao de Valores')
@nX++,14 say 'Associado.......: '+&(VM_CAMPO[1])
@nX++,14 say 'Data Vencimento.:' Get VM_DATA    Pict mDT  when .F.
@nX++,14 say 'Data Movimento..:' Get VM_DTMOV   Pict mDT  when .F.
@nX++,14 say 'Vlr Inicial.....:' Get VM_SLDINI  Pict mI92 when .F.
@nX++,14 say 'Vlr Pago/Receb..:' Get VM_VLRPG   Pict mI92 when .F.
@nX++,14 say 'Tipo Movimento..:' Get VM_TPMOV   Pict mUUU when .F.
 nX++
@nX++,14 say 'Confirmar Exclusao deste Valor ?' get cTipo pict mUUU valid cTipo$'SN' when pb_msg('Infome        <S>im        <N>ao')
read
if cTipo=='S'
	fn_elimi()
end
return NIL

*---------------------------------------------------ZOOM - CLIENTES
 static function ZoomCli()
*---------------------------------------------------ZOOM - CLIENTES
private VM_CODIG:=0
//pb_box(19,40,21,78,,'Seleciona Cliente')
//@20,42 say padr('Codigo',16,'.')  get VM_CODIG picture mI5 valid fn_codigo(@VM_CODIG,{'CLIENTE',{||dbseek(str(VM_CODIG,5))},{||NIL},{2,1}})
fn_codigo(@VM_CODIG,{'CLIENTE',{||dbseek(str(VM_CODIG,5))},{||NIL},{2,1}})
COTADV->(dbseek(str(VM_CODIG,5),.T.))
keyboard ''
//read
return NIL
