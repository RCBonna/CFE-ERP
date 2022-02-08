*-----------------------------------------------------------------------------*
function FN_CODPR(P1,P2)  // Verificar PRODUTO EXISTE
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local RT     :=.T.
local TF     :=savescreen(5)
local bColor :=SetColor()    // {|x| IIF( nReg % 2 == 0, {1,2}, {3,4} ) }

local ACabec :={ 'Descri‡„o',                      'Compl',                           'Qtdade',                        'Pco Venda',                               'Codigo'}
local ACampos:={;
						{'PROD->PR_DESCR', 								bColor},;
						{'left(PROD->PR_COMPL,10)',					bColor},;
						{'transform(PROD->PR_QTATU,masc(6))',		bColor},;
						{'transform(PROD->PR_VLVEN,masc(6))',		bColor},;
						{'pb_zer(PROD->PR_CODPR,'+str(L_P,2)+')',	bColor};
						}
P2:=if(valtype(P2)#'N',78,P2)
SALVABANCO
select('PROD')
dbsetorder(2)
if !dbseek(str(P1,L_P))
	dbsetorder(3)
	DbGoTop()
	if select('PARAMETRO') > 0 .and. PARAMETRO->PA_ZOOMPRD==1
		ACabec :={'Descri‡„o',                       'Compl',                           'Qtdade',                          'V.Venda',                        'V.Compra' ,                              'Codigo'}
		ACampos:={'PROD->PR_DESCR','left(PROD->PR_COMPL,10)','transform(PROD->PR_QTATU,masc(6))','transform(PROD->PR_VLVEN,masc(6))','transform(PROD->PR_VLCOM,masc(6))','pb_zer(PROD->PR_CODPR,'+str(L_P,2)+')'}
	end
	SALVACOR
	pb_box(05,00,maxrow()-2,maxcol(),'W+/RB','Cadastro de Produtos')
	pb_msg('Para incluir um PRODUTO press <INS> ou <Enter> para procurar.',NIL,.F.)
	private VM_ROT:={||CFEP4200T(.T.)}
	VM_TECLA:=''
	dbedit(06,01,maxrow()-3,maxcol()-1,ACampos,;
							'FN_TECLAx',,;
							ACabec,,,,)
	P1:=&(fieldname(2))
	RT:=.F.
	keyboard chr(iif(lastkey()==K_ESC,0,K_ENTER))
	restscreen(5,,,,TF)
	RESTAURACOR
	dbsetorder(2)
else
	@row(),col() say '-'+left(PROD->PR_DESCR,P2-col())
end
RESTAURABANCO
return(RT)
*--------------------------------[EOF]----------------------------------------