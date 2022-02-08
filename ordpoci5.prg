*-----------------------------------------------------------------------------*
function ORDPOCI5()	//	Rotina de Impressao
#include 'RCB.CH'
*-----------------------------------------------------------------------------*
local OPC:=alert('Selecione forma de impressÆo...',{'Lista','FICHA','Fax'})
if OPC==1
	ORDPOCIL() // lista de Orcamentos
elseif OPC==2
	ORDPOCIF() // lista de Orcamentos
elseif OPC==3
	ORDPOCIX() // Fax de Orcamentos
end
DbGoTop()
return NIL

function ORDPOCIL()
private VM_SELE:={1,999999,;	// nr das ordens
						 bom(PARAMETRO->PA_DATA),eom(PARAMETRO->PA_DATA),; // dt limite
						 1,99999,;	// clientes
						 'T'}// tipo E-Esperanado C-Cancelada A-Aprovada T-todas
pb_box(15,20,,,'W+/RB,R/W,,,W+/RB')
@15,34 say 'INICIAL'
@15,52 say 'FINAL'
@16,22 say 'Orcamento :  ' get VM_SELE[1] pict masc(19)
@16,54                     get VM_SELE[2] pict masc(19) valid VM_SELE[2]>=VM_SELE[1]
@17,22 say 'Data Prop :'   get VM_SELE[3] pict masc(07) 
@17,52                     get VM_SELE[4] pict masc(07) valid VM_SELE[4]>=VM_SELE[3]
@18,22 say 'Cliente...:  ' get VM_SELE[5] pict masc(19) 
@18,54                     get VM_SELE[6] pict masc(19) valid VM_SELE[6]>=VM_SELE[5]
@20,22 say 'Tipo Orcamento....:' get VM_SELE[7] pict masc(01) valid VM_SELE[7]$'AECT'
@20,52 say 'Aprov Esper Canc Todos'
read
if if(lastkey()#K_ESC,pb_ligaimp(I15CPP),.F.)
	ORDEM CLIORC
	VM_REL:='Orcamentos'
	VM_PAG:=0
	VM_LAR:=132
	set filter to  OC_CODOC>=VM_SELE[1].and.OC_CODOC<=VM_SELE[2].and.;
						OC_DTPRO>=VM_SELE[3].and.OC_DTPRO<=VM_SELE[4].and.;
						OC_CODCL>=VM_SELE[5].and.OC_CODCL<=VM_SELE[6].and.;
						if(VM_SELE[7]=='T',.T.,OC_SITUA==VM_SELE[7])
	DbGoTop()
	while !eof()
		VM_PAG=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'ORDPOCILC',VM_LAR)
		?pb_zer(OC_CODCL,5)+'-'+CLIENTE->CL_RAZAO
		VM_CLIENTE:=OC_CODCL
		while !eof().and.VM_CLIENTE==OC_CODCL
			? space(3)+str(OC_CODOC,6)+'/'+pb_zer(OC_SEQ,2)+" "
			??OC_CODED+'-'
			??left(EQUIDES->ED_DESCR,40)
			??space(2)+transform(OC_DTPRO,masc(7))
			??space(2)+transform(OC_DTVAL,masc(7))
			??space(2)+transform(OC_DTAPR,masc(7))
			??space(2)+transform(OC_VPROD,masc(2))
			??space(2)+transform(OC_VMDO, masc(2))
			pb_brake()
		end
		?
	end
	eject
	pb_deslimp(C15CPP)
	set filter to
	ORDEM CODORCT
	DbGoTop()
end
return NIL

function ORDPOCILC()
?'Cliente/'+padr(trim(PARAMORD->PA_DESCR2),60)+'Dt Prop  Dt Valid   Dt Apro    Valor Produtos   Valor Servicos'
?replicate('-',VM_LAR)
return NIL

*-----------------------------------------------------------------------------*
function ORDPOCIF()
private VM_SELE:={1,999999,;	// nr das ordens
						 bom(PARAMETRO->PA_DATA),eom(PARAMETRO->PA_DATA),; // dt limite
						 1,99999,;	// clientes
						 'T'}// tipo E-Esperanado C-Cancelada A-Aprovada T-todas
pb_box(15,20,,,'W+/RB,R/W,,,W+/RB')
@15,34 say 'INICIAL'
@15,52 say 'FINAL'
@16,22 say 'Orcamento :  ' get VM_SELE[1] pict masc(19)
@16,54                     get VM_SELE[2] pict masc(19) valid VM_SELE[2]>=VM_SELE[1]
@17,22 say 'Data Prop :'   get VM_SELE[3] pict masc(07) 
@17,52                     get VM_SELE[4] pict masc(07) valid VM_SELE[4]>=VM_SELE[3]
@18,22 say 'Cliente...:  ' get VM_SELE[5] pict masc(19) 
@18,54                     get VM_SELE[6] pict masc(19) valid VM_SELE[6]>=VM_SELE[5]
@20,22 say 'Tipo Orcamento....:' get VM_SELE[7] pict masc(01) valid VM_SELE[7]$'AECT'
@20,52 say 'Aprov Esper Canc Todos'
read
if if(lastkey()#K_ESC,pb_ligaimp(C15CPP),.F.)
	ORDEM CLIORC
	set filter to  OC_CODOC>=VM_SELE[1].and.OC_CODOC<=VM_SELE[2].and.;
						OC_DTPRO>=VM_SELE[3].and.OC_DTPRO<=VM_SELE[4].and.;
						OC_CODCL>=VM_SELE[5].and.OC_CODCL<=VM_SELE[6].and.;
						if(VM_SELE[7]=='T',.T.,OC_SITUA==VM_SELE[7])
	DbGoTop()
	while !eof()
		improrc(OC_CODOC)
		pb_brake()
	end
	pb_deslimp()
	set filter to
	ORDEM CODORCT
	DbGoTop()
end
return NIL

function IMPRORC()
local PROD  :=ORDPCHPRO(OC_CODOC)
local PROD1 :=ORDPCHMDO(OC_CODOC)
local VM_TOT:={0,0}
aeval(PROD ,{|VM_DET|VM_TOT[1]+=VM_DET[5]})
aeval(PROD1,{|VM_DET|VM_TOT[2]+=VM_DET[5]})

?VM_EMPR
?PARAMETRO->PA_ENDER
?transform(PARAMETRO->PA_CEP,masc(10))+'-'+PARAMETRO->PA_CIDAD+'  '+PARAMETRO->PA_UF
?'Fone '+PARAMETRO->PA_FONE+space(4)+'Fax '+PARAMETRO->PA_FAX
?replicate('-',78)
?padc('ORCAMENTO N. '+pb_zer(OC_CODOC,6),78)
?replicate('-',78)
?
?'Cliente : '+pb_zer(OC_CODCL,5)+'-'+CLIENTE->CL_RAZAO
?
?'Producao: '+OC_CODED+'-'+EQUIDES->ED_DESCR
?
? 'Data Proposta '+transform(OC_DTPRO,masc(7))
??	space(26)+'Data Validade '+transform(OC_DTVAL,masc(7))
?
if OC_TIPO=='U'
	?'Valor Unitario Total : '
else
	?'Valor Total : '
end
??transform(OC_VPROD+OC_VMDO+OC_VFRET,masc(2))
?
?
?replicate('-',78)
?padr('Codigo / Descricao Produtos/Servicos',49)+'Quantidade      Valor Total'
?replicate('-',78)
if VM_TOT[1]>0
	for X:=1 to len(PROD)
		if PROD[X,4]>0
			? padr(pb_zer(PROD[X,2],L_P)+'-'+PROD[X,3],50)
			??transform(PROD[X,4],masc(6))+space(2)
			??transform(PROD[X,5],masc(2))
		end
	next
end
if VM_TOT[2]>0
	for X:=1 to len(PROD1)
		if PROD1[X,4]>0
			? padr(str(PROD1[X,2],L_P)+'-'+PROD1[X,3],50)
			??transform(PROD1[X,4],masc(6))+space(2)
			??transform(PROD1[X,5],masc(2))
		end
	next
	?replicate('-',78)
end
?padr('Total dos Produtos',61)+transform(VM_TOT[1],masc(2))
?padr('Total dos Servicos',61)+transform(VM_TOT[2],masc(2))
?padr('Total do Frete',61)    +transform(OC_VFRET ,masc(2))
if OC_TIPO=='U'
	?replicate('=',78)
	?'Valor Total do Orcamento para '+str(OC_QUANT,7)+' peca(s) R$'+transform((OC_VPROD+OC_VMDO)*OC_QUANT,masc(2))
end
eject
return NIL

