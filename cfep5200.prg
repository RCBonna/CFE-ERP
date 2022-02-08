*-----------------------------------------------------------------------------*
  static aVariav := {''}
*.....................1.
*-----------------------------------------------------------------------------*
#xtranslate VM_DTCAN    => aVariav\[  1 \]
*-----------------------------------------------------------------------------*
 function CFEP5200()	//	Impressao e atualizacao da NF									*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
if !abre({	'C->PARAMETRO',;
				'C->DIARIO',;
				'C->CTRNF',;
				'C->GRUPOS',;
				'R->NCM',;
				'C->PROD',;
				'C->MOVEST',;
				'C->TABICMS',;
				'C->CLIENTE',;
				'C->CLIOBS',;
				'C->DPCLI',;
				'C->HISCLI',;
				'C->BANCO',;
				'C->VENDEDOR',;
				'C->OBS',;
				'C->CAIXACG',;
				'C->CAIXAMB',;
				'C->CONDPGTO',;
				'C->PEDPARC',;
				'C->XOBS',;
				'R->CODTR',;
				'C->PEDCAB',;
				'R->ENTCAB',; // Buscar XML para Devoluçao
				'C->PEDDET',;
				'C->PEDSVC',;
				'C->CTADET',;
				'C->CTACTB',;
				'R->LOTEPAR',;
				'C->PARALINH',;
				'C->FISACOF',;	// TABELA DE PIS X COFINS
				'C->ADTOSD',;	//ADIANTAMENTO A CLIENTE - DETALHE
				'C->ADTOSC',;	//ADIANTAMENTO A CLIENTE - CABEÇALHO
				'C->NATOP'})
	return NIL
end

pb_tela()
pb_lin4('Atualizacao de Pedidos/Impressao Nota Fiscal',ProcName())
select('ENTCAB')
ordem FORDTE
select('PROD')
ordem CODIGO // Ordem Produtos
select('PEDCAB')
dbsetorder(2) // Pedido  Cabec
set relation to str(PC_CODCL,5) into CLIENTE

setkey(K_F6,{||NFEE()})			// F6-NFE

DbGoTop()
pb_dbedit1('CFEP520','ImprimMostraCancelReImprSRemes')  // tela

dbedit(06,01,maxrow()-3,maxcol()-1,;
		{'PC_SERIE','PC_PEDID','pb_zer(PC_CODCL,5)+chr(45)+left(CLIENTE->CL_RAZAO,30)','PC_DTEMI', 'PC_CODOP','PC_NRNF','PC_TOTAL','if(PC_FLSVC,"Serv","Prod")','if(PC_FLADTO,"Sim","Nao")','PC_FATUR','if(PC_FLCAN,"Sim","Nao")'},;
		'PB_DBEDIT2',;
		{ mUUU,           mI6 ,                                                  mXXX ,      mDT ,       mNAT,     mI6 ,     mD112,     mXXX,                        mXXX                  ,mI4       ,mXXX  },;
		{'Ser',       'Pedido',                                              'Cliente','Dt Emiss',   'NatOpe',   'NrNF',   'Total',    'TpNF',                       'Adt'                 ,'Parc'    ,'Can' } )
dbunlockall()
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
  function CFEP5201(TIPOIMP)
*-----------------------------------------------------------------------------*
local FLAG
local OPC := .F.

pb_tela()
pb_lin4('Atualiza‡„o de Pedidos',ProcName())
if eof().or.bof()
	alert('Nada para ser Atualizado.',5,.T.)
	DbGoTop()
	return NIL
end

dbskip(0)
if PEDCAB->PC_FLAG
	alert('Pedido j  Impresso e Atualizado.',5,.T.)
	DbGoTop()
	return NIL
end

for nX :=1 to fcount()
	X1 :="VM"+substr(fieldname(nX),3)
	&X1:=&(fieldname(nX))
next
VM_FLADTO        :=if(VM_FLADTO,"S","N")
private VM_ULTPD := PC_PEDID
private VM_NSU   := PC_NSU
private VM_BCO   := 10
private VM_DET   := {}
private VM_ICMS  := {}
private VM_ICMT  := {}
private I_TRANS  := {}
private VM_CARNE :='N'
private VM_FAT   := {}
private OBS      := .F.
private VM_OBSP  := '' // Para OBS ADICIONAL
private VM_ENCFI :=0
private FLCONT   :=.T.
private VM_LOTE  :=0
private aAdtos   :=fn_aAdtos(VM_CODCL,'C')
private nPesoTot :=0
//.....................................DEVOLUÇÃO
private VM_DEVNFE:= PC_NFEDEV //.......Nr Chave NFE
private VM_DEVNNF:=0 //................Nr NF
private VM_DEVSER:=space(003) //.......Serie
private VM_DEVDTE:=ctod('')//..........DT Emissão
//............................................................


SetKeyNFE() // colocar Zeros na NF-E para recuperar posteriormente ou receber zeros.
keyboard chr(0)
CFEP5104(.F.) // Mostar pedido - Carregar dados no vetor de pedido
VM_DET :=fn_rtprdped(VM_ULTPD)	//............Retorna todos dos itens da nota num array.
FLCONT :=ValidaLimiteCredito(PEDCAB->PC_FATUR,PEDCAB->PC_TOTAL-PEDCAB->PC_VLRENT,CLIENTE->CL_CODCL)

if !FLCONT //......................SAIR
	select('PEDCAB')
	dbskip(0)
	dbunlockall()
	DbGoTop()
	if eof().or.bof()
		keyboard '0'
	end
	setcolor(VM_CORPAD)
	return NIL
end

VM_REGIS  := PEDCAB->(recno())
VM_OBS    := PEDCAB->PC_OBSER
VM_PARCE  := PEDCAB->PC_FATUR
VM_ULTNF  := PEDCAB->PC_NRNF
VM_ULTDP  := PEDCAB->PC_NRDPL
VENDEDOR->(dbseek(str(PEDCAB->PC_VEND,3)))
CTRNF->(dbseek(PEDCAB->PC_SERIE))
if lastkey()==K_ESC
	return NIL
end
if !PEDCAB->(reclock())
	return NIL
end

VM_NOMNF :=CLIENTE->CL_RAZAO
VM_CLI   :=PEDCAB->PC_CODCL
VM_AVALIS:=0
VM_AVAL  :={0,space(45),space(45),space(18)}
pb_box(11,,,,,'Finalizacao da NF')
if PARAMETRO->PA_AVALIS.and.PEDCAB->PC_FATUR>0 // Parcelado
	VM_ULTNF:=CLIENTE->(recno())
	@14,01 say 'Informe C¢digo do Avalista (0-Sem).:' get VM_AVALIS picture masc(4) valid if(VM_AVALIS#0,fn_codigo(@VM_AVALIS,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_AVALIS,5)))},{||CFEP3100T(.T.)},{2,1,8,7}}),.T.)
	read
	VM_AVAL[1]:=VM_AVALIS
	if VM_AVALIS>0
		VM_AVAL[2]:=CLIENTE->CL_RAZAO
		VM_AVAL[3]:=CLIENTE->CL_ENDER
		VM_AVAL[4]:=padr(transform(CLIENTE->CL_CGC,masc(if(len(trim(CLIENTE->CL_CGC))>12,18,17))),18)
	end
	CLIENTE->(DbGoTo(VM_ULTNF))
end

VM_ULTNF:=0
*-----------------------------------------------------------TRANSPORTADOR
if NATOP->NO_TIPO#'O' // Venda Normal de Produtos
	I_TRANS:=CFEPTRANL()
	if CTRNF->NF_TEMTRA
		I_TRANS[15]	:=-1
		I_TRANS		:=CFEPTRANE(I_TRANS,.T.) // Edita Transportador
	end
	CFEPTRANG('S',I_TRANS)
end
*-----------------------------------------------------------------------
VM_ULTDP :=VM_ULTNF
VM_NOMEC :=CLIENTE->CL_RAZAO
VM_CODCG :=max(PEDCAB->PC_CODCG,1)
if NATOP->NO_FLTRAN=='S'
	VM_CODCG :=if(NATOP->NO_FLTRAN=='S',3,VM_CODCG)
	VM_BCO   := 10
end
set function 10 to '+'+chr(13)

VM_DTSAI:=if(Empty(VM_DTSAI),VM_DTEMI,VM_DTSAI)

@12,01 say 'Dt Emissao..................:' get VM_DTEMI pict mDT        valid VM_DTEMI<=PARAMETRO->PA_DATA
@13,01 say 'Dt Saida....................:' get VM_DTSAI pict mDT        valid VM_DTSAI>=VM_DTEMI
if NATOP->NO_FLTRAN=='S'
	@12,60 say 'Nr. Lote :'                 get VM_LOTE   pict mI4
	@13,60 say 'Tp Transf:'                 get VM_TPTRAN pict mI1                                                when pb_msg('Opcoes:  <1>Transferencia Preco Custo  <2>Transferencia Preco Venda')
end
@15,01 say 'OBS'                           get VM_OBS   pict mUUU+'S74' valid fn_obs(@VM_OBS) when pb_msg('Informe Observacao para a NF. F10-para Consultar OBS')
@16,01 say 'Nome do Cliente.............:' get VM_NOMEC pict mUUU                             when 'CLIENTE NOMINAL'$CLIENTE->CL_RAZAO
@17,01 say 'Cod.Banco/Cxa de Recebimento:' get VM_BCO   pict mI2        valid fn_codigo(@VM_BCO,{'BANCO',{||BANCO->(dbseek(str(VM_BCO,2)))},{||CFEP1500T(.T.)},{2,1}})          when NATOP->NO_FLTRAN#'S'.and.PEDCAB->PC_FATUR==0
@18,01 say 'Cod.Receita para Caixa......:' get VM_CODCG pict mI3        valid fn_codigo(@VM_CODCG,{'CAIXACG',{||CAIXACG->(dbseek(str(VM_CODCG,3)))},{||CXAPCDGRT(.T.)},{2,1}})  when USACAIXA.and.PEDCAB->PC_FATUR==0.and.pb_msg('Codigo de lancamento no Caixa').and.NATOP->NO_FLTRAN#'S'
@19,01 say 'Serie da Nota Fiscal........:' get VM_SERIE pict mUUU       valid VM_SERIE==SCOLD.or.VM_SERIE=='ORD'.or.(fn_codigo(@VM_SERIE,{'CTRNF',{||CTRNF->(dbseek(VM_SERIE))},{||CFEPATNFT(.T.)},{2,1,3,4}}).and.CTRNF->NF_NRLIN>0) color 'R/W' when PARAMETRO->PA_EMCUFI
if PARAMETRO->PA_CFTIPOF==1
	@19,60 say 'Imprime Carne?'             get VM_CARNE pict mUUU valid VM_CARNE$'SN'                                                                                                                                    when PEDCAB->PC_FATUR>0.and.NATOP->NO_FLTRAN#'S'
end
@21,01 say left('OBS[Prod]'+VM_OBSP,79)
read
set function 10 to
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn('Imprimir a NOTA FISCAL ?'),.F.)
	CTRNF->(dbseek(PEDCAB->PC_SERIE))
	*..........................................................Verificar quantidade de produtos
	if !PEDCAB->PC_FLSVC // Não é serviço
		select('PROD')
		for ORD:=1 to len(VM_DET)
			if VM_DET[ORD,2]>0
				if dbseek(str(VM_DET[ORD,2],L_P))
					if reclock()
						if str(PROD->PR_CTB,2)=='97'.or.;
							str(PROD->PR_CTB,2)=='99'.or.;
							PROD->PR_CTRL=='N' //...........Não Controla Estoque
							//..............................Não controlar estoque
						else
							if str(VM_DET[ORD,4],15,3) > str(PROD->PR_QTATU,15,3)
								alert('Produto '+str(PROD->PR_CODPR)+'-'+trim(PROD->PR_DESCR)+;
								';sem saldo suficiente para venda;Cancelado')
								FLCONT:=.F.
							end
						end
						if FLCONT.and.VM_FLADTO=='S' // .................................É adiantamento
							nX:=aScan(aAdtos,{|DET|DET[2]==VM_DET[ORD,2]})
							if nX==0.or.!str(aAdtos[nX,4],15,3)>=str(VM_DET[ORD,4],15,3)
								Alert('Produto '+str(PROD->PR_CODPR)+'-'+trim(PROD->PR_DESCR)+;
								';sem saldo suficiente em ADIANTAMENTO para venda;Cancelado;N:'+;
								str(nX,3)+';QA'+str(aAdtos[nX,4],15,3)+';QD'+str(VM_DET[ORD,4],15,3))
								FLCONT:=.F.
							else
								if nX>0
									aAdtos[nX][04]-=VM_DET[ORD,4]	// Diminuir no saldo
									aAdtos[nX][08]+=VM_DET[ORD,4]	// Somar em Qtd Retirada
									aAdtos[nX][11]+=trunca(VM_DET[ORD,4]*VM_DET[ORD,5],2)	// Somar em Vlr Retirado
									aAdtos[nX][09]:=.T.				// Registro Alterado
								end
							end
						end
					else
						FLCONT:=.F.
					end
				else
					beeperro()
					beeperro()
					alert('CFEP5200-erro prod.'+pb_zer(VM_DET[ORD,2],L_P)+';Reordene - se o problema continuar;anote e AVISE RESPONSALVEL')
					FLCONT:=.F.
				end
			end
		next
	end
	if FLCONT.and.VM_FLADTO=='S'
		for ORD:=1 to len(aAdtos)
			ADTOSD->(DbGoTo(aAdtos[ORD,10]))
			if !ADTOSD->(reclock())
				FLCONT:=.F.
			end
		end
	end
	salvabd(RESTAURA)
	//----------------------------------------------------------------
	if FLCONT
		VM_VLRENT:= PEDCAB->PC_VLRENT
		VM_NOMNF := CLIENTE->CL_RAZAO
		VM_TOT   := PEDCAB->PC_TOTAL
		VM_ENCFI := PEDCAB->PC_ENCFI
		VM_JUROS := PEDCAB->PC_ENCFI
		VM_DESCG := PEDCAB->PC_DESC
		if !VM_SERIE$SCOLD+'...ORD' // NÃO é scold ou ordem de serviço?
			if CTRNF->NF_CUPFIS // Imprimir Para cupom fiscal ?
				if CupomFiscal()
					VM_ULTNF := CF_LENUMCUP() + 1
				else
					FLCONT:=.F. //...........................Nao continuar
				end
			else
				VM_ULTNF :=fn_psnf(VM_SERIE)
			end
		else
			VM_ULTNF :=PEDCAB->PC_PEDID
		end
	end
	if FLCONT //......................................Pode Continuar ?
		VM_ULTDP :=VM_ULTNF
		select('PEDCAB')
		if !pb_ifcod2(str(VM_ULTNF,6)+VM_SERIE,'PEDCAB',.F.,5)
			alert('A NF serie '+VM_SERIE+' Nr.'+str(VM_ULTNF,6)+' ja foi impressa;Mude em Faturamento/Parametros/Nr Doctos.')
		else
			DbGoTo(VM_REGIS)
			replace  PC_DTEMI with VM_DTEMI,;
						PC_DTSAI with VM_DTSAI

			if PARAMETRO->PA_TIPODPL==1
				VM_ULTDP := VM_ULTPD
			end
			VM_FAT   :=fn_RetParc(VM_ULTPD,PEDCAB->PC_FATUR,VM_ULTDP)
			@20,01 say 'Numero Nota Fiscal a imprimir..: '+str(VM_ULTNF,6)
			@21,01 say 'Numero Basico da Duplicata.....: '+str(VM_ULTDP,6)+'/NN'
			OPC:=.T.
			if VM_SERIE#SCOLD.and.VM_SERIE#'ORD'
				if CTRNF->NF_CUPFIS
					OPC:=CF_ImprGeral(VM_TOT,VM_ENCFI,VM_DESCG,VM_NOMNF,VM_FAT,VM_VLRENT,1,VM_DET) //...Rot Impressao Cupom
				else
					if VM_SERIE=='NFE'
						OPC    :=CFEPPNFE() //...............................Preparar NFE-Saida Normal (Gerar XML = FISPNFEG.prg)
					else
						VM_NSU :=fn_psnf("NSU")//............................Busca um número
						OPC    :=CFEPIMNF() //...............................Rot Impressao NF Normal
						if !OPC
							fn_backnf("NSU",VM_NSU)//.........................Retorna se não deu certo
						end
					end
				end
			end
			if OPC
				pb_msg('Atualizando Base de Dados. Aguarde...',NIL,.F.)
				CFEP520G() //...............................................Atualiza
				if VM_CARNE=='S'
					VM_DTEMI:=PEDCAB->PC_DTEMI
					fn_ImpCarne(VM_CLI,VM_NOMNF,VM_FAT,VM_DTEMI)
				end
			end
			dbskip(0)
		end
	end
end
if !OPC
	fn_backnf(VM_SERIE,VM_ULTNF)
end
select('PEDCAB')
dbskip(0)
dbunlockall()
DbGoTop()
if eof().or.bof()
	keyboard '0'
end
setcolor(VM_CORPAD)
return NIL

*-----------------------------------------------------------------------------*
  function CFEP5202() // Mostrar todas as Notas Fiscais
*-----------------------------------------------------------------------------*
if indexord()==4
	dbsetorder(2)
else
	dbsetorder(4)
end
DbGoTop()
return NIL

*-----------------------------------------------------------------------------*
 function CFEP5203() // Cancelar Notas Fiscal
*-----------------------------------------------------------------------------*
local VM_SERIE:=space(3)
local VM_NRNF :=0
VM_DTCAN:=PARAMETRO->PA_DATA
dbsetorder(5)
pb_box(15,02,,,,'Selecao de Cancelamento de NF')
@16,04 say 'Serie.:'				get VM_SERIE pict masc(01)
@16,40 say 'Numero NF......:' get VM_NRNF  pict masc(19) valid pb_ifcod2(str(VM_NRNF,6)+VM_SERIE,NIL,.T.,5)
read
if lastkey()#K_ESC
	if !PC_FLCAN				// Nota Cancelada ?
		if !PC_FLCTB			// Nota Contabilizada ?
			if !PC_FLOFI		// Nota já integrado no fiscal ?
				if !PC_FLSVC	// Nota de Serviço
					@19,04 say 'Data Emissao: '+transform(PC_DTEMI,masc(07))
					@20,04 say 'Cliente.....: '+pb_zer(PC_CODCL,5)+CHR(45)+CLIENTE->CL_RAZAO
					@21,04 say 'Total NF....: '+transform(PC_TOTAL,masc(2))
					@19,40 say 'Dt Cancelamento:' get VM_DTCAN pict mDT valid VM_DTCAN>=PC_DTEMI
					read
					if pb_sn('Cancelar NF;e Voltar os produtos para o Estoque ?').and.reclock()
						replace PC_FLCAN with .T. // nota fiscal cancelada
						replace PC_DTCAN with VM_DTCAN // Data Cancelamento
						select('PEDDET')
						dbseek(str(PEDCAB->PC_PEDID,6))
						while !eof().and.PEDCAB->PC_PEDID==PEDDET->PD_PEDID
							// Voltar produto ao estoque
							select('PROD')
							PROD->(dbseek(str(PEDDET->PD_CODPR,L_P)))
							while !reclock();end
							replace  PR_QTATU with PR_QTATU+PEDDET->PD_QTDE,;
										PR_VLATU with PR_VLATU+PEDDET->PD_VLRMD // Suma Valor Unitário Total
							dbrunlock(recno())
							// registrar movimento
							select('MOVEST')
							GravMovEst({PEDDET->PD_CODPR,;	//	1
											PEDCAB->PC_DTEMI,;	//	2
											PEDCAB->PC_NRNF,;		//	3
											PEDDET->PD_QTDE,;		//	4
											PEDDET->PD_VLRMD,;	// 5 Vlr Médio
											PEDDET->PD_VALOR,;	//	6
											'E',; 					//	7-Entra Estoque (cancelar)
											VM_SERIE,;				//	8
											0})						//	9
							select('PEDDET')
							dbskip()
						end
						select('PEDCAB')
						if PC_FATUR>0
							alert('ATENCAO;Os valores do Contas a Receber nao foram baixados;Faze-lo Manualmente')
						end
						// EXCLUIR DPL A PAGAR
					end
				else
					//------------eliminar lancamentos de servico
				end
			else
				alert('Nota Fiscal ja integrada no Fiscal')
			end
		else
			alert('Nota Fiscal ja contabilizada')
		end
	else
		alert('Nota Fiscal ja cancelada')
	end
end
dbsetorder(2)
DbGoTop()
return NIL

*-----------------------------------------------------------------------------*
// function CFEP5204() // Editar - 
*-----------------------------------------------------------------------------*

*--------------------------------------------------EOF----------------------------
