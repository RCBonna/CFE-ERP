//-----------------------------------------------------------------------------*
  static aVariav := {0,'','',{},0}
//...................1..2.3..4.,5
//-----------------------------------------------------------------------------*
#xtranslate nX			=> aVariav\[  1 \]
#xtranslate nY			=> aVariav\[  2 \]
#xtranslate dDataT	=> aVariav\[  3 \]
#xtranslate aBASES	=> aVariav\[  4 \]
#xtranslate nBASE		=> aVariav\[  5 \]

*-----------------------------------------------------------------------------*
function CFEPEDPC()	//	Edita Saidas de NF												*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

if !abre({	'C->PARAMETRO',;
				'C->TABICMS',	;
				'C->BANCO',		;
				'R->CODTR',		;
				'C->PEDDET',	;
				'C->PEDCAB',	;
				'C->NATOP',		;
				'R->PROD',		;
				'C->FISACOF',;
				'C->CTRNF',		;
				'C->PARALINH',	;
				'C->PEDSVC',	;
				'C->CLIOBS',	;
				'C->CLIENTE'})
	return NIL
end
private F_SERIE :=space(3)
private F_FORNEC:=0
private F_FORNEX:=99999
private F_NF    :=0
private F_DATA  :={CtoD(''),CtoD('31/12/2100')}
private FILTRO  :=''

PROD->(dbsetorder(2))
pb_tela()
pb_lin4(_MSG_,ProcName())

select('PEDCAB')
ORDEM NNFSER
 // Entrada  Cabec / index DTEMI+NF ;dbsetorder(6)
set relation to str(PC_CODCL,5) into CLIENTE
DbGoTop()
//set key K_ALT_A to LIXOX()
//set key K_ALT_B to LIXOY()
//set key K_ALT_C to LIXOZ()
set key K_ALT_X   to KillDetZero()
//set key K_ALT_Y   to COPIAR2010()
set key K_ALT_A   to AcertoS6()
select('PEDCAB')
ORDEM NNFSER

pb_dbedit1('CFEPEDP','IncluiAlteraPesqu.ExcluiACERTO')  // tela
dbedit(06,01,maxrow()-3,maxcol()-1,;
		{'PC_DTEMI','PC_NRNF' ,'PC_SERIE','pb_zer(PC_CODCL,5)+chr(45)+left(CLIENTE->CL_RAZAO,20)','PC_CODOP','PC_TOTAL',   'PC_DESC','PC_NRDPL' },;
		'PB_DBEDIT2'                                                                                                                  ,;
		{       mDT,   masc(19),  masc(1),                                               masc(23),      mNAT,  masc(2),      masc(2),  masc(16) },;
		{  'Emiss„o', 'Nr NF',     'Serie','Cliente',                                               'Nat.OP','Valor Total','Vlr Desc','Duplicata'})
dbcloseall()

	set key K_ALT_A to
	set key K_ALT_B to
	set key K_ALT_C to
	set key K_ALT_X to
	set key K_ALT_Y to

return NIL

*-----------------------------------------------------------------------------*
function CFEPEDP1() // Inclusao
*-----------------------------------------------------------------------------*
	dbgobottom()
	dbskip()
	CFEPEDPCT(.T.)
return NIL

*-----------------------------------------------------------------------------*
function CFEPEDP2()	// Alteracao
*-----------------------------------------------------------------------------*
if reclock()
	CFEPEDPCT(.F.)
end
dbrunlock()
return NIL

*-----------------------------------------------------------------------------*
function CFEPEDP3() // Pesquisa 
*-----------------------------------------------------------------------------*
local VM_DTEMI:=PC_DTEMI
local VM_NRNF :=PC_NRNF

ORDEM NNFSER
DbGoTop()
pb_box(19,40)
//@20,42 say 'Informe Data Emiss„o :' get VM_DTEMI pict masc(08)

@21,42 say 'N£mero da Nota Fiscal:' get VM_NRNF  pict masc(19)
read
dbseek(str(VM_NRNF,6),.T.)
//dbsetorder(6) // Entrada  Cabec / index DTEMI+NF

return NIL

*-----------------------------------------------------------------------------*
function CFEPEDP4() // Exclusao
*-----------------------------------------------------------------------------*
if RecLock().and.pb_sn('Excluir NF : '+dtoc(PC_DTEMI)+' NrNF '+pb_zer(PC_NRNF,6)+'/'+PC_SERIE+' ?')
	if pb_sn('Este documento foi gerado no Faturamento.;Remover tudos os registros/Produtos desta NF ?')
		nX:=0
		pb_msg('Verificando registros detalhes 1/2 '+str(PEDCAB->PC_PEDID,6))
		select('PEDDET')
		dbseek(str(PEDCAB->PC_PEDID,6),.T.)
		while !eof().and.PEDCAB->PC_PEDID==PEDDET->PD_PEDID
			pb_msg('Eliminando Reg.'+str(recno(),6)+' do PedidoP:'+str(PEDCAB->PC_PEDID,6)+'/'+str(PEDDET->PD_PEDID,6)+'/'+str(nX,6))
			if RecLock(100)
				delete
				dbrunlock()
				nX++
			end
			skip
		end

		pb_msg('Verificando registros detalhes 2/2 '+str(PEDCAB->PC_PEDID,6))
		select('PEDSVC')
		dbseek(str(PEDCAB->PC_PEDID,6),.T.)
		while !eof().and.PEDCAB->PC_PEDID==PEDSVC->PS_PEDID
			pb_msg('Eliminando Reg.'+str(recno(),6)+' do PedidoS:'+str(PEDCAB->PC_PEDID,6)+'/'+str(PEDSVC->PS_PEDID,6)+'/'+str(nX,6))
			if RecLock(100)
				delete
				dbrunlock()
				nX++
			end
			skip
		end
		select('PEDCAB')
		fn_elimi()
	end
end
dbrunlock()
go top
return NIL

*-----------------------------------------------------------------------------*
function CFEPEDP5() // Acerto Serie
*-----------------------------------------------------------------------------*
cColorOld:=SetColor()
SubMenu({	{'1.Filtrar Dados'				,'Solicita informacoes para Filtrar os dados da tela'				,{||AcertoS1()}},;
				{'2.Trocar Serie'					,'Trocar Serie de Documentos de A --> B'								,{||AcertoS2()}},;
				{'3.Tipo Docto/Nat.Oper.'		,'Ajustes Automatico de tipo documento (NF) e outros ajustes'	,{||AcertoS3()}},;
				{'4.Ajusta Base ICMS-Itens'	,'Recalcula Bases de ICMS dos Itens da NF'							,{||Acertos4()}},;
				{'5.Ajusta Cod.Pis/Cofins'		,'Ajustar Codigo PIS/Cofins nos Itens da NF'							,{||AcertoS5()}},;
				{'6.Ajusta Vlr Med Un->Tot.'	,'Ajustar Vlr Unitario Medio para Vlr Medio Total'					,{||AcertoS6()}}},;
				05,01,'R/W,W/B')
SetColor(cColorOld)

*-----------------------------------------------------------------------------*
	static function AcertoS1() // Filtro da base de dados
*-----------------------------------------------------------------------------*
pb_box(13,40,,,,'Filtro-Selecione')
@14,42 say 'Serie..........:' get F_SERIE  pict mUUU
@15,42 say 'Nr NF..........:' get F_NF     pict mI6
@16,42 say 'Cliente.Inicial:' get F_FORNEC pict mI5
@17,42 say 'Cliente.Final..:' get F_FORNEX pict mI5 valid F_FORNEX>=F_FORNEC
@19,42 say 'Data Inicial...:' get F_DATA[1] pict mDT
@20,42 say 'Data Final.....:' get F_DATA[2] pict mDT valid F_DATA[2]>=F_DATA[1]
read
if lastkey()#K_ESC
	FILTRO:=''
	if !empty(F_SERIE)
		FILTRO:='PC_SERIE==F_SERIE.and.'
	end
	if F_FORNEC#0.or.F_FORNEX#99999
		FILTRO+='PC_CODCL>=F_FORNEC.and.PC_CODCL<=F_FORNEX.and.'
	end
	if F_DATA[1]#CtoD('').or.F_DATA[2]#CtoD('31/12/2100')
		FILTRO+='PC_DTEMI>=F_DATA[1].and.PC_DTEMI<=F_DATA[2].and.'
	end
	if !empty(F_NF)
		FILTRO+='PC_NRNF==F_NF.and.'
	end
	pb_msg()
	FILTRO:=left(FILTRO,len(FILTRO)-5)
	set filter to &FILTRO
else
	set filter to
end
DbGoTop()
keyboard chr(27)
return NIL

*-----------------------------------------------------------------------------*
	static function AcertoS2() // Acerto Serie
*-----------------------------------------------------------------------------*
local SERIEA:=PC_SERIE
local SERIEN:=space(3)
nX:=1
pb_box(18,20,,,,'Selecione')
@20,22 say 'Serie Anterior:'  get SERIEA pict mUUU
@21,22 say 'Trocar para...:'  get SERIEN pict mUUU valid SERIEN==SCOLD.or.fn_codigo(@SERIEN,{'CTRNF',{||CTRNF->(dbseek(SERIEN))},{||CFEPATNFT(.T.)},{2,1,3,4}})
read
if pb_sn('CUIDADO AO TROCAR A SERIE;Trocar serie de todos os documentos ?').and.flock()
	pb_msg('Aguarde... Tocando serie das NFs')
	DbGoTop()
	while !eof()
		if PC_SERIE==SERIEA
			@24,50 say 'Nr.Registros Alterados:'+Str(nX++,6)
			replace PC_SERIE with SERIEN
		end
		dbskip()
	end
	DbGoTop()
	dbUnlockAll()
	Alert('Alteracao Serie concluida.')
end
return NIL
	
*-----------------------------------------------------------------------------*
	static function AcertoS3() // Acerto Geral dvs Campos
*-----------------------------------------------------------------------------*
if pb_sn('Processar alteracoes basicas na base de dados?')
		select PEDCAB 
	if Flock()
		pb_msg('Processando Serie Documento - Branco para SU',nil,.F.)
		dbeval({||PEDCAB->PC_SERIE:='U  '},{||empty(PEDCAB->PC_SERIE)})

		pb_msg('Processando Nat Operacao/1',nil,.F.)
		dbeval({||PEDCAB->PC_CODOP:=TrNatOper(PEDCAB->PC_CODOP)})
		dbUnlockAll()
	else
		alert('Arquivo Cabec.SAIDAS n„o disponivel exclusivamente...')
	end
	if PEDDET->(flock()).and.PEDSVC->(flock())
		pb_msg('Verificando se Detalhes Existem no Cabecalho da NF...',nil,.F.)
		select PEDCAB 
		dbsetorder(1) // Saida  Cabec / index DTEMI+NF
		select PEDDET
		DbGoTop()
		while !eof()
			if !PEDCAB->(dbseek(str(PEDDET->PD_PEDID,6)))
				delete
			end
			dbskip()
		end
		select PEDCAB 
		dbsetorder(6) // Saida  Cabec / index DTEMI+NF
		DbGoTop()
		pb_msg('Processando ajuste de Desconto nos Itens...',nil,.F.)
		dbeval({||GravaDes(PEDCAB->PC_PEDID,PEDCAB->PC_TOTAL,PEDCAB->PC_DESC)})
		dbUnlockAll()
		Alert('Alteracao Dados Gerais da NF concluida.')
	else
		alert('Arquivo Det.SAIDAS n„o disponivel exclusivamente...')
	end
else
	alert('Arquivo ENTRADAS n„o disponivel exclusivamente...')
end
return NIL

*-----------------------------------------------------------------------------*
	static function AcertoS4() // Acerto Base ICMS - Detalhes NF Saida
*-----------------------------------------------------------------------------*
if pb_sn('Corrige Base de ICMS Detalhes da Base de Saida?')
	if PEDDET->(flock()).and.PEDSVC->(flock())
		pb_msg('Acertando BASE ICMS NF Saidas...',nil,.F.)
		select PEDCAB
		DbGoTop()
		while !eof()
			select PEDDET
			DbGoTop()
			dbseek(str(PEDCAB->PC_PEDID,6),.T.)
			@24,70 say str(PEDCAB->PC_PEDID,9)
			while !eof().and.PEDCAB->PC_PEDID==PD_PEDID
				CalcBase() // GRAVA BASES DETALHES
				dbskip()
			end
			select PEDCAB
			skip
		end
		dbUnlockAll()
		Alert('Correcao da Base de ICMS dos Itens da NF concluida.')
	else
		Alert('Arquivos de Saidas em uso - nao podem ser bloqueados;tente mais tarde.')
	end
end
return NIL

*---------------------------------------------------------------------------------------*
	static function AcertoS5() // Acerto Codigo PIS/COFINS Itens Saida pelo Arq. PRODUTO
*---------------------------------------------------------------------------------------*
if pb_sn('Atualiza Cod.PIS/COFINS dos Itens;pelo Cadastro de Produto?')
	if PEDDET->(flock())
		nX:=0
		select PEDDET
		DbGoTop()
		while !eof()
			pb_msg('Det.Nr.Pedido:'+str(PEDDET->PD_PEDID,6)+' - Reg.Alterados:'+str(nX,6))
			if PROD->(dbseek(str(PEDDET->PD_CODPR,L_P)))
				if PEDDET->PD_CODCOF # PROD->PR_CODCOS
					replace PEDDET->PD_CODCOF with PROD->PR_CODCOS
					nX++
				end
			end
			skip
		end
		dbUnlockAll()
		select PEDCAB
		DbGoTop()
		Alert('Correcao da Codigo PIS/Cofins da Base dos Itens da NF concluida.')
		
	else
		Alert('Arquivos de Saidas em uso - nao podem ser bloqueados;tente mais tarde.')
	end
end
return NIL


*-----------------------------------------------------------------------------------------*
	static function AcertoS6() // Atualiza Vlr Unitário Médio para Valor Médio Total
*-----------------------------------------------------------------------------------------*
alert('ATENCAO;Este programa NAO pode ser executado mais de uma vez')

if pb_sn('Atualiza Vlr Medio Unitario->Total?')
	nX:=1
	select PEDCAB
	DbGoTop()
	while !eof()
		if DtoS(PEDCAB->PC_DTEMI)<'20150821' // só fazer isso antes de 20/08/15
			select PEDDET
			dbseek(str(PEDCAB->PC_PEDID,6),.T.)
			while !eof().and.PEDCAB->PC_PEDID==PEDDET->PD_PEDID
				pb_msg('Processando Nr.Pedido:'+str(PEDDET->PD_PEDID,6)+' - Reg.Alterados:'+str(nX,6))
				if RecLock()
					if PEDDET->PD_VLRMD>0
						replace PEDDET->PD_VLRMD with PEDDET->PD_VLRMD*PEDDET->PD_QTDE  // Médio Total
					else // Zero
						replace PEDDET->PD_VLRMD with PEDDET->PD_VALOR*PEDDET->PD_QTDE
					end
					nX++
					dbrunlock()
				end
				skip
			end
		end
		select PEDCAB
		skip
	end
	dbUnlockAll()
	Alert('Correcao da Valor Medio Venda (Unitario-->Total);Concluida.')
//	MemoWrit('C:\temp\conversao.csv',Lista)
end
return NIL

*-----------------------------------------------------------------------------------------*
	static function AcertoS7() // Unificar Arquivos já Convertidos
*-----------------------------------------------------------------------------------------*
alert('ACERTO;Unificacao arquivos com valores medios')
if !file('C:\TEMP\CFEAPD20150820.DBF')
	alert('Arquivo:;C:\TEMP\CFEAPD20150820.DBF;nao encontrado!')
	return NIL
end
if pb_sn('Atualizar Arquivo de Pedidos?')
	use C:\TEMP\CFEAPD20150820 new READONLY alias WORK
	nX:=1
	select WORK
	DbGoTop()
	while !eof()
		select PEDDET
		if dbseek(str(WORK->PD_PEDID,6)+str(WORK->PD_ORDEM,2))
			pb_msg('Processando Nr.Pedido:'+str(PEDDET->PD_PEDID,6)+' - Reg.Alterados:'+str(nX,6))
			if RecLock()
				replace PEDDET->PD_VLRMD with WORK->PD_VLRMD  // Médio Total
				nX++
				dbrunlock()
			end
		end
		select WORK
		skip
	end
	dbUnlockAll()
	close
	select PEDCAB
	DbGoTop()
	Alert('Atualizacao do Arquivo recuperado;Concluida.')
end
return NIL

*---------------------------------------------------------
  static function CalcBase()
*---------------------------------------------------------
PROD->(dbseek(str(PEDDET->PD_CODPR,L_P)))
nTrib:=if(PD_PTRIB==0,100,PD_PTRIB)/100
nBASE :=Trunca(max((PD_VALOR*PD_QTDE)-PD_DESCV+PD_ENCFI-PD_DESCG,0),2)
aBASES:=CalcSitTr(PEDDET->PD_CODTR,nBASE,PEDDET->PD_ICMSP,PEDDET->PD_VLICM,nTrib,0)

replace  PD_BAICM  with trunca(aBASES[1],2),;
			PD_VLRIS  with trunca(aBASES[2],2),;
			PD_VLROU  with trunca(aBASES[3],2),;
			PD_VLITEM with nBASE,;
			PD_PTRIB  with nTrib*100

return (PD_BAICM+PD_VLRIS+PD_VLROU)

//------------------------------------------------------------------------------------
  static function GRAVADES(P1,   P2,   P3)
//.........................PEDID,TOTAL,DESCON
//------------------------------------------------------------------------------------
local REGISTROS:={}
local SODESG:=0.00
local VLRLIQ:=0.00
local MAIOR :=0.00
local INDIC :=0
local PERDES:=pb_divzero(P3,P2)
@24,70 say P1
salvabd(SALVA)
if !PEDCAB->PC_FLSVC
	select('PEDDET')
	dbseek(str(P1,6),.T.)
	while !eof().and.P1==PEDDET->PD_PEDID
		VLRLIQ:=trunca(PD_VALOR*PD_QTDE,2)-PD_DESCV
		aadd(REGISTROS,{recno(),trunca(VLRLIQ*PERDES),VLRLIQ})
		SODESG+=REGISTROS[len(REGISTROS),2]
		if VLRLIQ>MAIOR
			MAIOR:=VLRLIQ
			INDIC:=len(REGISTROS)
		end
		dbskip()
	end
	if INDIC>0
		REGISTROS[INDIC,2]+=(P3-SODESG) // colocar diferenca no maior
	end
	for INDIC:=1 to len(REGISTROS)
		DbGoTo(REGISTROS[INDIC,1])
		VLRLIQ:=REGISTROS[INDIC,3]-REGISTROS[INDIC,2]
		if PD_ICMSP=0.00
			VLRLIQ:=0.00
		end
		replace 	PD_DESCG with REGISTROS[INDIC,2],;
					PD_BAICM with round(VLRLIQ*PD_PTRIB/100,2)
		dbskip(0)
	end
else//---------------------------PROCESSA SERVICOS
	select('PEDSVC')
	dbseek(str(P1,6),.T.)
	while !eof().and.P1==PEDSVC->PS_PEDID
		VLRLIQ:=(PS_VALOR*PS_QTDE)-PS_DESCV
		aadd(REGISTROS,{recno(),trunca(VLRLIQ*PERDES),VLRLIQ})
		SODESG+=REGISTROS[len(REGISTROS),2]
		if VLRLIQ>MAIOR
			MAIOR:=VLRLIQ
			INDIC:=len(REGISTROS)
		end
		dbskip()
	end
	if INDIC>0
		REGISTROS[INDIC,2]+=(P3-SODESG) // colocar diferenca no maior
	end
	for INDIC:=1 to len(REGISTROS)
		DbGoTo(REGISTROS[INDIC,1])
		VLRLIQ:=REGISTROS[INDIC,3]-REGISTROS[INDIC,2]
		if PS_ICMSP=0.00
			VLRLIQ:=0.00
		end
		replace 	PS_DESCG with REGISTROS[INDIC,2],;
					PS_BAICM with round(VLRLIQ*PS_PTRIB/100,2)
		dbskip(0)
	end
end

salvabd(RESTAURA)
release REGISTROS
return NIL

//------------------------------------------------------------------------------------
  static function LIXOX()
//------------------------------------------------------------------------------------
local X,Y,Z,NF1,VL1,DT1
local OPC:=alert('NF COM PROBLEMA DE NR PEDIDO;Selecione...',{'Listar','Imprimir'})
if OPC==2
	pb_ligaimp()
	?'LISTA DAS NOTAS FISCAIS COM PROBLEMA DE NUMERO DE PEDIDO'
	?
	?
else
	clear
end
select('PEDCAB');dbsetorder(1) // pedido
DbGoTop()
while !eof()
	X  :=PC_PEDID
	Y  :=.T.
	Z  :=.T.
	NF1:=0
	while !eof().and.X==PC_PEDID
		if Y
			Y:=.F.
			NF1:=PC_NRNF
			SE1:=PC_SERIE
			DT1:=PC_DTEMI
			VL1:=PC_TOTAL
		else
			if Z
				?'Pedido '+str(X,6)+' Dupl NF1:='+str(NF1,6)+' serie :'+SE1+' Data:'+dtoc(DT1)+'Vlr:'+str(VL1,10,2)
				Z:=.F.
			end
			?space(19)+'NF :='+str(PC_NRNF)+' serie :'+PC_SERIE+' Data:'+dtoc(PC_DTEMI)+'Vlr:'+str(PC_TOTAL,10,2)
			if OPC#2
				if row()>22
					pb_msg('Press Enter',0)
					clear
				end
			end
		end
		dbskip()
	end
end
if OPC==2
	pb_deslimp()
else
	pb_msg('Press Enter',0)
end
select('PEDCAB');dbsetorder(6) // Entrada  Cabec / index DTEMI+NF
DbGoTop()
return NIL

//------------------------------------------------------------------------------------
  static function LIXOY()
//------------------------------------------------------------------------------------
local NOTA
local CONTA,REGI,REGA
local OPC:=alert('NF COM NUMEROS DUPLICADOS;Selecione...',{'Listar','Imprimir'})
if OPC=0
	return NIL
elseif OPC==2
	pb_ligaimp()
elseif OPC==1
	clear
end
select('PEDCAB')
ordem NNFSER // NF + SERIE
DbGoTop()
while !eof()
	NOTA :=PC_NRNF
	SERIE:=PC_SERIE
	CONTA:=0
	REGI:=recno()
	while !eof().and.NOTA==PC_NRNF.and.SERIE==PC_SERIE
		CONTA++
		if CONTA>1
			if CONTA==2
				REGA:=recno()
				DbGoTo(REGI)
				?
				? "---NF: "+pb_zer(PC_NRNF,6)
				??" serie "+PC_SERIE
				??" data "+dtoc(PC_DTEMI)
				??' Vlr:'+str(PC_TOTAL,10,2)
				DbGoTo(REGA)
			end
			? "    -------->"
			??" serie "+PC_SERIE
			??" data "+dtoc(PC_DTEMI)
			??' Vlr: '+str(PC_TOTAL,10,2)
		end
		pb_brake()
	end
end
if OPC==2
	pb_deslimp()
end
select('PEDCAB');dbsetorder(6) // Entrada  Cabec / index DTEMI+NF
DbGoTop()
return NIL

//------------------------------------------------------------------------------------
  static function LIXOZ()
//------------------------------------------------------------------------------------
local X
local Y
local Z
local vBase

local OPC:=alert('NF COM PROBLEMA DE BASE ICMS;Selecione...',{'Listar','Imprimir'})
if OPC==2
	pb_ligaimp()
	?'LISTA DAS NOTAS FISCAIS COM PROBLEMA DE BASE ICMS'
	?
	?
else
	clear
end
select('PEDCAB');dbsetorder(6) // pedido
DbGoTop()

while !eof()
	if PC_DTEMI>CTOD("31/12/2003")
		X    :=PEDCAB->PC_PEDID
		Z    :=PEDCAB->PC_TOTAL-PEDCAB->PC_DESC
		vBase:={0,0,0,0,0}
		
		NATOP->(dbseek(str(PEDCAB->PC_CODOP,7)))
		if NATOP->NO_TIPO == 'S' //...........Saidas
			select PEDDET
			dbseek(str(X,6))
			@24,70 say str(X,6)
			while !eof().and.X==PD_PEDID
				@24,76 say '-'+str(pd_ordem,2)
				vBase[4]+=PD_BAICM+PD_VLRIS+PD_VLROU
				vBase[1]+=PD_BAICM
				vBase[2]+=PD_VLRIS
				vBase[3]+=PD_VLROU
				vBase[5]+=PD_VLITEM
				skip
			end
		else
			// servico
			select PEDSVC
			dbseek(str(X,6))
			@24,60 say str(X,6)
			while !eof().and.X==PS_PEDID
				@24,66 say '-'+str(PS_ORDEM,2)
				vBase[4]+=PS_BAICM+PS_VLRIS+PS_VLROU
				vBase[1]+=PS_BAICM
				vBase[2]+=PS_VLRIS
				vBase[3]+=PS_VLROU
				vBase[5]+=PS_VLITEM
				skip
			end
		end
		if !(str(vBase[4]-Z,15,2)==str(0,15,2))
			? STR(PEDCAB->PC_PEDID,6)+" NF:"+STR(PEDCAB->PC_NRNF,6)+" Ser:"+PEDCAB->PC_SERIE
			??" Dt="+dtoc(PEDCAB->PC_DTEMI)+" TOT NF="+STR(Z,10,2)
			??" = "
			??(str(vBase[4]-Z,15,2)==str(0,15,2))
			??" ="
			??" DTOT=" +str(vBase[4],10,2)
			??" BICM=" +str(vBase[1],10,2)
			??" ISEN=" +str(vBase[2],10,2)
			??" OUTR=" +str(vBase[3],10,2)
			??" TotIT="+str(vBase[5],10,2)+"*"
			??(str(vBase[5]-Z,15,2)==str(0,15,2))
			??' NatOp='+NATOP->NO_TIPO
			??'/'+str(PEDCAB->PC_CODOP,7)
		end
		select PEDCAB
	end
	dbskip()
end
if OPC==2
	pb_deslimp()
else
	pb_msg('Press Enter',0)
end
select('PEDCAB');dbsetorder(6) // Entrada  Cabec / index DTEMI+NF
DbGoTop()
return NIL

*------------------------------------------------------------------------------------
  static function COPIAR2010()	// TRANSFERIR
*------------------------------------------------------------------------------------
local OPC:=alert('Transferir dados dos PEDIDOS;Dez/2010 para ..\CFE2010...',{'Sair','Iniciar'})
nX:={0,0}
dDataT:={ctod('01/12/2010'),;
			ctod('31/12/2010')}
if OPC==2
	if file('..\CFE2010\CFEAPC.DBF').and.file('..\CFE2010\CFEAPD.DBF').and.; // EXISTEM ARQUIVOS PARA RECEBER A TRANSFERENCIA
		file('..\CFE2010\CFEAPC.NSX').and.file('..\CFE2010\CFEAPD.NSX')
		
		if !net_use('..\CFE2010\CFEAPC',.T., ,'CFE_PC', ,.F.,'SIXNSX')
			pb_msg('Arquivo ..\CFE2010\CFEAPC n„o pode ser aberto.',3,.T.)
			return NIL
		end
		dbsetindex('..\CFE2010\CFEAPC')

		if !net_use('..\CFE2010\CFEAPD',.T., ,'CFE_PD', ,.F.,'SIXNSX')
			pb_msg('Arquivo ..\CFE2010\CFEAPD n„o pode ser aberto.',3,.T.)
			return NIL
		end
		dbsetindex('..\CFE2010\CFEAPD')
		
		alert('Iniciar Eliminar Dados..\CFE2010\CFEAPD;'+dtos(dDataT[1])+' ate '+dtos(dDataT[2]))
		pb_msg('Eliminando registros...')
		select CFE_PC
		SET ORDER TO 4 // DATA + PEDIDO
		dbseek(dtos(dDataT[1]),.T.)
		while !eof().and.dtos(CFE_PC->PC_DTEMI)>=dtos(dDataT[1]).and.dtos(CFE_PC->PC_DTEMI)<=dtos(dDataT[2])
			select CFE_PD
			dbseek(str(CFE_PC->PC_PEDID,6),.T.)
			while !eof().and.str(PD_PEDID,6)==str(CFE_PC->PC_PEDID,6)
				delete
				nX[2]++
				@24,60 say 'NFD'+str(nX[2],6)
				skip
			end
			select CFE_PC
			delete
			nX[1]++
			@24,50 say 'NFC'+str(nX[1],6)
			skip
		end
		
		nX:={0,0}
		alert('Iniciar Transfer Dados ..\CFE2010\CFEAPD')
		pb_msg('Transferindo registros...')
		select PEDCAB
		ORDEM DTEPED
		go top
		dbseek(dtos(dDataT[1]),.T.)
		while !eof().and.dtos(PEDCAB->PC_DTEMI)>=dtos(dDataT[1]).and.dtos(PEDCAB->PC_DTEMI)<=dtos(dDataT[2])
			@24,0 say 'ProcReg1'+str(RECNO(),6)
			select CFE_PC
			APPEND BLANK
			for nY:=1 to fCount()
				FieldPut(nY,PEDCAB->(FieldGet(nY)))
			next
			nX[1]++
			@24,50 say 'Tr.NFC'+str(nX[1],6)

			select PEDDET
			dbseek(str(PEDCAB->PC_PEDID,6),.T.)
			while !eof().and.str(PD_PEDID,6)==str(PEDCAB->PC_PEDID,6)
				@24,15 say 'ProcReg2'+str(RECNO(),6)
				select CFE_PD
				APPEND BLANK
				for nY:=1 to fCount()
					FieldPut(nY,PEDDET->(FieldGet(nY)))
				next
				select PEDDET
				skip
				nX[2]++
				@24,65 say 'Tr.NFD'+str(nX[2],6)
			end
			select PEDCAB
			skip
		end
		alert('Transferencia Concluida')
		keyboard('0')
	else
		alert('Arquivos destinos em ..\CFE2010 de pedidos nao encontrados')
	end
end
go top
return NIL

*------------------------------------------------------------------------------------
  static function KillDetZero()	// Eliminar detalhe zerado
*------------------------------------------------------------------------------------
local OPC:=alert('Eliminar REG DET Zerado?',{'Sair','Iniciar'})
if OPC==2
	dbcloseall()
	if !net_use('CFEAPD',.T., ,'CFE_PD', ,.F.,'SIXNSX')
		keyboard '0'
	end
	pb_msg('Eliminando DET Reg Zerado')
	nX:={0,0}
	while !eof()
		nX[1]++
		@24,02 say 'Reg.Proc:'+str(nX[1],7)
		if PD_PEDID==0
			delete
			nX[2]++
			@24,60 say 'Reg.Elin:'+str(nX[2],7)
		end
		skip
	end
	if nX[2]>0
		FileDelete('CFEAPD'+OrdBagExt())
	end
	close
	alert('CFE saira automaticamente - favor reiniciar')
	quit
end
return NIL
*------------------------------EOF---------------------------------------------------*
