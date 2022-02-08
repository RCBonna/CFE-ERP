*-----------------------------------------------------------------------------*
function ORDPOCIN()	//	Criar Orcamentos													*
*-----------------------------------------------------------------------------*

#include 'RCB.CH'
if !abre({	'E->CLIENTE',	'E->CLIOBS',	'E->PARAMETRO',;
				'E->GRUPOS',	'E->PROD',		'E->PARAMORD',;
				'E->MOVORDEM',	'E->ATIVIDAD',	'E->EQUIDES',;
				'E->CODTR',		'E->ORDEM',		'E->ORCADET',;
				'E->ORCACAB'})
	return NIL
end

pb_tela()
pb_lin4(PARAMORD->PA_DESCR3,ProcName())

if empty(PARAMORD->PA_DESCR1)
	alert('M¢dulo n„o implantando corretamente, consulte pessoal de Suporte.')
	pb_dbedit1('ORDPOCI','')
else
	pb_dbedit1('ORDPOCI')
end
PROD->(dbsetorder(2))

set relation   to str(OC_CODCL,5) into CLIENTE,;
					to OC_CODED        into EQUIDES

VM_CAMPO:={};aeval(dbstruct(),{|DET|aadd(VM_CAMPO,DET[1])})
aadd(VM_CAMPO,'substr(OC_OBS,61)')
VM_CAMPO[14]:='left(OC_OBS,60)'

VM_CAMPO[01]:='pb_zer(OC_CODOC,6)+chr(47)+pb_zer(OC_SEQ,2)+chr(45)+OC_SITUA'
VM_CAMPO[02]:='pb_zer(OC_CODCL,5)+chr(45)+left(CLIENTE->CL_RAZAO,20)'
VM_CAMPO[03]:='OC_CODED+chr(45)+left(EQUIDES->ED_DESCR,30)'
VM_CAMPO[08]:='if(OC_SITUA=="A","APROVADA",if(OC_SITUA=="E","Esperand","Cancelad"))'

dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',;
					{ masc(1) , masc(1), masc(1),             masc(7), masc(7), masc(1),masc(6), masc(23),  masc(7), masc(19), masc(2),    masc(2),  masc(23),masc(23)},;
					{'Orcamen','Cliente',trim(PARAMORD->PA_DESCR2),'DtEntr','DtVali','Tipo', 'QtdPrd','Situa‡„o','DtApro','NrOrdPr','Vlr Pecas','Vlr MDO','OBS1',  'OBS2'})
set filter to
// dbcommitall()
// packarq('ORCADET')
// packarq('ORCACAD')
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
function ORDPOCI1()	//	Rotina de Inclus„o
while lastkey()#27
	dbgobottom()
	VX_CODOC:=OC_CODOC + 1
	dbskip()
	ORDPOCINT(.T.)
end
return NIL

*-----------------------------------------------------------------------------*
function ORDPOCI2()	//	Rotina de Alteracao
ORDPOCINT(.F.)
return NIL

*-----------------------------------------------------------------------------*
function ORDPOCINT( VM_FL )
local GETLIST:={},X,X1,OBS:=array(2),VM_TOT
if !VM_FL.and.OC_SITUA#'E'
	beeperro()
	pb_msg('Ordem Servi‡o/Produ‡„o fechada.',15,.T.)
	return NIL
end

for X:=1 to fcount()
	X1:='V'+substr(fieldname(X),3)
	&X1:=&(fieldname(X))
next
if VM_FL
	V_CODOC:=VX_CODOC
	V_DTPRO:=PARAMETRO->PA_DATA
	V_DTVAL:=V_DTPRO+30
	V_QUANT:=1
	V_TIPO :='U'
end
OBS[1]=left(  V_OBS,60)
OBS[2]=substr(V_OBS,61)
pb_box(,,,,'W+/B,N/W,,,W+/B',trim(PARAMORD->PA_DESCR3))
@06,02 say padr('Or‡amento N§',15,'.')      get V_CODOC picture masc(19) valid V_CODOC>0 when VM_FL
@06,25 say '/'                              get V_SEQ   picture masc(11) valid V_SEQ>=0.and.pb_ifcod2(str(V_CODOC,6)+str(V_SEQ,2),NIL,.F.,1) when VM_FL
@06,32 say      'Dt.Proposta:'              get V_DTPRO picture masc(07) valid V_DTPRO>=PARAMETRO->PA_DATA-30.and.V_DTPRO<=PARAMETRO->PA_DATA+30
@06,56 say      'Dt.Validade:'              get V_DTVAL picture masc(07) valid V_DTVAL>=V_DTVAL             when if(VM_FL,(V_DTVAL:=(V_DTPRO+30))>ctod(''),.T.)
@07,02 say padr('C¢d.Cliente',15,'.')       get V_CODCL picture masc(04) valid fn_codigo(@V_CODCL,{'CLIENTE',{||CLIENTE->(dbseek(str(V_CODCL,5)))},{||CFEP3100T(.T.)},{2,1,8,7}})
@08,02 say padr(trim(PARAMORD->PA_DESCR2),15,'.');
														  get V_CODED picture masc(01) valid fn_codigo(@V_CODED,{'EQUIDES',{||EQUIDES->(dbseek(V_CODED))},{||ORDP1300T(.T.)},{2,1}}) when !empty(PARAMORD->PA_DESCR2)
@09,02 say padr('Tipo Orcamento',15,'.')    get V_TIPO  picture masc(01) valid V_TIPO$'UT' when pb_msg('Tipo Or‡amento => U-Tnit rio  T=Total')
@09,35 say 'Quantidade a Produzir:'         get V_QUANT picture masc(06) valid V_QUANT>0 when PARAMORD->PA_TIPO=='P'
@10,02 say padr('O.B.S./1',15,'.')          get OBS[1]  picture masc(01)
@11,02 say padr('O.B.S./2',15,'.')          get OBS[2]  picture masc(01)
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	X:=1
	PRODUTOS:=ORDPCHPRO(V_CODOC,V_SEQ)
	SERVICOS:=ORDPCHMDO(V_CODOC,V_SEQ)
	while X#3
		VM_TOT:=0
		aeval(PRODUTOS,{|VM_DET1|VM_TOT+=VM_DET1[5]})
		aeval(SERVICOS,{|VM_DET1|VM_TOT+=VM_DET1[5]})
		pb_msg('Selecione tipo de dados para or‡ar. TOTAL '+transform(VM_TOT,masc(2)))
		X:=alert('Editar dados de Or‡amento de :',{'PRODUTOS','SERVI€OS','FINALIZA'})
		if X==1
			PRODUTOS:=ORDPOCINP(V_CODOC,V_SEQ)
			FN_GRORCDET(PRODUTOS,X)
		elseif X==2
			SERVICOS:=ORDPOCINS(V_CODOC,V_SEQ)
			FN_GRORCDET(SERVICOS,X)
		elseif X==3
			V_VPROD:=0.00
			V_VMDO :=0.00
			V_VFRET:=0.00
			aeval(PRODUTOS,{|VM_DET1|V_VPROD+=VM_DET1[5]})
			aeval(SERVICOS,{|VM_DET1|V_VMDO+= VM_DET1[5]})
			pb_box(12,1,18,40,,'Informe')
			@13,02 say padr('Valor Produtos',15,'.')+' '+transform(V_VPROD,masc(6))
			@14,02 say padr('Valor Servicos',15,'.')+' '+transform(V_VMDO ,masc(6))
			@15,02 say padr('Valor ICMS',15,'.')   get V_VICMS pict masc(6)
			@16,02 say padr('Valor IPI', 15,'.')   get V_VIPI  pict masc(6)
			@17,02 say padr('Valor Frete',15,'.')  get V_VFRET pict masc(6)
			read
			exit
		end
	end
	if VM_FL
		dbappend(.T.)
		V_SITUA:='E'
	end
	V_OBS  :=OBS[1]+OBS[2]
	V_VPROD:=0
	aeval(PRODUTOS,{|VM_DET1|V_VPROD+=VM_DET1[5]})
	V_VMDO :=0
	aeval(SERVICOS,{|VM_DET1|V_VMDO+=VM_DET1[5]})
	for X:=1 to fcount()
		X1:='V'+substr(fieldname(X),3)
		replace &(fieldname(X)) with &X1
	next
	*------------------------------------------------------------------*
	if pb_sn('Deseja Imprimir Or‡amento agora ?')
		if pb_ligaimp(C15CPP)
			IMPRORC()
			pb_deslimp()
		end
	end
end
return NIL

*-----------------------------------------------------------------------------*
function ORDPOCI3()	//	Rotina de Pesquisa
local ORD:=alert('Selecione Ordem...',{'C¢digo','Cliente'},'R/W')
if ORD>0
	dbsetorder(ORD+if(ORD=1,0,1))
	PESQ(indexord())
end
return NIL

*-----------------------------------------------------------------------------*
function ORDPOCI4()	//	Rotina de Exclusao
if pb_sn('Excluir '+trim(PARAMORD->PA_DESCR3)+':'+;
			pb_zer(OC_CODOC,6)+'/'+pb_zer(OC_SEQ,2)+' ?')
	salvabd(SALVA)
	select('ORCADET')
	dbseek(str(ORCACAB->OC_CODOC,6)+str(ORCACAB->OC_SEQ,2),.T.)
	while !eof().and.ORCACAB->OC_CODOC==OD_CODOC.and.ORCACAB->OC_SEQ==OD_SEQ
		fn_elimi()
	end
	salvabd(RESTAURA)
	fn_elimi()
end
return NIL
