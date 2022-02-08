*-----------------------------------------------------------------------------*
 static aVariav := {'','','','','',0,'',0,0}
 //.................1...2...3.4..5.6..7.8.9
*-----------------------------------------------------------------------------*
#xtranslate aLinDet		=> aVariav\[  1 \]
#xtranslate aTipDoc		=> aVariav\[  2 \]
#xtranslate cArq			=> aVariav\[  3 \]
#xtranslate TipoMov		=> aVariav\[  4 \]
#xtranslate ArqMovS		=> aVariav\[  5 \]
#xtranslate Opc			=> aVariav\[  6 \]
#xtranslate ArqNSX		=> aVariav\[  7 \]
#xtranslate nX				=> aVariav\[  8 \]
#xtranslate NRLOTE		=> aVariav\[  9 \]

*-----------------------------------------------------------------------------*
  function CTBPIDIA(P1) // Virada Diaria Contabil										*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
#include 'hbsix.ch'

private cFiltro := '*'+space(19)

P1     :=if(P1==NIL,'M',P1)
TipoMov:=P1
ArqNSX :=''
ArqMovS:=''
pb_lin4(_MSG_,ProcName())
if !abre({	;	// 'C->LCTODIR',;
				'C->CTRLOTE'	,;
				'C->PARAMETRO'	,;
				'C->RAZAO'		,;
				'C->PARAMCTB'	,;
				'C->CTADET'		,;
				'C->DIARIO'		})
	return NIL
end
if P1#"M" //...............Filial
	if SelDiario()==0 //....Seleção de arquivo de transferencia
		dbcloseall()
		return NIL
	end
end
pb_msg()
aTipDoc:={cFiltro}
DbGoTop()
while !eof()
	if ascan(aTipDoc,DIARIO->DI_DOCTO) = 0
		aadd( aTipDoc,DIARIO->DI_DOCTO)
	end
	skip
end
aTipDoc = Asort(aTipDoc)
pb_box(20,28,,,,'Informe Filtro ('+P1+')')
@21,30 say 'Informe um Filtro..:' get cFiltro valid fn_CodArM(@cFiltro,aTipDoc) pict mUUU when pb_msg('* para todos os registros')
read
if lastkey()#K_ESC
	pb_msg('Diretorio de trabalho = '+diskName()+':'+DirName(),2)
	cArq:=''
	if trim(cFiltro)=='*'
		set filter to
	else
		cArq:=ArqTemp(,,'')
		pb_lin4(_MSG_+' - Filtro: '+trim(cFiltro),ProcName())
		pb_msg('Selecionando registros do filtro '+trim(cFiltro))
		Index on dtos(DI_DATA)+str(DI_CONTA,4) tag DATA2 to (cArq) for DI_DOCTO==cFiltro additive Temporary
	end
	go top
	ATU_DIARIO()
	set filter to
	go top
	pb_msg('')
	if TipoMov=='F'
		Pack
		if LastRec()==0
			dbcloseall()
			FileDelete(ArqMovS+'.*')
		end
	end
end
dbcloseall()
if !empty(cArq)
	FileDelete (cArq+'.*') // Eliminar arquivo temporário de indice...
end
if !empty(ArqNSX)
	FileDelete (ArqNSX+'.*') // Eliminar arquivo temporário de indice...
end
return NIL

*------------------------------------------------------------------*
	static function ATU_DIARIO()
*------------------------------------------------------------------
if LastRec()>0
	DbSetRelation(	'CTADET',{||str(DIARIO->DI_CONTA,4)})
	VM_CAMPO:={		'DI_DATA',;
						'pb_zer(DI_CONTA,4)+chr(45)+CTADET->CD_DESCR',;
						'FN_DBCR(DI_VALOR)',;
						'DI_HISTOR',;
						'DI_DOCTO'}

	pb_box(05,00,maxrow()-2,maxcol(),'W+/B')
	pb_dbedit1('CTBPIDI','IncluiAlteraExcluiIntegrLista Outros')
	dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,"PB_DBEDIT2",;
								{ mDT	 , mUUU  , mUUU				 , mXXX		 , mUUU			},;
								{'Data','Conta','Valor Lancamento','Hist¢rico','Documentos'	})
	DbClearRelation()
else
	alert('Sem dados para integrar na contabilidade')
end
return NIL

*------------------------------------------------------------------
  function CTBPIDI1()	// Incluir lancamentos
*------------------------------------------------------------------
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	CTBPIDIT(.T.)
end
return NIL

*------------------------------------------------------------------
	function CTBPIDI2()	// Alterar lancamentos
*------------------------------------------------------------------
if reclock()
	CTBPIDIT(.F.)
	dbskip()
end
return NIL

*------------------------------------------------------------------
	function CTBPIDI6()	// Ajuste lancamentos
*------------------------------------------------------------------
private TEXTO1:=space(30)
private TEXTO2:=space(30)
pb_box(17,28,,,,'Trocar textos dos Historicos')
@20,30 say 'Trocar..:' get TEXTO1   pict masc(23)
@21,30 say 'Por.....:' get TEXTO2   pict masc(23)
read
if lastkey()#K_ESC
	pb_msg()
	DbGoTop()
	while !eof()
		if reclock()
			replace DIARIO->DI_HISTOR with strtran(DI_HISTOR,trim(TEXTO1),trim(TEXTO2))
			dbunlockall()
		end
		dbskip()
	end
	DbGoTop()
end
return NIL

*-----------------------------------------------------------------------------*
	function CTBPIDIT(FL)	// Inclusao/Alteracao lancamentos
*-----------------------------------------------------------------------------*
local VM_DATA  :=DI_DATA,;
		VM_CONTA :=DI_CONTA,;
		VM_CTA   :=DI_CONTA,;
		VM_VALOR :=abs(DI_VALOR),;
		TIPO     :=if(DI_VALOR>0,'D','C'),;
		VM_HISTOR:=DI_HISTOR,;
		LCONT    :=.T.,;
		VM_DOCTO :=if(FL,if(trim(cFiltro)='*',DI_DOCTO,padr(cFiltro,20)),DI_DOCTO)

pb_box(16,2,,,,'Altera‡”es de Lancamentos Contabeis')
@17,04 say 'Data......:' get VM_DATA   pict masc(07) valid ValidaMesContabilFechado(VM_DATA,'LANCAMENTOS CONTABEIS')
@18,04 say 'Conta.....:' get VM_CTA    pict masc(03) valid fn_ifconta(@VM_CONTA,@VM_CTA)
@19,04 say 'Valor.....:' get VM_VALOR  pict masc(05) valid VM_VALOR > 0
@19,30                   get TIPO      pict masc(01) valid TIPO$'DC'
@20,04 say 'Hist¢rico.:' get VM_HISTOR pict masc(23)+'S34'
@21,04 say 'Documento.:' get VM_DOCTO  pict mUUU
read
if lastkey()#K_ESC
	if FL
		LCONT:=AddRec()
	end
	if LCONT
		replace  DI_DATA   with VM_DATA,;
					DI_CONTA  with VM_CTA,;
					DI_VALOR  with VM_VALOR*if(TIPO=='D',1,-1),;
					DI_HISTOR with VM_HISTOR,;
					DI_DOCTO  with VM_DOCTO
		dbcommitall()
	end
end
dbunlockall()
return NIL

*-----------------------------------------------------------------------------*
	function CTBPIDI3()	// Eliminar lancamento
*-----------------------------------------------------------------------------*
if RecLock().and.;
	pb_sn('Eliminar - '+dtoc(DI_DATA)+'  '+pb_zer(DI_CONTA,4)+chr(45)+CTADET->CD_DESCR+' Vlr '+FN_DBCR(DI_VALOR)+' ?')
	fn_elimi()
end
dbunlockall()
return NIL

*-----------------------------------------------------------------------------*
	function CTBPIDI4() // Atualizacao Contabil
*-----------------------------------------------------------------------------*
local VM_DATA:=DI_DATA
local VALOR  :=0
pb_box(20,40)
@21,42 say 'Informe a Data:' get VM_DATA pict mDT valid ValidaMesContabilFechado(VM_DATA,'INTEGRACAO CONTABIL')
read
if lastkey()#K_ESC
	if VM_DATA==PARAMETRO->PA_DATA
		beepaler()
		alert('AVISO;Data de Integra‡„o e Data do Sistema s„o Iguais.',{'Continuar'})
	end
	if year(VM_DATA)==PARAMCTB->PA_ANO // Verificar se a data é do ano contábil
		if pb_sn('Atualiza‡„o Cont bil da Data '+dtoc(VM_DATA)+' ?') 
			pb_msg('Aguarde... Verificando Fechamento Contábil da Data')
			if dbseek(dtos(VM_DATA),.F.) // Existem dados para esta data?
				dbeval({||VALOR+=DI_VALOR},{||VM_DATA==DI_DATA})
				if str(VALOR,15,2)==str(0,15,2)
					aLinDet:='' // Guardar as contas que podem não existir no plano de contas
					DbGoTop()
					dbeval({||ValidaConta()},{||VM_DATA==DI_DATA})
					if empty(aLinDet) // Todas as Contas Existem?
						NRLOTE:=1
						while NRLOTE>0
							if dbseek(dtos(VM_DATA),.F.) // Ainda tem data a ser processada?
								VM_DOCTO:=DI_DOCTO
								NRLOTE  :=NovoLote()
								DbGoTop()
								pb_msg('Integrando Lote:'+str(NRLOTE,8)+' - Chave:'+VM_DOCTO+' -Ini')
								@24,78 say "i "
								dbeval({||fn_diatul(NRLOTE)},{||VM_DATA==DI_DATA.and.VM_DOCTO==DI_DOCTO})
								@24,78 say "-"
								select('DIARIO')
								dbcommitall()
								dbunlockall()
								DbGoTop()
								pb_msg('Integrando Lote:'+str(NRLOTE,8)+' - Chave:'+VM_DOCTO+' -FIM')
							else
								alert('Atualiza‡„o Completa.')
								NRLOTE:=0	//......................................Sair do loop
								@24,78 say "fi"
							end
						end
					else
						beeperro()
						beeperro()
						Alert('Contas contabeis nao encontradas no plano;'+aLinDet)
					end
				else
					beeperro()
					beeperro()
					alert('Valores dos Lan‡amento desta data;NAO ESTAO FECHADOS')
				end
			else
				beeperro()
				beeperro()
				Alert('Nao Foram encontrados dados a serem integrados.')
			end
		end
	else
		beepaler()
		alert('Esta nao pertencem ao ano do parametro Contabil;FAZER ENCERRAMENTO ANUAL;NAO CONTINUAR')
	end
end
dbunlockall()
return NIL

*-----------------------------------------------------------------------------*
	static function FN_DIATUL(pNrLote)
*-----------------------------------------------------------------------------*
	@24,78 say "l"
//	while !RecLock();end
	@24,78 say "c"
	fn_atcta(CTADET->CD_CONTA,DI_VALOR,DI_DATA) //..............................Atual Ctas Balancete
	@24,78 say "ri"
	fn_atraz(CTADET->CD_CONTA,DI_VALOR,DI_DATA,pNrLote,DI_HISTOR,DI_DOCTO) //...Atual Lcto Razao
	@24,78 say "rf"
//	dbdelete()
	for nX:=1 to 10 // número de tentativas para exluir o registro
		@24,78 say "de"
		if NetDelete() // Travar Registro e Excluido
			nX:=20
		else
			pb_msg(str(nX,2)+'-Tentando Excluir Registro da INTEGRACAO'+str(RecNo(),5)+'-Lote='+str(pNrLote,6))
		end
	end
return NIL

*-----------------------------------------------------------------------------*
	static function ValidaConta()
*-----------------------------------------------------------------------------*
if !CTADET->(Found())
	if at(str(DIARIO->DI_CONTA,5),aLinDet) == 0
		if len(aLinDet)>0
			aLinDet +=','
		end
		aLinDet += str(DIARIO->DI_CONTA,5)
	end
end
return NIL

*-----------------------------------------------------------------------------*
	function CTBPIDI5() //............................. Impressao
*-----------------------------------------------------------------------------*
local VM_DATA:=ctod('')
pb_box(20,20)
@21,60 say '<Enter para Todas>'
@21,22 say 'Data para Impress„o :' get VM_DATA
read
if if(lastkey()#K_ESC,pb_ligaimp(I15CPP),.T.)
	VM_REL:='Lancamentos Contabeis para Integracao'
	VM_PAG:=0
	VM_LAR:=132
	DbGoTop()
	dbseek(dtos(VM_DATA),.T.)
	while !eof().and.if(empty(VM_DATA),.T.,DI_DATA==VM_DATA)
		VM_DATA:=DI_DATA
		TOT    :={0,0}
		VM_PAG :=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEPIDIAC',VM_LAR)
		?padc('Lancamentos do dia '+dtoc(VM_DATA),VM_LAR,'-')
		while !eof().and.VM_DATA==DI_DATA
			VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEPIDIAC',VM_LAR)
			?  pb_zer(DI_CONTA,4)+chr(45)+CTADET->CD_DESCR+space(2)
			??	DI_HISTOR+space(2)
			?? if(DI_VALOR>0,space(0),space(15))
			??	transform(abs(DI_VALOR),masc(2))
			TOT[if(DI_VALOR>0,1,2)]+=abs(DI_VALOR)
			dbskip()
		end
		?replicate('-',VM_LAR)
		? space(50)+padr('Total do Dia ('+;
		            if(round(TOT[1]-TOT[2],2)==0.00,'FECHADO','EM ABERTO')+')',49)
		??transform(TOT[1],masc(2))
		??transform(TOT[2],masc(2))
		if TOT[1]-TOT[2]#0
			?space(50)+padr('Diferenca:',49+if(TOT[1]-TOT[2]>0,15,0))+transform(abs(TOT[1]-TOT[2]),masc(2))
		end
		?replicate('-',VM_LAR)
	end
	eject
	pb_deslimp(C15CPP)
	set filter to
end
return NIL

*------------------------------------------------------------------
	function CFEPIDIAC()
*------------------------------------------------------------------
?padr('Conta Contabil',37)+padr('Historico',67)+'Vlr Debito    Vlr Credito'
?replicate('-',VM_LAR)
return NIL

*------------------------------------------------------------------------
	static function SelDiario() // selecao de arquivo de contabilizacao
*------------------------------------------------------------------------
ArqMovS   :=''
Opc       :=0
//........................................gerado (extraido) programa importação "EXPCFE.PRG"
ArqDiarios:=Directory('.\CTBADI*.*','D')
ArqSelec  :={}
aeval(ArqDiarios,{|DET|if(val(substr(DET[1],7,2))>0,aadd(ArqSelec,DET[1]),nil)})
if len(ArqSelec)>0
	pb_msg('Exitem '+str(len(ArqSelec),2)+' arquivos contabeis da Filial neste diretorio')
	Opc:=Abrowse(11,60,22,79,ArqSelec,;
						{'Nome'},;
						{   12 },;
						{  mUUU},,'Mov.Filial')
	if Opc>0
		close // Fecha "DIARIO" normal da matriz
		ArqMovS:=ArqSelec[Opc]
		ArqNSX :=ArqTemp(,,'')
		if !net_use(ArqMovS,.T., ,'DIARIO', ,.F.,RDDSETDEFAULT())
			pb_msg('Arquivo '+ArqMovS+' n„o pode ser aberto.',3,.T.)
			Opc:=0
		else
			Pack
			Index on dtos(DI_DATA)+str(RecNo(),7) tag DTCTA to (ArqNSX)
		end
	end
else
	Alert('N„o encontrado arquivos de contabilizac„o da Filial')
end
return OPC
*------------------------------------------------------------------EOF-----------
