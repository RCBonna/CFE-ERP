*-----------------------------------------------------------------------------*
 static aVariav := {0, 0, .F.,'',.F.}
*...................1..2...3...4..5
*-----------------------------------------------------------------------------*
#xtranslate nX				=> aVariav\[  1 \]
#xtranslate VM_VLVENX	=> aVariav\[  2 \]
#xtranslate lFlag			=> aVariav\[  3 \]
#xtranslate cDesc			=> aVariav\[  4 \]
#xtranslate lRT			=> aVariav\[  5 \]

#include 'RCB.CH'

*-----------------------------------------------------------------------------*
function CFEP5110(VM_DET,ORD,FL_NEW,TOTNF,pParam) // DIGITAR ITENS
*-----------------------------------------------------------------------------*

local VM_PROD    :=VM_DET[ORD,02]
local VM_QTD     :=VM_DET[ORD,04]
local VM_VLVEN   :=VM_DET[ORD,05]
local VM_DESC    :=VM_DET[ORD,06]
local VM_ENCFI   :=VM_DET[ORD,07]
local VM_CODTR   :=VM_DET[ORD,08]
local VM_ICMSP   :=VM_DET[ORD,09]	// % ICMS
local VM_QTDAN   :=VM_DET[ORD,12]	// Quantidade Anterior para Alteracao
local VM_PTRIB   :=if(empty(VM_DET[ORD,11]),100,VM_DET[ORD,11])
local VM_DESTRAN :=VM_DET[ORD,21]
local VM_DESTRAC :=VM_DET[ORD,22]

VM_VLVENX:=0

SalvaCor(SALVA)
pb_box(8,0,18,79,'W+/G,N/W*,,,W+/G','Item '+pb_zer(ORD,2)+'/'+pb_zer(len(VM_DET),2))
if !FL_NEW
	@09,27 say ''
	fn_codpr(VM_PROD,77)
	fn_rtunid(VM_PROD)
end
@11,38 say 'Total :'
@09,01 say padr('Produto',       20,'.') get VM_PROD  pict masc(21)     valid fn_codpr(@VM_PROD,77)				.and.;
																										fn_rtunid(VM_PROD)					.and.;
																										ChkProdNFDev(@VM_PROD)				.and.;
																										ChkProdArray(VM_PROD,VM_DET,ORD)	.and.;
																										(VM_CODTR:=PROD->PR_CODTR)>=''	.and.;
																										(VM_ICMSP:=PROD->PR_PICMS)>=0		.and.;
																										(VM_PTRIB:=PROD->PR_PTRIB)>=0 	.and.;
																										ChkAdtoPrd(VM_PROD,VM_FLADTO)		.and.;
																										ChkPisCofinsP(PROD->PR_CODCOS);
																										when FL_NEW
@10,01 say padr('Quantidade',    20,'.') get VM_QTD   pict mI123        valid VM_QTD  > 0																				.and.;
																										fn_sdest1(-(VM_QTD-VM_QTDAN),@VM_VLVEN,VM_PARCE,VM_SERIE,VM_TPTRAN)	.and.;
																										ChkQtdeNFDev(VM_QTD)																	.and.;
																										(VM_VLVENX:=VM_VLVEN)>=0 															.and.;
																										ChkAdtoQtd(VM_PROD,VM_FLADTO,VM_QTD,@VM_VLVEN)																	when aeval(GETLIST,{|DET|DET:display()})==GETLIST
@11,01 say padr('VlrVenda(Unit)',20,'.') get VM_VLVEN pict masc(53)     valid VM_VLVEN> 0          .and.fn_vlrvenda(VM_VLVEN,VM_VLVENX)													when fn_imprv(transform(trunca(VM_VLVEN*VM_QTD,2),masc(2)),{11,45})
@12,01 say padr('Desconto',      20,'.') get VM_DESC  pict masc(05)     valid VM_DESC >=0          .and.VM_DESC<=trunca(VM_VLVEN*VM_QTD,2)												when fn_imprv(transform(trunca(VM_VLVEN*VM_QTD,2),masc(2)),{11,45})
@14,01 say padr('C¢d.Tribut rio',20,'.') get VM_CODTR pict mI3          valid fn_codigo(@VM_CODTR,{'CODTR',{||CODTR->(dbseek(VM_CODTR))},{||NIL},{2,1,3}}) 						   when fn_imprv('+'+CODTR->CT_DESCR,{14,25})
@15,01 say padr('% ICMS',        20,'.') get VM_ICMSP pict masc(14)     valid VM_ICMSP>=0                                                                                     when VM_CODTR$'000#020'//.or.VM_CODTR#PROD->PR_CODTR
@15,35 say padr('% Tributado',   15,'.') get VM_PTRIB pict masc(20)     valid VM_PTRIB>=0			                                                                              when VM_CODTR=='020'   //.or.VM_CODTR#PROD->PR_CODTR
if VM_TPTRAN > 0 .and. NATOP->NO_FLCTB=='S' // É transferência e Contabiliza
	@16,01 say 'Cta Contabil DEBITO.:'    get VM_DESTRAN pict mI4 valid fn_ifconta(,@VM_DESTRAN)
	@17,01 say 'Cta Contabil CREDITO:'    get VM_DESTRAC pict mI4 valid fn_ifconta(,@VM_DESTRAC)
end
read
salvacor(RESTAURA)
if lastkey()#K_ESC
	if VM_PROD > 0
		
		VM_DET[ORD, 2]:=VM_PROD
		VM_DET[ORD, 3]:=PROD->PR_DESCR
		VM_DET[ORD, 4]:=Trunca(VM_QTD,  3)
		VM_DET[ORD, 5]:=Trunca(VM_VLVEN,4)	// Unitário 4 casas
		VM_DET[ORD, 6]:=Trunca(VM_DESC, 2)	// Desconto
		VM_DET[ORD, 7]:=Trunca(VM_ENCFI,2)
		VM_DET[ORD, 8]:=VM_CODTR
		VM_DET[ORD, 9]:=if(VM_CODTR$'000#020',VM_ICMSP,0.00)
		VM_DET[ORD,10]:=PROD->PR_UND
		VM_DET[ORD,11]:=VM_PTRIB
		VM_DET[ORD,17]:=pParam[1]	// CFOP Padrão
		if left(str(pParam[1],7),4)=="5102".and.VM_CODTR$'060' // modifica se for 5102 e CST=060
			VM_DET[ORD,17]:=5405000
		end
		if left(str(pParam[1],7),4)=="6102".and.VM_CODTR$'060' // modifica se for 6102 e CST=060
			VM_DET[ORD,17]:=6403000
		end
		VM_DET[ORD,14]:=Round(pb_divzero(PROD->PR_VLATU,PROD->PR_QTATU),4) // Vlr Médio
		VM_DET[ORD,20]:=PROD->PR_CFISIPI
		VM_DET[ORD,21]:=VM_DESTRAN // CONTA CONTABIL DESTINO TRANSFERENCIA = DEBITO
		VM_DET[ORD,22]:=VM_DESTRAC // CONTA CONTABIL DESTINO TRANSFERENCIA = CREDITO
		
		// Não gravar Valor Pis e Cofins porque falta proporcionalidade do Desconto Geral
		//------------------------------------------Trata adiantamento
		if VM_FLADTO=='S'
			nX:=aScan(aAdtos,{|DET|DET[2]==VM_PROD})
			if nX>0
				VM_DET[ORD,19]:=aAdtos[nX,1] // Numero Adiantamento
			end
		end
	else
		VM_DET[ORD]:=LinDetProd(ORD)
	end
end
TOTNF         :=0.00
for nX:=1 to len(VM_DET)
	if VM_DET[nX, 2] > 0 // Tem item
		TOTNF+=(Trunca(VM_DET[nX,4]*VM_DET[nX,5],2)-VM_DET[nX,6]+VM_DET[nX,7]) // Valor NF
	end
end
@17,01 say 'TOTAL do Pedido (NF):' + transform(TOTNF, masc(2))
return NIL

*------------------------------------------------------------------------------------------------*
static function CHK_ICMS(pCodTr,pPIcms) // 
*------------------------------------------------------------------------------------------------*
lRT:=.T.
if pCodTr$'000#020'
	if str(pPIcms,15,2)==str(0,15,2)
		lRT:=pb_sn('Codigo tributario deveria ter % ICMS. Manter % Zero?')
	end
else
	if str(pPIcms,15,2)>str(0,15,2)
		lRT:=pb_sn('Codigo tributario deveria ter % ICMS Zero. Manter % maior que Zero?')
	end
end
return lRT

*------------------------------------------------------------------------------------------------*
function FN_SDEST1(P1,pVlrVenda,pNrMeses,P4,pTransf) // SALDO DO ESTOQUE RETORNA PRECO DE VENDA
*------------------------------------------------------------------------------------------------*
//...................P1=quantidade
//.........................................P4=serie
pNrMeses:=if(pNrMeses==NIL,0,pNrMeses)
pTransf :=if(pTransf ==NIL,1,pTransf)
if pTransf#1 // Sem Transferencia
	pVlrVenda:=Round(PROD->PR_VLVEN+(PROD->PR_VLVEN*(fn_perfin(P4)+PROD->PR_PERVEN)/100)*pNrMeses,4)
else
	pVlrVenda:=Round(pb_divzero(PROD->PR_VLATU,PROD->PR_QTATU),4)
end
return(.T.)

*------------------------------------------------------------------------------------------------*
	function ChkPisCofinsP(pPisCof) // Validar se o Produto tem Código Pis+Cofins 
*------------------------------------------------------------------------------------------------*
if FISACOF->(dbseek(pPisCof+CLIENTE->CL_TIPOFJ))
	lRT:=.T.
else
	alert('Produto com Codigo PIS/COFINS <'+pPisCof+;
			'>;nao cadastrado para pessoas tipo<'+CLIENTE->CL_TIPOFJ+;
			'>;Verifique a tabela PIS x Cofins')
	lRT:=.F.
end
return(lRT)
*-------------------------------------------------------EOF---------------------
