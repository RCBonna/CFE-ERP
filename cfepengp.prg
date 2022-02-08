//-----------------------------------------------------------------------------*
  static aVariav:= {{} }
//...................1.2...3..4....5..6..7..8.9.10..11.12.13..14..15.16, 17
//-----------------------------------------------------------------------------*
#xtranslate aCusFix  => aVariav\[ 1 \]

*-----------------------------------------------------------------------------*
 function CFEPENGP()	// Cadastro de Itens de Engenharia 								*
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

Conta1:=Plinha('ContaCustoFixoMO' ,16,'N')
Conta2:=Plinha('ContaCustoFixoOUT',16,'N')
Conta3:=Plinha('ContaCustoFixoEst',16,'N')
ContaX:=0
Valor1:=Plinha('VlrCustoFixoMO'   ,16,'N')
Valor2:=Plinha('VlrCustoFixoOUT'  , 4,'N')
pb_box(13,1,,,,'Parametros producao')
@15,2 say 'C-Conta Ctb Custo Fixo Mao-de-Obra:' get Conta1 Pict mI4 valid fn_ifconta(@ContaX,@Conta1)
@16,2 say 'C-Conta Ctb Custo Fixo Outros.....:' get Conta2 Pict mI4 valid fn_ifconta(@ContaX,@Conta2)
@17,2 say 'D-Conta Ctb Custo Fixo Estoque....:' get Conta3 Pict mI4 valid fn_ifconta(@ContaX,@Conta3)
@19,2 say 'Valor por Tonelada CF Mao-de-Obra.:' get Valor1 pict mD82 valid Valor1>=0
@20,2 say 'Valor por Tonelada CF Outros......:' get Valor2 pict mD82 valid Valor2>=0
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	Conta1:=Slinha('ContaCustoFixoMO' ,Conta1)
	Conta2:=Slinha('ContaCustoFixoOUT',Conta2)
	Conta3:=Slinha('ContaCustoFixoEst',Conta3)
	Valor1:=Slinha('VlrCustoFixoMO'   ,Valor1)
	Valor2:=Slinha('VlrCustoFixoOUT'  ,Valor2)
end
dbcommit()
dbcloseall()
return NIL
