*-----------------------------------------------------------------------------*
function ORDPOCIX() // Fazer Fax
#include 'RCB.CH'
*-----------------------------------------------------------------------------*
local TOT:=0
private VM_SELE:={1,999999,;	// nr das ordens
						 bom(PARAMETRO->PA_DATA),eom(PARAMETRO->PA_DATA),; // dt limite
						 'S',;														// 5-Cabecalho ?
						 space(30),;												// 6-Att
						 padr('Prazo de Entrega : 15 Dias',60),;			// 7 Rodape1
						 padr('Condicoes de Pagamento : 30 Dias',60),;	// 8 Rodape2
						 padr('Nome',60),;								// 9 Assinatura
						 padr('      Conforme vossa solicitacao, apresentamos nosso orcamento para fabricacao das seguintes pecas :',140)}
if file('FAX.ARR')
	VM_SELE:=restarray('FAX.ARR')
end
pb_box(11,1,,,'W+/RB,R/W,,,W+/RB')
V_CODCL:=0
@12,02 say 'Cliente...:  '      get V_CODCL    pict masc(04) valid fn_codigo(@V_CODCL,{'CLIENTE',{||CLIENTE->(dbseek(str(V_CODCL,5)))},{||CFEP3100T(.T.)},{2,1,8,7}}).and.(VM_SELE[6]:=left(CLIENTE->CL_OBS,30))>=' '
@13,02 say 'Orcamento Inicial: 'get VM_SELE[01] pict masc(19)
@13,54 say 'Final.:'            get VM_SELE[02] pict masc(19) valid VM_SELE[2]>=VM_SELE[1]
@14,02 say 'Data Prop Inicial:' get VM_SELE[03] pict masc(07) 
@14,54 say 'Final.:'            get VM_SELE[04] pict masc(07) valid VM_SELE[4]>=VM_SELE[3]
@16,02 say 'Lista Cabe‡alho:'   get VM_SELE[05] pict masc(01) valid VM_SELE[5]$'SN'
@17,02 say 'Destinacao Orca:'   get VM_SELE[10] pict masc(01)+'S60'
@18,02 say 'ATT............:'   get VM_SELE[06] pict masc(23)
@19,02 say 'Linha 1 Rodape.:'   get VM_SELE[07] pict masc(23)
@20,02 say 'Linha 2 Rodape.:'   get VM_SELE[08] pict masc(23)
@21,02 say 'Assinatura.....:'   get VM_SELE[09] pict masc(23)
read
if if(lastkey()#K_ESC,pb_ligaimp(C15CPP),.F.)
	savearray(VM_SELE,'FAX.ARR')
	ORDEM CLIORC
	set filter to  OC_CODOC>=VM_SELE[1].and.OC_CODOC<=VM_SELE[2].and.;
						OC_DTPRO>=VM_SELE[3].and.OC_DTPRO<=VM_SELE[4].and.;
						OC_CODCL==V_CODCL   .and.OC_SITUA=='E'
	DbGoTop()
	set margin to 5
	if VM_SELE[5]=='S'
		?VM_EMPR
		?PARAMETRO->PA_ENDER
		?transform(PARAMETRO->PA_CEP,masc(10))+'-'+PARAMETRO->PA_CIDAD+'  '+PARAMETRO->PA_UF
		?'Fone '+PARAMETRO->PA_FONE+space(4)+'Fax '+PARAMETRO->PA_FAX
		?
		?
	else
		?
		?
		?
		?
		?
		?
	end
	? 'Data : '+transform(date(),mDT)
	??space(20)+'Orcamento : '+pb_zer(OC_CODOC,6)
	? 
	?
	? CLIENTE->CL_RAZAO+space(10)+'('+pb_zer(OC_CODCL,5)+')'
	? transform(CLIENTE->CL_CEP,masc(10))
	??space(05)+CLIENTE->CL_CIDAD+space(5)+CLIENTE->CL_UF
	? 'Fax:'+CLIENTE->CL_FAX
	?
	? 'Att.: '+VM_SELE[6]
	?
	? 'Prezado Senhor'
	?left(VM_SELE[10],70)
	?right(VM_SELE[10],70)
	? I15CPP
	? replicate('-',128)
	? '  Qtdade  Desenho       Denominacao                                            Vlr Unitario        Vlr Total'
	? replicate('-',128)
	while !eof()
		? str(OC_QUANT,8)
		??space(2)+OC_CODED
		??space(2)+EQUIDES->ED_DESCR
		??space(2)+transform((OC_VMDO+OC_VPROD)         ,masc(2))
		??space(2)+transform((OC_VMDO+OC_VPROD)*OC_QUANT,masc(2))
		TOT+=(OC_VMDO+OC_VPROD)*OC_QUANT
		pb_brake()
	end
	? replicate('-',128)
	? padr('  Valor Total do Orcamento',93,'.')+transform(TOT,masc(2))
	? replicate('-',128)
	? C15CPP
	?VM_SELE[7]
	?VM_SELE[8]
	?
	?'Sendo o que tinhamos para o momento,'
	?
	?'Atenciosamente,'
	?
	? VM_SELE[9]
	set margin to
	eject
	pb_deslimp(C15CPP)
	set filter to
	ORDEM CODORCT
	DbGoTop()
end
return NIL
//----------------------------------------------------eof------------------------------