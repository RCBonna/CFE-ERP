//-----------------------------------------------------------------------------*
  static aVariav:= {{} }
//...................1.2...3..4....5..6..7..8.9.10..11.12.13..14..15.16, 17
//-----------------------------------------------------------------------------*
#xtranslate aCusFix  => aVariav\[ 1 \]

*-----------------------------------------------------------------------------*
	function PARACTBF()	// Cadastro de Contabilização Fretes							*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

if !abre({	'R->PARAMETRO',;
				'C->CTADET',	;
				'C->DIARIO',	;
				'C->CTATIT',	;
				'C->PARALINH'  ;
				})
	return NIL
end
pb_tela()
pb_lin4(_MSG_,ProcName())

//Frete A Pagar--------------------------------------
//D-Cliente/Caixa
//C-Receita Frete
//D-ICMS Sobre Frete
//C-ICMS A Recuperar
//D-PIS sobre Frete (1,65%)
//C-PIS A Recuperar
//D-COFINS sobre Frete (7,6%)
//C-COFINS a Recuperar

//Frete Pago--------------------------------------
//D-Despesa com Frete
//C-Fornecedor/Caixa

//D-Despesa com ICMS
//C-ICMS A Recuperar
//D-Despesa PIS  (1,65%)
//C-PIS A Recuperar
//D-Despesas com COFINS (7,6%)
//C-COFINS a Recuperar

ContaX:=0
Conta1:=Plinha('ContaReceitaFrete'   ,16,'N')	// Crédito
Conta2:=Plinha('ContaICMSFrete'      ,16,'N')	//	Deb
Conta3:=Plinha('ContaICMSRecuperar'  ,16,'N')
Conta4:=Plinha('ContaPISFrete'       ,16,'N')
Conta5:=Plinha('ContaPISRecuperar'   ,16,'N')
Conta6:=Plinha('ContaCOFINSFrete'    ,16,'N')
Conta7:=Plinha('ContaCOFINSRecuperar',16,'N')
Conta8:=Plinha('ContaDespesaFrete'   ,16,'N')
Conta9:=Plinha('ContaDespesaICMS'    ,16,'N')
ContaA:=Plinha('ContaDespesaPIS'     ,16,'N')
ContaB:=Plinha('ContaDespesaCOFINS'  ,16,'N')

pb_box(05,00,23,,,'Parametros Contabeis Conhecimento Frete')
@05,01 say padc('CONTAS CONTABEIS - FRETE A PAGAR',78) color 'R/W'
@06,01 say 'D-Cliente / Caixa...: XXXX -Busca Tipo Cliente' color 'GR+/G'
@07,01 say 'C-Receita   Frete...:' get Conta1 Pict mI4 valid fn_ifconta(@ContaX,@Conta1)
@08,01 say 'D-ICMS   s/ Frete...:' get Conta2 Pict mI4 valid fn_ifconta(@ContaX,@Conta2)
@09,01 say 'C-ICMS a Recuperar..:' get Conta3 Pict mI4 valid fn_ifconta(@ContaX,@Conta3)
@10,01 say 'D-PIS    s/ Frete...:' get Conta4 Pict mI4 valid fn_ifconta(@ContaX,@Conta4)
@11,01 say 'C-PIS a Recuperar...:' get Conta5 Pict mI4 valid fn_ifconta(@ContaX,@Conta5)
@12,01 say 'D-COFINS s/ Frete...:' get Conta6 Pict mI4 valid fn_ifconta(@ContaX,@Conta6)
@13,01 say 'C-COFINS a Recuperar:' get Conta7 Pict mI4 valid fn_ifconta(@ContaX,@Conta7)

@14,01 say padc('CONTAS CONTABEIS - FRETE PAGO',78) color 'R/W'

@15,01 say 'D-Despesa c/ Frete..:' get Conta8 Pict mI4 valid fn_ifconta(@ContaX,@Conta8)
@16,01 say 'C-Fornecedor/Caixa..: XXXX -Busca Tipo Fornecedor' color 'GR+/G'
@17,01 say 'D-Despesa c/ICMS....:' get Conta9 Pict mI4 valid fn_ifconta(@ContaX,@Conta9)
@18,01 say 'C-ICMS a Recuperar..: XXXX -Mesma Conta Acima' color 'GR+/G'
@19,01 say 'D-Despesa c/PIS.....:' get ContaA Pict mI4 valid fn_ifconta(@ContaX,@ContaA)
@20,01 say 'C-PIS  a Recuperar..: XXXX -Mesma Conta Acima' color 'GR+/G'
@21,01 say 'D-Despesas c/COFINS.:' get ContaB Pict mI4 valid fn_ifconta(@ContaX,@ContaB)
@22,01 say 'C-COFINS a Recuperar: XXXX -Mesma Conta Acima' color 'GR+/G'

read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	Conta1:=Slinha('ContaReceitaFrete'   ,Conta1)	// Crédito
	Conta2:=Slinha('ContaICMSFrete'      ,Conta2)	//	Deb
	Conta3:=Slinha('ContaICMSRecuperar'  ,Conta3)
	Conta4:=Slinha('ContaPISFrete'       ,Conta4)
	Conta5:=Slinha('ContaPISRecuperar'   ,Conta5)
	Conta6:=Slinha('ContaCOFINSFrete'    ,Conta6)
	Conta7:=Slinha('ContaCOFINSRecuperar',Conta7)
	Conta8:=Slinha('ContaDespesaFrete'   ,Conta8)
	Conta9:=Slinha('ContaDespesaICMS'    ,Conta9)
	ContaA:=Slinha('ContaDespesaPIS'     ,ContaA)
	ContaB:=Slinha('ContaDespesaCOFINS'  ,ContaB)
end
dbcommit()
dbcloseall()
return NIL
*--------------------------------------------------------------EOF-----------------------

