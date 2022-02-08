*-----------------------------------------------------------------------------*
function ORDPOCCA()	//	Aprovar Orcamentos												*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
if !abre({'E->CLIENTE','E->CLIOBS','E->PARAMETRO','E->PROD',;
			 'E->PARAMORD','E->MOVORDEM','E->MECMAQ','E->EQUIDES',;
			 'E->ORDEM','E->ORCADET','E->ORCACAB'})
	return NIL
end

pb_tela()
pb_lin4(_MSG_,ProcName())
if empty(PARAMORD->PA_DESCR1)
	alert('M¢dulo n„o implantando corretamente,;consulte pessoal de Suporte.')
end
PROD->(dbsetorder(2))
set relation   to str(OC_CODCL,5) into CLIENTE,;
					to OC_CODED        into EQUIDES

V_CODOC:=0
V_SEQ  :=0
pb_box(,,,,'W+/BR,N/W,,,W+/BR')
@06,02 say padr('Or‡amento N§',15,'.') get V_CODOC pict masc(19)
@06,25 say '/'                         get V_SEQ   pict masc(11) valid fn_chorca(@V_CODOC,@V_SEQ)
read
if lastkey()#K_ESC
	for X=1 to fcount()
		X1='V'+substr(fieldname(X),3)
		&X1=&(fieldname(X))
	next
	V_DTAPR:=PARAMETRO->PA_DATA
	@06,33 say      'Dt.Proposta: '+transform(V_DTPRO,masc(07))
	@06,57 say      'Dt.Validade: '+transform(V_DTVAL,masc(07))
	@07,02 say padr('C¢d.Cliente',15,'.')+pb_zer(V_CODCL,5)+'-'+CLIENTE->CL_RAZAO
	@08,02 say padr(trim(PARAMORD->PA_DESCR2),15,'.')+V_CODED+'-'+left(EQUIDES->ED_DESCR,40)
	@09,02 say 'Quantidade a Produzir: '+str(V_QUANT,7)
	@10,02 say padr('O.B.S./1',15,'.')+left(V_OBS,60)
	@11,02 say padr('O.B.S./2',15,'.')+substr(V_OBS,61)
	@13,02 say 'Data de Cancelamento do Or‡amento......:' get V_DTAPR pict masc(7) valid V_DTAPR>=V_DTPRO
	read
	setcolor('W+/G')
	if if(lastkey()#K_ESC,pb_sn(),.F.)
		replace  OC_DTAPR with V_DTAPR,;
					OC_SITUA with 'C'
		// dbcommitall()
	end
end
setcolor(VM_CORPAD)
dbcloseall()
return nil
