//-----------------------------------------------------------------------------*
  static aVariav := {.T.,'',{},0,.T.,{}}
//....................1..2...3.4...5..6..7..8...9.10.11, 12,13,14,15
//-----------------------------------------------------------------------------*
#xtranslate lRT				=> aVariav\[  1 \]
#xtranslate cOrdAnt			=> aVariav\[  2 \]
#xtranslate aDpls				=> aVariav\[  3 \]
#xtranslate nVlrVencido		=> aVariav\[  4 \]
#xtranslate lLibMSG			=> aVariav\[  5 \] // ALT + A
#xtranslate aLog				=> aVariav\[  6 \] // ALT + A

#include 'RCB.CH'

//-----------------------------------------------------------------------------
	function CFEPVEBA()	//	PEDIDO Balcao
//-----------------------------------------------------------------------------

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
				'R->ENTCAB',; // Buscar NFE-Devolução
				'R->ENTDET',; // Buscar NFE-Devolução - itens da NF
				'C->PEDCAB',;
				'C->PEDDET',;
				'C->PEDSVC',;
				'C->CTADET',;
				'C->CTACTB',;
				'R->LOTEPAR',;
				'C->PARALINH',;
				'C->FISACOF',;
				'C->EXCESSAO',;
				'C->ADTOSD',;	//ADIANTAMENTO A CLIENTE - DETALHE
				'C->ADTOSC',;	//ADIANTAMENTO A CLIENTE - CABEÇALHO
				'C->NATOP'})
	return NIL
end
aLog		:={}
lLibMSG	:=.F.
set key K_ALT_A to LibMSGEspecial() // Libera Mensagem Especial - ALT + A
pb_tela()
pb_lin4('Digita‡„o de Pedidos',ProcName())

select('PROD')
dbsetorder(2) // Produtos
select('PEDCAB')
dbsetorder(2) // Pedido  Cabec
set relation to str(PC_CODCL,5) into CLIENTE
DbGoTop()

setcolor('W+/B,N/W,,,W+/B')
scroll(06,01,21,78,00)

private VM_CODOP	:=5102000
private VM_OPC		:=VM_TOT:=VM_CLI:=VM_VEND:=VM_ICMSPG:=VM_PARCE:=VM_DESCG:=VM_DESCIT:=VM_ULTPD:=VM_ULTDP:=VM_NSU:=0
private VM_BCO  	:=1
private VM_CODCG	:=1
private VM_OBS		:=space(132)
private VM_SVC		:=space(80)
private VM_DTEMI	:=PARAMETRO->PA_DATA
private VM_ULTPD	:=fn_psnf('VBA')
private VM_CODFC	:=space(10)
private VM_SERIE	:='VBA'
private VM_ICMT	:={0,0}	// Valor total ICMS, Base Total ICMS
private VM_DET  	:=VM_FAT:=VM_ICMS:={}
private VM_FLADTO	:='N'
private VM_RT		:=.T.

*-------------------------------------------------------Devolução
private VM_DEVNFE:=padr('0',44,'0') //.Nr Chave NFE
private VM_DEVNNF:=0 //................Nr NF
private VM_DEVSER:=space(003) //.......Serie
private VM_DEVDTE:=ctod('')//..........DT Emissão
*............................................................

while !pb_ifcod2(str(VM_ULTPD,6),NIL,.F.,1)
	VM_ULTPD :=fn_psnf('VBA')
end

salvacor(SALVA)
setcolor('GR+/BG,R/W,,,GR+/BG')
scroll(01,01,03,50,0)
@01,01 say 'Nr.Pedido.: '+str(VM_ULTPD,6) 
@01,23 say 'Dt.Emissao:' get VM_DTEMI pict masc(07) valid VM_DTEMI>PARAMETRO->PA_DATA-10 when pb_msg('Infome Data de EmissÆo do Pedido/NF')
read
if lastkey()==K_ESC
	fn_backnf('VBA',VM_ULTPD)
	DbGoTop()
	dbunlockall()
	dbcloseall()
	return NIL
end
@02,01 say 'Cliente...: '   get VM_CLI   pict masc(04) valid fn_codigo(@VM_CLI,	{'CLIENTE',	{||CLIENTE->(dbseek(str(VM_CLI,5)))},{||CFEP3100T(.T.)},{2,1,8,7}}).and.fn_icms(@VM_ICMSPG,'S').and.(VM_VEND:=CLIENTE->CL_VENDED)>=0.and.fn_ChkDpCaD(VM_CLI) when pb_msg('Infome C¢digo do Cliente')
@03,01 say 'Vendedor..:   ' get VM_VEND  pict masc(12) valid fn_codigo(@VM_VEND,	{'VENDEDOR',{||VENDEDOR->(dbseek(str(VM_VEND,3)))},{||CFEP5610T(.T.)},{2,1}})                                                                                            when pb_msg('Infome C¢digo do Vendedor').and.PARAMETRO->PA_VENDED==USOMODULO
read
salvacor(RESTAURA)
if lastkey()==K_ESC
	fn_backnf('VBA',VM_ULTPD)
	DbGoTop()
	dbcommitall()
	dbunlockall()
	dbcloseall()
	return NIL
end
salvabd(SALVA)
select('PARAMETRO')
dbrunlock(recno())
salvabd(RESTAURA)

	VM_ULTDP:=VM_ULTPD

EdPrdBalcao(.T.)

DbGoTop()
dbunlockall()
//............Gerar Log
EXCESSAO_Grava(aLog)

dbcloseall()
set key K_ALT_A to // Libera Mensagem Especial

return NIL

*------------------------------------------------------------------------------------
 function EdPrdBalcao(StDig)
*------------------------------------------------------------------------------------
local X
local iDes:=32-L_P
scroll(5,0,23,79,0)
salvacor(SALVA)
for X:=len(VM_DET)+1 to 99
	aadd(VM_DET,LinDetProd(X))
next

	aeval(VM_DET,{|DET|DET[6]:=round(DET[4]*DET[5],2)})	

@22,01 say 'TOTAL do Pedido.:'
@23,01 say 'Observacao......:'
keyboard chr(13)
while .T.

	VM_ICMS       :=FN_ICMSC(VM_DET) // retorna array ICMS
	VM_TOT        :=0 					// TOTAL DO PEDIDO
	aeval(VM_DET,{|VM_DET1|VM_TOT+=VM_DET1[6]})
	@22,18 say VM_TOT pict masc(2)

	pb_msg('<ESC> para selecionar uma linha ou <ESC><ESC> para sair.',NIL,.F.)
	set function 10 to chr(13)+'-1'+chr(13)
	X:=abrowse(5,1,21,78,;
				VM_DET,;
				{'Sq', 'Prod.','Descricao','Qtdade', 'Vlr Unit Venda','Valor Total','Enc Financ',   'CT',   '%ICMS', 'Unid','%Tribut'},;
				{   2,     L_P,       iDes,      10,					12,           15,          15,      2,         5,      6,       6 },;
				{ mI2,masc(21),       mXXX, masc(6),			masc(42),      masc(2),     masc(2),masc(11), masc(14),   mUUU,masc(20)})
	set function 10 to
	if X>0
		VM_ICMS:=CFEPVEBAD(VM_DET,X,StDig) // Editar * Retorna ICMS
		if lastkey()#K_ESC
			keyboard replicate(chr(K_DOWN),X)+chr(13)
		else
			keyboard replicate(chr(K_DOWN),X-1)
		end
	else
		exit
	end
end
salvacor(RESTAURA)

*---------------------------------------------------------------Roda pe da NOTA
if VM_TOT>0
	FLAG    :=.F.
	set function 10 to '+'+chr(13)
	@23,21 get VM_OBS pict masc(1)+'S52' valid fn_obs(@VM_OBS) when pb_msg('Digite Observa‡äes ou <press> F10 para cadastro de OBSERVACOES',NIL,.F.)
	read
	set function 10 to
	salvabd(SALVA)
	if lastkey()#K_ESC
		VM_VLRENT:=0
		VM_CODCP :=0
		VM_PERC  :=0.00
		VM_FAT   :={}
		while .T.
			pb_box(15,20,,,'W+/BG,R/W,,,W+/BG','Total da Venda')
			KeyBoard ''
			@16,22 say 'Cond.Pagamento:'    get VM_CODCP pict masc(12) valid fn_codcp(@VM_CODCP,@VM_TOT,@VM_VLRENT,@VM_PARCE)
			read
			if lastkey()#K_ESC
				@17,22 say 'Total da Venda: '+	transform(VM_TOT, masc(02))
				@18,60 say '%'							get VM_PERC  pict mI62      valid VM_PERC>=0                                         when pb_msg('Informe Percentual de Desconto')
				@18,22 say '(-) Descontos.:   '	get VM_DESCG pict masc(05)  valid VM_DESCG>=0.AND.fn_imprv(transform(VM_TOT-VM_DESCG,masc(2)),{19,38}) when ((VM_DESCG:=trunca(VM_TOT*VM_PERC/100,2))>=0).and.pb_msg('Informe Valor do Desconto')
				@19,22 say 'Sub-Total.....: '+	transform(VM_TOT-VM_DESCG,masc(2))
				@20,22 say 'Valor Entrada.:   '	get VM_VLRENT pict masc(05);
															valid str(VM_VLRENT,15,2)<=str(VM_TOT-VM_DESCG,15,2).and.ValidaLimiteCredito(VM_PARCE,VM_TOT-VM_DESCG-VM_VLRENT,CLIENTE->CL_CODCL) ;
															when fn_imprv(transform(VM_TOT-VM_DESCG,masc(2)),{19,38}).and.(VM_VLRENT:=trunca((VM_TOT-VM_DESCG)*CONDPGTO->CP_PERENT/100),2)>=0.00.and.VM_PARCE>0
				@21,22 say 'N.Parcelas....: '+	str(VM_PARCE,2)
				read
			end
			exit
		end
		if lastkey()#K_ESC
			FLAG:=.T.
			if VM_PARCE > 0
				VM_FAT:=fn_parc(VM_PARCE,(VM_TOT-VM_DESCG-VM_VLRENT),VM_ULTPD,VM_DTEMI)
				if (FLAG:=(len(VM_FAT)==VM_PARCE))
					if VM_PARCE>0
						TXTPARC:=''
						for X:=1 to VM_PARCE
							TXTPARC+=dtoc(VM_FAT[X,2])				 //----dd/mm/aaaa  01-10
							TXTPARC+=str( VM_FAT[X,3]*100,11)+'*'//----99999999999 11-21
						next
						fn_grparc(VM_ULTPD,TXTPARC) // GRAVAR PARCELAMENTO
					end
				end
			end
		end
	end
	select('PEDCAB')
	dbgobottom()
	dbskip()
	if if(FLAG,pb_sn(),.F.)
		aeval(VM_DET,{|DET|DET[6]:=0.00}) //...Limpar desconto indiv
		if StDig
			FATPGRPE('Novo','Produto') //..Atualizar Pedidos
			CFEPVEBC(VM_FAT) //............Impressao
			if PARAMETRO->PA_VBPEAT // Atualizar depois de digitar
				CFEPVEBD(VM_FAT)
			end
		else
			FATPGRPE('Altera','Produto') //..Atualizar Pedidos
		end
	end
else
	if StDig
		fn_backnf('VBA',VM_ULTPD)
		alert('Pedido Nao Gravado;Cancelado.')
	end
end
DbGoTop()
dbcommitall()
dbunlockall()
return NIL

//-----------------------------------------------------------------------------
 static function CFEPVEBAD(VM_DET,ORD,P1) // Digitar Itens (P1=L=Inclusao ?)
//-----------------------------------------------------------------------------
local VM_PROD  :=VM_DET[ORD,02]
local VM_QTD   :=VM_DET[ORD,04]
local VM_VLVEN :=VM_DET[ORD,05]
local VM_ENCFI :=VM_DET[ORD,07]
local VM_CODTR :=VM_DET[ORD,08]
local VM_ICMSP :=if(VM_PROD>0,VM_DET[ORD,09],VM_ICMSPG)
local VM_PTRIB :=if(empty(VM_DET[ORD,11]),100,VM_DET[ORD,11])
local VM_ICMS  :={}
local VM_VLVENX:=0
local X        :=row()
local Z
if !P1
	PROD->(dbseek(str(VM_PROD,L_P)))
end
set function 10 to '-1'+chr(13)
pb_msg('F10 para excluir a item do pedido')
@23,35 say 'Total Item '+str(ORD,2)+':'
@ X,05 get VM_PROD  pict masc(21)		valid VM_PROD=-1.or.;
															(fn_codpr(@VM_PROD,77).and.;
															fn_rtunid(VM_PROD).and.;
															if(empty(PROD->PR_VLVEN),alert('Preco de Venda Zerado;Nao pode ser Vendido.',{'Erro'})==-1,.T.));
															when P1.or.VM_PROD==0
@ X,39 get VM_QTD   pict masc(06)		valid (if(P1,VM_QTD>0,VM_QTD>=0)).and.fn_sdest(-VM_QTD+VM_DET[ORD,12],@VM_VLVEN,VM_PARCE).and.fn_chksvet(VM_PROD,VM_DET,VM_QTD,ORD).and.(VM_VLVENX:=VM_VLVEN)>=0 when VM_PROD > 0 .and. pb_msg('Valor unitario de Venda R$'+transform(PROD->PR_VLVEN,mD82))
@ X,50 get VM_VLVEN pict masc(42)		valid VM_VLVEN>0.and.fn_vlrvenda(VM_VLVEN,VM_VLVENX)    when fn_imprv(transform(round(VM_VLVEN*VM_QTD,2),masc(2)),{23,50}).and..F.
read
set function 10 to
if lastkey()#K_ESC
	if VM_PROD>0
		VM_DET[ORD,02]:=VM_PROD
		VM_DET[ORD,03]:=PROD->PR_DESCR
		VM_DET[ORD,04]:=VM_QTD
		VM_DET[ORD,05]:=VM_VLVEN
		VM_DET[ORD,06]:=round(VM_QTD * VM_VLVEN, 2) // Total
		VM_DET[ORD,07]:=VM_ENCFI
		VM_DET[ORD,08]:=if(empty(PROD->PR_CODTR),'000',PROD->PR_CODTR)
		VM_DET[ORD,09]:=PROD->PR_PICMS
		VM_DET[ORD,10]:=PROD->PR_UND
		CODTR->(dbseek(VM_DET[ORD,8]))
		VM_DET[ORD,11]:=CODTR->CT_PERC
	else
		VM_DET[ORD,02]:=  0
		VM_DET[ORD,03]:=replicate('.',20)
		VM_DET[ORD,04]:=  0
		VM_DET[ORD,05]:=  0
		VM_DET[ORD,06]:=  0
		VM_DET[ORD,07]:=  0
		VM_DET[ORD,08]:='000'
		VM_DET[ORD,09]:=  0
		VM_DET[ORD,10]:=  0
		VM_DET[ORD,11]:=  0
		VM_DET[ORD,12]:=  0
	end
	VM_ICMS       :=FN_ICMSC(VM_DET) // retorna array ICMS
	VM_TOT        :=0 					// TOTAL DO PEDIDO
	aeval(VM_DET,{|VM_DET1|VM_TOT+=VM_DET1[6]})
	@22,18 say VM_TOT pict masc(2)
end
return (VM_ICMS)

*-----------------------------------------------------Validar Cadastro/Duplicatas
function fn_ChkDpCaD(pCli)
*--------------------------------------------------------------------------------
lRT			:=.T. // Continua
cOrdAnt		:=DPCLI->(indexord())
nVlrVencido	:=0
nTempo		:=0
CodVerif		:=''

if PARAMETRO->PA_VBCHKMO>0 // Validar Duplicata ou Tempo Compra?
	if !empty(CLIENTE->CL_DTUCOM) // Teve Alguma Compra ?
		for nTempo:=1 to 12
			if AddMonth(CLIENTE->CL_DTUCOM,nTempo) > PARAMETRO->PA_DATA	// Soma Meses a Última DT Compra 
				nTempo--
				Exit // Sair do Loop
			end
		next
		DO CASE
			CASE PARAMETRO->PA_VBCHKMO==1	// Comprou à mais de 3 meses ?
				if nTempo>3
					lRT:=.F.	// Não Continua por Data
					CodVerif+='C1'
				end
			CASE PARAMETRO->PA_VBCHKMO==2	// Comprou à mais de 6 meses ?
				if nTempo>6
					lRT:=.F.	// Não Continua por Data
					CodVerif+='C2'
				end
			CASE PARAMETRO->PA_VBCHKMO==3	// Comprou à Mais de 12 Meses?
				if nTempo>12
					lRT:=.F.	// Não Continua por Data
					CodVerif+='C3'
				end
		ENDCASE
	else
		nTempo:=500 // Sem data de compra
		CodVerif+='C+'
	end

	salvabd(SALVA)
	select('DPCLI')
	cOrdAnt:=indexord()
	dbsetorder(5) // Ordem Cliente + Duplicata
	aDpls:=fn_rtdpls(pCli) // CFEP2211.PRG
	DbUnlockAll() // Liberar Registros Bloqueados - Todos Arquivos
	aeval(aDpls,{|DET1|nVlrVencido+=if(DET1[2]<PARAMETRO->PA_DATA,DET1[4],0)})
	if nVlrVencido>0 // Valor Vencido
		if xxsenha(ProcName(),'Liberacao Cliente DPL Vencida')
			Alert('Cliente Liberado por DPL Vencida.')
			aadd(aLog,{Date(),Time(),'Liberado Compra','Cliente '+trim(Left(CLIENTE->CL_RAZAO,30))+ ' Vlr Vencido:'+Str(nVlrVencido,7,2),RT_NOMEUSU()})
		else
			lRT:=.F.
			CodVerif+='V'
		end
	end
	dbsetorder(cOrdAnt)
	salvabd(RESTAURA)
end
if !lRT
	Alert('Verificar dados com Financeiro;antes da compra.;Codigo:'+CodVerif,,,10)
end

if lLibMSG
	Alert('T  E  S  T  E'									+;
	';Parametro....:'+Str(PARAMETRO->PA_VBCHKMO,2)	+;
	';Vlr Venc.....:'+Str(nVlrVencido,10,2)			+;
	';Dt Ult Compra:'+DtoC(CLIENTE->CL_DTUCOM)		+;
	';Dt Sistema...:'+DtoC(PARAMETRO->PA_DATA)		+;
	';Meses Compra.:'+Str(nTempo,3)						+;
	';Situacao.....:'+if(lRT,'Aprovado','Reprovado')+' => '+CodVerif)
end
return (lRT)

*-------------------------------------------------------*
Static Function LibMSGEspecial()
lLibMSG:=!lLibMSG
// Alert('Alt+A - LibMSG = '+if(lLibMSG,'Liberado','Nao Liberado'))
return NIL

//-----------------------------------------------------------------------------EOF

