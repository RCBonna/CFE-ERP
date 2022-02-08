*-----------------------------------------------------------------------------*
function CFEPVEBE()	//	Alterar Pedidos/NF Atualizados								*
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
				'C->ADTOSD',;	//ADIANTAMENTO A CLIENTE - DETALHE
				'C->ADTOSC',;	//ADIANTAMENTO A CLIENTE - CABEÇALHO
				'C->NATOP'})
	return NIL
end

pb_tela()
pb_lin4('Alterar Pedidos',ProcName())
select('PROD')
dbsetorder(2) // Produtos
select('PEDCAB')
dbsetorder(1) // Todos os Pedido incl atualizados

set relation to str(PC_CODCL,5) into CLIENTE
DbGoTop()

private VM_OPC	  :=VM_TOT:=VM_CLI:=VM_VEND:=VM_ICMSPG:=VM_PARCE:=VM_DESCG:=VM_DESCIT:=VM_ULTPD:=VM_ULTDP:=VM_NSU:=0
private VM_RT    :=.T.
private VM_OBS   :=space(132)
private VM_SVC   :=space(80)
private VM_DET   :={}
private VM_FAT   :={}
private VM_ICMS  :={} // %ICMS,BASE
private VM_ICMT  :={0,0}	// Valor total ICMS, Base Total ICMS
private VM_CODFC :=space(10)
private VM_FLADTO:=if(PC_FLADTO,'S','N')

salvacor(SALVA)
setcolor('GR+/BG,R/W,,,GR+/BG')
scroll(01,01,03,50,0)
@01,01 say 'Nr.Pedido.:' get VM_ULTPD pict masc(19) valid fn_pedped(@VM_ULTPD,.T.) when pb_msg('Infome N§ Pedido')
read
if lastkey()==K_ESC
	dbcloseall()
	return NIL
elseif !reclock() // Travar Registro
	dbcloseall()
	return NIL
end

private VM_DTEMI :=PC_DTEMI
private VM_SERIE :=PC_SERIE
private VM_CODOP :=PC_CODOP
*-------------------------------------------------------Devolução
private VM_DEVNFE:=PC_NFEDEV //.Nr Chave NFE
private VM_DEVNNF:=0 //................Nr NF
private VM_DEVSER:=space(03) //........Serie
private VM_DEVDTE:=ctod('')//..........DT Emissão
*------------------------------------------------------
VM_PARCE :=PC_FATUR
VM_CLI   :=PC_CODCL
VM_VEND  :=PC_VEND
VM_TOT   :=PC_TOTAL
VM_DESCIT:=PC_DESCIT
VM_ULTDP :=VM_ULTPD
VM_OBS   :=PC_OBSER

@01,23 say 'Dt.Emissao: '+transform(VM_DTEMI,masc(07))
@01,47 say 'N§Parcelas ' +transform(VM_PARCE,masc(11))
@02,01 say 'Cliente...: '+transform(VM_CLI,masc(4))+'-'+CLIENTE->CL_RAZAO

if PARAMETRO->PA_VENDED==USOMODULO
	VENDEDOR->(dbseek(str(VM_VEND,3)))
	@03,01 say 'Vendedor..:   '+transform(VM_VEND,masc(12))+'-'+VENDEDOR->VE_NOME
end
salvacor(RESTAURA)

VM_DET :=FN_RTPRDPED(VM_ULTPD)
VM_ICMS:=FN_ICMSC(VM_DET)

	EdPrdBalcao(.F.)

dbcloseall()
return NIL

*-----------------------------------------------------------------
function FN_PEDPED1(P1) //----------BROWSE PEDIDO
local RT:=.T.
local TF:=savescreen(6,0,21,79)
if !dbseek(str(P1,6))
	DbGoTop()
	salvacor(.T.)
	setcolor('W+/B,B/W,,,,W+/B')
	dbedit(06,01,maxrow()-3,maxcol()-1,;
			{'PC_PEDID','PC_CODCL','CLIENTE->CL_RAZAO','PC_DTEMI', 'PC_CODOP'},,;
			{masc(19),   masc(4),   masc(1),            masc(8)   ,      mNAT},;
			{'N.Pedido','Codig',   'Cliente',          'Dt Emiss„o', 'NatOpe'})
	salvacor(.F.)
	P1:=PC_PEDID
	keyboard chr(13)
	RT:=.F.
	restscreen(6,0,21,79,TF)
end
return(RT)
