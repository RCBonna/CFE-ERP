#include 'RCB.CH'

*-----------------------------------------------------------------------------*
function CFEP7240()	//	Parametros Venda Balcao
*-----------------------------------------------------------------------------*
local VM_X
local VM_P1
pb_lin4('Altera dados b sicos',ProcName())

if !abre({	'E->PARAMETRO'})
	return NIL
end
for VM_X:=1 to fcount()
	VM_P1 :="VM"+substr(fieldname(VM_X),3)
	&VM_P1:=&(fieldname(VM_X))
end
VM_EDVCUP:=if(PA_EDVCUP,'S','N')
VM_EMCUFI:=if(PA_EMCUFI,'S','N')
VM_CONVEN:=if(PA_CONVEN,'S','N')
VM_VBPEAT:=if(PA_VBPEAT,'S','N')
VM_VZIPD :=if(empty(PA_VZIPD),1,PA_VZIPD)
VM_VZIPD :=if(empty(PA_TIPPD),1,PA_TIPPD)
VM_OBS1  :=left(PA_OBSCUP,40)
VM_OBS2  :=right(PA_OBSCUP,40)
pb_box(,,16,79,,'Altera dados B sicos-Venda Balcao')
@06,01 say 'Empresa........: '+VM_EMPR
@08,01 say 'Atualizar Pedido a partir da Digitacao ?'  get VM_VBPEAT pict masc(01) valid VM_VBPEAT$'SN' when pb_msg('Pede atualização')
@09,01 say 'Tipo de Impressao do Pedido (1,2,3)     '  get VM_TIPPD   pict mI2     valid VM_TIPPD>0     when pb_msg('<1>Pedido Normal  <2>Pedido Reduzido (33L) <3>Bematech 4200')
@10,01 say 'Numero de Vezes para Imprimir o Pedido  '  get VM_VZIPD   pict mI2     valid VM_VZIPD>0     when pb_msg('Nro de vezes p/Imprimir Pedido')
@11,01 say 'Validar Compra/Dupl Atraso/Tempo Compra '  get VM_VBCHKMO pict mI2     valid VM_VBCHKMO>=0.and.VM_VBCHKMO<4 when pb_msg('<0>Sem validar - Sem Compra <1> +3 Meses <2> +6 Meses <3> + 12 Meses')

@13,01 say 'OBS-1..........:' get VM_OBS1    pict masc(23) when pb_msg('OBS-1')
@14,01 say 'OBS-2..........:' get VM_OBS2    pict masc(23) when pb_msg('OBS-2')
read
if if(lastkey()#K_ESC,pb_sn(),.F.)
	VM_EDVCUP:=(VM_EDVCUP=='S')
	VM_EMCUFI:=(VM_EMCUFI=='S')
	VM_CONVEN:=(VM_CONVEN=='S')
	VM_VBPEAT:=(VM_VBPEAT=='S')
	VM_OBSCUP:=VM_OBS1+VM_OBS2
	for VM_X :=1 to fcount()
		VM_P1 :="VM"+substr(fieldname(VM_X),3)
		replace &(fieldname(VM_X)) with &VM_P1
	end
end
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
function CFEP7250()	//	Outros Parametros 
*-----------------------------------------------------------------------------*
local VM_X
local VM_P1
local CHKCGCCPFCli
private VM_CTCLP
pb_lin4(_MSG_,ProcName())
if !abre({	'C->CTADET',;
				'C->CTATIT',;
				'C->PARALINH',;
				'E->PARAMETRO'})
	return NIL
end
for VM_X:=1 to fcount()
	VM_P1 :="VM"+substr(fieldname(VM_X),3)
	&VM_P1:=&(fieldname(VM_X))
end

CHKCGCCPFCli:=left(PLinha('Validar CPF/CNPJ Zero','N'),1)

pb_box(,,,,,'Altera Parametros Contas Receber/Pagar')
@06,01 say 'Contas a Receber' color 'GR+/G'
@07,01 say '- Tipo de Recibo........:' 			get VM_RECICR  pict mI1		valid VM_RECICR$'0123'	when pb_msg('Impressao Recibo : 0=Nao   1=Normal    2=Super Comprimido  3=Bematech')
@08,01 say '- Dias de Carencia Juros:' 			get VM_CARENCR pict mI3		valid VM_CARENCR>=0		when pb_msg('Dias de Carencia para NAO cobrar Juros de pagamentos em atrasos')
@09,01 say '- Juros por Atraso (max):'				get VM_PJUROS  pict mI52	valid VM_PJUROS>=0		when pb_msg('Juros Maximo por pagamento em atraso')
@10,01 say '- Juros por Atraso (min):'				get VM_PJUROSM pict mI52	valid VM_PJUROSM>=0.and.VM_PJUROSM<=VM_PJUROS		when VM_PJUROS>0.and.pb_msg('Juros Minomo por pagamento em atraso')

@12,01 say 'Contas a Pagar' color 'GR+/G'
@13,01 say '- Tipo de Recibo................:'	get VM_RECICP  pict mI1 valid VM_RECICP$'0123' 						when pb_msg('Impressao Recibo : 0=Nao   1=Normal    2=Super Comprimido  3=Bematech')
@14,01 say '- Porta de Impressao dos Cheques:'	get VM_PORCHE  pict mI1      valid VM_PORCHE>0.and.VM_PORCHE<4

@16,01 Say 'Tipo de Cadastro de Cliente.....:' get VM_CADCLI    pict mUUU  Valid VM_CADCLI$' RC'   when pb_msg('C=Completo   R=Resumido')
@17,01 Say 'Valida CPF/CNPJ Zerados.........:' get CHKCGCCPFCli pict mUUU  Valid CHKCGCCPFCli$'SN' when pb_msg('Valida no cadastro de Cliente CNPJ/CPF zerados->Nao permitir')

if PARAMETRO->PA_CONTAB==USOMODULO
	@19,01 say 'Conta Contabil Ganho na Equiv Produt:' get VM_CTBRET  pict mI4   valid if(VM_CTBRET==0,.T.,fn_ifconta(@VM_CTCLP,@VM_CTBRET)) when PARAMETRO->PA_CONTAB==USOMODULO
	@20,01 say 'Conta Contabil Perda na Equiv Produt:' get VM_CTBBON  pict mI4   valid if(VM_CTBBON==0,.T.,fn_ifconta(@VM_CTCLP,@VM_CTBBON)) when PARAMETRO->PA_CONTAB==USOMODULO
end
read
if if(lastkey()#K_ESC,pb_sn(),.F.)
	VM_CADCLI:=if(empty(VM_CADCLI),'R','C')
	for VM_X:=1 to fcount()
		VM_P1:="VM"+substr(fieldname(VM_X),3)
		replace &(fieldname(VM_X)) with &VM_P1
	end
	SLinha('Validar CPF/CNPJ Zero',CHKCGCCPFCli)
end
dbcloseall()
return NIL
//-------------------------------------------EOF---------------------------------