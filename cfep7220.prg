*-----------------------------------------------------------------------------*
	function CFEP7220()	//	Atualiza Parametros Faturamento								*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local X
local VM_P1
pb_lin4('Altera Parametro Faturamento',ProcName())
if !abre({'E->PARAMETRO'})
	return NIL
end
for X:=1 to fcount()
	VM_P1 :="VM"+substr(fieldname(X),3)
	&VM_P1:=fieldget(X)
end
VM_CONTAB:=if(PA_CONTAB=chr(255)+chr(25),'YY','NN')
VM_CHKVEN:=if(PA_CHKVEN=chr(255)+chr(25),'YY','NN')
VM_VENDED:=if(PA_VENDED=chr(255)+chr(25),'YY','NN')
VM_LIMEST:=if(PA_LIMEST,'S','N')

pb_box(,,,,,'Parametro Faturamento')
@06,01 say 'Empresa........: '+VM_EMPR
@07,01 say 'Moeda Utilizada:' get VM_MOEDA     pict masc(1)     valid !empty(VM_MOEDA)
@08,01 say 'Dias Hist.Forne:' get VM_HTFOR     pict masc(4)     valid VM_HTFOR>=0
@08,29 say 'Dias Hist.Clien:' get VM_HTCLI     pict masc(4)     valid VM_HTCLI>=0
@08,59 say 'Limpeza Anual..:' get VM_LIMANUA   pict mUUU        valid VM_LIMANUA$'SN' 						when pb_msg('Na rotina fechamento ANUAL Executar LIMPEZA dados DE NF')

@10,01 say 'Imprime Empresa no cabecalho do Pedido?' get VM_PEDCAB pict mUUU valid VM_PEDCAB$'SN'
@11,01 say 'Limpar Movimentacao Estoque do Mes    ?' get VM_LIMEST pict mUUU valid VM_LIMEST$'SN'

@12,01 say 'N§ Cadastro SPC:' get VM_NRASPC  pict masc(04)
@12,29 say 'N§ Dias 1§Pgto.:' get VM_1PGTO   pict masc(11)      valid VM_1PGTO>=0.and.VM_1PGTO<=60
@12,55 say 'Outros Pgtos...:' get VM_OPGTO   pict masc(11)      valid VM_OPGTO>=15

@11,55 say 'Tipo Vc Data...:' get VM_TPPRZ   pict mUUU          valid VM_TPPRZ$'DM'							when pb_msg('D=Vcto sempre no mesmo dia seguinte        M=Vcto a cada 30 dias do mes')
@13,01 say 'Tipo de Carne..:' get VM_TIPOCAR pict mI1           valid VM_TIPOCAR>=0.and.VM_TIPOCAR<=2 when pb_msg('Tipo Carne Pagto <0>Normal   <1>Com Compromisso   <2>Bematech MP-4200 TH')
@13,29 say 'Tipo Dpl Venda.:' get VM_TIPODPL pict mI1           valid VM_TIPODPL>=0.and.VM_TIPODPL<=1 when pb_msg('Tipo NR Duplicata  <0>=Numero NF     <1>=Numero Pedido')
@13,55 say 'Cad.Cli Complet?' get VM_FICHCLI pict mUUU 			 valid VM_FICHCLI$'SN' 						when pb_msg('Na impressao de cadastro (ficha) de cliente imprimir dados adicionais')

@14,01 say 'M¢dulo Vendedor:' get VM_VENDED  pict masc(1)       color 'W*/W'
@14,29 say 'M¢dulo Contabil:' get VM_CONTAB  pict masc(1)       color 'W*/W'
@15,01 say 'CHK VLR Venda?.:' get VM_CHKVEN  pict masc(1)       color 'W*/W'

@16,01 say '% Funrural.....:' get VM_FUNRUR  pict mI52			valid VM_FUNRUR>=0

@17,01 say '%Acres.Financ..:' get VM_DESCV   pict mI52			valid VM_DESCV>=0  when pb_msg("")
@17,29 say '%Juros Mora Rec:' get VM_PJUROS  pict mI52			valid VM_PJUROS>=0 when pb_msg('Informe % de juros para Recebimento = Quando pago fora da data')

@18,01 say '%COFINS........:' get VM_COFIN   pict mI52			valid VM_COFIN>=0  when pb_msg("")
@18,29 say '%PIS...........:' get VM_PRPIS   pict mI52			valid VM_PRPIS>=0

@19,01 say '%Enc. Sociais..:' get VM_ENCAR   pict mI52			valid VM_ENCAR>=0
@19,29 say '%Salarios......:' get VM_SALAR   pict mI52			valid VM_SALAR>=0

@20,01 say '%Despesas DVS..:' get VM_DESPE   pict mI52			valid VM_DESPE>=0
@20,29 say '(-)%Prev.ICMS-S:' get VM_ICMSS   pict mI52			valid VM_ICMSS>=0

@21,01 say '(-)%Out.Imposto:' get VM_IMPOU   pict mI52			valid VM_IMPOU>=0
@21,29 say '%Lucro.........:' get VM_LUCRO   pict mI62			valid VM_LUCRO>=0

@17,55 say 'Tipo Zoom Prod.:' get VM_ZOOMPRD pict mI2				valid VM_ZOOMPRD>=0.and.VM_ZOOMPRD<=1  when pb_msg("0-Normal 1-Com Preco Custo")
@18,55 say 'Casa Dec.VVenda:' get PA_NRDECVE pict mI2				valid PA_NRDECVE=2.or.PA_NRDECVE=3     when pb_msg("2 ou 3 casas decimais para valor unitario de venda")

read
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if VM_VENDED='YY'
		VM_VENDED:=chr(255)+chr(25)
	end
	if VM_CONTAB='YY'
		VM_CONTAB:=chr(255)+chr(25)
	end
	if VM_CHKVEN='YY'
		VM_CHKVEN:=chr(255)+chr(25)
	end
	VM_LIMEST:=(VM_LIMEST=='S')
	for X:=1 to fcount()
		VM_P1:="VM"+substr(fieldname(X),3)
		replace &(fieldname(X)) with &VM_P1
	end
end
dbcloseall()
return NIL
//-------------------------------------------------------EOF--------------------------------