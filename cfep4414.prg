*-----------------------------------------------------------------------------*
 static aVariav := {{}, 0,'T',.F. }
 //.................1...2..3...4...5..6...7...8...9, 10, 11, 12,13,14,15
*-----------------------------------------------------------------------------*
#xtranslate aLinDet    => aVariav\[  1 \]
#xtranslate nX         => aVariav\[  2 \]
#xtranslate cTipoDev   => aVariav\[  3 \]
#xtranslate lFlag      => aVariav\[  4 \]

#include 'RCB.CH'
#include 'ENTRADA.CH'

*-----------------------------------------------------------------------------*
 function CFEP4414() // Rotina de Devolucao
*-----------------------------------------------------------------------------*
nao(ProcName())
pb_tela()
pb_lin4(_MSG_,ProcName())
nDOCTO:=0
TSERIE:=space(3)
FORNEC :=0
pb_box(5,0,22,79,'Nota Fiscal Devolucao')
@06,01 say 'Emitente....:' get FORNEC   pict mI5  valid fn_codigo(@FORNEC,{'CLIENTE',{||CLIENTE->(dbseek(str(FORNEC,5)))},{||CFEP3100T(.T.)},{2,1,8,7}})
@07,01 say 'Serie.......:' get TSERIE   pict mUUU valid TSERIE==SCOLD.or.fn_codigo(@TSERIE,{'CTRNF',{||CTRNF->(dbseek(TSERIE))},{||CFEPATNFT(.T.)},{2,1,3,4}})
@08,01 say 'Documento...:' get nDOCTO   pict mI8  valid pb_ifcod2(str(nDOCTO,8)+TSERIE+str(FORNEC,5),'ENTCAB',.T.,1)
@09,01 say 'Tp Devolucao:' get cTipoDev pict mUUU valid cTipoDev$'TP' when pb_msg('Tipo de devolucao      T=Total      P=Parcial')
read
if pb_sn()
	if cTipoDev=='T'
		PRODUTOS:=DetProdEnt('R') // INICIALIZAR
	else
		
	end
end
return NIL
//---------------------------------------------EOF-------------------------------------
