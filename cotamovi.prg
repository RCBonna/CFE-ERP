*-----------------------------------------------------------------------------*
function CotaMovi()	//	Edita Cota parte
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
if !abre({	'R->PARAMETRO','C->CLIENTE',;
				'E->COTAS',		'E->COTAMV'})
	return NIL
end

pb_tela()
pb_lin4(_MSG_,ProcName())
set relation to str(COTAMV->MV_CODCL,5) into CLIENTE
pb_dbedit1("COTAMOVI","OrdCliOrdDatExclui")
VM_CAMPO := array(9)
afields(VM_CAMPO)
VM_CAMPO[1]:='pb_zer(MV_CODCL,5)+chr(45)+left(CLIENTE->CL_RAZAO,30)'
VM_CAMPO[8]:='if(MV_FLCTB,"Sim","Nao")'
VM_CAMPO[9]:='if(MV_FLCXA,"Sim","Nao")'

VM_MUSC:={       mXXX,      mDT,    mD82, mUUU,  mI3,  mI3, mI6,   mUUU,   mUUU }
VM_CABE:={"Associado","Dt Lcto", "Valor",  "T",'Bco','Cxa','Docto','FlCtb','FlCxa' }

dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,"PB_DBEDIT2",VM_MUSC,VM_CABE)
dbcloseall()
return NIL

//---------------------------> Ordem Codigo
function COTAMOVI1()
local CodCL:=MV_CODCL
pb_box(19,50,,,,'Selecione')
@21,52 get CodCl pict mI5
read
if lastkey()#K_ESC
	dbseek(str(CodCl,5),.T.)
end
return NIL

//---------------------------> Ordem Data
function COTAMOVI2()
local Data:=MV_DATA
pb_box(19,50,,,,'Selecione')
@21,52 get Data pict mDT
read
if lastkey()#K_ESC
	dbseek(dtos(Data),.T.)
end
return NIL

//---------------------------> Excluir
function COTAMOVI3()
if reclock().and.pb_sn('Excluir Movimento Associado;' + &(VM_CAMPO[1])+';Valor:'+transform(MV_VALOR,mD82))
	fn_elimi()
end
dbrunlock()
return NIL
