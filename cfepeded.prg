*-----------------------------------------------------------------------------*
static aVariav:= { 0,0,0,''}
 //................1.2.3.4
*-----------------------------------------------------------------------------*
#xtranslate nX				=> aVariav\[  1 \]
#xtranslate nOPC			=> aVariav\[  2 \]
#xtranslate nDesc			=> aVariav\[  3 \]
#xtranslate cColorOld	=> aVariav\[  4 \]
#include 'RCB.CH'
*-----------------------------------------------------------------------------*
	function CFEPEDE5() // Acertos
*-----------------------------------------------------------------------------*
cColorOld:=SetColor()
SubMenu({	{'1.Filtrar Dados'				,'Solicita informacoes para Filtrar os dados da tela'				,{||Acerto1 ()}},;
				{'2.Tipo Docto/Nat.Oper.'		,'Ajustes Automatico de tipo documento (NF) e outros ajustes'	,{||Acerto2 ()}},;
				{'3.Corrige Estoque'				,'Corrige Valor do Estoque pelo preco custo'							,{||Acerto3 ()}},;
				{'4.Trocar Serie'					,'Trocar Serie de Documentos de A --> B'								,{||Acerto41()}},;
				{'5.Ajusta Base ICMS-Itens'	,'Recalcula Bases de ICMS dos Itens da NF'							,{||Acerto42()}},;
				{'6.Ajusta Cod.Pis/Cofins'		,'Ajustar Codigo PIS/Cofins nos Itens da NF'							,{||Acerto43()}},;
				{'7.Ajusta Base ICMS-Cabec'	,'Recalcula Bases de ICMS do Cabecalho da NF'						,{||Acerto44()}}},;
				05,01,'R/W,W/B')
SetColor(cColorOld)
return NIL

*---------------------------------------------------------------------------*
static function ACERTO1()//.................................................1
*---------------------------------------------------------------------------*
pb_box(13,40,,,,'FILTRO-Selecione')
@14,42 say 'Serie........:' get F_SERIE   pict mUUU when pb_msg("Informe Serie BRANCO para mostrar todas")
@15,42 say 'Nr.NF........:' get F_DOCTO   pict mI6
@16,42 say 'Fornec Inical:' get F_FORNEC  pict mI5
@17,42 say 'Fornec Final.:' get F_FORNEX  pict mI5 valid F_FORNEX>=F_FORNEC
@19,42 say 'Data Inicial.:' get F_DATA[1] pict mDT
@20,42 say 'Data Final...:' get F_DATA[2] pict mDT valid F_DATA[2]>=F_DATA[1]
read
if lastkey()#K_ESC
	FILTRO:=''
	if !empty(F_SERIE)
		FILTRO:='EC_SERIE==F_SERIE.and.'
	end
	if F_FORNEC#0.or.F_FORNEX#99999
		FILTRO+='EC_CODFO>=F_FORNEC.and.EC_CODFO<=F_FORNEX.and.'
	end
	if F_DATA[1]#CtoD('').or.F_DATA[2]#CtoD('31/12/2100')
		FILTRO+='EC_DTEMI>=F_DATA[1].and.EC_DTEMI<=F_DATA[2].and.'
	end
	if !empty(F_DOCTO)
		FILTRO+='EC_DOCTO==F_DOCTO.and.'
	end
	pb_msg('Selecionando...')
	FILTRO:=left(FILTRO,len(FILTRO)-5)
	set filter to &FILTRO
else
	set filter to
end
DbGoTop()
keyboard chr(27)
return NIL

*---------------------------------------------------------------------------*
static function ACERTO2()
*---------------------------------------------------------------------------*
if pb_sn('Acerto de TP Docto/Serie/Nat.Operacao').and.FLock()
	pb_msg('Processando Tipo de Documento',nil,.F.)
	DbGoTop()
	dbeval({||ENTCAB->EC_TPDOC:='NF '},{||empty(ENTCAB->EC_TPDOC)})
	
	pb_msg('Processando Serie Documento',nil,.F.)
	DbGoTop()
	dbeval({||ENTCAB->EC_SERIE:='SU '},{||ENTCAB->EC_SERIE$'FUN...NF ...   '})

	pb_msg('Processando Tipo Geracao',nil,.F.)
	DbGoTop()
	dbeval({||ENTCAB->EC_GERAC:='G'},{||ENTCAB->EC_GERAC==' '})

	pb_msg('Processando Nat Operacao/1',nil,.F.)
	DbGoTop()
	dbeval({||ENTCAB->EC_CODOP:=TrNatOper(ENTCAB->EC_CODOP)})

	pb_msg('Processando Nat Operacao/3',nil,.F.)
	DbGoTop()
	dbeval({||ENTCAB->EC_ICMSB:=round(ENTCAB->EC_ICMSV/(ENTCAB->EC_ICMSP/100),2)})

	pb_msg('Processando Cod Tributario',nil,.F.)
	DbGoTop()
	dbeval({||ENTCAB->EC_CODTR:='000'},{||empty(EC_CODTR)})
	select('ENTDET')
	if flock()
		select('ENTCAB')
		DbGoTop()
		while !eof()
			select('ENTDET')
			dbseek(str(ENTCAB->EC_DOCTO,8),.T.)
			while !eof().and.str(ENTCAB->EC_DOCTO,8)==str(ENTDET->ED_DOCTO,8)
				if empty(ENTDET->ED_SERIE)
					if ENTCAB->EC_CODFO == ENTDET->ED_CODFO.and.!empty(ENTCAB->EC_SERIE)
						replace ED_SERIE with ENTCAB->EC_SERIE
						dbseek(str(ENTCAB->EC_DOCTO,8)+' ',.T.)
						loop
					end
				end
				dbskip()
			end
			select('ENTCAB')
			dbskip()
		end
	end
	select('ENTDET')
	unlock
	select('ENTCAB')
	unlock
else
	alert('Arquivo ENTRADAS n„o disponivel exclusivamente...')
end
return NIL

*---------------------------------------------------------------------------*
static function ACERTO3()
*---------------------------------------------------------------------------*
local VLRUNI
local VM_PERA
local VM_PERD
if !pb_sn('Esta rotina corrige o estoque pelo preco de Custo/Entrada;Continuar?')
	return NIL
end
set decim to 6
salvabd(SALVA)
if !abre({'E->PROD'})
	keyboard chr(27)
	return NIL
end
ordem CODIGO

select('ENTCAB')
ordem DTEDOC
DbGoTop()
while !eof()
	@24,60 say EC_DTENT
	VM_PERA:=pb_divzero(EC_ACESS,EC_TOTAL)
	VM_PERD:=pb_divzero(EC_DESC ,EC_TOTAL)
	salvabd(SALVA)
	select('ENTDET')
	dbseek(str(ENTCAB->EC_DOCTO,8),.T.)
	while !eof().and.ENTCAB->EC_DOCTO==ED_DOCTO
		if ENTCAB->EC_CODFO==ED_CODFO
			VLRUNI:=ED_VALOR-ED_VLICM
			VLRUNI+=(ED_VALOR*VM_PERA)	// MAIS PROPORCAO DE DESP ACESSORIAS
			VLRUNI-=(ED_VALOR*VM_PERD)	// MENOS PROPORCAO DE DESCONTOS
			VLRUNI:=pb_divzero(VLRUNI,ED_QTDE) // MEDIO CUSTO
			VLRUNI:=max(VLRUNI,0.01)
			salvabd(SALVA)
			select('PROD')
			if dbseek(str(ENTDET->ED_CODPR,L_P))
				replace PR_VLATU with round(PR_QTATU*VLRUNI,2)
				replace PR_VLCOM with VLRUNI
			end
			salvabd(RESTAURA)
		end
		dbskip()
	end
	salvabd(RESTAURA)
	dbskip()
end
select('PROD')
close
salvabd(RESTAURA)
DbGoTop()
set decim to 
return NIL

*---------------------------------------------------------------------------------------------
static function ACERTO41()
*---------------------------------------------------------------------------------------------
local SERIEA:=EC_SERIE
local SERIEN:=space(3)
pb_box(18,40,,,,'Trocar Serie-Informe')
@19,42 say 'Serie Atual...:' get SERIEA pict mUUU
@20,42 say 'Trocar para...:' get SERIEN pict mUUU valid SERIEN==SCOLD.or.fn_codigo(@SERIEN,{'CTRNF',{||CTRNF->(dbseek(SERIEN))},{||CFEPATNFT(.T.)},{2,1,3,4}})
read
if pb_sn('Processar troca de serie ?').and.(flock())
	pb_msg()
	DbGoTop()
	while !eof()
		if EC_SERIE==SERIEA
			replace EC_SERIE with SERIEN
			select('ENTDET')
			dbseek(str(ENTCAB->EC_DOCTO,8),.T.)
			while !eof().and.ENTCAB->EC_DOCTO==ED_DOCTO
				if reclock()
					replace ED_SERIE with SERIEN
					dbunlock()
				end
				dbskip()
			end
			select('ENTCAB')
		end
		dbskip()
	end
	DbGoTop()
	dbrunlock()
end
return NIL

*---------------------------------------------------------------------------------------------
static function ACERTO42()	//Acerto de Base ICMS - Itens da Nota
*---------------------------------------------------------------------------------------------
local aICMS
local BASE
local pTrib
set decim to 6
ORDEM DOCSER // Doc+Ser+Forn
salvabd(SALVA)
select ENTDET
if pb_sn('Processar Acerto das Bases do ICMS;refente aos Itens da Nota Fiscal?')
	if flock()
		DbGoTop()
		nX:=1
		while !eof()
			ENTCAB->(DbSeek(str(ENTDET->ED_DOCTO,8)+ENTDET->ED_SERIE+str(ENTDET->ED_CODFO,5))) // achar registro pai
			pb_msg('Processando...'+str(ED_DOCTO,8)+' Nr Reg:'+str(nX,6))
			nDesc:=Round(pb_divzero(ENTCAB->EC_DESC,ENTCAB->EC_TOTAL)*ENTDET->ED_VALOR,2) // Desconto Proporcional
			BASE :=ENTDET->ED_VALOR-nDesc // Valor Contábil
			pTrib:=1.00//.............................100% Tributado
			if Right(ENTDET->ED_CODTR,2)=='20' // Tipo 
				pTrib:=pb_divzero(pb_divzero(ENTDET->ED_VLICM*100,ENTDET->ED_PCICM),BASE)
				if str(pTrib,15,4)<str(0,15,4)
					pTrib:=1.00//.......................100% Tributado - há probemas com dados de Vlr ICMS ou % ICMS
				end
			end
			aICMS:=CalcSitTr(ENTDET->ED_CODTR,BASE,ENTDET->ED_PCICM,ENTDET->ED_VLICM,pTrib,ENTDET->ED_IPI)
			replace 	ED_BICMS with aICMS[1],;
						ED_ISENT with aICMS[2],;
						ED_OUTRA with aICMS[3]
			skip
			nX++
		end
	else
		Alert('Arquivo de Entrada Bloqueado por outro usuario;tente mais tarde.')
	end
end
salvabd(RESTAURA)
ORDEM DTEDOC // Dt+Docto
DbGoTop()
set decim to 
return NIL

*---------------------------------------------------------------------------------------------
static function ACERTO43()
*---------------------------------------------------------------------------------------------
nX:=0
if pb_sn('Acerta Codigo PIS-COFINS NF Entrada?;Itens da Nota.')
	salvabd(SALVA)
	select ENTDET
	if ENTDET->(flock())
		go top
		while !eof()
			pb_msg('Processando NF DETALHE...'+str(ENTDET->ED_DOCTO,8)+' Reg Alterado:'+str(nX,6))
			if PROD->(dbseek(str(ENTDET->ED_CODPR,L_P)))
				if ENTDET->ED_CODCOF#PROD->PR_CODCOE
					replace ENTDET->ED_CODCOF with PROD->PR_CODCOE
					nX++
				end
			end
			skip
		end
	else
		Alert('Arquivo de Entrada Bloqueado por outro usuario;tente mais tarde.')
	end
	dbrunlock()
	salvabd(RESTAURA)
end
go top
return NIL

*---------------------------------------------------------------------------------------------
static function ACERTO44()
*---------------------------------------------------------------------------------------------
if pb_sn('Atualiar Base ICMS-Cabecalho ?')
	if flock()
		DbGoTop()
		while !eof()
			pb_msg('Processando..'+str(ENTCAB->EC_DOCTO,8)+'/'+ENTCAB->EC_SERIE)
			VL_BASE:=0
			select('ENTDET')
			dbseek(str(ENTCAB->EC_DOCTO,8)+ENTCAB->EC_SERIE,.T.)
			while !eof().and.	ENTDET->ED_DOCTO==ENTCAB->EC_DOCTO.and.;
									ENTDET->ED_SERIE==ENTCAB->EC_SERIE
				if ENTDET->ED_CODFO==ENTCAB->EC_CODFO //---------------------------------Cod Fornecedor
					VL_BASE+=ED_BICMS
				end
				dbskip()
			end
			select('ENTCAB')
			replace EC_ICMSB with VL_BASE
			dbskip()
		end
		DbGoTop()
		dbrunlock()
	else
		Alert('Arquivo de Entrada Bloqueado por outro usuario;tente mais tarde.')		
	end
end
return NIL


*---------------------------------------------------------------------------------------------
