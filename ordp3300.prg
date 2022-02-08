*-----------------------------------------------------------------------------*
function ORDP3300()	//	Ficha tecnica														*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

pb_lin4(_MSG_,ProcName())

if !abre({'E->CLIENTE','E->PROD','E->PARAMORD','E->MECMAQ','E->MOVORDEM',;
			 'E->ATIVIDAD','E->ORDEM','E->EQUIDES'})
	return NIL
end
PROD->(dbsetorder(2))
MOVORDEM->(dbsetorder(3))
VM_CODED :=ED_CODIG
VM_FLNOME:='N'
pb_box(19,20)
@20,22 say padr('Listar <N>=Nome A=Atividade',26,'.')       get VM_FLNOME pict masc(01) valid VM_FLNOME$'NA'
@21,22 say padr('C¢digo '+trim(PARAMORD->PA_DESCR2),26,'.') get VM_CODED pict masc(1) valid fn_codigo(@VM_CODED,{'EQUIDES',{||EQUIDES->(dbseek(VM_CODED))},,{2,1}})
read
if if(lastkey()#K_ESC,pb_ligaimp(chr(18)),.F.)
	VM_REL:='Ficha Tecnica '+trim(PARAMORD->PA_DESCR2)
	VM_LAR:=78
	VM_PAG:= 0
	select('ORDEM')
	ordem EQUIPA
	dbseek(VM_CODED,.T.)
	while VM_CODED==ORDEM->OR_CODED
		CLIENTE->(dbseek(str(ORDEM->OR_CODCL,5)))
		ORDP310I(ORDEM->OR_CODOR)
		select('ORDEM')
		dbskip()
	end
	eject
	pb_deslimp()
end
dbcloseall()
return NIL
