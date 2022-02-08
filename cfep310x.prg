*-----------------------------------------------------------------------------*
static aVariav2:= {0,0,.T. }
 //.................1.2..3
#xtranslate nX    => aVariav2\[  1 \]

#include 'RCB.CH'

*-----------------------------------------------------------------------------*
 function CFEP310X()	//	Cadastro de Clientes
*-----------------------------------------------------------------------------*

pb_lin4(_MSG_,ProcName())
if !abre({	'R->PARAMETRO',;
				'C->PARALINH',;
				'C->VENDEDOR',;
				'C->CLIENTE'})
	return NIL
end
select('CLIENTE')
dbsetorder(2) // Ord Alfabetica
set relation to str(CL_VENDED,3) into VENDEDOR
DbGoTop()

pb_dbedit1('CFEP310X','AlteraProcur')  // tela
private VM_CABE :={'Cliente','Vendedores','Dt.Ult.Comp','Vlr Limit Cred'}
private VM_CAMPO:={	'pb_zer(CL_CODCL,5)+chr(45)+left(CL_RAZAO,35)',;
							'pb_zer(CL_VENDED,3)+chr(45)+left(VENDEDOR->VE_NOME,27)',;
							'CL_DTUCOM',;
							'CL_LIMCRE'}

dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',,VM_CABE)
dbcloseall()
return NIL

*-------------------------------------------------------------------* Fim
function CFEP310X1() // Rotina de Alteração
*-------------------------------------------------------------------* Fim
if reclock()
	nX     :=MaxRow()-6
	VM_VENDED:=CL_VENDED
	VM_DTUCOM:=CL_DTUCOM
	VM_LIMCRE:=CL_LIMCRE
	pb_box(nX++,MaxCol()-40,MaxRow()-2,MaxCol(),,'Informe')
	@nX++,MaxCol()-38 say 'Cod.Vendedor..:' get VM_VENDED pict mI3 valid if(VM_VENDED==0,.T.,fn_codigo(@VM_VENDED,{'VENDEDOR',{||VENDEDOR->(dbseek(str(VM_VENDED,3)))},{||CFEP5610T(.T.)},{2,1}})) when pb_msg('<Zero> Qualquer Vendedor ou Informe um Vendedor')
	@nX++,MaxCol()-38 say 'DT.Ult.Compra.:' get CL_DTUCOM pict mDT when pb_msg('Atualiza DT de validacao do Cadastro do Cliente')
	@nX++,MaxCol()-38 say 'Vlr Limit Cred:' get VM_LIMCRE pict mI92 valid VM_LIMCRE>=0 when pb_msg('<zero> Sem Limite ou um Valor para validar as compras')	
	READ
	if if(lastkey()#K_ESC,pb_sn(),.F.)
		replace 	CL_VENDED with VM_VENDED,;
					CL_DTUCOM with VM_DTUCOM,;
					CL_LIMCRE with VM_LIMCRE
	end
	dbrunlock(recno())
end
return NIL

*-----------------------------------------------------------------------------*
function CFEP310X2() // Rotina de Pesquisa
*-------------------------------------------------------------------* 
CFEP3103()
return NIL

*---------------------------------------------------------------EOF-----------------------------------------
