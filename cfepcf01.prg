*-----------------------------------------------------------------------------*
function CFEPCF01()	//	Venda cupom fiscal-direto
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
#define CF_ITEM_CAN  'ITEM CANCELADO'

local LogStat

if !abre({'C->PARAMETRO','C->DIARIO'	,'C->CTRNF'		,'C->GRUPOS',;
			 'C->PROD'		,'C->MOVEST'	,'C->CTACTB'	,'C->TABICMS',;
          'C->CONDPGTO' ,'R->ALIQUOTAS','C->CAIXAMB'  ,'R->CAIXA01',;
			 'C->CODTR'		,'C->CLIENTE'	,'C->CLIOBS'	,'C->DPCLI',;
			 'C->HISCLI'	,'C->BANCO'		,'C->VENDEDOR'	,'C->OBS',;
			 'C->PEDPARC'	,'C->PEDDET'	,'C->PEDCAB'	,'C->NATOP',;
			 'C->PARALINH' ,'C->CAIXASA'	,'C->CLICONV'})
	return NIL
end

pb_tela()
pb_lin4('Venda Cupom Fiscal-Direto',ProcName())
select('PROD');  dbsetorder(2) // Produtos
select('PEDCAB');dbsetorder(2) // Pedido  Cabec
set confirm on
//LogStat:=FN_StatCxa(NUM_CXA)
if LogStat=='FECHADO'
	alert('Caixa '+str(NUM_CXA,2)+' com Situacao FECHADO')
	dbcloseall()
	return Nil
end

while CupomFiscal().and.CFEPCF011()
	dbunlockall()
	select('PEDCAB')
	dbsetorder(2) // Pedido  Cabec
end
dbcloseall()
return NIL

*--------------------------------------------------------------*
function CFEPCF011()
local CF_DATA:=CF_Info('23')

DbGoTop()

VM_CODOP  :=0
VM_OPC    :=0
VM_TOT    :=0
VM_ICMSPG :=0
VM_DESCG  :=0
VM_VEND   :=0
VM_RT     :=.T.
VM_OBS    :=space(132)
VM_SVC    :=space(080)
VM_DET    :={}
VM_ICMS   :={} // %ICMS,BASE
VM_DTEMI  :=PARAMETRO->PA_DATA
VM_SERIE  :='CF'+str(NUM_CXA,1)
VM_TIPOE  :='CF'+str(NUM_CXA,1)
VM_CLI    := 1
VM_CODCG  := 1
VM_CODFC  :=space(10)
VM_EMPRESA:= 0
VM_PARCE  := 0	// Nr Parcelas
VM_ULTPD  := CF_LENUMCUP()+1
VM_ULTDP  := VM_ULTPD
ARRCXA    :={0.00,         0}
CF_DATA   :=ctod(substr(CF_DATA,1,2)+'/'+substr(CF_DATA,3,2)+'/'+substr(CF_DATA,5,2)) // data da impressora
if dtos(PARAMETRO->PA_DATA)#dtos(CF_DATA)
		Alert('Data Impressora Fiscal:'+dtoc(CF_DATA)+';'+;
				'Data do Sistema.......:'+dtoc(PARAMETRO->PA_DATA)+;
				';Devem ser Iguais;Ajute Parametros no Micro')
	return .F.
end

LOG_ABERTO:=.F. // ABERTURA DO CUMPOM

//.........VLR INICIAL   NR NAO
if file(_ARQ_CXA)
	ARRCXA:=restarray(_ARQ_CXA)
else
end
salvacor(SALVA)

setcolor('R/W*,R/W,,,R/W*')
scroll(00,00,24,79,0)
pb_box(0,0,6,79,'R/W*,R/W,,,R/W*',' T o t a l ')
@02,59 say 'Dt.Emis..:'+transform(VM_DTEMI,mDT)
@03,59 say 'Hora.....:'
@04,59 say 'Caixa nr.:'+str(NUM_CXA,2)
@05,50 Say CF_Advert() color 'W/R*+'
@05,59 say ProcName()+':'+str(VM_ULTPD,6)

CLIENTE->(dbseek(str(VM_CLI,5)))
VM_NOMNF:=CLIENTE->CL_RAZAO

salvabd(SALVA)
select('PARAMETRO')
dbrunlock(recno())
salvabd(RESTAURA)

	MOSTRA_NUM(1,str(0,7,2))

for VM_X:=1 to 100
	aadd(VM_DET,{VM_X,; 					//  1 -seq
					 0,;						//  2 -prod
					 replicate('.',45),;	//  3 -descr
					 0.00,;					//  4 -qtde
					 0.00,;					//  5 -vlr venda UNID
					 0.00,;					//  6 -total produto
					 0.00,;					//  7 -enc financ
					 '000',;					//  8 -cod tributario
					 17.00,;					//  9 -% ICMS
					 ' ',;					// 10 -Unidade
					 100.00,;				// 11 -% Tributacao
					 0.00,;					// 12 - Qtd anterior (P/alteracao)
					 0,;						// 13 - registro
					 0.00,;					// 14 - Vlr Medio
					 0.00,;					// 15 - Vlr ICMS
					 0.00,;					// 16 - Vlr BASE ICMS
					 0,;						// 17 - natureza opera‡Æo
					 'II'})					// 18 - Cod Trib -Impressora Fiscal
next
keyboard chr(13)
while .T.
	pb_msg('F10-Sai.',NIL,.F.)
	set function 10 to chr(27)
	X:=abrowse(7,0,21,79,;
				VM_DET,;
				{'Sq', 'Prod.','Descricao','Qtdade','Vlr Unit Venda','Valor Total','Enc Financ',   'CT',   '%ICMS', 'Unid','%Tribut'},;
				{   2,     L_P,     44-L_P,      10,              15,           15,          15,      2,         5,      6,       6  },;
				{ mI2,masc(21),       mUUU, masc(6),         masc(2),      masc(2),     masc(2),masc(11), masc(14),   mUUU,masc(20)})
	set function 10 to
	if X > 0
		if trim(VM_DET[X,3]) # CF_ITEM_CAN
			VM_ICMS:=CF_DigItens(VM_DET,X,VM_DET[X,2]==0) // editar * retorna ICMS
			if lastkey()#K_ESC
				X:=ascan(VM_DET,{|DET|DET[2]==0})
				keyboard replicate(chr(K_DOWN),X-1)+chr(13)
			end
		end
	else
		scroll(24,00,24,79,0)
		exit
	end
end

*---------------------------------------------------------------Roda pe da NOTA
private FLAG     :=.F.
private VM_CODCP :=0
private VM_VLRENT:=0
private VM_FAT   :={}
private vParcelas:=0
private VM_PERC  :=0.00
private VM_PARCE :=0	// Nr Parcelas
private VM_OPC   :=0
private VM_RETORN:={}
private VM_CARNE :='N'
private VM_ENCFI :=0.00
if LOG_ABERTO
	FLAG_LOOP:=.T.
	while FLAG_LOOP
		salvabd(SALVA)
		VM_DINH  :=VM_TOT
		if PARAMETRO->PA_CFTIPOF==0
			VM_RETORN:=Fechar_0(VM_TOT,'V')
			VM_DESCG :=VM_RETORN[03]
			VM_PARCE :=VM_RETORN[04]	// Nr Parcelas
			VM_ENCFI :=VM_RETORN[06]
			VM_VLRENT:=VM_RETORN[07]
			VM_FAT   :=VM_RETORN[12]   // Parcelamento
			VM_DINH  :=VM_RETORN[07]
			VM_CLI   :=VM_RETORN[13]
			VM_NOMNF :=VM_RETORN[14]	//
			VM_CARNE :=VM_RETORN[15]	// Imprimir Carne ?
			
		elseif PARAMETRO->PA_CFTIPOF==1
			VM_RETORN:=Fechar_1(VM_TOT,'V')
			VM_DESCG :=VM_RETORN[03]
			VM_PARCE :=VM_RETORN[04]	// Nr Parcelas
			VM_ENCFI :=VM_RETORN[06]
			VM_VLRENT:=VM_RETORN[07]
			VM_FAT   :=VM_RETORN[12]   // Parcelamento
			VM_DINH  :=VM_RETORN[07]
			VM_CLI   :=VM_RETORN[13]
			VM_NOMNF :=VM_RETORN[14]	//
			VM_CARNE :=VM_RETORN[15]	// Imprimir Carne ?
		end
		*------------------------------------------------------Soma Vlr das Parcelas
		vParcelas:=0
		if len(VM_FAT)>0
			aeval(VM_FAT,{|DET|vParcelas+=DET[3]})
		end

		@24,55 say "Troco...: "+transform(abs((VM_TOT+VM_ENCFI-VM_DESCG)-VM_DINH-vParcelas),masc(5)) color 'W/R'
		select('PEDCAB')
		dbgobottom()
		dbskip()
		VM_OPC:=alert('Concluir Venda ?',{'SIM','Retorna Fechamento'})
		if VM_OPC==1		//................. Sim
			FLAG_LOOP:=.F.
			pb_msg('Fechando Cupom...')
			CF_FechCup(VM_TOT,VM_ENCFI,VM_DESCG,VM_NOMNF,VM_FAT,VM_DINH,1,{})
			CFEPCFIM(VM_FAT,.F.)	//........... Impressora Fiscal
		elseif VM_OPC==0	//................. Esc
			FLAG_LOOP:=.T.
		elseif VM_OPC==2	//................. Sim Altera Cliete
		end
	end
	if VM_CARNE=='S'
		if VM_PARCE>0
			fn_impcarne(VM_CLI,VM_NOMNF,VM_FAT,VM_DTEMI)
		end
	end
else
	return .F.
end
DbGoTop()
return .T.

*-----------------------------------------------------------------------------*
 static function CF_DigItens(VM_DET,ORD,P1) // Digitar Itens (P1=L=Inclusao ?)
*-----------------------------------------------------------------------------*
local VM_PROD  :=VM_DET[ORD,02]
local VM_QTD   :=if(VM_DET[ORD,04]>0,VM_DET[ORD,04],1)
local VM_VLVEN :=VM_DET[ORD,05]
local VM_ENCFID:=VM_DET[ORD,07]
local VM_CODTR :=VM_DET[ORD,08]
local VM_ICMSP :=if(VM_PROD>0,VM_DET[ORD,09],VM_ICMSPG)
local VM_PTRIB :=if(empty(VM_DET[ORD,11]),100,VM_DET[ORD,11])
local VM_CFTRIB:=if(empty(VM_DET[ORD,13]),"03",VM_DET[ORD,13])
local VM_ICMS  :={}
local VM_VLVENX:=0
local         X:=row()
local         Z

	pb_msg('<ESC> seleciona linha escluir item  F10-Sai   F12-Altera Qtde',NIL,.F.)
	set function 10 to chr(27)+chr(27)
	setkey(K_F12,{||INPUT_QTD(X,@VM_QTD)})	// F9-Chama Selecao de Impressora

@X,05 get VM_PROD   pict masc(21) valid VM_PROD=-1.or.(fn_codpr(@VM_PROD,77).and.fn_rtunid(VM_PROD)).and.fn_sdest(-VM_QTD+VM_DET[ORD,12],@VM_VLVEN,VM_PARCE) 		when P1
if PARAMETRO->PA_EDQCUP
	@X,51 get VM_QTD pict masc(06) valid VM_QTD>=0.and.fn_valqt(VM_QTD,30)
end
if PARAMETRO->PA_EDVCUP
	@X,62 get VM_VLVEN pict masc(02) valid VM_VLVEN>0
end
read
set function 10 to
if lastkey()#K_ESC
	if VM_PROD>0
		@05,50 Say CF_Advert() color 'W/R*+'
		if !LOG_ABERTO
			LOG_ABERTO:=CF_ImprAbert()
		end
		if VM_DET[ORD,2]>0 // ja tem cadastro - excluir
			//.........................................................Cancelar ITEM
			if trim(VM_DET[ORD,03])==CF_ITEM_CAN
				alert('*** Item ja excluido ***')
			elseif pb_sn('Excluir Item '+pb_zer(ORD,2))
				ImprFisc("31|"+pb_zer(ORD,4)+"|") //....................Impressao da linha = produto
				VM_DET[ORD,03]:=CF_ITEM_CAN
				VM_DET[ORD,02]:= 0
				VM_DET[ORD,04]:= 0
				VM_DET[ORD,05]:= 0
				VM_DET[ORD,06]:= 0
				VM_DET[ORD,07]:= 0
				VM_DET[ORD,08]:= '000'
				VM_DET[ORD,09]:= 0
				VM_DET[ORD,10]:= 0
				VM_DET[ORD,11]:= 0
				VM_DET[ORD,13]:= 0
				VM_DET[ORD,14]:= 0.00
				VM_DET[ORD,15]:= 0.00
				VM_DET[ORD,18]:= 'II'
			end
		else
			VM_DET[ORD,02]:=VM_PROD
			VM_DET[ORD,03]:=PROD->PR_DESCR
			VM_DET[ORD,04]:=VM_QTD
			VM_DET[ORD,05]:=VM_VLVEN
			VM_DET[ORD,06]:=round(VM_QTD * VM_VLVEN, 2) // total
			VM_DET[ORD,07]:=VM_ENCFID
			VM_DET[ORD,08]:=if(empty(PROD->PR_CODTR),'000',PROD->PR_CODTR)
			VM_DET[ORD,09]:=PROD->PR_PICMS
			VM_DET[ORD,10]:=PROD->PR_UND
			CODTR->(dbseek(VM_DET[ORD,8]))
			VM_DET[ORD,11]:=CODTR->CT_PERC
			VM_DET[ORD,13]:=0  // registro pd
			VM_DET[ORD,14]:=pb_divzero(PROD->PR_VLATU,PROD->PR_QTATU)
			VM_DET[ORD,15]:=round((VM_DET[ORD,6] * VM_DET[ORD,9] / 100 ) * VM_DET[ORD,11] / 100 , 2)
			if !empty(VM_DET[ORD,18]) 
				VM_DET[ORD,18]:=PROD->PR_CFTRIB  // IMPRESSORA FISCAL
			end
			if !CF_ImprItem(VM_DET[ORD])
				VM_DET[ORD,02]:= 0
				VM_DET[ORD,03]:= replicate('.',20)
				VM_DET[ORD,04]:= 0
				VM_DET[ORD,05]:= 0
				VM_DET[ORD,06]:= 0
				VM_DET[ORD,07]:= 0
				VM_DET[ORD,08]:= '000'
				VM_DET[ORD,09]:= 0
				VM_DET[ORD,10]:= 0
				VM_DET[ORD,11]:= 0
				VM_DET[ORD,13]:= 0
				VM_DET[ORD,14]:= 0.00
				VM_DET[ORD,15]:= 0.00
				VM_DET[ORD,18]:= 'II'
			end
		end
	else
		VM_DET[ORD,02]:= 0
		VM_DET[ORD,03]:= replicate('.',20)
		VM_DET[ORD,04]:= 0
		VM_DET[ORD,05]:= 0
		VM_DET[ORD,06]:= 0
		VM_DET[ORD,07]:= 0
		VM_DET[ORD,08]:= '000'
		VM_DET[ORD,09]:= 0
		VM_DET[ORD,10]:= 0
		VM_DET[ORD,11]:= 0
		VM_DET[ORD,13]:= 0
		VM_DET[ORD,14]:= 0.00
		VM_DET[ORD,15]:= 0.00
		VM_DET[ORD,18]:= 'II'
	end
	VM_ICMS          :=FN_ICMSC(VM_DET) // retorna array ICMS
	VM_TOT           :=0
	aeval(VM_DET,{|VM_DET1|VM_TOT+=VM_DET1[6]})
	MOSTRA_NUM(1,str(VM_TOT,7,2))
end
setkey(K_F12,{||NIL})
return (VM_ICMS)

*-----------------------------------------------------------------------------*
static function INPUT_QTD(P1,P2)
*--------------------------------------------------------------------------
local GetList:={}
@P1,50 get P2 pict masc(6) valid P2>=0.and.fn_valqt(P2,30)
read
set cursor ON
return NIL

*--------------------------------------------------------------------------
 static function FN_VALQT(P1,P2)
*--------------------------------------------------------------------------
local RT:=.T.
if P1>P2 
	beeperro()
	beeperro()
	beeperro()
	keyboard ''
	RT:=pb_sn('A D V E R T E N C I A;Quantidade deve ser confirmada;Continuar ?')
end
return RT

*--------------------------------------------------------------------------
	function CF_FECHA()
*--------------------------------------------------------------------------
Alert('----<Comando Incorreto>-----;Alterar menu;CF_FECHA = CF_RES_ERRO()')
CF_RES_ERRO()
INKEY(2)
return NIL
