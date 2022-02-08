*-----------------------------------------------------------------------------*
function ORDPOCAP()	//	Aprovar Orcamentos												*
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
pb_box(,,,,'W+/B,N/W,,,W+/B')
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
	@13,02 say 'Data de aprova‡Æo do Or‡amento......:' get V_DTAPR  pict masc(7) valid V_DTAPR>=V_DTPRO
	@14,02 say 'C¢digo de Aprova‡Æo do Cliente......:' get V_ORDCOM pict masc(1)
	read
	if if(lastkey()#K_ESC,pb_sn('Aprovar Orcamento ?'),.F.)
		replace  OC_DTAPR with V_DTAPR,;
					OC_SITUA with 'A'
		beepaler()
		if pb_sn('Orcamento Aprovado;Abrir Ordem de Produ‡Æo ?')
			salvabd(.T.)
			select('ORDEM')
			V_CODOR:=PARAMORD->PA_SEQ+1
			V_DTENT:=PARAMETRO->PA_DATA
			V_DTSAI:=PARAMETRO->PA_DATA + 30
			@15,02 say 'Informe N£mero da Ordem de Produ‡Æo :' get V_CODOR ;
					 pict masc(19) valid pb_ifcod2(str(V_CODOR,6),NIL,.F.,1)
			@17,02 say 'Data de Inicio......................:' get V_DTENT pict masc(7) valid V_DTENT>=V_DTAPR
			@18,02 say 'PrevisÆo de T‚rmino.................:' get V_DTSAI pict masc(7) valid V_DTSAI>=V_DTENT
			read
			if lastkey()#K_ESC
				AddRec()
				replace  OR_CODOR with V_CODOR,;
							OR_CODCL with V_CODCL,;
							OR_CODED with V_CODED,;
							OR_DTENT with V_DTENT,;
							OR_DTSAI with V_DTSAI,;
							OR_OBS   with V_OBS,;
							OR_QUANT with V_QUANT,;
							OR_NRCLI with V_ORDCOM,;
							OR_VICMS with V_VICMS,;
							OR_VIPI  with V_VIPI
				replace  PARAMORD->PA_SEQ with V_CODOR
				replace  ORCACAB->OC_CODOR  with V_CODOR
			else
				alert('Or‡amento ja Aprovado;NÆo aberto Ordem de Produ‡Æo?')
			end
			salvabd(.F.)
		end
		// dbcommitall()
	end
end
setcolor(VM_CORPAD)
dbcloseall()
return nil

function FN_CHORCA(P1,P2)
local VM_TF:=savescreen(5,0),CAMPO,RT:=.T.
if !dbseek(str(P1,6)+str(P2,2))
	dbsetorder(2)
	DbGoTop()
	CAMPO:={fieldname(1),fieldname(2),fieldname(3),'left(CLIENTE->CL_RAZAO,25)',fieldname(4)}
	salvacor(.T.)
	pb_box(05,00,22,65,'W+/BR','Or‡amentos')
	dbedit(06,01,21,64,CAMPO,,'',{'Orc','Sq','CodCli','Nome','Equip'})
	P1:=fieldget(1)
	P2:=fieldget(2)
	restscreen(5,0,,,VM_TF)
	salvacor(.F.)
	RT:=.F.
	dbsetorder(1)
	aeval(GETLIST,{|DET|DET:display()})
end
return RT
